[CmdletBinding()]
param(
    [string]$Image = 'cloudcart-app:0.1.0',
    [string]$OutputDirectory = 'tmp/module14/evidence'
)

$ErrorActionPreference = 'Stop'
$required = @('docker', 'helm', 'syft', 'grype', 'cosign')
foreach ($name in $required) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        throw "Required command '$name' is not installed."
    }
}

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
docker image inspect $Image *> $null
if ($LASTEXITCODE -ne 0) {
    docker build -t $Image capstone/cloudcart
    if ($LASTEXITCODE -ne 0) { throw 'CloudCart image build failed.' }
}

$imageId = docker image inspect $Image --format '{{.Id}}'
syft $Image -o "cyclonedx-json=$OutputDirectory/cloudcart.cdx.json"
if ($LASTEXITCODE -ne 0) { throw 'SBOM generation failed.' }
$sbom = Get-Content -Raw "$OutputDirectory/cloudcart.cdx.json" | ConvertFrom-Json
if ($sbom.bomFormat -ne 'CycloneDX' -or $sbom.components.Count -lt 1) {
    throw 'SBOM format or component inventory is invalid.'
}

grype "sbom:$OutputDirectory/cloudcart.cdx.json" --only-fixed `
    -o json --file "$OutputDirectory/grype.json"
if ($LASTEXITCODE -ne 0) { throw 'Vulnerability scan execution failed.' }
$scan = Get-Content -Raw "$OutputDirectory/grype.json" | ConvertFrom-Json

helm lint capstone/cloudcart/helm/cloudcart --strict
if ($LASTEXITCODE -ne 0) { throw 'Helm lint failed.' }
helm package capstone/cloudcart/helm/cloudcart --destination $OutputDirectory | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Helm packaging failed.' }
$chart = Get-ChildItem $OutputDirectory -Filter 'cloudcart-*.tgz' | Select-Object -First 1
if (-not $chart) { throw 'Packaged chart is missing.' }
$chartHash = (Get-FileHash -Algorithm SHA256 $chart.FullName).Hash.ToLowerInvariant()

$previousPassword = $env:COSIGN_PASSWORD
$env:COSIGN_PASSWORD = 'module14-disposable-key'
try {
    cosign generate-key-pair --output-key-prefix "$OutputDirectory/cosign" *> $null
    if ($LASTEXITCODE -ne 0) { throw 'Disposable key generation failed.' }
    cosign sign-blob --yes --key "$OutputDirectory/cosign.key" `
        --bundle "$OutputDirectory/chart.sigstore.json" $chart.FullName *> $null
    if ($LASTEXITCODE -ne 0) { throw 'Chart blob signing failed.' }
    cosign verify-blob --key "$OutputDirectory/cosign.pub" `
        --bundle "$OutputDirectory/chart.sigstore.json" $chart.FullName *> $null
    if ($LASTEXITCODE -ne 0) { throw 'Chart blob verification failed.' }
}
finally {
    $env:COSIGN_PASSWORD = $previousPassword
    Remove-Item -LiteralPath "$OutputDirectory/cosign.key" -Force -ErrorAction SilentlyContinue
}

[ordered]@{
    source = (git rev-parse HEAD)
    image = $Image
    imageId = $imageId
    chart = $chart.Name
    chartSha256 = $chartHash
    sbomFormat = $sbom.bomFormat
    sbomComponents = $sbom.components.Count
    vulnerabilityMatches = @($scan.matches).Count
    signatureBundle = 'chart.sigstore.json'
} | ConvertTo-Json | Set-Content "$OutputDirectory/provenance-summary.json"

Write-Output "Supply-chain evidence=PASS image=$imageId chartSha256=$chartHash output=$OutputDirectory"
