[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-observability"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

$clientPod = "observability-client"

function Get-ApiJson {
    param([Parameter(Mandatory)][string]$Url)
    $program = 'import json,sys,urllib.request; print(json.dumps(json.load(urllib.request.urlopen(sys.argv[1], timeout=10))))'
    $response = kubectl exec -n monitoring $clientPod -- python -c $program $Url
    if ($LASTEXITCODE -ne 0) { throw "API request failed: $Url" }
    return $response | ConvertFrom-Json
}

function Wait-ForCondition {
    param(
        [Parameter(Mandatory)][scriptblock]$Condition,
        [Parameter(Mandatory)][string]$Failure,
        [int]$Attempts = 40,
        [int]$DelaySeconds = 3
    )
    foreach ($attempt in 1..$Attempts) {
        if (& $Condition) { return }
        Start-Sleep -Seconds $DelaySeconds
    }
    throw $Failure
}

function Test-TempoTrace {
    param([Parameter(Mandatory)][string]$TraceId)
    $program = @'
import json
import sys
import urllib.error
import urllib.request

try:
    response = json.load(urllib.request.urlopen(sys.argv[1], timeout=10))
    print("true" if response.get("batches") else "false")
except urllib.error.HTTPError as error:
    if error.code != 404:
        raise
    print("false")
'@
    $result = kubectl exec -n monitoring $clientPod -- python -c $program `
        "http://tempo:3200/api/traces/$TraceId"
    if ($LASTEXITCODE -ne 0) { throw "Tempo trace lookup failed." }
    return $result -eq "true"
}

try {
    kubectl delete pod $clientPod -n monitoring --ignore-not-found --wait=true | Out-Null
    kubectl run $clientPod -n monitoring --image=cloudcart-app:0.1.0 `
        --image-pull-policy=IfNotPresent --restart=Never --command -- sleep 900 | Out-Null
    kubectl wait --for=condition=Ready pod/$clientPod -n monitoring --timeout=120s | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Observability client Pod did not become ready." }

    $health = Get-ApiJson "http://grafana:3000/api/health"
    if ($health.database -ne "ok") { throw "Grafana health check did not report database=ok." }
    foreach ($uid in @("prometheus", "loki", "tempo")) {
        $source = Get-ApiJson "http://grafana:3000/api/datasources/uid/$uid"
        if ($source.uid -ne $uid) { throw "Grafana data source '$uid' is not provisioned." }
    }
    $dashboard = Get-ApiJson "http://grafana:3000/api/dashboards/uid/cloudcart-overview"
    if ($dashboard.dashboard.title -ne "CloudCart RED and SLO overview") {
        throw "The provisioned CloudCart dashboard is unavailable."
    }

    $trafficProgram = @'
import json
import urllib.request

payload = json.dumps({"lines": [{"product_id": "10000000-0000-0000-0000-000000000002", "quantity": 1}]}).encode()
order_ids = []
for _ in range(4):
    request = urllib.request.Request(
        "http://cloudcart-api.cloudcart.svc:8080/api/orders",
        data=payload,
        headers={"Content-Type": "application/json", "Idempotency-Key": "module13-observability-check"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=10) as response:
        assert response.status == 201
        order_ids.append(json.load(response)["id"])
print(json.dumps(order_ids))
'@
    $trafficOutput = kubectl exec -n monitoring $clientPod -- python -c $trafficProgram
    if ($LASTEXITCODE -ne 0) { throw "Could not generate traced CloudCart traffic." }
    $orderIds = @($trafficOutput | Select-Object -Last 1 | ConvertFrom-Json)
    if ($orderIds.Count -ne 4) { throw "Expected four generated order identifiers." }
    # A classic histogram retains the newest exemplar per bucket and label set.
    # Select the final request so earlier requests cannot replace its exemplar.
    $correlationOrderId = $orderIds[-1]
    Write-Output "traffic=PASS orders=$($orderIds.Count)"

    $script:traceId = $null
    $lokiExpression = "{service_name=`"cloudcart-api`"} |= `"$correlationOrderId`""
    $lokiQuery = [uri]::EscapeDataString($lokiExpression)
    Wait-ForCondition -Failure "A correlated CloudCart log did not arrive in Loki." -Condition {
        $logs = Get-ApiJson "http://loki:3100/loki/api/v1/query_range?query=$lokiQuery&limit=50&direction=backward"
        $latestTimestamp = [Int64]::MinValue
        $latestTraceId = $null
        foreach ($stream in @($logs.data.result)) {
            foreach ($entry in @($stream.values)) {
                try {
                    $document = $entry[1] | ConvertFrom-Json
                    $timestamp = [Int64]$entry[0]
                    if ($document.trace_id -match '^[0-9a-f]{32}$' -and
                        $timestamp -gt $latestTimestamp) {
                        $latestTimestamp = $timestamp
                        $latestTraceId = $document.trace_id
                    }
                } catch { }
            }
        }
        if ($null -ne $latestTraceId) {
            $script:traceId = $latestTraceId
            return $true
        }
        return $false
    }

    Wait-ForCondition -Failure "The correlated trace did not arrive in Tempo." -Condition {
        return Test-TempoTrace $script:traceId
    }

    $promQuery = [uri]::EscapeDataString('cloudcart:slo_availability:ratio5m')
    Wait-ForCondition -Failure "The availability SLI recording rule has no result." -Condition {
        $result = Get-ApiJson "http://prometheus:9090/api/v1/query?query=$promQuery"
        return @($result.data.result).Count -eq 1
    }

    $end = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $start = $end - 300
    $exemplarQuery = [uri]::EscapeDataString('cloudcart_http_request_duration_seconds_bucket{route="/api/orders"}')
    Wait-ForCondition -Failure "Prometheus did not store a trace-linked exemplar." -Condition {
        $result = Get-ApiJson "http://prometheus:9090/api/v1/query_exemplars?query=$exemplarQuery&start=$start&end=$end"
        $ids = @($result.data | ForEach-Object { $_.exemplars } | ForEach-Object { $_.labels.trace_id })
        return $ids -contains $script:traceId
    }

    Write-Output "Observability lab tests=PASS dashboard=provisioned logs=correlated trace=$script:traceId slo=recorded exemplar=linked"
}
finally {
    kubectl delete pod $clientPod -n monitoring --ignore-not-found --wait=true | Out-Null
}
