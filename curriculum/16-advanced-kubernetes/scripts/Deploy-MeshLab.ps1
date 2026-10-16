[CmdletBinding()]
param([string]$ClusterName = 'cloudcart-advanced', [string]$IstioVersion = '1.31.2')

$ErrorActionPreference = 'Stop'
foreach ($name in @('kubectl', 'istioctl')) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) { throw "Required command '$name' is not installed." }
}
if ((kubectl config current-context) -ne "kind-$ClusterName") { throw 'Unexpected Kubernetes context.' }
$clientVersion = (istioctl version --remote=false -o json | ConvertFrom-Json).clientVersion.version
if ($clientVersion -ne $IstioVersion) { throw "Expected istioctl $IstioVersion, found $clientVersion." }

istioctl install --set profile=ambient --skip-confirmation
if ($LASTEXITCODE -ne 0) { throw 'Istio ambient installation failed.' }
kubectl rollout status deployment/istiod -n istio-system --timeout=300s
kubectl rollout status daemonset/istio-cni-node -n istio-system --timeout=300s
kubectl rollout status daemonset/ztunnel -n istio-system --timeout=300s

$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
kubectl apply -f (Join-Path $root 'curriculum\16-advanced-kubernetes\lab\mesh\workloads.yaml') | Out-Null
foreach ($deployment in @('mesh-server', 'mesh-client', 'mesh-other')) {
    kubectl rollout status "deployment/$deployment" -n mesh-lab --timeout=180s
    if ($LASTEXITCODE -ne 0) { throw "Deployment '$deployment' did not become ready." }
}
Write-Output "Mesh deployment=PASS context=kind-$ClusterName istio=$IstioVersion mode=ambient"
