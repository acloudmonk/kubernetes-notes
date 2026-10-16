[CmdletBinding()]
param(
    [int]$PrimaryPort = 18080,
    [int]$SecondaryPort = 18081,
    [switch]$IncludeNetwork
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

foreach ($name in @('python')) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        throw "Required command '$name' is unavailable."
    }
}
if ($IncludeNetwork -and -not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
    throw "Required command 'curl.exe' is unavailable."
}
if (-not (Get-Command Get-NetTCPConnection -ErrorAction SilentlyContinue)) {
    throw 'This verification script requires Windows PowerShell networking cmdlets.'
}

$pythonPath = (& python -c 'import sys; print(sys.executable)').Trim()
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $pythonPath)) {
    throw 'Could not resolve the Python interpreter.'
}
$probe = Join-Path $PSScriptRoot 'dependency_probe.py'
$servers = [System.Collections.Generic.List[System.Diagnostics.Process]]::new()
$owners = [System.Collections.Generic.HashSet[int]]::new()

function Start-LabServer([int]$Port) {
    $server = Start-Process -FilePath $pythonPath `
        -ArgumentList @('-m', 'http.server', "$Port", '--bind', '127.0.0.1') `
        -PassThru -WindowStyle Hidden
    $servers.Add($server)
    foreach ($attempt in 1..30) {
        $listener = Get-NetTCPConnection -LocalPort $Port -State Listen `
            -ErrorAction SilentlyContinue
        if ($listener) {
            [void]$owners.Add([int]$listener.OwningProcess)
            return $listener
        }
        Start-Sleep -Milliseconds 250
    }
    throw "Port $Port did not enter the listening state."
}

try {
    if ($PrimaryPort -eq $SecondaryPort -or $SecondaryPort -ge 65535) {
        throw 'Choose distinct ports below 65535.'
    }
    $failurePort = $SecondaryPort + 1
    foreach ($port in @($PrimaryPort, $SecondaryPort)) {
        if (Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue) {
            throw "Refusing to use occupied port $port."
        }
    }

    $primary = Start-LabServer $PrimaryPort
    $process = Get-Process -Id $primary.OwningProcess
    $response = Invoke-WebRequest -UseBasicParsing `
        "http://127.0.0.1:$PrimaryPort/" -TimeoutSec 5
    if ($response.StatusCode -ne 200 -or $process.ProcessName -ne 'python') {
        throw 'Process, listener, and HTTP evidence did not agree.'
    }

    $contender = [Net.Sockets.TcpListener]::new(
        [Net.IPAddress]::Loopback,
        $PrimaryPort
    )
    $conflictDetected = $false
    try { $contender.Start() }
    catch [Net.Sockets.SocketException] { $conflictDetected = $true }
    finally { $contender.Stop() }
    if (-not $conflictDetected) {
        throw 'The controlled bind conflict unexpectedly succeeded.'
    }
    Start-LabServer $SecondaryPort | Out-Null

    $env:DEPENDENCY_URL = "http://127.0.0.1:$PrimaryPort/"
    $success = & $pythonPath $probe
    if ($LASTEXITCODE -ne 0 -or ($success -join "`n") -notmatch 'HTTP 200') {
        throw 'The dependency success path failed.'
    }

    if (Get-NetTCPConnection -LocalPort $failurePort -State Listen `
        -ErrorAction SilentlyContinue) {
        throw "Refusing to use occupied failure port $failurePort."
    }
    $env:DEPENDENCY_URL = "http://127.0.0.1:$failurePort/"
    $connectionFailure = & $pythonPath $probe 2>&1
    if ($LASTEXITCODE -ne 1 -or
        ($connectionFailure -join "`n") -notmatch 'connection error') {
        throw 'The connection failure was not classified correctly.'
    }

    Remove-Item Env:DEPENDENCY_URL
    $configurationFailure = & $pythonPath $probe 2>&1
    if ($LASTEXITCODE -ne 2 -or
        ($configurationFailure -join "`n") -notmatch 'configuration error') {
        throw 'The configuration failure was not classified correctly.'
    }

    if ($IncludeNetwork) {
        if (-not (Get-Command Resolve-DnsName -ErrorAction SilentlyContinue)) {
            throw 'Resolve-DnsName is required for -IncludeNetwork.'
        }
        $dns = Resolve-DnsName example.com -Type A
        if (-not $dns.IPAddress) { throw 'DNS produced no IPv4 address.' }

        curl.exe --connect-timeout 5 --max-time 10 --silent --show-error `
            --fail --output NUL https://example.com/
        if ($LASTEXITCODE -ne 0) { throw 'The valid HTTPS request failed.' }

        if (Resolve-DnsName name-that-should-not-exist.invalid `
            -ErrorAction SilentlyContinue) {
            throw 'The reserved .invalid name unexpectedly resolved.'
        }
        curl.exe --connect-timeout 5 --max-time 10 --silent --show-error `
            --fail --output NUL https://wrong.host.badssl.com/ 2>$null
        if ($LASTEXITCODE -eq 0) {
            throw 'The invalid TLS hostname unexpectedly passed verification.'
        }
    }

    $network = if ($IncludeNetwork) { 'verified' } else { 'skipped' }
    Write-Output (
        'Prerequisite labs=PASS process_listener=verified http=200 ' +
        'bind_conflict=detected dependency_boundaries=classified ' +
        "external_dns_tls=$network"
    )
}
finally {
    Remove-Item Env:DEPENDENCY_URL -ErrorAction SilentlyContinue
    # On Windows the selected Python command can be a supervising launcher.
    # Stop it before its socket-owning child so it cannot replace the child.
    foreach ($server in $servers) {
        if (-not $server.HasExited) {
            Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue
        }
    }
    foreach ($processId in $owners) {
        Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    }
    foreach ($attempt in 1..30) {
        $remaining = Get-NetTCPConnection `
            -LocalPort $PrimaryPort, $SecondaryPort -State Listen `
            -ErrorAction SilentlyContinue
        if (-not $remaining) { break }
        Start-Sleep -Milliseconds 250
    }
    if ($remaining) { throw 'Cleanup left a lab listener running.' }
    Write-Output 'Prerequisite labs cleanup=PASS'
}
