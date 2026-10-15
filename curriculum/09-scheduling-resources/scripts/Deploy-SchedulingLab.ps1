[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-scheduling",
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

kubectl apply -f capstone/cloudcart/k8s/scheduling/policies.yaml
if ($LASTEXITCODE -ne 0) { throw "Could not apply scheduling and disruption policies." }

$patches = @{
    "cloudcart-api" = "api-placement-patch.yaml"
    "cloudcart-relay" = "relay-placement-patch.yaml"
    "cloudcart-worker" = "worker-placement-patch.yaml"
}
foreach ($entry in $patches.GetEnumerator()) {
    kubectl patch deployment $entry.Key -n cloudcart --type=strategic `
        --patch-file "capstone/cloudcart/k8s/scheduling/$($entry.Value)"
    if ($LASTEXITCODE -ne 0) { throw "Could not patch deployment '$($entry.Key)'." }
}

foreach ($deployment in $patches.Keys) {
    kubectl rollout status "deployment/$deployment" -n cloudcart --timeout=180s
    if ($LASTEXITCODE -ne 0) { throw "Deployment '$deployment' did not become ready." }
}

$metricsServerVersion = "v0.9.0"
$metricsServerManifest = "https://github.com/kubernetes-sigs/metrics-server/releases/download/$metricsServerVersion/components.yaml"
kubectl apply -f $metricsServerManifest
if ($LASTEXITCODE -ne 0) { throw "Could not install Metrics Server $metricsServerVersion." }

$metricsArguments = (kubectl get deployment metrics-server -n kube-system `
    -o jsonpath='{.spec.template.spec.containers[0].args[*]}') -split " "
if ($LASTEXITCODE -ne 0) { throw "Could not inspect Metrics Server arguments." }
if ($metricsArguments -notcontains "--kubelet-insecure-tls") {
    $metricsPatch = ConvertTo-Json -Compress -InputObject @(
        @{op = "add"; path = "/spec/template/spec/containers/0/args/-"; value = "--kubelet-insecure-tls"}
    )
    kubectl patch deployment metrics-server -n kube-system --type=json --patch=$metricsPatch
    if ($LASTEXITCODE -ne 0) { throw "Could not configure Metrics Server for kind kubelet certificates." }
}
kubectl rollout status deployment/metrics-server -n kube-system --timeout=180s
if ($LASTEXITCODE -ne 0) { throw "Metrics Server did not become ready." }

$metricsReady = $false
foreach ($attempt in 1..60) {
    $metrics = kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes 2>$null
    if ($LASTEXITCODE -eq 0 -and ($metrics | ConvertFrom-Json).items.Count -ge 3) {
        $metricsReady = $true
        break
    }
    Start-Sleep -Seconds 2
}
if (-not $metricsReady) { throw "Node metrics did not become available." }

kubectl apply -f capstone/cloudcart/k8s/scheduling/autoscaling.yaml
if ($LASTEXITCODE -ne 0) { throw "Could not apply the API autoscaler." }

Write-Output "CloudCart scheduling deployment=PASS context=$expectedContext image=$Image metrics-server=$metricsServerVersion"
