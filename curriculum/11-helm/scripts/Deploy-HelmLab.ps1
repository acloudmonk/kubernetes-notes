[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-helm",
    [string]$Image = "cloudcart-app:0.1.0",
    [string]$ReleaseName = "cloudcart"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
$chartPath = "capstone/cloudcart/helm/cloudcart"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}
if (-not (Get-Command helm -ErrorAction SilentlyContinue)) {
    throw "Helm 4.3.1 is required. Install it from the official Helm distribution."
}
$helmVersion = helm version --short
if ($LASTEXITCODE -ne 0 -or $helmVersion -notmatch '^v4\.3\.1(?:\+|$)') {
    throw "Expected Helm 4.3.1; found '$helmVersion'."
}

docker image inspect $Image *> $null
if ($LASTEXITCODE -ne 0) { throw "Build '$Image' before deployment." }
kind load docker-image $Image --name $ClusterName
if ($LASTEXITCODE -ne 0) { throw "Failed to load '$Image' into kind." }

kubectl create namespace cloudcart --dry-run=client -o yaml | kubectl apply -f - | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not create the CloudCart namespace." }
$existingSecret = kubectl get secret cloudcart-credentials -n cloudcart --ignore-not-found -o name
if (-not $existingSecret) {
    $databasePassword = [guid]::NewGuid().ToString("N")
    $amqpPassword = [guid]::NewGuid().ToString("N")
    kubectl create secret generic cloudcart-credentials -n cloudcart `
        --from-literal="DATABASE_PASSWORD=$databasePassword" `
        --from-literal="AMQP_PASSWORD=$amqpPassword" `
        --dry-run=client -o yaml | kubectl apply -f - | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Could not create disposable in-cluster credentials." }
    $databasePassword = $null
    $amqpPassword = $null
}

helm lint $chartPath --strict
if ($LASTEXITCODE -ne 0) { throw "Chart lint failed." }
helm template $ReleaseName $chartPath --namespace cloudcart | `
    kubectl apply --dry-run=server -f - | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Rendered manifests failed server-side validation." }

helm upgrade --install $ReleaseName $chartPath --namespace cloudcart `
    --wait --wait-for-jobs --timeout 5m --rollback-on-failure
if ($LASTEXITCODE -ne 0) { throw "Helm install/upgrade failed." }
helm test $ReleaseName --namespace cloudcart --timeout 2m --logs
if ($LASTEXITCODE -ne 0) { throw "Helm chart test failed." }

Write-Output "CloudCart Helm deployment=PASS context=$expectedContext helm=$helmVersion release=$ReleaseName"
