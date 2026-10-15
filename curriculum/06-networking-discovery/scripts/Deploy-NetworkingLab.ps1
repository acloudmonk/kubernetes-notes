[CmdletBinding()]
param([string]$ClusterName = "cloudcart-networking")

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

./curriculum/05-kubernetes-workloads/scripts/Deploy-CloudCartLab.ps1 `
    -ClusterName $ClusterName

$envoyInstall = "https://github.com/envoyproxy/gateway/releases/download/v1.8.5/install.yaml"
kubectl apply --server-side -f $envoyInstall
if ($LASTEXITCODE -ne 0) { throw "Envoy Gateway installation failed." }
kubectl wait --timeout=300s -n envoy-gateway-system `
    deployment/envoy-gateway --for=condition=Available

kubectl apply -f capstone/cloudcart/k8s/networking/network-policies.yaml
kubectl apply -f capstone/cloudcart/k8s/networking/gateway.yaml
if ($LASTEXITCODE -ne 0) { throw "Networking resources failed to apply." }

kubectl wait gateway/cloudcart -n cloudcart `
    --for=condition=Accepted --timeout=180s

# HTTPRoute conditions are nested under status.parents, which kubectl wait does
# not evaluate as top-level resource conditions.
$routeDeadline = (Get-Date).AddSeconds(180)
do {
    $routeConditions = kubectl get httproute cloudcart -n cloudcart `
        -o jsonpath="{range .status.parents[*].conditions[*]}{.type}={.status}{' '}{end}"
    if ($LASTEXITCODE -ne 0) { throw "Could not read the CloudCart HTTPRoute." }

    $routeAccepted = $routeConditions -match "(?:^|\s)Accepted=True(?:\s|$)"
    $routeReferencesResolved = $routeConditions -match "(?:^|\s)ResolvedRefs=True(?:\s|$)"
    if (-not ($routeAccepted -and $routeReferencesResolved)) {
        Start-Sleep -Seconds 2
    }
} until (($routeAccepted -and $routeReferencesResolved) -or (Get-Date) -ge $routeDeadline)

if (-not ($routeAccepted -and $routeReferencesResolved)) {
    throw "HTTPRoute was not ready within 180 seconds. Conditions: $routeConditions"
}

kubectl wait pod -n envoy-gateway-system `
    -l gateway.envoyproxy.io/owning-gateway-name=cloudcart `
    --for=condition=Ready --timeout=180s

Write-Output "CloudCart networking deployment=PASS context=$expectedContext envoy=v1.8.5"
