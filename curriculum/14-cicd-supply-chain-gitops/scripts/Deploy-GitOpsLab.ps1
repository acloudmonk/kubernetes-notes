[CmdletBinding()]
param(
    [string]$ClusterName = 'cloudcart-gitops',
    [string]$RepositoryUrl = 'https://github.com/acloudmonk/kubernetes-notes',
    [string]$GitBranch = 'main',
    [string]$CloudCartImage = 'cloudcart-app:0.1.0'
)

$ErrorActionPreference = 'Stop'
foreach ($name in @('docker','kind','kubectl','flux','helm')) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) { throw "Required command '$name' is not installed." }
}

if (-not (kind get clusters | Select-String -SimpleMatch $ClusterName)) {
    kind create cluster --name $ClusterName `
        --image kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed
    if ($LASTEXITCODE -ne 0) { throw 'kind cluster creation failed.' }
}
$expectedContext = "kind-$ClusterName"
kubectl config use-context $expectedContext | Out-Null

docker image inspect $CloudCartImage *> $null
if ($LASTEXITCODE -ne 0) {
    docker build -t $CloudCartImage capstone/cloudcart
    if ($LASTEXITCODE -ne 0) { throw 'CloudCart image build failed.' }
}
kind load docker-image $CloudCartImage --name $ClusterName

flux install --version=2.9.6
if ($LASTEXITCODE -ne 0) { throw 'Flux installation failed.' }
flux check --pre
if ($LASTEXITCODE -ne 0) { throw 'Flux prerequisite check failed.' }

$source = @"
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: kubernetes-notes
  namespace: flux-system
spec:
  interval: 1m
  url: $RepositoryUrl
  ref:
    branch: $GitBranch
"@
$source | kubectl apply -f - | Out-Null

$kustomization = @"
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: cloudcart
  namespace: flux-system
spec:
  interval: 1m
  retryInterval: 20s
  timeout: 5m
  wait: true
  prune: true
  sourceRef:
    kind: GitRepository
    name: kubernetes-notes
  path: ./curriculum/14-cicd-supply-chain-gitops/lab/gitops
"@
$kustomization | kubectl apply -f - | Out-Null

kubectl create namespace cloudcart --dry-run=client -o yaml | kubectl apply -f - | Out-Null
$password = [Convert]::ToBase64String([Security.Cryptography.RandomNumberGenerator]::GetBytes(24))
kubectl create secret generic cloudcart-credentials -n cloudcart `
    --from-literal=DATABASE_PASSWORD=$password `
    --from-literal=AMQP_PASSWORD=$password `
    --dry-run=client -o yaml | kubectl apply -f - | Out-Null
$password = $null

flux reconcile source git kubernetes-notes --with-source --timeout=3m
flux reconcile kustomization cloudcart --with-source --timeout=6m
if ($LASTEXITCODE -ne 0) { throw 'Flux reconciliation failed.' }
flux wait kustomization cloudcart --for=condition=ready --timeout=6m
kubectl wait helmrelease/cloudcart -n cloudcart --for=condition=Ready --timeout=6m

Write-Output "GitOps deployment=PASS context=$expectedContext branch=$GitBranch flux=2.9.6"
