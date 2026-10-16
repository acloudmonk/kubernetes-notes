[CmdletBinding()]
param([string]$ClusterName = 'cloudcart-production-ops')

$ErrorActionPreference = 'Stop'
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) { throw "Expected context '$expectedContext'." }

$apiPods = @(kubectl get pods -n cloudcart -l app.kubernetes.io/component=api -o json | ConvertFrom-Json | Select-Object -ExpandProperty items)
if ($apiPods.Count -ne 2 -or @($apiPods | Where-Object { $_.status.phase -eq 'Running' }).Count -ne 2) {
    throw 'Expected two running API replicas.'
}
$initialNodes = @($apiPods | ForEach-Object { $_.spec.nodeName } | Sort-Object -Unique)
if ($initialNodes.Count -ne 2) { throw 'API replicas are not spread across two workers.' }

$pdb = kubectl get pdb cloudcart-api -n cloudcart -o json | ConvertFrom-Json
if ([int]$pdb.status.disruptionsAllowed -lt 1) { throw 'The API PDB permits no voluntary disruption.' }

$postgresPod = 'cloudcart-postgres-0'
$processedBefore = kubectl exec -n cloudcart $postgresPod -- `
    psql -U cloudcart -d cloudcart -tAc 'SELECT count(*) FROM notification.processed_events;'
if ($LASTEXITCODE -ne 0) { throw 'Could not read the initial processed-event count.' }

$clientCode = @'
import json, urllib.request, uuid
payload=json.dumps({"lines":[{"product_id":"10000000-0000-0000-0000-000000000001","quantity":1}]}).encode()
request=urllib.request.Request("http://cloudcart-api:8080/api/orders",data=payload,headers={"Content-Type":"application/json","Idempotency-Key":"module15-"+uuid.uuid4().hex},method="POST")
response=urllib.request.urlopen(request,timeout=10)
assert response.status == 201
print(json.load(response)["id"])
'@

$drainedNode = $apiPods[0].spec.nodeName
$restoredDatabase = $false
try {
    kubectl drain $drainedNode --pod-selector=app.kubernetes.io/component=api `
        --ignore-daemonsets --delete-emptydir-data --timeout=180s
    if ($LASTEXITCODE -ne 0) { throw 'Bounded API drain failed.' }

    $available = kubectl get deployment cloudcart-api -n cloudcart -o jsonpath='{.status.availableReplicas}'
    if ([int]$available -lt 1) { throw 'API availability fell below the PDB objective.' }

    $orderId = kubectl run module15-client -n cloudcart --rm -i --restart=Never `
        --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
        --command -- python -c $clientCode
    if ($LASTEXITCODE -ne 0 -or -not $orderId) { throw 'Could not create an order during the bounded disruption.' }

    $processed = $false
    foreach ($attempt in 1..30) {
        $count = kubectl exec -n cloudcart $postgresPod -- `
            psql -U cloudcart -d cloudcart -tAc 'SELECT count(*) FROM notification.processed_events;'
        if ($LASTEXITCODE -eq 0 -and [int]$count -gt [int]$processedBefore) { $processed = $true; break }
        Start-Sleep -Seconds 2
    }
    if (-not $processed) { throw 'The disrupted system did not complete the order event path.' }

    kubectl exec -n cloudcart $postgresPod -- pg_dump -U cloudcart -d cloudcart -Fc -f /tmp/module15.dump
    if ($LASTEXITCODE -ne 0) { throw 'Database backup failed.' }
    kubectl exec -n cloudcart $postgresPod -- createdb -U cloudcart cloudcart_restore
    if ($LASTEXITCODE -ne 0) { throw 'Could not create the isolated restore database.' }
    $restoredDatabase = $true
    kubectl exec -n cloudcart $postgresPod -- pg_restore -U cloudcart -d cloudcart_restore --no-owner --no-privileges /tmp/module15.dump
    if ($LASTEXITCODE -ne 0) { throw 'Isolated database restore failed.' }
    $sourceOrders = kubectl exec -n cloudcart $postgresPod -- psql -U cloudcart -d cloudcart -tAc 'SELECT count(*) FROM ordering.orders;'
    $restoredOrders = kubectl exec -n cloudcart $postgresPod -- psql -U cloudcart -d cloudcart_restore -tAc 'SELECT count(*) FROM ordering.orders;'
    if ([int]$sourceOrders -ne [int]$restoredOrders) { throw 'Restored business data does not match the source.' }

    Write-Output "Operations test=PASS drained_node=$drainedNode available_during_drain=$available order=$orderId restored_orders=$restoredOrders"
}
finally {
    kubectl uncordon $drainedNode *> $null
    if ($restoredDatabase) { kubectl exec -n cloudcart $postgresPod -- dropdb -U cloudcart cloudcart_restore *> $null }
    kubectl exec -n cloudcart $postgresPod -- rm -f /tmp/module15.dump *> $null
    kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=180s *> $null
}
