[CmdletBinding()]
param([string]$ClusterName = "cloudcart-configuration")

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

function Set-DatabasePassword([string]$Password) {
    $statement = "ALTER ROLE cloudcart WITH PASSWORD '$Password';"
    $statement | kubectl exec -i -n cloudcart postgres-0 -- `
        psql -U cloudcart -d postgres -v ON_ERROR_STOP=1
    $statement = $null
    if ($LASTEXITCODE -ne 0) { throw "Database credential update failed." }
}

function Set-SecretPassword([string]$Password) {
    $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Password))
    $secret = kubectl get secret cloudcart-credentials -n cloudcart -o json | `
        ConvertFrom-Json
    $secret.data.DATABASE_PASSWORD = $encoded
    $document = $secret | ConvertTo-Json -Depth 20 -Compress
    $document | kubectl replace -f -
    $encoded = $null
    $secret = $null
    $document = $null
    if ($LASTEXITCODE -ne 0) { throw "Kubernetes Secret update failed." }
}

$oldEncoded = kubectl get secret cloudcart-credentials -n cloudcart `
    -o jsonpath='{.data.DATABASE_PASSWORD}'
if ($LASTEXITCODE -ne 0 -or -not $oldEncoded) { throw "Database credential was not found." }
$oldPassword = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($oldEncoded))
$newPassword = [guid]::NewGuid().ToString("N")
$resourceVersionBefore = kubectl get secret cloudcart-credentials -n cloudcart `
    -o jsonpath='{.metadata.resourceVersion}'
$orderCountBefore = kubectl exec -n cloudcart postgres-0 -- `
    psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM ordering.orders;"

try {
    Set-DatabasePassword $newPassword
    Set-SecretPassword $newPassword

    foreach ($deployment in @("cloudcart-api", "cloudcart-relay", "cloudcart-worker")) {
        kubectl rollout restart "deployment/$deployment" -n cloudcart
        kubectl rollout status "deployment/$deployment" -n cloudcart --timeout=180s
        if ($LASTEXITCODE -ne 0) { throw "Deployment '$deployment' did not recover." }
    }

    $clientCode = @'
import json, urllib.request, uuid
payload = json.dumps({"lines": [{"product_id": "10000000-0000-0000-0000-000000000001", "quantity": 1}]}).encode()
request = urllib.request.Request("http://cloudcart-api:8080/api/orders", data=payload, headers={"Content-Type": "application/json", "Idempotency-Key": "module08-" + uuid.uuid4().hex}, method="POST")
response = urllib.request.urlopen(request, timeout=5)
assert response.status == 201
print(json.load(response)["id"])
'@
    $orderId = kubectl run rotation-client -n cloudcart --rm -i --restart=Never `
        --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
        --command -- python -c $clientCode
    if ($LASTEXITCODE -ne 0 -or -not $orderId) { throw "Post-rotation API request failed." }

    $orderCountAfter = kubectl exec -n cloudcart postgres-0 -- `
        psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM ordering.orders;"
    $resourceVersionAfter = kubectl get secret cloudcart-credentials -n cloudcart `
        -o jsonpath='{.metadata.resourceVersion}'
    if ([int]$orderCountAfter -le [int]$orderCountBefore) {
        throw "Post-rotation order was not persisted."
    }
    if ($resourceVersionAfter -eq $resourceVersionBefore) {
        throw "Secret resourceVersion did not change."
    }

    [pscustomobject]@{
        Context = $expectedContext
        BackendCredential = "Rotated"
        SecretResourceVersionChanged = $true
        WorkloadsRestarted = 3
        PostRotationOrder = "Persisted"
        Result = "PASS"
    } | Format-List
}
catch {
    Write-Warning "Rotation failed; attempting to restore the previous generated lab credential."
    Set-DatabasePassword $oldPassword
    Set-SecretPassword $oldPassword
    foreach ($deployment in @("cloudcart-api", "cloudcart-relay", "cloudcart-worker")) {
        kubectl rollout restart "deployment/$deployment" -n cloudcart | Out-Null
        kubectl rollout status "deployment/$deployment" -n cloudcart --timeout=180s | Out-Null
    }
    throw
}
finally {
    $oldEncoded = $null
    $oldPassword = $null
    $newPassword = $null
}
