# Distributed-System Foundations

> **Module navigation:** [Prerequisites module home](README.md) · Previous:
> [Git, YAML, and shell](03-git-yaml-shell.md) · Next:
> [Quick exercises](quick-exercises.md)

A distributed request crosses process or network boundaries where components
can fail independently. The caller often cannot immediately distinguish a slow
success, a lost request, a lost response, and a failed dependency.

## Timeouts

Every remote call needs a finite timeout derived from the caller's overall
budget. Without one, resources accumulate while callers wait indefinitely.

## Retries

Retries can recover from transient faults but amplify overload. Use bounded
attempts, exponential backoff, jitter, and a retry budget. Do not retry every
error: validation and authorization failures are normally permanent.

## Idempotency

An idempotent operation can be repeated without creating additional business
effects. Network ambiguity makes this essential for order creation, payments,
and message consumption. An idempotency key must be stored with the result; it
is not merely a request header.

## Partial failure and cascading failure

One slow dependency consumes caller threads, connections, or workers. Queues
grow, timeouts trigger retries, and the retries increase load. Resource limits,
backpressure, circuit breakers, bulkheads, and graceful degradation contain the
failure, but each mechanism has operational costs.

## Consistency

Once multiple services own data, a single database transaction cannot safely
be assumed across them. Workflows must define intermediate states,
compensation, duplicate handling, ordering expectations, and reconciliation.

The key question is not “can this component fail?” but “what will callers
observe when it fails, and how does the system return to a known state?”

---

[Previous: Git, YAML, and shell](03-git-yaml-shell.md) ·
[Prerequisites module home](README.md) · [Next: Quick exercises](quick-exercises.md)
