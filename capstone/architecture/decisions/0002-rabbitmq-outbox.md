# ADR 0002: Use RabbitMQ with a transactional outbox

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

CloudCart needs to teach asynchronous delivery, failure recovery, duplicate
handling, dead letters, and eventual consistency. Publishing directly during an
order transaction creates a database/broker dual-write failure window.

Alternatives considered were an in-process event bus, PostgreSQL-only job
polling, RabbitMQ, and Kafka. An in-process bus hides network and persistence
behavior. PostgreSQL polling teaches durable work but not broker protocols.
Kafka is valuable for retained event streams but adds concepts not required for
the first command/event workflow.

## Decision

Use RabbitMQ 4.2 for the learning baseline. Commit `order.accepted.v1` to a
PostgreSQL outbox in the order transaction. A polling relay publishes persistent
messages with publisher confirms. The notification worker acknowledges after
its idempotent database effect commits and rejects invalid messages to a
dead-letter queue.

## Consequences

Learners see a real broker, acknowledgement boundary, outage backlog, duplicate
window, and replay surface. The design adds a relay, broker operations, schema
governance, and eventual consistency. RabbitMQ does not make external effects
exactly once, and the polling relay is not a high-throughput production design.

## Validation

- Stop the broker and prove orders still commit with unpublished outbox rows.
- Restore it and prove the backlog drains.
- Repeat an order command and an event; prove one effect for each identity.
- Send invalid JSON and prove it is dead-lettered without stopping the worker.
- Trace order and event identifiers through structured logs and database rows.
