# Knowledge Check

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Interview questions](interview-questions.md) · Next:
> [References and videos](references.md)

Answer every question before reading the answer section.

1. Which property distinguishes a microservice from a code module?
2. Why can a timeout produce an unknown outcome?
3. What four controls bound a retry policy?
4. Where must an idempotency record be committed?
5. Which failure window does a transactional outbox close?
6. Why can an outbox relay still publish twice?
7. When should a consumer acknowledge a message?
8. What is the difference between compensation and rollback?
9. What evidence distinguishes a missing consumer from a slow consumer?
10. Design a test for a crash after an effect commits but before acknowledgement.
11. Why is a dead-letter queue not a complete recovery strategy?
12. Name two signals that justify service extraction.

---

## Answers

1. Independent deployability aligned to ownership, including its data and operations.
2. The server may commit after the client stops waiting.
3. Retryable classification, attempt/deadline limit, exponential backoff with
   jitter, and a retry budget at one chosen layer.
4. In the same transaction as the protected business effect.
5. Atomicity between a local database change and the intent to publish.
6. It can publish, lose the confirmation or crash, then retry before marking.
7. After the durable, idempotent local effect commits.
8. Compensation is a new semantic action; rollback erases an uncommitted local change.
9. Consumer presence/capacity and ready versus unacknowledged counts plus handler latency.
10. Inject the crash at that boundary, redeliver the same event ID, and assert one effect.
11. It needs alerting, diagnosis, retention, correction, controlled replay, and audit.
12. Examples: independent release cadence, scaling profile, reliability boundary,
    security isolation, or stable separate team ownership.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Interview questions](interview-questions.md) · Next:
> [References and videos](references.md)
