[CmdletBinding()]
param(
    [string]$ClusterName = "architecture-lab"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
$currentContext = kubectl config current-context

if ($LASTEXITCODE -ne 0 -or $currentContext -ne $expectedContext) {
    throw "Expected context '$expectedContext'; current context is '$currentContext'."
}

$clientVersion = kubectl version --client -o json | ConvertFrom-Json
$serverVersion = kubectl version -o json | ConvertFrom-Json
$nodes = kubectl get nodes -o json | ConvertFrom-Json
$systemPods = kubectl get pods -n kube-system -o json | ConvertFrom-Json

if ($nodes.items.Count -ne 2) {
    throw "Expected two nodes; found $($nodes.items.Count)."
}

$notReadyNodes = @(
    $nodes.items | Where-Object {
        ($_.status.conditions | Where-Object type -eq "Ready").status -ne "True"
    }
)
if ($notReadyNodes.Count -gt 0) {
    throw "Nodes not Ready: $($notReadyNodes.metadata.name -join ', ')."
}

$unhealthySystemPods = @(
    $systemPods.items | Where-Object {
        $_.status.phase -notin @("Running", "Succeeded")
    }
)
if ($unhealthySystemPods.Count -gt 0) {
    throw "Unhealthy kube-system Pods: $($unhealthySystemPods.metadata.name -join ', ')."
}

[pscustomobject]@{
    Context = $currentContext
    Client = $clientVersion.clientVersion.gitVersion
    Server = $serverVersion.serverVersion.gitVersion
    Nodes = $nodes.items.Count
    SystemPods = $systemPods.items.Count
    Result = "PASS"
} | Format-List
