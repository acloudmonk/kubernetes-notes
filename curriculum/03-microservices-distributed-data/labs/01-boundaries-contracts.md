# Lab 1 — Model Boundaries and Contracts

> **Module:** [03 — Microservices and Distributed Data](../README.md) · Previous:
> [Quick exercises](../quick-exercises.md) · Next:
> [Lab 2 — CloudCart delivery](02-cloudcart-delivery.md)

## Outcome

Produce an architecture decision, context diagram, ownership table, HTTP
contract, event contract, and failure matrix before changing deployment shape.
No cloud resources are required.

## Tasks

1. Read the [capstone requirements](../../../capstone/architecture/requirements.md)
   and current [architecture](../../../capstone/architecture/README.md).
2. For Catalog, Inventory, Ordering, and Notification, record owned commands,
   data, invariants, and forbidden direct writes.
3. Specify `POST /api/orders`: request, response, idempotency behavior, errors,
   authentication assumption, maximum size, and deadline.
4. Specify `order.accepted.v1`: metadata, payload, compatibility rules, routing,
   retention, duplicate handling, and sensitive-data classification.
5. Build a failure matrix for database unavailable, broker unavailable,
   publish-confirm ambiguity, worker crash before effect, worker crash after
   effect, poison message, and slow consumer.
6. Write an ADR that compares modular monolith, immediate decomposition, and
   the staged design. Include reversibility and validation evidence.

## Acceptance evidence

- Every mutable data set has exactly one owner.
- Each failure has a visible symptom, bounded behavior, recovery, and metric.
- The contract distinguishes retryable from terminal errors.
- The event can be replayed without duplicating the notification record.
- A reviewer can identify what would justify the next extraction.

## Review

Exchange the artifacts with another learner or revisit them after Lab 2. Mark
assumptions that the running system disproves; architecture documents are
testable hypotheses.

> **Module:** [03 — Microservices and Distributed Data](../README.md) · Previous:
> [Quick exercises](../quick-exercises.md) · Next:
> [Lab 2 — CloudCart delivery](02-cloudcart-delivery.md)
