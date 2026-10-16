[CmdletBinding()]
param(
    [string]$ClusterName = 'cloudcart-production-ops',
    [string]$CloudCartImage = 'cloudcart-app:0.1.0'
)

$ErrorActionPreference = 'Stop'
foreach ($name in @('docker', 'kind', 'kubectl', 'helm')) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) { throw "Required command '$name' is not installed." }
}

$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$kindConfig = Join-Path $root 'curriculum\15-infrastructure-production-operations\lab\kind-config.yaml'
$policy = Join-Path $root 'curriculum\15-infrastructure-production-operations\lab\operations-policy.yaml'
$values = Join-Path $root 'curriculum\15-infrastructure-production-operations\lab\values-production-lab.yaml'
$chart = Join-Path $root 'capstone\cloudcart\helm\cloudcart'

if (-not (kind get clusters | Select-String -SimpleMatch $ClusterName)) {
    kind create cluster --config $kindConfig `
        --image kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed
    if ($LASTEXITCODE -ne 0) { throw 'kind cluster creation failed.' }
}
$expectedContext = "kind-$ClusterName"
kubectl config use-context $expectedContext | Out-Null

docker image inspect $CloudCartImage *> $null
if ($LASTEXITCODE -ne 0) {
    docker build -t $CloudCartImage (Join-Path $root 'capstone\cloudcart')
    if ($LASTEXITCODE -ne 0) { throw 'CloudCart image build failed.' }
}
kind load docker-image $CloudCartImage --name $ClusterName
if ($LASTEXITCODE -ne 0) { throw 'Could not load the CloudCart image.' }

kubectl create namespace cloudcart --dry-run=client -o yaml | kubectl apply -f - | Out-Null
kubectl apply -f $policy | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Capacity policy failed to apply.' }

kubectl get secret cloudcart-credentials -n cloudcart *> $null
if ($LASTEXITCODE -ne 0) {
    $credentialAction = 'generated'
    $databasePassword = [Convert]::ToBase64String([Security.Cryptography.RandomNumberGenerator]::GetBytes(24))
    $amqpPassword = [Convert]::ToBase64String([Security.Cryptography.RandomNumberGenerator]::GetBytes(24))
    kubectl create secret generic cloudcart-credentials -n cloudcart `
        --from-literal=DATABASE_PASSWORD=$databasePassword `
        --from-literal=AMQP_PASSWORD=$amqpPassword `
        --dry-run=client -o yaml | kubectl apply -f - | Out-Null
    $databasePassword = $null
    $amqpPassword = $null
}
else {
    $credentialAction = 'reused'
}

helm upgrade --install cloudcart $chart -n cloudcart -f $values --wait --wait-for-jobs --timeout 8m
if ($LASTEXITCODE -ne 0) { throw 'CloudCart Helm deployment failed.' }
kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=180s
if ($LASTEXITCODE -ne 0) { throw 'CloudCart API did not become ready.' }

Write-Output "Operations deployment=PASS context=$expectedContext credentials=$credentialAction topology=two-workers"
