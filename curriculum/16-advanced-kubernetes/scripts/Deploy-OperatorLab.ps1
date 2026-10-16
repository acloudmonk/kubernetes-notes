[CmdletBinding()]
param([string]$ClusterName = 'cloudcart-advanced', [string]$Image = 'cloudcart-app:0.1.0')

$ErrorActionPreference = 'Stop'
foreach ($name in @('docker', 'kind', 'kubectl')) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) { throw "Required command '$name' is not installed." }
}
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$module = Join-Path $root 'curriculum\16-advanced-kubernetes'

if (-not (kind get clusters | Select-String -SimpleMatch $ClusterName)) {
    kind create cluster --config (Join-Path $module 'lab\kind-config.yaml') `
        --image kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed
    if ($LASTEXITCODE -ne 0) { throw 'kind cluster creation failed.' }
}
kubectl config use-context "kind-$ClusterName" | Out-Null
docker image inspect $Image *> $null
if ($LASTEXITCODE -ne 0) {
    docker build -t $Image (Join-Path $root 'capstone\cloudcart')
    if ($LASTEXITCODE -ne 0) { throw 'CloudCart image build failed.' }
}
kind load docker-image $Image --name $ClusterName

kubectl apply -f (Join-Path $module 'lab\operator\crd.yaml') | Out-Null
kubectl wait --for=condition=Established crd/cloudcartpolicies.learning.cloudcart.io --timeout=90s
$controllerManifest = Join-Path $module 'lab\operator\controller.yaml'
kubectl apply -f $controllerManifest | Out-Null
$controllerSource = Join-Path $module 'operator\controller.py'
kubectl create configmap cloudcart-policy-controller-source -n operator-lab `
    "--from-file=controller.py=$controllerSource" `
    --dry-run=client -o yaml | kubectl apply -f - | Out-Null
kubectl rollout restart deployment/cloudcart-policy-controller -n operator-lab | Out-Null
kubectl rollout status deployment/cloudcart-policy-controller -n operator-lab --timeout=180s
if ($LASTEXITCODE -ne 0) { throw 'Controller did not become ready.' }
Write-Output "Operator deployment=PASS context=kind-$ClusterName image=$Image"
