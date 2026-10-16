[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-prometheus"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

$clientPod = "metrics-client"
$apiReplicas = [int](kubectl get deployment cloudcart-api -n cloudcart -o jsonpath='{.spec.replicas}')

function Get-ApiJson {
    param([Parameter(Mandatory)][string]$Url)
    $program = 'import json,sys,urllib.request; print(json.dumps(json.load(urllib.request.urlopen(sys.argv[1], timeout=5))))'
    $response = kubectl exec -n monitoring $clientPod -- python -c $program $Url
    if ($LASTEXITCODE -ne 0) { throw "API request failed: $Url" }
    return $response | ConvertFrom-Json
}

function Get-PrometheusVector {
    param([Parameter(Mandatory)][string]$Expression)
    $encoded = [uri]::EscapeDataString($Expression)
    $response = Get-ApiJson "http://prometheus:9090/api/v1/query?query=$encoded"
    if ($response.status -ne "success") { throw "Prometheus query failed: $Expression" }
    return @($response.data.result)
}

function Wait-ForCondition {
    param(
        [Parameter(Mandatory)][scriptblock]$Condition,
        [Parameter(Mandatory)][string]$Failure,
        [int]$Attempts = 30,
        [int]$DelaySeconds = 3
    )
    foreach ($attempt in 1..$Attempts) {
        if (& $Condition) { return }
        Start-Sleep -Seconds $DelaySeconds
    }
    throw $Failure
}

try {
    kubectl delete pod $clientPod -n monitoring --ignore-not-found --wait=true | Out-Null
    kubectl run $clientPod -n monitoring --image=cloudcart-app:0.1.0 `
        --image-pull-policy=IfNotPresent --restart=Never --command -- sleep 900 | Out-Null
    kubectl wait --for=condition=Ready pod/$clientPod -n monitoring --timeout=120s | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Metrics client Pod did not become ready." }

    Wait-ForCondition -Failure "Prometheus did not discover both CloudCart API targets." -Condition {
        $targets = Get-PrometheusVector 'up{job="cloudcart-api"} == 1'
        return $targets.Count -eq 2
    }

    $trafficProgram = @'
import json
import urllib.request
import uuid

base_url = "http://cloudcart-" + "api" + ".cloudcart.svc:" + str(8080)
for _ in range(8):
    urllib.request.urlopen(base_url + "/api/catalog/items", timeout=5).read()
for _ in range(3):
    payload = json.dumps({"lines": [{"product_id": "10000000-0000-0000-0000-000000000001", "quantity": 1}]}).encode()
    request = urllib.request.Request(
        base_url + "/api/orders",
        data=payload,
        headers={"Content-Type": "application/json", "Idempotency-Key": "module12-" + uuid.uuid4().hex},
        method="POST",
    )
    response = urllib.request.urlopen(request, timeout=5)
    assert response.status == 201
    order_id = json.load(response)["id"]
    urllib.request.urlopen(
        base_url + "/api/orders/" + order_id,
        timeout=5,
    ).read()
'@
    kubectl exec -n monitoring $clientPod -- python -c $trafficProgram
    if ($LASTEXITCODE -ne 0) { throw "Could not generate bounded CloudCart traffic." }

    Wait-ForCondition -Failure "Recorded HTTP rate did not become available." -Condition {
        $rate = Get-PrometheusVector 'sum(cloudcart:http_requests:rate1m) > 0'
        return $rate.Count -eq 1
    }

    $routeLabels = Get-ApiJson "http://prometheus:9090/api/v1/label/route/values"
    $uuidLabel = @($routeLabels.data | Where-Object {
        $_ -match '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
    })
    if ($uuidLabel.Count -gt 0) {
        throw "A resource identifier leaked into the route label cardinality boundary."
    }
    if ($routeLabels.data -notcontains "/api/orders" -or
        $routeLabels.data -notcontains "/api/orders/{order_id}" -or
        $routeLabels.data -notcontains "/api/catalog/items") {
        throw "Expected bounded route labels were not scraped."
    }

    $tsdb = Get-ApiJson "http://prometheus:9090/api/v1/status/tsdb"
    $seriesCount = [int]$tsdb.data.headStats.numSeries
    if ($seriesCount -le 0 -or $seriesCount -gt 2000) {
        throw "Unexpected lab TSDB series count: $seriesCount"
    }

    kubectl scale deployment/cloudcart-api -n cloudcart --replicas=0 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Could not inject the missing-target failure." }
    kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=120s | Out-Null

    Wait-ForCondition -Attempts 30 -DelaySeconds 3 `
        -Failure "CloudCartAPITargetsMissing did not fire in Prometheus." -Condition {
        $alerts = Get-ApiJson "http://prometheus:9090/api/v1/alerts"
        return @($alerts.data.alerts | Where-Object {
            $_.labels.alertname -eq "CloudCartAPITargetsMissing" -and $_.state -eq "firing"
        }).Count -eq 1
    }

    Wait-ForCondition -Attempts 20 -DelaySeconds 3 `
        -Failure "Alertmanager did not receive the firing alert." -Condition {
        $alerts = Get-ApiJson "http://alertmanager:9093/api/v2/alerts?active=true&silenced=false&inhibited=false"
        return @($alerts | Where-Object { $_.labels.alertname -eq "CloudCartAPITargetsMissing" }).Count -eq 1
    }

    kubectl scale deployment/cloudcart-api -n cloudcart --replicas=$apiReplicas | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Could not restore the CloudCart API replicas." }
    kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=180s | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "CloudCart API did not recover." }
    Wait-ForCondition -Failure "Both CloudCart API scrape targets did not recover." -Condition {
        $targets = Get-PrometheusVector 'up{job="cloudcart-api"} == 1'
        return $targets.Count -eq 2
    }
    Wait-ForCondition -Attempts 20 -DelaySeconds 3 `
        -Failure "CloudCartAPITargetsMissing did not resolve after recovery." -Condition {
        $alerts = Get-ApiJson "http://prometheus:9090/api/v1/alerts"
        return @($alerts.data.alerts | Where-Object {
            $_.labels.alertname -eq "CloudCartAPITargetsMissing" -and $_.state -eq "firing"
        }).Count -eq 0
    }

    [pscustomobject]@{
        Context = $expectedContext
        HealthyTargets = 2
        RecordedRate = "PASS"
        BoundedRouteLabels = "PASS"
        HeadSeries = $seriesCount
        MissingTargetAlert = "Firing"
        AlertmanagerRoute = "PASS"
        RecoveredTargets = 2
        AlertResolution = "PASS"
        Result = "PASS"
    } | Format-List
}
finally {
    kubectl scale deployment/cloudcart-api -n cloudcart --replicas=$apiReplicas *> $null
    kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=180s *> $null
    kubectl delete pod $clientPod -n monitoring --ignore-not-found --wait=false *> $null
}
