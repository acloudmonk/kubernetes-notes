# Troubleshooting Microservices and Distributed Data

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Independent challenge](independent-challenge.md) · Next:
> [Interview questions](interview-questions.md)

## Evidence order

Define the expected user outcome and time window, then inspect:

1. client request, key, response, and deadline;
2. API health, logs, latency, and database transaction outcome;
3. outbox unpublished count and oldest age;
4. broker connection, exchange binding, ready/unacknowledged counts, and DLQ;
5. worker logs, acknowledgement behavior, and processed-event record;
6. dependency saturation, recent deploys, and schema versions.

Do not “retry everything” or purge a queue before preserving evidence.

## Scenarios

| Symptom | Discriminating evidence | Likely correction |
|---|---|---|
| Order times out but exists | Same idempotency key returns order | Return saved outcome; keep client retries idempotent |
| Orders exist; no notifications | Old unpublished outbox rows | Restore relay/broker; do not recreate orders |
| Queue grows with ready messages | Consumer absent or low capacity | Restore/fix worker; scale only after cause is known |
| Unacknowledged count grows | Worker slow or blocked after delivery | Inspect dependency and handler; preserve ack-after-commit |
| One message repeats forever | Same event ID and error | Classify poison message; reject to DLQ; fix then replay |
| Notification repeats | Missing/incorrect dedup transaction | Persist event ID atomically with effect |
| Stock becomes negative | Missing lock or invariant | Restore invariant, reconcile, add concurrent integration test |
| New consumer fails on old event | Incompatible schema assumption | Deploy tolerant reader or upcaster; restore compatible producer |

## Prevention questions

For every incident, ask which contract, invariant, test, metric, alert, deployment
check, or ownership rule should prevent recurrence. “Operator error” is not a
root cause; explain why the system allowed an unsafe action.

> **Module:** [03 — Microservices and Distributed Data](README.md) · Previous:
> [Independent challenge](independent-challenge.md) · Next:
> [Interview questions](interview-questions.md)
