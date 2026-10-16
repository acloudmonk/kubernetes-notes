[CmdletBinding()]
param([string]$Image = 'alpine:3.22.2')

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$containers = @('container-fundamentals-lab', 'container-fundamentals-exit')

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker is required.'
}
$existing = docker ps --all --format '{{.Names}}' |
    Where-Object { $_ -in $containers }
if ($existing) {
    throw "Refusing to overwrite existing lab containers: $($existing -join ', ')"
}

try {
    $engine = docker version --format '{{.Server.Os}}|{{.Server.Arch}}'
    $engineParts = $engine.Split('|', 2)
    if ($LASTEXITCODE -ne 0 -or $engineParts[0] -ne 'linux') {
        throw "Expected a Docker Linux engine; found '$engine'."
    }
    docker pull $Image | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Could not pull $Image." }

    $imageIdentity = docker image inspect $Image --format '{{.Id}}'
    docker run --detach --name container-fundamentals-lab `
        --hostname isolated-host --memory 128m --cpus 0.5 $Image `
        sh -c "trap 'echo received-TERM; exit 0' TERM; while :; do sleep 1; done" |
        Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'The long-running container did not start.' }

    $state = docker inspect container-fundamentals-lab | ConvertFrom-Json
    if ($state[0].State.Status -ne 'running' -or
        $state[0].HostConfig.Memory -ne 134217728 -or
        $state[0].HostConfig.NanoCpus -ne 500000000 -or
        $state[0].Image -ne $imageIdentity) {
        throw 'Container state, limits, or image identity did not match.'
    }
    $evidence = docker exec container-fundamentals-lab `
        sh -c 'hostname; id; ps; cat /proc/1/cgroup'
    if ($LASTEXITCODE -ne 0 -or $evidence -notcontains 'isolated-host' -or
        ($evidence -join "`n") -notmatch 'PID') {
        throw 'Process or isolation evidence was incomplete.'
    }

    docker exec container-fundamentals-lab `
        sh -c 'echo runtime-state > /tmp/state.txt'
    docker stop container-fundamentals-lab | Out-Null
    docker start container-fundamentals-lab | Out-Null
    if ((docker exec container-fundamentals-lab cat /tmp/state.txt) -ne 'runtime-state') {
        throw 'The writable layer did not persist across stop/start.'
    }

    docker stop --timeout 5 container-fundamentals-lab | Out-Null
    $logs = docker logs container-fundamentals-lab
    $exit = docker inspect container-fundamentals-lab `
        --format 'status={{.State.Status}} exit={{.State.ExitCode}}'
    if ($logs -notcontains 'received-TERM' -or $exit -ne 'status=exited exit=0') {
        throw 'Graceful termination verification failed.'
    }

    docker run --name container-fundamentals-exit $Image echo completed | Out-Null
    $finite = docker inspect container-fundamentals-exit `
        --format 'status={{.State.Status}} exit={{.State.ExitCode}}'
    if ($finite -ne 'status=exited exit=0') {
        throw 'The finite process did not exit successfully.'
    }

    Write-Output (
        "Container lab=PASS engine=linux/$($engineParts[1]) limits=verified " +
        'process_cgroup=observed writable_layer=persisted ' +
        'termination=graceful finite_process=exit0'
    )
}
finally {
    docker rm --force @containers 2>$null | Out-Null
    $remaining = docker ps --all --filter 'name=container-fundamentals' `
        --format '{{.Names}}'
    if ($remaining) { throw 'Cleanup left a Module 01 container.' }
    Write-Output 'Container lab cleanup=PASS'
}
