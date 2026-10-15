[CmdletBinding()]
param(
    [string]$ClusterName = "cloudcart-configuration",
    [string]$Image = "cloudcart-app:0.1.0"
)

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

./curriculum/07-storage-state/scripts/Deploy-StorageLab.ps1 `
    -ClusterName $ClusterName -Image $Image
if ($LASTEXITCODE -ne 0) { throw "CloudCart storage baseline deployment failed." }

Write-Output "CloudCart configuration deployment=PASS context=$expectedContext image=$Image"
