# CloudCart Application

This is the first runnable CloudCart increment. Catalog, Inventory, and Ordering
are modules in one FastAPI process. An outbox relay publishes accepted orders to
RabbitMQ, and an independently running notification worker records each event
once.

## Runtime flow

```mermaid
sequenceDiagram
    participant Client
    participant API
    participant DB as PostgreSQL
    participant Relay
    participant Broker as RabbitMQ
    participant Worker
    Client->>API: POST /api/orders + Idempotency-Key
    API->>DB: lock stock; commit order + key + outbox
    API-->>Client: 201 order
    Relay->>DB: read unpublished event
    Relay->>Broker: persistent publish
    Broker-->>Relay: publisher confirm
    Relay->>DB: mark published
    Broker->>Worker: at-least-once delivery
    Worker->>DB: insert processed event if absent
    Worker-->>Broker: acknowledge after commit
```

The outbox prevents a committed order from losing its publication intent.
Publisher confirmation plus marking is not atomic, so the worker deduplicates by
event ID. This implementation records a synthetic notification rather than
sending email or handling personal data.

## Layout

- `src/cloudcart/main.py` — HTTP contract and dependency injection boundary
- `src/cloudcart/service.py` — transaction, locking, idempotency, and ownership
- `src/cloudcart/relay.py` — polling outbox relay with publisher confirms
- `src/cloudcart/worker.py` — manual acknowledgement and idempotent consumer
- `migrations/001_initial.sql` — schemas, constraints, indexes, and seed data
- `tests` — pure-domain, API-contract, and opt-in PostgreSQL tests
- `compose.yaml` — isolated API, migration, relay, worker, database, and broker
- `k8s` — plain manifests for the Module 05 disposable Kubernetes deployment

`requirements.txt` records the fully resolved Python 3.12 runtime set rather
than only direct dependencies. Review and update that set atomically, rebuild
without cache, and repeat all tests when changing it.

## Local tests

From this directory in PowerShell:

```powershell
python -m venv .venv
./.venv/Scripts/python -m pip install --requirement requirements-dev.txt
$env:PYTHONPATH = (Resolve-Path src)
./.venv/Scripts/python -m pytest -q
Remove-Item Env:PYTHONPATH
```

The database tests skip unless `TEST_DATABASE_URL` is set. To exercise them
against the lab database, run the migration first and use a local test database;
never point destructive learning tests at shared or production data.

## Compose environment

Copy `.env.example` to ignored `.env`, replace both example passwords with
different local-only values, then run:

```powershell
docker compose config --quiet
docker compose build
docker compose up --detach
docker compose ps
```

The API is at <http://127.0.0.1:8080/docs> and RabbitMQ management is at
<http://127.0.0.1:15672>. Follow the complete verification, failure, and cleanup
steps in [Module 03 Lab 2](../../curriculum/03-microservices-distributed-data/labs/02-cloudcart-delivery.md).

## Guarantees and limitations

- Order, stock update, idempotency record, and outbox record commit atomically.
- A repeated key with the same canonical request returns the original order; a
  changed request conflicts.
- Notification delivery is at least once and its database effect is idempotent.
- The notification quorum queue dead-letters a delivery after five unsuccessful
  returns, preventing an unbounded hot retry loop.
- Ordering is not promised across aggregates, and the polling relay is designed
  for learning rather than high throughput.
- RabbitMQ and PostgreSQL run as single instances; this is not an HA topology.
- The migration runner has no version table or rollback framework yet. Later
  increments add production migration discipline and telemetry.

## Cleanup

```powershell
docker compose down --volumes --remove-orphans
Remove-Item .env
```

Volume deletion is intentional only because this environment contains synthetic
lab data.

## Kubernetes environment

The [Module 05 workload labs](../../curriculum/05-kubernetes-workloads/README.md)
build this same image, load it into kind, generate random credentials directly
in the cluster, run the migration as a Job, and operate API, relay, and worker
Deployments. The dependency `emptyDir` volumes are deliberately non-durable;
follow the exact lab cleanup and do not use these manifests as a production
database or broker design.

The [Module 07 storage labs](../../curriculum/07-storage-state/README.md) replace
PostgreSQL with a single-replica StatefulSet and retained PVC, test Pod
replacement, and perform an isolated logical restore. This demonstrates storage
lifecycle and recovery mechanics; it does not claim database high availability.
