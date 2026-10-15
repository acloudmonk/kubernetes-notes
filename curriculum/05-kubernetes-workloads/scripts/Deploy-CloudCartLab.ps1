[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-workloads",
    [string]$Image = "cloudcart-app:0.1.0"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
$currentContext = kubectl config current-context
if ($LASTEXITCODE -ne 0 -or $currentContext -ne $expectedContext) {
    throw "Expected context '$expectedContext'; current context is '$currentContext'."
}

docker image inspect $Image *> $null
if ($LASTEXITCODE -ne 0) {
    throw "Build '$Image' before deployment."
}

kind load docker-image $Image --name $ClusterName
if ($LASTEXITCODE -ne 0) { throw "Failed to load '$Image' into kind." }

kubectl apply -f capstone/cloudcart/k8s/base/namespace.yaml
if ($LASTEXITCODE -ne 0) { throw "Failed to create namespace." }

$existingSecret = kubectl get secret cloudcart-credentials `
    --namespace cloudcart --ignore-not-found -o name
if (-not $existingSecret) {
    $databasePassword = [guid]::NewGuid().ToString("N")
    $amqpPassword = [guid]::NewGuid().ToString("N")
    kubectl create secret generic cloudcart-credentials `
        --namespace cloudcart `
        --from-literal="DATABASE_PASSWORD=$databasePassword" `
        --from-literal="AMQP_PASSWORD=$amqpPassword" `
        --dry-run=client -o yaml | kubectl apply -f -
    if ($LASTEXITCODE -ne 0) { throw "Failed to create in-cluster credentials." }
    $databasePassword = $null
    $amqpPassword = $null
}

kubectl apply -k capstone/cloudcart/k8s/base
if ($LASTEXITCODE -ne 0) { throw "Failed to apply base resources." }
kubectl rollout status deployment/postgres -n cloudcart --timeout=180s
kubectl rollout status deployment/rabbitmq -n cloudcart --timeout=180s

kubectl delete job cloudcart-migrate -n cloudcart --ignore-not-found --wait=true
kubectl apply -f capstone/cloudcart/k8s/migration-job.yaml
kubectl wait --for=condition=complete job/cloudcart-migrate -n cloudcart --timeout=180s

kubectl apply -f capstone/cloudcart/k8s/applications.yaml
foreach ($deployment in @("cloudcart-api", "cloudcart-relay", "cloudcart-worker")) {
    kubectl rollout status "deployment/$deployment" -n cloudcart --timeout=180s
    if ($LASTEXITCODE -ne 0) { throw "Deployment '$deployment' did not become ready." }
}

Write-Output "CloudCart deployment=PASS context=$currentContext image=$Image"
