[CmdletBinding()]
param(
    [switch]$IncludeHistory
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git is required.'
}

$repositoryRoot = git rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
    throw 'Run this script from inside the repository.'
}

Push-Location $repositoryRoot
try {
    $failures = [System.Collections.Generic.List[string]]::new()
    $trackedFiles = @(git ls-files)

    $suspiciousPathPattern =
        '(?i)(^|/)(\.env($|\.)|id_rsa($|\.)|id_ed25519($|\.)|' +
        'credentials($|\.)|secrets?($|\.|/)|kubeconfig($|\.)|' +
        '[^/]+\.(pem|key|p12|pfx|jks|keystore|tfstate($|\.)))'

    $allowedPathPattern =
        '(?i)(\.env(\.[^/]+)?\.example$|credentials\.example(\.[^/]+)?$)'

    foreach ($path in $trackedFiles) {
        if ($path -match $suspiciousPathPattern -and
            $path -notmatch $allowedPathPattern) {
            $failures.Add("suspicious tracked path: $path")
        }
    }

    $trackedIgnored = @(git ls-files -ci --exclude-standard)
    foreach ($path in $trackedIgnored) {
        $failures.Add("tracked file matches .gitignore: $path")
    }

    $signatures = [ordered]@{
        private_key   = '-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----'
        aws_access_key = '\b(AKIA|ASIA)[0-9A-Z]{16}\b'
        github_token  = '\b(gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,})\b'
        slack_token   = '\bxox[baprs]-[A-Za-z0-9-]{20,}\b'
        google_api_key = '\bAIza[0-9A-Za-z_-]{35}\b'
        jwt           = '\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b'
        credential_url = '[a-zA-Z][a-zA-Z0-9+.-]*://[^\s/:@]+:[^\s/@]+@'
    }

    $scanTargets = [ordered]@{
        tracked_worktree = (git grep -I -n -e '.' -- 2>$null) -join "`n"
    }

    if ($IncludeHistory) {
        $scanTargets['history'] = (git log -p --all --no-color) -join "`n"
    }

    foreach ($target in $scanTargets.GetEnumerator()) {
        foreach ($signature in $signatures.GetEnumerator()) {
            if ([regex]::IsMatch($target.Value, $signature.Value)) {
                $failures.Add(
                    "secret signature '$($signature.Key)' detected in $($target.Key)"
                )
            }
        }
    }

    if ($failures.Count -gt 0) {
        Write-Error (
            "Repository hygiene check failed:`n- " +
            ($failures -join "`n- ")
        )
        exit 1
    }

    Write-Output (
        "Repository hygiene: PASS ($($trackedFiles.Count) tracked files; " +
        "history scan: $($IncludeHistory.IsPresent))"
    )
}
finally {
    Pop-Location
}
