[CmdletBinding()]
param([string]$ClusterName = "cloudcart-storage")

$ErrorActionPreference = "Stop"
$expectedContext = "kind-$ClusterName"
if ((kubectl config current-context) -ne $expectedContext) {
    throw "Expected context '$expectedContext'."
}

$repositoryRoot = git rev-parse --show-toplevel
$backupDirectory = Join-Path $repositoryRoot "tmp/module07"
$backupPath = Join-Path $backupDirectory "cloudcart.dump"
$backupRelativePath = "tmp/module07/cloudcart.dump"
New-Item -ItemType Directory -Force -Path $backupDirectory | Out-Null
Push-Location $repositoryRoot

try {
    kubectl exec -n cloudcart postgres-0 -- `
        pg_dump -U cloudcart -d cloudcart -Fc -f /tmp/cloudcart-module07.dump
    if ($LASTEXITCODE -ne 0) { throw "pg_dump failed." }
    kubectl cp "cloudcart/postgres-0:/tmp/cloudcart-module07.dump" $backupRelativePath
    if ($LASTEXITCODE -ne 0 -or (Get-Item $backupPath).Length -eq 0) {
        throw "Backup artifact was not copied."
    }

    $sourceCount = kubectl exec -n cloudcart postgres-0 -- `
        psql -U cloudcart -d cloudcart -tAc "SELECT count(*) FROM ordering.orders;"
    kubectl exec -n cloudcart postgres-0 -- dropdb -U cloudcart --if-exists cloudcart_restore
    kubectl exec -n cloudcart postgres-0 -- createdb -U cloudcart cloudcart_restore
    kubectl cp $backupRelativePath "cloudcart/postgres-0:/tmp/cloudcart-module07-restore.dump"
    kubectl exec -n cloudcart postgres-0 -- `
        pg_restore -U cloudcart -d cloudcart_restore --no-owner --no-privileges `
        /tmp/cloudcart-module07-restore.dump
    if ($LASTEXITCODE -ne 0) { throw "Restore into the isolated database failed." }

    $restoredCount = kubectl exec -n cloudcart postgres-0 -- `
        psql -U cloudcart -d cloudcart_restore -tAc "SELECT count(*) FROM ordering.orders;"
    if ([int]$restoredCount -ne [int]$sourceCount) {
        throw "Restore verification count does not match the source."
    }

    [pscustomobject]@{
        Context = $expectedContext
        Format = "PostgreSQL custom archive"
        SourceOrders = [int]$sourceCount
        RestoredOrders = [int]$restoredCount
        IsolatedRestore = "Verified"
        Result = "PASS"
    } | Format-List
}
finally {
    kubectl exec -n cloudcart postgres-0 -- dropdb -U cloudcart --if-exists cloudcart_restore 2>$null
    kubectl exec -n cloudcart postgres-0 -- `
        rm -f /tmp/cloudcart-module07.dump /tmp/cloudcart-module07-restore.dump 2>$null
    if (Test-Path -LiteralPath $backupPath) {
        Remove-Item -LiteralPath $backupPath -Force
    }
    Pop-Location
}
