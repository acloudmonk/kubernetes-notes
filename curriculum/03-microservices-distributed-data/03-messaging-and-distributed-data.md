# Messaging and Distributed Data

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Synchronous contracts and resilience](02-synchronous-contracts-resilience.md) ·
> Next: [Testing, operations, and evolution](04-testing-operations-evolution.md)

## Delivery is a protocol

Messaging separates producer availability from consumer availability, but it
does not remove contracts or failures. A producer needs routing, persistence,
publisher confirmation, and an outcome for unroutable messages. A consumer
acknowledges only after its durable business effect commits.

- **At-most-once:** loss is possible; duplicates are avoided.
- **At-least-once:** redelivery is possible; consumers must be idempotent.
- **Exactly-once:** meaningful only within a precisely stated boundary. It does
  not automatically make external side effects exactly once.

Ordering is also scoped. A broker may preserve order in one partition or queue,
while multiple consumers, retries, or dead letters change observed order. Use an
aggregate key, sequence number, or commutative operation when order matters.

## The dual-write problem and outbox

Writing a database row and publishing an event are two independent operations.
Either order has a failure window. The transactional outbox stores the business
change and event record in one database transaction. A relay later publishes
the record and marks it delivered after broker confirmation.

The relay can publish the same event twice if it crashes after publish but
before marking the row. Therefore the consumer records the event identifier in
the same local transaction as its effect. CloudCart demonstrates this producer
outbox and idempotent-consumer pair.

## Sagas and compensation

A Saga coordinates local transactions across owners. Choreography reacts to
events and has low central coupling but can hide the workflow. Orchestration
uses a coordinator and makes state visible but centralizes workflow knowledge.
Compensation is a new business action, not a database rollback: releasing stock
does not erase the fact that it was reserved.

Model states, deadlines, retries, compensation failures, and manual resolution.
Use a single local transaction when one owner can safely enforce the invariant;
do not introduce a Saga merely to appear distributed.

## Dead letters, replay, and reconciliation

A dead-letter queue isolates messages that cannot be processed. It is not a
graveyard. Alert on growth, record the failure reason, restrict access, define
retention, fix the cause, and replay through a controlled tool. Replays must
preserve identity and remain idempotent.

CloudCart uses a quorum queue with a delivery limit so transient database
failures are retried but cannot create an unbounded poison-message loop.

Reconciliation compares sources of truth to derived state and repairs drift.
It is the safety net for lost operator actions, software defects, and failures
outside the normal retry window. Record audit evidence for every repair.

## Schema evolution

Events are durable public contracts. Include an event ID, type, version,
occurred time, producer, aggregate ID, and correlation context. Evolve by adding
optional fields and use tolerant readers. Never silently change field meaning.
Protect sensitive information because event logs and dead letters increase its
copies and retention.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Synchronous contracts and resilience](02-synchronous-contracts-resilience.md) ·
> Next: [Testing, operations, and evolution](04-testing-operations-evolution.md)
