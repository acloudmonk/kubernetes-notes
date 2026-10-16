[CmdletBinding()]
param([string]$ClusterName = 'cloudcart-advanced')

$ErrorActionPreference = 'Stop'
if ((kubectl config current-context) -ne "kind-$ClusterName") { throw 'Unexpected Kubernetes context.' }

function Wait-ForValue([scriptblock]$Read, [scriptblock]$Accept, [string]$Failure) {
    foreach ($attempt in 1..60) {
        $value = & $Read
        if (& $Accept $value) { return $value }
        Start-Sleep -Seconds 2
    }
    throw $Failure
}

Wait-ForValue { kubectl get ccp sample -n operator-lab -o jsonpath='{.status.ready}' 2>$null } { param($v) $v -eq 'true' } 'Initial policy did not reconcile.' | Out-Null
$initial = kubectl get configmap policy-sample -n operator-lab -o jsonpath='{.data.message}'
if ($initial -ne 'initial-policy') { throw 'Initial ConfigMap content is wrong.' }

kubectl patch configmap policy-sample -n operator-lab --type=merge -p '{"data":{"message":"manual-drift"}}' | Out-Null
Wait-ForValue { kubectl get configmap policy-sample -n operator-lab -o jsonpath='{.data.message}' } { param($v) $v -eq 'initial-policy' } 'Controller did not correct drift.' | Out-Null

$controllerScaledDown = $false
try {
    kubectl scale deployment/cloudcart-policy-controller -n operator-lab --replicas=0 | Out-Null
    $controllerScaledDown = $true
    kubectl wait --for=delete pod -n operator-lab -l app=cloudcart-policy-controller --timeout=90s | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'Controller Pod did not terminate.' }
    $fixture = '{"apiVersion":"learning.cloudcart.io/v1alpha1","kind":"CloudCartPolicy","metadata":{"name":"recovery","namespace":"operator-lab"},"spec":{"message":"after-recovery"}}'
    $fixture | kubectl apply -f - | Out-Null
    Start-Sleep -Seconds 4
    kubectl get configmap policy-recovery -n operator-lab *> $null
    if ($LASTEXITCODE -eq 0) { throw 'Resource reconciled while the controller was stopped.' }
    kubectl scale deployment/cloudcart-policy-controller -n operator-lab --replicas=1 | Out-Null
    $controllerScaledDown = $false
    kubectl rollout status deployment/cloudcart-policy-controller -n operator-lab --timeout=180s | Out-Null
    Wait-ForValue { kubectl get configmap policy-recovery -n operator-lab -o jsonpath='{.data.message}' 2>$null } { param($v) $v -eq 'after-recovery' } 'Controller did not recover reconciliation.' | Out-Null

    kubectl delete ccp recovery -n operator-lab --wait=false | Out-Null
    kubectl wait --for=delete ccp/recovery -n operator-lab --timeout=90s
    kubectl get configmap policy-recovery -n operator-lab *> $null
    if ($LASTEXITCODE -eq 0) { throw 'Finalizer cleanup left the managed ConfigMap.' }
}
finally {
    if ($controllerScaledDown) {
        kubectl scale deployment/cloudcart-policy-controller -n operator-lab --replicas=1 *> $null
        kubectl rollout status deployment/cloudcart-policy-controller -n operator-lab --timeout=180s *> $null
    }
    kubectl get ccp recovery -n operator-lab *> $null
    if ($LASTEXITCODE -eq 0) {
        kubectl delete ccp recovery -n operator-lab --wait=true --timeout=90s *> $null
    }
}

Write-Output 'Operator test=PASS schema=status finalizer=cleaned drift=corrected outage=recovered'
