[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-observability",
    [string]$CloudCartImage = "cloudcart-app:0.1.0"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

docker image inspect $CloudCartImage *> $null
if ($LASTEXITCODE -ne 0) { throw "Build required image '$CloudCartImage' first." }

./curriculum/12-prometheus/scripts/Deploy-PrometheusLab.ps1 `
    -ClusterName $ClusterName -CloudCartImage $CloudCartImage
if ($LASTEXITCODE -ne 0) { throw "Module 12 baseline deployment failed." }

kubectl create configmap grafana-dashboard -n monitoring `
    --from-file=cloudcart-overview.json=curriculum/13-grafana-observability/lab/grafana-dashboard.json `
    --dry-run=client -o yaml | kubectl apply -f - | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not create the dashboard ConfigMap." }

kubectl apply --dry-run=server -f curriculum/13-grafana-observability/lab/prometheus.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Prometheus SLO configuration failed validation." }
kubectl apply --dry-run=server -f curriculum/13-grafana-observability/lab/observability.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Observability manifests failed validation." }

kubectl apply -f curriculum/13-grafana-observability/lab/prometheus.yaml | Out-Null
kubectl patch deployment prometheus -n monitoring --type=strategic `
    --patch-file curriculum/13-grafana-observability/lab/prometheus-exemplars-patch.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not enable Prometheus exemplar storage." }
kubectl rollout restart deployment/prometheus -n monitoring | Out-Null

kubectl apply -f curriculum/13-grafana-observability/lab/observability.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not apply the observability stack." }
kubectl rollout restart daemonset/otel-collector -n monitoring | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not restart Collectors after configuration apply." }

foreach ($deployment in @("loki", "tempo", "grafana")) {
    kubectl rollout status "deployment/$deployment" -n monitoring --timeout=240s
    if ($LASTEXITCODE -ne 0) { throw "$deployment did not become ready." }
}
kubectl rollout status daemonset/otel-collector -n monitoring --timeout=240s
if ($LASTEXITCODE -ne 0) { throw "OpenTelemetry Collector did not become ready." }

kubectl set env deployment/cloudcart-api -n cloudcart `
    OTEL_SERVICE_NAME=cloudcart-api `
    OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector.monitoring.svc:4318 `
    DEPLOYMENT_ENVIRONMENT=learning | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not configure CloudCart OTLP export." }
kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=240s
if ($LASTEXITCODE -ne 0) { throw "Instrumented CloudCart API did not become ready." }

kubectl rollout status deployment/prometheus -n monitoring --timeout=180s
kubectl exec -n monitoring deployment/prometheus -- `
    promtool check config /etc/prometheus/prometheus.yml
if ($LASTEXITCODE -ne 0) { throw "Prometheus configuration validation failed." }
kubectl exec -n monitoring deployment/prometheus -- `
    promtool check rules /etc/prometheus/rules/cloudcart-rules.yml
if ($LASTEXITCODE -ne 0) { throw "Prometheus SLO rule validation failed." }
kubectl exec -n monitoring daemonset/otel-collector -- `
    /otelcol-contrib validate --config=/etc/otelcol/collector.yaml
if ($LASTEXITCODE -ne 0) { throw "Collector configuration validation failed." }

Write-Output "Observability lab deployment=PASS context=$expectedContext grafana=13.1.6 loki=3.7.7 tempo=3.1.0 collector=0.160.0 images=digest-pinned"
