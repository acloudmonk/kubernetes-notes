[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-helm",
    [string]$ReleaseName = "cloudcart"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
$chartPath = "capstone/cloudcart/helm/cloudcart"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

$statusBefore = helm status $ReleaseName --namespace cloudcart -o json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0 -or $statusBefore.info.status -ne "deployed") {
    throw "Expected a deployed Helm release."
}
$revisionBefore = [int]$statusBefore.version

$managedObjects = kubectl get deployments,statefulsets,services,configmaps,serviceaccounts,pdb `
    -n cloudcart -l app.kubernetes.io/instance=$ReleaseName -o json | ConvertFrom-Json
if ($managedObjects.items.Count -lt 10) { throw "Expected Helm-managed CloudCart resources." }
foreach ($item in $managedObjects.items) {
    if ($item.metadata.labels.'app.kubernetes.io/managed-by' -ne "Helm") {
        throw "Resource '$($item.kind)/$($item.metadata.name)' lacks Helm ownership labels."
    }
}
$credentialSecret = kubectl get secret cloudcart-credentials -n cloudcart -o json | ConvertFrom-Json
if ($credentialSecret.metadata.labels.'app.kubernetes.io/managed-by' -eq "Helm" -or
    $credentialSecret.metadata.annotations.'meta.helm.sh/release-name') {
    throw "The externally created credential Secret must not be owned by the release."
}

$relaySelector = "app.kubernetes.io/instance=$ReleaseName,app.kubernetes.io/component=relay"
$relayBefore = kubectl get pod -n cloudcart `
    -l $relaySelector `
    -o jsonpath='{.items[0].metadata.uid}'
$currentInterval = kubectl get configmap "$ReleaseName-config" -n cloudcart `
    -o jsonpath='{.data.RELAY_INTERVAL_SECONDS}'
$nextInterval = if ($currentInterval -eq "2") { "3" } else { "2" }

helm upgrade $ReleaseName $chartPath --namespace cloudcart --reuse-values `
    --set-string config.relayIntervalSeconds=$nextInterval `
    --wait --wait-for-jobs --timeout 5m --rollback-on-failure
if ($LASTEXITCODE -ne 0) { throw "The valid Helm upgrade failed." }
$statusSuccessful = helm status $ReleaseName -n cloudcart -o json | ConvertFrom-Json
$successfulRevision = [int]$statusSuccessful.version
if ($successfulRevision -ne ($revisionBefore + 1)) { throw "The valid upgrade did not create one revision." }

$relayAfter = kubectl get pod -n cloudcart `
    -l $relaySelector `
    -o jsonpath='{.items[0].metadata.uid}'
$intervalAfter = kubectl exec -n cloudcart deployment/$ReleaseName-relay -- `
    printenv RELAY_INTERVAL_SECONDS
if ($relayAfter -eq $relayBefore -or $intervalAfter -ne $nextInterval) {
    throw "The checksum-driven configuration rollout was not observed."
}

$failedOutput = helm upgrade $ReleaseName $chartPath --namespace cloudcart --reuse-values `
    --set image.tag=missing-module11 `
    --wait --wait-for-jobs --timeout 45s 2>&1
if ($LASTEXITCODE -eq 0) { throw "The intentionally broken upgrade unexpectedly succeeded." }
$failedStatus = helm status $ReleaseName -n cloudcart -o json | ConvertFrom-Json
$failedRevision = [int]$failedStatus.version
if ($failedStatus.info.status -ne "failed" -or $failedRevision -ne ($successfulRevision + 1)) {
    throw "The failed upgrade was not recorded as the next failed revision."
}

helm rollback $ReleaseName $successfulRevision --namespace cloudcart --wait --timeout 5m
if ($LASTEXITCODE -ne 0) { throw "Rollback to revision $successfulRevision failed." }
$statusRecovered = helm status $ReleaseName -n cloudcart -o json | ConvertFrom-Json
if ($statusRecovered.info.status -ne "deployed") { throw "Release is not deployed after rollback." }
$imageAfterRollback = kubectl get deployment $ReleaseName-api -n cloudcart `
    -o jsonpath='{.spec.template.spec.containers[0].image}'
if ($imageAfterRollback -ne "cloudcart-app:0.1.0") { throw "Rollback did not restore the application image." }

helm test $ReleaseName --namespace cloudcart --timeout 2m --logs
if ($LASTEXITCODE -ne 0) { throw "Chart test failed after rollback." }

$clientCode = @'
import json, urllib.request, uuid
payload = json.dumps({"lines": [{"product_id": "10000000-0000-0000-0000-000000000001", "quantity": 1}]}).encode()
request = urllib.request.Request("http://cloudcart-api:8080/api/orders", data=payload, headers={"Content-Type": "application/json", "Idempotency-Key": "module11-" + uuid.uuid4().hex}, method="POST")
response = urllib.request.urlopen(request, timeout=5)
assert response.status == 201
print(json.load(response)["id"])
'@
$orderId = kubectl run helm-client -n cloudcart --rm -i --restart=Never `
    --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
    --command -- python -c $clientCode
if ($LASTEXITCODE -ne 0 -or -not $orderId) { throw "Could not create the post-rollback order." }

$processed = $false
foreach ($attempt in 1..30) {
    $count = kubectl exec -n cloudcart "$ReleaseName-postgres-0" -- `
        psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM notification.processed_events;"
    if ($LASTEXITCODE -eq 0 -and [int]$count -ge 1) { $processed = $true; break }
    Start-Sleep -Seconds 2
}
if (-not $processed) { throw "The post-rollback order was not processed." }

$packageDirectory = "tmp/module11"
New-Item -ItemType Directory -Path $packageDirectory -Force | Out-Null
helm package $chartPath --destination $packageDirectory | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Chart packaging failed." }
$package = Get-ChildItem $packageDirectory -Filter 'cloudcart-0.1.0.tgz' | Select-Object -First 1
if (-not $package) { throw "Expected chart package was not created." }
helm show chart $package.FullName | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Packaged chart metadata could not be read." }

[pscustomobject]@{
    Context = $expectedContext
    InitialRevision = $revisionBefore
    SuccessfulUpgrade = $successfulRevision
    FailedRevision = $failedRevision
    RecoveredRevision = [int]$statusRecovered.version
    ConfigRollout = $nextInterval
    HelmTest = "PASS"
    ExternalSecretOwnership = "PASS"
    EventPath = "Processed"
    Package = $package.Name
    Result = "PASS"
} | Format-List
