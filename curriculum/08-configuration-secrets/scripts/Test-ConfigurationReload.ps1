[CmdletBinding()]
param([string]$ClusterName = "cloudcart-configuration")

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

function Get-ReadyRelayPod {
    $pods = kubectl get pod -n cloudcart `
        -l app.kubernetes.io/name=cloudcart-relay -o json | ConvertFrom-Json
    $readyPod = $pods.items | Where-Object {
        -not $_.metadata.deletionTimestamp -and
        ($_.status.conditions | Where-Object {
            $_.type -eq "Ready" -and $_.status -eq "True"
        })
    } | Select-Object -First 1
    if (-not $readyPod) { throw "No non-terminating Ready relay Pod was found." }
    return $readyPod
}

$relayPodBefore = Get-ReadyRelayPod
$podUidBefore = $relayPodBefore.metadata.uid
$environmentBefore = kubectl exec -n cloudcart $relayPodBefore.metadata.name -- `
    printenv RELAY_INTERVAL_SECONDS
if ($environmentBefore -ne "1") { throw "Expected initial relay interval 1." }

try {
    kubectl patch configmap cloudcart-config -n cloudcart --type=merge `
        -p '{"data":{"RELAY_INTERVAL_SECONDS":"2"}}'
    if ($LASTEXITCODE -ne 0) { throw "Could not update the ConfigMap." }

    $storedValue = kubectl get configmap cloudcart-config -n cloudcart `
        -o jsonpath='{.data.RELAY_INTERVAL_SECONDS}'
    $environmentWithoutRestart = kubectl exec -n cloudcart $relayPodBefore.metadata.name -- `
        printenv RELAY_INTERVAL_SECONDS
    if ($storedValue -ne "2" -or $environmentWithoutRestart -ne "1") {
        throw "ConfigMap/environment update semantics did not match expectations."
    }

    kubectl rollout restart deployment/cloudcart-relay -n cloudcart
    kubectl rollout status deployment/cloudcart-relay -n cloudcart --timeout=180s
    if ($LASTEXITCODE -ne 0) { throw "Relay rollout did not complete." }

    $relayPodAfter = Get-ReadyRelayPod
    $podUidAfter = $relayPodAfter.metadata.uid
    $environmentAfter = kubectl exec -n cloudcart $relayPodAfter.metadata.name -- `
        printenv RELAY_INTERVAL_SECONDS
    if ($podUidAfter -eq $podUidBefore -or $environmentAfter -ne "2") {
        throw "The replacement Pod did not consume the updated configuration."
    }

    [pscustomobject]@{
        Context = $expectedContext
        ConfigMapUpdated = $true
        ExistingEnvironment = $environmentWithoutRestart
        ReplacementEnvironment = $environmentAfter
        PodReplaced = $true
        Result = "PASS"
    } | Format-List
}
finally {
    kubectl apply -f capstone/cloudcart/k8s/base/configuration.yaml | Out-Null
    kubectl rollout restart deployment/cloudcart-relay -n cloudcart | Out-Null
    kubectl rollout status deployment/cloudcart-relay -n cloudcart --timeout=180s | Out-Null
}
