# Quick Exercises

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Testing, operations, and evolution](04-testing-operations-evolution.md) · Next:
> [Lab 1 — Boundaries and contracts](labs/01-boundaries-contracts.md)

1. Draw one CloudCart request and label every owner, transaction, remote call,
   timeout, and unknown-outcome window.
2. For `POST /orders`, define three retryable and three non-retryable outcomes.
3. Explain why publisher confirms do not eliminate duplicate delivery.
4. Design an incompatible event change and then replace it with an additive one.
5. Decide whether Catalog needs extraction for: high reads, a separate team,
   monthly price changes, or a different programming language. Defend each.
6. Write the alert condition and first three diagnostic checks for a growing
   outbox backlog.
7. Predict the result if two orders reserve the last unit concurrently without
   row locking.
8. Define a safe replay procedure for ten corrected dead-letter messages.

Do each first from memory, then verify against the theory pages.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Testing, operations, and evolution](04-testing-operations-evolution.md) · Next:
> [Lab 1 — Boundaries and contracts](labs/01-boundaries-contracts.md)
