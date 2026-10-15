# Testing, Operations, and Evolution

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Messaging and distributed data](03-messaging-and-distributed-data.md) · Next:
> [Quick exercises](quick-exercises.md)

## Test the risk at the smallest useful boundary

- Unit tests protect invariants and deterministic transformations.
- API tests protect status codes, validation, and schema behavior.
- Integration tests use the real database or broker for transactions,
  migrations, locking, routing, acknowledgement, and serialization.
- Contract tests protect provider and consumer assumptions independently.
- End-to-end tests protect a few critical journeys, not every permutation.
- Failure tests interrupt dependencies at dangerous commit/acknowledgement
  boundaries and prove recovery.

A mock cannot prove PostgreSQL locking or RabbitMQ routing. A large end-to-end
test may find a failure but make its cause slow to locate. Record what each test
cannot prove.

## Migrations and compatibility

Use expand-and-contract: add compatible storage or contract shape, deploy code
that understands both, migrate data, move readers and writers, verify old usage
is gone, then remove the old shape. Migrations should be repeatable, reviewed,
observable, and separated from horizontally scaled application startup when
concurrent execution is unsafe.

## Operability

Liveness answers whether the process should restart. Readiness answers whether
it should receive traffic. A broker outage should not make an API process dead
if orders can still commit to an outbox. Observe request rate, errors, duration,
resource saturation, queue depth, oldest message age, retry counts, dead-letter
growth, outbox backlog, and consumer capacity.

Structured logs need event, order, request, and correlation identifiers without
secrets. Traces explain a sampled path; metrics describe system-wide behavior;
logs preserve discrete evidence. Later modules instrument all three.

## Caching and derived data

Cache only after identifying a measured latency or load problem. Define the
source of truth, key, TTL, invalidation event, stale-data tolerance, stampede
protection, and failure behavior. A cache is distributed state, not free speed.
CQRS read models are intentionally derived and require lag monitoring and
reconciliation.

## Evolution checklist

Before extracting a CloudCart capability, require:

- stable ownership and contracts;
- independent deployment or scaling value;
- a plan for historical data and migrations;
- deadlines, idempotency, observability, and failure tests;
- an operator and SLO;
- a rollback or coexistence path.

The strangler approach routes a small capability to the new implementation,
measures it, and expands gradually. Avoid a synchronized rewrite.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Messaging and distributed data](03-messaging-and-distributed-data.md) · Next:
> [Quick exercises](quick-exercises.md)
