[CmdletBinding()]
param([string]$ClusterName = "cloudcart-storage")

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

$claim = kubectl get pvc data-postgres-0 -n cloudcart -o json | ConvertFrom-Json
if ($claim.status.phase -ne "Bound" -or -not $claim.spec.volumeName) {
    throw "PostgreSQL claim is not bound."
}
$volumeName = $claim.spec.volumeName
$claimUid = $claim.metadata.uid
$podUidBefore = kubectl get pod postgres-0 -n cloudcart -o jsonpath='{.metadata.uid}'

$clientCode = @'
import json, urllib.request, uuid
payload = json.dumps({"lines": [{"product_id": "10000000-0000-0000-0000-000000000001", "quantity": 1}]}).encode()
request = urllib.request.Request("http://cloudcart-api:8080/api/orders", data=payload, headers={"Content-Type": "application/json", "Idempotency-Key": "module07-" + uuid.uuid4().hex}, method="POST")
response = urllib.request.urlopen(request, timeout=5)
assert response.status == 201
print(json.load(response)["id"])
'@
$orderId = kubectl run storage-client -n cloudcart --rm -i --restart=Never `
    --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
    --command -- python -c $clientCode
if ($LASTEXITCODE -ne 0 -or -not $orderId) { throw "Could not create the persistence probe order." }

$orderCountBefore = kubectl exec -n cloudcart postgres-0 -- `
    psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM ordering.orders;"
if ($LASTEXITCODE -ne 0 -or [int]$orderCountBefore -lt 1) { throw "Order was not stored." }

kubectl delete pod postgres-0 -n cloudcart --wait=true
if ($LASTEXITCODE -ne 0) { throw "Could not replace the PostgreSQL Pod." }
kubectl rollout status statefulset/postgres -n cloudcart --timeout=180s
if ($LASTEXITCODE -ne 0) { throw "PostgreSQL Pod replacement did not become ready." }

$podUidAfter = kubectl get pod postgres-0 -n cloudcart -o jsonpath='{.metadata.uid}'
$claimAfter = kubectl get pvc data-postgres-0 -n cloudcart -o json | ConvertFrom-Json
$orderCountAfter = kubectl exec -n cloudcart postgres-0 -- `
    psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM ordering.orders;"

if ($podUidAfter -eq $podUidBefore) { throw "PostgreSQL Pod identity did not change." }
if ($claimAfter.metadata.uid -ne $claimUid -or $claimAfter.spec.volumeName -ne $volumeName) {
    throw "PostgreSQL did not reattach the original claim and volume."
}
if ([int]$orderCountAfter -lt [int]$orderCountBefore) { throw "Persisted orders were lost." }

[pscustomobject]@{
    Context = $expectedContext
    Claim = "Bound"
    PersistentVolume = $volumeName
    PodReplaced = $true
    ClaimReused = $true
    OrdersBefore = [int]$orderCountBefore
    OrdersAfter = [int]$orderCountAfter
    Result = "PASS"
} | Format-List
