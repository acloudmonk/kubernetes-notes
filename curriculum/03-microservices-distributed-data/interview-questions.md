# Interview Questions

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

## Fundamental

**When should a modular monolith become microservices?**

When a stable capability needs independent ownership, deployment, scale,
reliability, or security and the value exceeds distributed-systems cost. Show
change/deployment evidence, define data ownership and contracts, extract with a
coexistence path, and measure the result. “The codebase is large” alone is not
enough; poor module boundaries become a distributed monolith.

**What is the difference between an aggregate and a service?**

An aggregate is a transactional consistency boundary for domain invariants. A
service is an independently deployable ownership boundary and may own multiple
aggregates. Treating every entity as a service produces chatty calls and weak
invariants.

## Implementation

**How does an idempotency key work?**

Persist a scoped key, canonical request hash, and result in the same transaction
as the effect. A replay of the same request returns the result; a changed request
with the key returns conflict. Discuss retention, concurrent inserts, response
storage, abuse limits, and tests at the database boundary.

**Why use a transactional outbox?**

It closes the database/broker dual-write gap by committing the domain change and
event record together. A relay publishes later. The relay can duplicate after
an ambiguous confirmation, so consumers still deduplicate. Verify commit,
rollback, relay-crash, duplicate, ordering, and backlog behavior.

## Architecture and production

**Is exactly-once delivery possible?**

Only within a declared boundary and protocol. A broker transaction cannot make
an email or third-party charge exactly once. Prefer at-least-once delivery with
idempotent effects, stable identities, reconciliation, and explicit guarantees.

**Choreography or orchestration for a Saga?**

Choreography is decentralized but makes long workflows and ownership harder to
see. Orchestration exposes state and recovery in one coordinator but couples it
to workflow steps. Choose from workflow length, audit needs, team ownership, and
change rate; test compensation and stuck-state recovery either way.

## Troubleshooting and senior

**The queue is growing. Do you scale consumers?**

First compare arrival and completion rate, oldest age, ready versus
unacknowledged messages, handler latency/errors, dependency capacity, poison
messages, and recent changes. Scaling helps only when consumers and dependencies
have safe headroom. It can amplify database failure or retry storms.

**How do you evolve an event schema?**

Treat it as a durable public contract. Prefer additive optional fields and
tolerant readers, test old/new producer-consumer pairs, observe consumer usage,
and use parallel versions or upcasters for breaking changes. Preserve semantic
meaning and replayability; schema validation alone cannot prove semantics.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
