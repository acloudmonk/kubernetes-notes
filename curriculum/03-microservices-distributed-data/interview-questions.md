# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

## Fundamentals

### 1. When should a modular monolith become microservices?

**Answer:** Extract a stable capability when independent ownership, deployment,
scale, reliability, or security creates measurable value greater than the cost
of distributed operation. Use change and deployment evidence, define data and
contract ownership, plan coexistence, and measure the result. “The codebase is
large” is insufficient; weak boundaries become a distributed monolith.

**Follow-up:** What evidence would make you merge two services again?

### 2. What is the difference between an aggregate and a service?

**Answer:** An aggregate is a transactional consistency boundary that protects
domain invariants. A service is an independently deployable ownership boundary
and may own multiple aggregates. Treating every entity as a service creates
chatty calls and weak invariants; placing unrelated capabilities in one service
blocks independent change.

## Implementation

### 3. How does an idempotency key work?

**Answer:** Persist a scoped key, canonical request hash, and result atomically
with the protected effect. A replay of the same request returns the recorded
result; a changed request with the same key returns conflict. Design retention,
concurrent insert behavior, response storage, abuse limits, and recovery, then
test at the database transaction boundary.

### 4. Why use a transactional outbox?

**Answer:** It closes the database/broker dual-write gap by committing the domain
change and an event record in one local transaction. A relay publishes later.
The relay can publish twice after an ambiguous confirmation or crash, so consumers
still need idempotent effects and deduplication. Monitor backlog age and test
commit, rollback, duplicate, ordering, and relay-recovery paths.

## Architecture and production

### 5. Is exactly-once delivery possible?

**Answer:** Only within a precisely declared boundary and protocol. A broker
transaction cannot make an external email, payment, or arbitrary database effect
globally exactly once. Prefer explicit at-least-once delivery with stable message
identity, idempotent local effects, reconciliation, and documented guarantees;
avoid advertising a broker feature as an end-to-end business property.

### 6. When should a Saga use choreography or orchestration?

**Answer:** Choreography keeps participants decentralized but can hide long
workflow state and ownership. Orchestration makes state, sequencing, and recovery
explicit in a coordinator but couples it to workflow steps. Choose from workflow
length, audit/recovery needs, team ownership, and change rate; test compensation,
timeouts, duplicates, and stuck-state recovery either way.

## Troubleshooting and senior practice

### 7. A queue is growing. Should you immediately scale consumers?

**Answer:** First compare arrival and completion rates, oldest age, ready versus
unacknowledged messages, handler latency/errors, dependency capacity, poison
messages, and recent changes. Scaling helps only when consumers and dependencies
have safe headroom; otherwise it can amplify database overload or retry storms.
Apply a bounded change and verify backlog age and business completion.

### 8. How should an event schema evolve?

**Answer:** Treat it as a durable public contract. Prefer additive optional fields
and tolerant readers, test old/new producer-consumer combinations, observe actual
consumer usage, and use parallel versions or upcasters for breaking changes.
Preserve semantic meaning and replayability; schema validation alone cannot prove
that old events retain the same business interpretation.

### 9. How do timeout, retry, and circuit-breaker policies interact?

**Answer:** A timeout bounds one attempt, retries consume a larger caller deadline,
and a circuit breaker temporarily rejects calls when recent outcomes indicate a
dependency is unlikely to succeed. Put retries at one controlled layer, retry
only suitable failures with jitter and a budget, and preserve enough deadline for
useful work. Breakers protect capacity but can also delay recovery if tuned poorly.

### 10. Why should each service own its data?

**Answer:** Ownership lets a service enforce invariants and evolve storage behind
an explicit contract. Shared-table writes couple schemas, deployments, security,
and failure recovery and allow other services to bypass domain rules. Ownership
does not require one database server per service, but write authority, migration,
backup, and access boundaries must remain explicit.

### 11. What happens when a Saga compensation fails?

**Answer:** Compensation is a new distributed business action, not a database
rollback, and it can time out or fail like any other call. Persist workflow state,
retry idempotently where safe, expose stuck states, alert an owner, and provide
reconciliation or manual resolution with audit. Never assume compensations can
perfectly erase irreversible external effects.

### 12. What should a service contract test prove?

**Answer:** It should prove that a provider and consumer agree on request, response,
event, error, and compatibility semantics for supported versions. Run consumer-
driven or schema/example tests in delivery pipelines, but retain integration and
end-to-end tests for transport, deployment, authentication, timing, and behavior
that a contract fixture cannot establish.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
