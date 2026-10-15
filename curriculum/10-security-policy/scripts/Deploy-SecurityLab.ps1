[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-security",
    [string]$Image = "cloudcart-app:0.1.0"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

./curriculum/08-configuration-secrets/scripts/Deploy-ConfigurationLab.ps1 `
    -ClusterName $ClusterName -Image $Image
if ($LASTEXITCODE -ne 0) { throw "CloudCart configuration baseline deployment failed." }

kubectl apply -f capstone/cloudcart/k8s/security/service-accounts.yaml
if ($LASTEXITCODE -ne 0) { throw "Could not apply CloudCart service accounts." }

$identityPatches = @{
    "cloudcart-api" = "api-identity-patch.yaml"
    "cloudcart-relay" = "relay-identity-patch.yaml"
    "cloudcart-worker" = "worker-identity-patch.yaml"
}
foreach ($entry in $identityPatches.GetEnumerator()) {
    kubectl patch deployment $entry.Key -n cloudcart --type=strategic `
        --patch-file "capstone/cloudcart/k8s/security/$($entry.Value)"
    if ($LASTEXITCODE -ne 0) { throw "Could not patch identity for '$($entry.Key)'." }
}
foreach ($deployment in $identityPatches.Keys) {
    kubectl rollout status "deployment/$deployment" -n cloudcart --timeout=180s
    if ($LASTEXITCODE -ne 0) { throw "Deployment '$deployment' did not become ready." }
}

# Observe Restricted-profile gaps in third-party dependencies without blocking
# the existing learning stack. The isolated security-lab namespace enforces it.
kubectl label namespace cloudcart --overwrite `
    pod-security.kubernetes.io/audit=restricted `
    pod-security.kubernetes.io/audit-version=v1.36 `
    pod-security.kubernetes.io/warn=restricted `
    pod-security.kubernetes.io/warn-version=v1.36 | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not apply CloudCart Pod Security migration labels." }

kubectl apply -f curriculum/10-security-policy/lab/security-boundary.yaml
if ($LASTEXITCODE -ne 0) { throw "Could not apply the isolated security boundary." }
kubectl apply -f curriculum/10-security-policy/lab/admission-policy.yaml
if ($LASTEXITCODE -ne 0) { throw "Could not apply native CEL admission policy." }

# Admission policy configuration is eventually observed by the API server.
$policyReady = $false
foreach ($attempt in 1..30) {
    $policy = kubectl get validatingadmissionpolicy security-lab-no-latest -o json 2>$null | ConvertFrom-Json
    $typeChecked = $policy.status.PSObject.Properties.Name -contains "typeChecking"
    $hasWarnings = $policy.status.typeChecking.PSObject.Properties.Name -contains "expressionWarnings"
    if ($LASTEXITCODE -eq 0 -and $typeChecked -and -not $hasWarnings) {
        $policyReady = $true
        break
    }
    Start-Sleep -Seconds 1
}
if (-not $policyReady) { throw "ValidatingAdmissionPolicy did not become ready." }

kubectl apply -f curriculum/10-security-policy/lab/compliant-pod.yaml
if ($LASTEXITCODE -ne 0) { throw "Could not create the compliant workload." }
kubectl wait --for=condition=Ready pod/compliant-workload -n security-lab --timeout=120s
if ($LASTEXITCODE -ne 0) { throw "The compliant workload did not become ready." }

Write-Output "CloudCart security deployment=PASS context=$expectedContext image=$Image admission=CEL"
