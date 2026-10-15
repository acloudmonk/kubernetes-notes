[CmdletBinding()]
param([string]$ClusterName = "cloudcart-networking")

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

$route = kubectl get httproute cloudcart -n cloudcart -o json | ConvertFrom-Json
$conditions = $route.status.parents[0].conditions
foreach ($type in @("Accepted", "ResolvedRefs")) {
    $condition = $conditions | Where-Object { $_.type -eq $type }
    if ($condition.status -ne "True") { throw "HTTPRoute condition '$type' is not True." }
}

$allowedCode = @'
import json, socket, urllib.request, uuid
assert socket.gethostbyname("cloudcart-api.cloudcart.svc.cluster.local")
payload = json.dumps({"lines": [{"product_id": "10000000-0000-0000-0000-000000000001", "quantity": 1}]}).encode()
request = urllib.request.Request("http://cloudcart-api:8080/api/orders", data=payload, headers={"Content-Type": "application/json", "Idempotency-Key": "module06-" + uuid.uuid4().hex}, method="POST")
response = urllib.request.urlopen(request, timeout=5)
assert response.status == 201
print(json.load(response)["id"])
'@
$order = kubectl run allowed-client -n cloudcart --rm -i --restart=Never `
    --labels="learning.cloudcart.io/role=network-client" `
    --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
    --command -- python -c $allowedCode
if ($LASTEXITCODE -ne 0 -or -not $order) { throw "Allowed client failed." }

$deniedCode = @'
import urllib.request
urllib.request.urlopen("http://cloudcart-api:8080/health/live", timeout=3)
'@
kubectl run denied-client -n cloudcart --rm -i --restart=Never `
    --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
    --command -- python -c $deniedCode
if ($LASTEXITCODE -eq 0) { throw "Default-denied client unexpectedly connected." }

$processed = $false
foreach ($attempt in 1..30) {
    $count = kubectl exec -n cloudcart deployment/postgres -- `
        psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM notification.processed_events;"
    if ([int]$count -ge 1) { $processed = $true; break }
    Start-Sleep -Seconds 2
}
if (-not $processed) { throw "Allowed order did not reach the worker." }

$proxyService = kubectl get service -n envoy-gateway-system `
    -l gateway.envoyproxy.io/owning-gateway-name=cloudcart `
    -o jsonpath='{.items[0].metadata.name}'
if (-not $proxyService) { throw "Managed Envoy proxy Service not found." }
$gatewayCode = @'
import urllib.request
request = urllib.request.Request("http://SERVICE.envoy-gateway-system/health/live", headers={"Host": "cloudcart.local"})
assert urllib.request.urlopen(request, timeout=5).status == 200
'@
$gatewayCode = $gatewayCode.Replace("SERVICE", $proxyService)
kubectl run gateway-client -n envoy-gateway-system --rm -i --restart=Never `
    --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
    --command -- python -c $gatewayCode
if ($LASTEXITCODE -ne 0) { throw "Gateway request failed." }

[pscustomobject]@{
    Context = $expectedContext
    Dns = "Resolved"
    AllowedClient = "Connected"
    DeniedClient = "Blocked"
    Gateway = "Routed"
    EventPath = "Processed"
    Result = "PASS"
} | Format-List
