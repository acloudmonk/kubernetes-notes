[CmdletBinding()]
param([string]$TerraformCommand = 'terraform')

$ErrorActionPreference = 'Stop'
if (-not (Get-Command $TerraformCommand -ErrorAction SilentlyContinue)) {
    throw "Required command '$TerraformCommand' is not installed."
}

$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$module = Join-Path $root 'curriculum\15-infrastructure-production-operations\iac\production-platform'
$data = Join-Path $root 'tmp\module15\terraform-data'
$env:TF_DATA_DIR = $data

try {
    & $TerraformCommand "-chdir=$module" fmt -check -recursive
    if ($LASTEXITCODE -ne 0) { throw 'terraform fmt check failed.' }
    & $TerraformCommand "-chdir=$module" init -backend=false -input=false
    if ($LASTEXITCODE -ne 0) { throw 'terraform init failed.' }
    & $TerraformCommand "-chdir=$module" validate
    if ($LASTEXITCODE -ne 0) { throw 'terraform validate failed.' }
    & $TerraformCommand "-chdir=$module" test
    if ($LASTEXITCODE -ne 0) { throw 'terraform test failed.' }
    Write-Output 'Topology test=PASS billable_resources=0 state_committed=false'
}
finally {
    Remove-Item Env:TF_DATA_DIR -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $data) { Remove-Item -LiteralPath $data -Recurse -Force }
}
