[CmdletBinding()]
param([string]$ClusterName = "cloudcart-security")

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

function Test-CanI([string]$Verb, [string]$Resource, [string]$Namespace) {
    kubectl auth can-i $Verb $Resource --namespace $Namespace `
        --as system:serviceaccount:security-lab:security-auditor --quiet
    return $LASTEXITCODE -eq 0
}

$readerAllowed = Test-CanI "get" "pods" "security-lab"
$secretDenied = -not (Test-CanI "get" "secrets" "security-lab")
$deploymentDenied = -not (Test-CanI "create" "deployments.apps" "security-lab")
$crossNamespaceDenied = -not (Test-CanI "get" "pods" "cloudcart")
if (-not ($readerAllowed -and $secretDenied -and $deploymentDenied -and $crossNamespaceDenied)) {
    throw "The security-auditor RBAC boundary does not match the intended matrix."
}

$deployments = kubectl get deployments -n cloudcart -o json | ConvertFrom-Json
foreach ($name in @("cloudcart-api", "cloudcart-relay", "cloudcart-worker")) {
    $deployment = $deployments.items | Where-Object { $_.metadata.name -eq $name }
    if ($deployment.spec.template.spec.serviceAccountName -ne $name -or
        $deployment.spec.template.spec.automountServiceAccountToken -ne $false) {
        throw "Deployment '$name' does not use its tokenless dedicated identity."
    }
}

$applicationPods = kubectl get pods -n cloudcart -l app.kubernetes.io/part-of=cloudcart -o json | ConvertFrom-Json
foreach ($pod in $applicationPods.items) {
    $tokenVolumes = @($pod.spec.volumes | Where-Object { $_.projected.sources.serviceAccountToken })
    if ($tokenVolumes.Count -ne 0) { throw "Pod '$($pod.metadata.name)' mounts a service-account token." }
}

$namespace = kubectl get namespace security-lab -o json | ConvertFrom-Json
if ($namespace.metadata.labels.'pod-security.kubernetes.io/enforce' -ne "restricted" -or
    $namespace.metadata.labels.'pod-security.kubernetes.io/enforce-version' -ne "v1.36") {
    throw "security-lab does not enforce the pinned Restricted profile."
}

$psaOutput = kubectl apply -f curriculum/10-security-policy/lab/psa-violation.yaml 2>&1
if ($LASTEXITCODE -eq 0 -or ($psaOutput -join " ") -notmatch "violates PodSecurity") {
    kubectl delete pod privileged-workload -n security-lab --ignore-not-found | Out-Null
    throw "Pod Security Admission did not reject the privileged fixture."
}

$policyOutput = kubectl apply -f curriculum/10-security-policy/lab/latest-image-violation.yaml 2>&1
if ($LASTEXITCODE -eq 0 -or ($policyOutput -join " ") -notmatch "Explicit :latest image tags") {
    kubectl delete pod latest-image-workload -n security-lab --ignore-not-found | Out-Null
    throw "The CEL policy did not reject the :latest fixture."
}

$compliant = kubectl get pod compliant-workload -n security-lab -o json | ConvertFrom-Json
if ($compliant.status.phase -ne "Running" -or $compliant.status.qosClass -ne "Burstable") {
    throw "The compliant workload is not running with expected QoS."
}
$quota = kubectl get resourcequota tenant-budget -n security-lab -o json | ConvertFrom-Json
if ([int]$quota.status.used.pods -ne 1) { throw "Tenant quota did not account for the compliant Pod." }

$clientCode = @'
import json, urllib.request, uuid
payload = json.dumps({"lines": [{"product_id": "10000000-0000-0000-0000-000000000001", "quantity": 1}]}).encode()
request = urllib.request.Request("http://cloudcart-api:8080/api/orders", data=payload, headers={"Content-Type": "application/json", "Idempotency-Key": "module10-" + uuid.uuid4().hex}, method="POST")
response = urllib.request.urlopen(request, timeout=5)
assert response.status == 201
print(json.load(response)["id"])
'@
$clientOverrides = @{
    spec = @{
        automountServiceAccountToken = $false
        securityContext = @{
            runAsNonRoot = $true
            seccompProfile = @{type = "RuntimeDefault"}
        }
        containers = @(
            @{
                name = "security-client"
                image = "cloudcart-app:0.1.0"
                imagePullPolicy = "IfNotPresent"
                command = @("python", "-c", $clientCode)
                securityContext = @{
                    allowPrivilegeEscalation = $false
                    capabilities = @{drop = @("ALL")}
                    readOnlyRootFilesystem = $true
                    runAsUser = 10001
                }
            }
        )
    }
} | ConvertTo-Json -Depth 6 -Compress
$orderId = kubectl run security-client -n cloudcart --rm -i --restart=Never `
    --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
    --overrides=$clientOverrides
if ($LASTEXITCODE -ne 0 -or -not $orderId) { throw "Could not create the security verification order." }

$processed = $false
foreach ($attempt in 1..30) {
    $count = kubectl exec -n cloudcart postgres-0 -- `
        psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM notification.processed_events;"
    if ($LASTEXITCODE -eq 0 -and [int]$count -ge 1) { $processed = $true; break }
    Start-Sleep -Seconds 2
}
if (-not $processed) { throw "The order did not reach the tokenless worker." }

[pscustomobject]@{
    Context = $expectedContext
    DedicatedIdentities = "PASS"
    TokenAutomount = "Disabled"
    LeastPrivilegeRbac = "PASS"
    PodSecurityRestricted = "Deny verified"
    CelAdmission = "Deny verified"
    TenantQuota = "Accounted"
    EventPath = "Processed"
    Result = "PASS"
} | Format-List
