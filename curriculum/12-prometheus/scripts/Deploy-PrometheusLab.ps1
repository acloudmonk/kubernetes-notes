[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-prometheus",
    [string]$CloudCartImage = "cloudcart-app:0.1.0"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

docker image inspect $CloudCartImage *> $null
if ($LASTEXITCODE -ne 0) { throw "Build required image '$CloudCartImage' first." }

./curriculum/11-helm/scripts/Deploy-HelmLab.ps1 `
    -ClusterName $ClusterName -Image $CloudCartImage
if ($LASTEXITCODE -ne 0) { throw "CloudCart Helm baseline deployment failed." }

# The Module 11 chart intentionally has no monitoring dependency. This explicit
# lab integration makes discovery metadata visible without installing an operator.
kubectl annotate service cloudcart-api -n cloudcart --overwrite `
    prometheus.io/scrape=true prometheus.io/path=/metrics | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not annotate the CloudCart API Service." }

# Server-side dry run validates namespaced objects only after the namespace is
# discoverable; a multi-document request does not persist its first document.
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f - | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not establish the monitoring namespace." }
kubectl apply --dry-run=server -f curriculum/12-prometheus/lab/monitoring.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Monitoring manifests failed server-side validation." }
kubectl apply -f curriculum/12-prometheus/lab/monitoring.yaml
if ($LASTEXITCODE -ne 0) { throw "Could not apply the monitoring stack." }

kubectl rollout status deployment/alertmanager -n monitoring --timeout=180s
if ($LASTEXITCODE -ne 0) { throw "Alertmanager did not become ready." }
kubectl rollout status deployment/prometheus -n monitoring --timeout=180s
if ($LASTEXITCODE -ne 0) { throw "Prometheus did not become ready." }

kubectl exec -n monitoring deployment/prometheus -- `
    promtool check config /etc/prometheus/prometheus.yml
if ($LASTEXITCODE -ne 0) { throw "Prometheus configuration validation failed." }
kubectl exec -n monitoring deployment/prometheus -- `
    promtool check rules /etc/prometheus/rules/cloudcart-rules.yml
if ($LASTEXITCODE -ne 0) { throw "Prometheus rule validation failed." }

Write-Output "Prometheus lab deployment=PASS context=$expectedContext prometheus=3.15.0 alertmanager=0.34.1 images=digest-pinned"
