[CmdletBinding()]
param([string]$ClusterName = 'cloudcart-gitops')

$ErrorActionPreference = 'Stop'
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) { throw "Expected context '$expectedContext'." }

flux get sources git kubernetes-notes | Select-String 'True' | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Git source is not ready.' }
flux get kustomizations cloudcart | Select-String 'True' | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Kustomization is not ready.' }
kubectl wait helmrelease/cloudcart -n cloudcart --for=condition=Ready --timeout=3m

$original = kubectl get configmap cloudcart-config -n cloudcart -o jsonpath='{.data.RELAY_INTERVAL_SECONDS}'
kubectl patch configmap cloudcart-config -n cloudcart --type merge -p '{"data":{"RELAY_INTERVAL_SECONDS":"99"}}' | Out-Null
flux reconcile helmrelease cloudcart --namespace cloudcart --force --timeout=3m | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'HelmRelease drift reconciliation failed.' }
$restored = kubectl get configmap cloudcart-config -n cloudcart -o jsonpath='{.data.RELAY_INTERVAL_SECONDS}'
if ($restored -ne $original) { throw 'Flux did not correct ConfigMap drift.' }

$processedBefore = kubectl exec -n cloudcart cloudcart-postgres-0 -- `
    psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM notification.processed_events;"
if ($LASTEXITCODE -ne 0) { throw 'Could not read the initial processed-event count.' }

$clientCode = @'
import json, urllib.request, uuid
payload=json.dumps({"lines":[{"product_id":"10000000-0000-0000-0000-000000000001","quantity":1}]}).encode()
request=urllib.request.Request("http://cloudcart-api:8080/api/orders",data=payload,headers={"Content-Type":"application/json","Idempotency-Key":"module14-"+uuid.uuid4().hex},method="POST")
response=urllib.request.urlopen(request,timeout=5)
assert response.status==201
print(json.load(response)["id"])
'@
$orderId = kubectl run gitops-client -n cloudcart --rm -i --restart=Never `
    --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
    --command -- python -c $clientCode
if ($LASTEXITCODE -ne 0 -or -not $orderId) { throw 'CloudCart transaction failed.' }

$processed = $false
foreach ($attempt in 1..30) {
    $count = kubectl exec -n cloudcart cloudcart-postgres-0 -- `
        psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM notification.processed_events;"
    if ($LASTEXITCODE -eq 0 -and [int]$count -gt [int]$processedBefore) { $processed = $true; break }
    Start-Sleep -Seconds 2
}
if (-not $processed) { throw 'The order event was not processed.' }

Write-Output "GitOps test=PASS drift=corrected order=$orderId event=processed source=ready kustomization=ready"
