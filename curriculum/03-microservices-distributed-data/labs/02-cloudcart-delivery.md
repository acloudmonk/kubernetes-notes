# Lab 2 — Run the CloudCart Delivery Path

> **Module:** [03 — Microservices and Distributed Data](../README.md) · Previous:
> [Lab 1 — Boundaries and contracts](01-boundaries-contracts.md) · Next:
> [Independent challenge](../independent-challenge.md)

## Safety and prerequisites

The Compose project binds API and RabbitMQ management ports to loopback. It
uses only synthetic data. Do not reuse real credentials; create
`capstone/cloudcart/.env` from `.env.example` with local-only values. The file
is ignored by Git.

From `capstone/cloudcart`:

```powershell
Copy-Item .env.example .env
docker compose config --quiet
docker compose build
docker compose up --detach
docker compose ps
```

## Verify the request path

List products, then use one product ID in an order:

```powershell
Invoke-RestMethod http://127.0.0.1:8080/api/catalog/items
$body = '{"lines":[{"product_id":"10000000-0000-0000-0000-000000000001","quantity":1}]}'
$headers = @{ 'Idempotency-Key' = 'module03-order-001' }
$first = Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8080/api/orders -Headers $headers -ContentType application/json -Body $body
$again = Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8080/api/orders -Headers $headers -ContentType application/json -Body $body
$first.id -eq $again.id
```

Expected: the final expression is `True`; stock decreases once. Inspect API,
relay, and worker logs and correlate the order and event identifiers:

```powershell
docker compose logs api outbox-relay notification-worker
docker compose exec db psql -U cloudcart -d cloudcart -c "TABLE messaging.outbox;"
docker compose exec db psql -U cloudcart -d cloudcart -c "TABLE notification.processed_events;"
```

## Controlled failure: broker unavailable

Stop the broker, submit a new order with a new key, and inspect the unpublished
outbox row. The API should remain live and the order should commit. Start the
broker and verify the relay drains the backlog and the worker records the event.

```powershell
docker compose stop broker
docker compose start broker
docker compose ps
```

Do not start the broker immediately: first predict and observe each component's
state. Explain why API liveness differs from end-to-end notification health.

## Controlled failure: poison message

Use the management UI at <http://127.0.0.1:15672> with the local lab account.
Publish invalid JSON to exchange `cloudcart.events` with routing key
`order.accepted.v1`. Verify it moves to `cloudcart.notifications.dlq` and the
worker remains healthy. Never put a real secret or personal record in a test
message.

## Tests

Run unit/API tests from `capstone/cloudcart` in a local virtual environment:

```powershell
python -m venv .venv
./.venv/Scripts/python -m pip install --requirement requirements-dev.txt
$env:PYTHONPATH = (Resolve-Path src)
./.venv/Scripts/python -m pytest -q
Remove-Item Env:PYTHONPATH
```

For database tests, use a dedicated local test database and set
`TEST_DATABASE_URL` from a trusted local shell without committing it.

## Cleanup

```powershell
docker compose down --volumes --remove-orphans
Remove-Item .env
```

Confirm no `cloudcart` containers, networks, or volumes remain. The volume
deletion is intentional because the lab uses synthetic data.

> **Module:** [03 — Microservices and Distributed Data](../README.md) · Previous:
> [Lab 1 — Boundaries and contracts](01-boundaries-contracts.md) · Next:
> [Independent challenge](../independent-challenge.md)
