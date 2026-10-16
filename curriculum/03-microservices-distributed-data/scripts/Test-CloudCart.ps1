[CmdletBinding()]
param(
    [string]$ProjectName = 'cloudcart-module03-verify',
    [string]$TestImage = 'cloudcart-module03-tests:verify'
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker with Compose is required.'
}

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$application = Join-Path $repositoryRoot 'capstone\cloudcart'
$composeFile = Join-Path $application 'compose.yaml'
$compose = @('compose', '--project-name', $ProjectName, '--file', $composeFile)
$testImageCreated = $false
$env:POSTGRES_PASSWORD = 'pg-' + [guid]::NewGuid().ToString('N')
$env:RABBITMQ_USER = 'cloudcart'
$env:RABBITMQ_PASSWORD = 'mq-' + [guid]::NewGuid().ToString('N')

function Invoke-Compose {
    & docker @compose @args
    if ($LASTEXITCODE -ne 0) {
        throw "docker compose failed: $($args -join ' ')"
    }
}

function Wait-Until(
    [scriptblock]$Probe,
    [string]$Failure,
    [int]$Attempts = 90
) {
    foreach ($attempt in 1..$Attempts) {
        try { if (& $Probe) { return } } catch {}
        Start-Sleep -Seconds 2
    }
    throw $Failure
}

try {
    $existing = docker ps --all `
        --filter "label=com.docker.compose.project=$ProjectName" `
        --format '{{.Names}}'
    if ($existing) {
        throw "Refusing to overwrite existing project resources: $($existing -join ', ')"
    }
    docker image inspect $TestImage *> $null
    if ($LASTEXITCODE -eq 0) {
        throw "Refusing to overwrite existing test image '$TestImage'."
    }

    Invoke-Compose config --quiet
    docker build --target test --tag $TestImage $application
    if ($LASTEXITCODE -ne 0) { throw 'The CloudCart test image build failed.' }
    $testImageCreated = $true
    Invoke-Compose build
    Invoke-Compose up --detach

    Wait-Until {
        try {
            (Invoke-WebRequest -UseBasicParsing `
                http://127.0.0.1:8080/health/ready -TimeoutSec 2).StatusCode -eq 200
        }
        catch { $false }
    } 'The CloudCart API did not become ready.'

    $testDsn = 'postgresql://' + 'cloudcart:' + $env:POSTGRES_PASSWORD +
        '@db:5432/cloudcart'
    docker run --rm --network "${ProjectName}_default" `
        --env "TEST_DATABASE_URL=$testDsn" $TestImage
    if ($LASTEXITCODE -ne 0) { throw 'The 14-test CloudCart suite failed.' }

    $catalog = Invoke-RestMethod http://127.0.0.1:8080/api/catalog/items
    if ($catalog.Count -lt 2) { throw 'The catalog contract returned too few products.' }
    $body = @{
        lines = @(@{
            product_id = '10000000-0000-0000-0000-000000000001'
            quantity = 1
        })
    } | ConvertTo-Json -Depth 4 -Compress
    $headers = @{ 'Idempotency-Key' = 'module03-runtime-001' }
    $first = Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8080/api/orders `
        -Headers $headers -ContentType 'application/json' -Body $body
    $again = Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8080/api/orders `
        -Headers $headers -ContentType 'application/json' -Body $body
    if ($first.id -ne $again.id) {
        throw 'An idempotent API replay returned a different order.'
    }
    $orderCount = (& docker @compose exec -T db psql -U cloudcart -d cloudcart `
        -tA -c "SELECT count(*) FROM ordering.orders WHERE id='$($first.id)';").Trim()
    if ($LASTEXITCODE -ne 0 -or $orderCount -ne '1') {
        throw 'The repeated command produced an unexpected business effect.'
    }

    Invoke-Compose stop broker
    $outageHeaders = @{ 'Idempotency-Key' = 'module03-broker-outage-001' }
    $duringOutage = Invoke-RestMethod -Method Post `
        -Uri http://127.0.0.1:8080/api/orders -Headers $outageHeaders `
        -ContentType 'application/json' -Body $body
    $unpublished = (& docker @compose exec -T db psql -U cloudcart -d cloudcart `
        -tA -c ("SELECT count(*) FROM messaging.outbox WHERE aggregate_id=" +
            "'$($duringOutage.id)' AND published_at IS NULL;")).Trim()
    if ($LASTEXITCODE -ne 0 -or $unpublished -ne '1') {
        throw 'The broker outage did not preserve one unpublished event.'
    }

    Invoke-Compose start broker
    Wait-Until {
        $health = & docker @compose exec -T broker `
            rabbitmq-diagnostics -q ping 2>$null
        $LASTEXITCODE -eq 0 -and $health -match 'Ping succeeded'
    } 'RabbitMQ did not recover.'
    Wait-Until {
        $query = (
            'SELECT ((o.published_at IS NOT NULL) AND ' +
            "(n.event_id IS NOT NULL))::text FROM messaging.outbox o " +
            'LEFT JOIN notification.processed_events n ON n.event_id=o.id ' +
            "WHERE o.aggregate_id='$($duringOutage.id)';"
        )
        $result = (& docker @compose exec -T db psql -U cloudcart -d cloudcart `
            -tA -c $query 2>$null).Trim()
        $LASTEXITCODE -eq 0 -and $result -eq 'true'
    } 'The outbox did not drain after broker recovery.'

    $authBytes = [Text.Encoding]::ASCII.GetBytes(
        "$($env:RABBITMQ_USER):$($env:RABBITMQ_PASSWORD)"
    )
    $managementHeaders = @{
        Authorization = 'Basic ' + [Convert]::ToBase64String($authBytes)
    }
    $publishUri = 'http://127.0.0.1:15672/api/exchanges/%2F/cloudcart.events/publish'
    $poisonBody = @{
        properties = @{ delivery_mode = 2 }
        routing_key = 'order.accepted.v1'
        payload = 'not-json'
        payload_encoding = 'string'
    } | ConvertTo-Json -Depth 5 -Compress
    $poison = Invoke-RestMethod -Method Post -Uri $publishUri `
        -Headers $managementHeaders -ContentType 'application/json' -Body $poisonBody
    if (-not $poison.routed) { throw 'The poison message was not routed.' }
    Wait-Until {
        $queues = & docker @compose exec -T broker `
            rabbitmqctl -q list_queues name messages 2>$null
        $LASTEXITCODE -eq 0 -and
            (($queues -join "`n") -match 'cloudcart\.notifications\.dlq\s+1')
    } 'The poison message did not reach the dead-letter queue.'

    $eventRow = (& docker @compose exec -T db psql -U cloudcart -d cloudcart `
        -tA -F '|' -c ("SELECT id,payload::text FROM messaging.outbox WHERE " +
            "aggregate_id='$($first.id)';")).Trim()
    if ($LASTEXITCODE -ne 0 -or -not $eventRow.Contains('|')) {
        throw 'Could not read the original event.'
    }
    $parts = $eventRow.Split('|', 2)
    $eventId = $parts[0]
    $duplicateBody = @{
        properties = @{
            message_id = $eventId
            content_type = 'application/json'
            delivery_mode = 2
        }
        routing_key = 'order.accepted.v1'
        payload = $parts[1]
        payload_encoding = 'string'
    } | ConvertTo-Json -Depth 6 -Compress
    $duplicate = Invoke-RestMethod -Method Post -Uri $publishUri `
        -Headers $managementHeaders -ContentType 'application/json' -Body $duplicateBody
    if (-not $duplicate.routed) { throw 'The duplicate event was not routed.' }
    Wait-Until {
        $count = (& docker @compose exec -T db psql -U cloudcart -d cloudcart `
            -tA -c ("SELECT count(*) FROM notification.processed_events " +
                "WHERE event_id='$eventId';") 2>$null).Trim()
        $LASTEXITCODE -eq 0 -and $count -eq '1'
    } 'The duplicate event produced an unexpected worker effect.' 30

    Write-Output (
        'CloudCart verification=PASS tests=14 command_idempotency=one-effect ' +
        'broker_outage=durable-outbox recovery=delivered ' +
        'poison=dead-lettered event_duplicate=one-effect'
    )
}
finally {
    & docker @compose down --volumes --remove-orphans 2>$null | Out-Null
    if ($testImageCreated) { docker image rm $TestImage 2>$null | Out-Null }
    Remove-Item Env:POSTGRES_PASSWORD, Env:RABBITMQ_USER, Env:RABBITMQ_PASSWORD `
        -ErrorAction SilentlyContinue
    $remaining = docker ps --all `
        --filter "label=com.docker.compose.project=$ProjectName" `
        --format '{{.Names}}'
    $volumes = docker volume ls `
        --filter "label=com.docker.compose.project=$ProjectName" `
        --format '{{.Name}}'
    if ($remaining -or $volumes) {
        throw 'Cleanup left Module 03 project resources.'
    }
    Write-Output 'CloudCart cleanup=PASS'
}
