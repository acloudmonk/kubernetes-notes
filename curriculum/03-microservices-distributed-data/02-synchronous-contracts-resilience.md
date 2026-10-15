# Synchronous Contracts and Resilience

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Boundaries and architecture](01-boundaries-and-architecture.md) · Next:
> [Messaging and distributed data](03-messaging-and-distributed-data.md)

## Contract design

An API contract includes more than paths and JSON. It includes identity,
authorization, validation, error meaning, pagination, concurrency, idempotency,
timeouts, rate limits, and compatibility. Use nouns for resources, stable error
shapes, and machine-readable schemas. Additive optional fields are usually safer
than renamed fields or changed meaning.

Version only when compatibility cannot be preserved. During migration, support
old and new consumers for a defined window and measure usage before removal.
OpenAPI validates syntax; consumer or provider contract tests validate the
assumptions clients actually use.

## Deadlines and timeouts

Every remote call must have a finite deadline. A connection timeout limits
establishment; a read timeout limits stalled response work; an end-to-end
deadline limits the entire operation. A caller should pass a smaller remaining
budget downstream rather than allowing every hop a fresh full timeout.

Timeout does not mean the server did nothing. The result may be unknown, so a
blind retry can duplicate an effect. Make commands idempotent or provide a way
to query their outcome.

## Retries without retry storms

Retry only transient failures, only at one deliberate layer, and only while the
deadline permits. Use a maximum attempt count, exponential backoff, random
jitter, and a retry budget. Do not retry validation, authorization, or invariant
failures. Load shedding and bounded queues keep an unhealthy dependency from
being overwhelmed by work it cannot complete.

A circuit breaker can stop calls after repeated failures and probe recovery,
but it adds state and tuning. It does not repair a dependency. Bulkheads limit
the resources one dependency or tenant can consume.

## Idempotency

An idempotency key identifies one logical command. Persist the key, a canonical
request fingerprint, and its outcome in the same transaction as the business
effect. Replaying the same key and payload returns the outcome; reusing the key
with a different payload is a conflict. Define retention and tenant scope.

CloudCart requires `Idempotency-Key` for order creation. It also locks inventory
rows so concurrent orders cannot both spend the same stock.

## Security at boundaries

Authenticate callers, authorize business actions, validate size and shape,
protect credentials, encrypt untrusted links, and avoid logging tokens or
personal data. Internal network location is not identity. Threat-model retries,
large payloads, expensive queries, and key-space exhaustion as abuse cases.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Boundaries and architecture](01-boundaries-and-architecture.md) · Next:
> [Messaging and distributed data](03-messaging-and-distributed-data.md)
