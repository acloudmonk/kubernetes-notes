$ErrorActionPreference = 'Stop'

$tools = @(
    @{ Name = 'git'; Required = $true },
    @{ Name = 'python'; Required = $true },
    @{ Name = 'docker'; Required = $false },
    @{ Name = 'kubectl'; Required = $false },
    @{ Name = 'helm'; Required = $false }
)

$missingRequired = $false
foreach ($tool in $tools) {
    $command = Get-Command $tool.Name -ErrorAction SilentlyContinue
    $status = if ($command) { 'available' } else { 'missing' }
    [pscustomobject]@{
        Tool = $tool.Name
        RequiredNow = $tool.Required
        Status = $status
    }
    if ($tool.Required -and -not $command) { $missingRequired = $true }
}

if ($missingRequired) {
    Write-Error 'One or more Phase 2A requirements are missing.'
    exit 1
}

Write-Host 'Phase 2A requirements are available. Optional tools are used later.'
