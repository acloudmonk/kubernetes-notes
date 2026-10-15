[CmdletBinding()]
param([string]$ClusterName = "cloudcart-workloads")

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
$currentContext = kubectl config current-context
if ($LASTEXITCODE -ne 0 -or $currentContext -ne $expectedContext) {
    throw "Expected context '$expectedContext'; current context is '$currentContext'."
}

$deployments = kubectl get deployments -n cloudcart -o json | ConvertFrom-Json
$expected = @("cloudcart-api", "cloudcart-relay", "cloudcart-worker", "postgres", "rabbitmq")
foreach ($name in $expected) {
    $deployment = $deployments.items | Where-Object { $_.metadata.name -eq $name }
    if (-not $deployment) { throw "Missing Deployment '$name'." }
    if ($deployment.status.readyReplicas -ne $deployment.spec.replicas) {
        throw "Deployment '$name' is not ready."
    }
}

$job = kubectl get job cloudcart-migrate -n cloudcart -o json | ConvertFrom-Json
if ($job.status.succeeded -ne 1) { throw "Migration Job did not succeed." }

$endpoints = kubectl get endpointslice -n cloudcart `
    -l kubernetes.io/service-name=cloudcart-api -o json | ConvertFrom-Json
$readyAddresses = @($endpoints.items.endpoints | Where-Object { $_.conditions.ready -eq $true })
if ($readyAddresses.Count -ne 2) {
    throw "Expected two ready API endpoints; found $($readyAddresses.Count)."
}

$smokeCode = @'
import json, urllib.request, uuid
base = "http://cloudcart-api:8080"
assert urllib.request.urlopen(base + "/health/ready", timeout=5).status == 200
payload = json.dumps({"lines": [{"product_id": "10000000-0000-0000-0000-000000000001", "quantity": 1}]}).encode()
request = urllib.request.Request(base + "/api/orders", data=payload, headers={"Content-Type": "application/json", "Idempotency-Key": "module05-" + uuid.uuid4().hex}, method="POST")
response = urllib.request.urlopen(request, timeout=5)
assert response.status == 201
print(json.load(response)["id"])
'@
$orderId = kubectl exec -n cloudcart deployment/cloudcart-api -- python -c $smokeCode
if ($LASTEXITCODE -ne 0 -or -not $orderId) { throw "API smoke test failed." }

$processed = $false
foreach ($attempt in 1..30) {
    $count = kubectl exec -n cloudcart deployment/postgres -- `
        psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM notification.processed_events;"
    if ([int]$count -ge 1) { $processed = $true; break }
    Start-Sleep -Seconds 2
}
if (-not $processed) { throw "Notification worker did not record the event." }

[pscustomobject]@{
    Context = $currentContext
    Deployments = $expected.Count
    ApiEndpoints = $readyAddresses.Count
    Migration = "Complete"
    Order = $orderId
    Notification = "Processed"
    Result = "PASS"
} | Format-List
