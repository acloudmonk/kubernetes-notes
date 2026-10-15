[CmdletBinding()]
param([string]$ClusterName = "cloudcart-scheduling")

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

function Wait-Until([scriptblock]$Condition, [string]$Failure, [int]$Attempts = 60) {
    foreach ($attempt in 1..$Attempts) {
        if (& $Condition) { return }
        Start-Sleep -Seconds 2
    }
    throw $Failure
}

try {
    $pods = kubectl get pods -n cloudcart -l app.kubernetes.io/part-of=cloudcart -o json | ConvertFrom-Json
    $applicationNodes = kubectl get nodes -l learning.cloudcart.io/role=application -o json | ConvertFrom-Json
    $nodeNames = @($applicationNodes.items.metadata.name)
    if ($nodeNames.Count -ne 2) { throw "Expected exactly two application worker nodes." }
    foreach ($pod in $pods.items) {
        if ($pod.spec.nodeName -notin $nodeNames) {
            throw "Pod '$($pod.metadata.name)' is not on an application worker."
        }
    }

    $apiPods = @($pods.items | Where-Object { $_.metadata.labels.'app.kubernetes.io/name' -eq "cloudcart-api" })
    if ($apiPods.Count -ne 2 -or @($apiPods.spec.nodeName | Select-Object -Unique).Count -ne 2) {
        throw "The two API replicas are not spread across both worker hostnames."
    }
    foreach ($pod in $apiPods) {
        if ($pod.status.qosClass -ne "Burstable" -or $pod.spec.priorityClassName -ne "cloudcart-serving") {
            throw "API QoS or priority does not match the intended policy."
        }
    }

    Wait-Until {
        $hpa = kubectl get hpa cloudcart-api -n cloudcart -o json 2>$null | ConvertFrom-Json
        $able = $hpa.status.conditions | Where-Object { $_.type -eq "AbleToScale" }
        $active = $hpa.status.conditions | Where-Object { $_.type -eq "ScalingActive" }
        return $able.status -eq "True" -and $active.status -eq "True" -and $hpa.status.currentMetrics.Count -ge 1
    } "HPA did not receive usable CPU metrics."

    $pdb = kubectl get pdb cloudcart-api -n cloudcart -o json | ConvertFrom-Json
    if ($pdb.status.currentHealthy -lt 2 -or $pdb.status.disruptionsAllowed -lt 1) {
        throw "API disruption budget is not healthy."
    }

    kubectl apply -f curriculum/09-scheduling-resources/lab/qos-pods.yaml | Out-Null
    kubectl wait --for=condition=Ready pod/qos-guaranteed pod/qos-burstable pod/qos-besteffort `
        -n cloudcart --timeout=120s | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "QoS fixture Pods did not become ready." }
    $expectedQos = @{"qos-guaranteed"="Guaranteed"; "qos-burstable"="Burstable"; "qos-besteffort"="BestEffort"}
    foreach ($entry in $expectedQos.GetEnumerator()) {
        $actual = kubectl get pod $entry.Key -n cloudcart -o jsonpath='{.status.qosClass}'
        if ($actual -ne $entry.Value) { throw "Pod '$($entry.Key)' has QoS '$actual', expected '$($entry.Value)'." }
    }

    kubectl apply -f curriculum/09-scheduling-resources/lab/unschedulable-pod.yaml | Out-Null
    Wait-Until {
        $probe = kubectl get pod impossible-request -n cloudcart -o json | ConvertFrom-Json
        $eventText = kubectl get events -n cloudcart --field-selector involvedObject.name=impossible-request -o json 2>$null | ConvertFrom-Json
        return $probe.status.phase -eq "Pending" -and ($eventText.items.message -join " ") -match "Insufficient cpu"
    } "The impossible request did not produce Pending/Insufficient cpu evidence." 30

    kubectl apply -f curriculum/09-scheduling-resources/lab/oom-pod.yaml | Out-Null
    Wait-Until {
        $probe = kubectl get pod memory-limit-probe -n cloudcart -o json | ConvertFrom-Json
        return $probe.status.containerStatuses[0].state.terminated.reason -eq "OOMKilled"
    } "The memory-limit probe was not OOMKilled." 60

    $clientCode = @'
import json, urllib.request, uuid
payload = json.dumps({"lines": [{"product_id": "10000000-0000-0000-0000-000000000001", "quantity": 1}]}).encode()
request = urllib.request.Request("http://cloudcart-api:8080/api/orders", data=payload, headers={"Content-Type": "application/json", "Idempotency-Key": "module09-" + uuid.uuid4().hex}, method="POST")
response = urllib.request.urlopen(request, timeout=5)
assert response.status == 201
print(json.load(response)["id"])
'@
    $orderId = kubectl run scheduling-client -n cloudcart --rm -i --restart=Never `
        --image=cloudcart-app:0.1.0 --image-pull-policy=IfNotPresent `
        --command -- python -c $clientCode
    if ($LASTEXITCODE -ne 0 -or -not $orderId) { throw "Could not create the end-to-end order." }

    Wait-Until {
        $count = kubectl exec -n cloudcart postgres-0 -- `
            psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM notification.processed_events;"
        return $LASTEXITCODE -eq 0 -and [int]$count -ge 1
    } "The order was not processed by the worker." 30

    [pscustomobject]@{
        Context = $expectedContext
        WorkerPlacement = "PASS"
        ApiSpread = "PASS"
        QoSClasses = "PASS"
        PendingEvidence = "Insufficient cpu"
        MemoryLimitEvidence = "OOMKilled"
        HpaMetrics = "PASS"
        DisruptionBudget = "PASS"
        EventPath = "Processed"
        Result = "PASS"
    } | Format-List
}
finally {
    kubectl delete pods -n cloudcart -l learning.cloudcart.io/fixture=scheduling `
        --ignore-not-found --wait=true | Out-Null
    kubectl delete pod scheduling-client -n cloudcart --ignore-not-found --wait=true | Out-Null
}
