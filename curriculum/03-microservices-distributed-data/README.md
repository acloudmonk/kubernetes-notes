# 03 — Microservices and Distributed Data

**Status:** Verified<br>
**Estimated time:** 22–28 hours<br>
**Prerequisites:** [02 — Docker](../02-docker/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous:
> [Docker](../02-docker/README.md) · Next:
> [Kubernetes architecture](../04-kubernetes-architecture/README.md)

## Why this matters

Microservices trade in-process simplicity for independent ownership and
deployment. Every network call, duplicated message, partial failure, schema
change, and cross-service workflow becomes an explicit design problem. This
module teaches how to recognize when that trade is justified and how to make
failure behavior testable.

CloudCart begins as a modular monolith. Its request path owns one database
transaction, while an outbox relay and notification worker introduce a real
asynchronous boundary. This is an evolution path, not a claim that more
services are automatically better.

## Learning objectives

You can:

- Derive capability boundaries from business behavior and data ownership.
- Compare a modular monolith with microservices using measurable forces.
- Design versioned HTTP and event contracts with compatible evolution.
- Apply deadlines, bounded retries, backoff, jitter, and idempotency.
- Explain delivery semantics, ordering, outbox, Saga, dead letters, and replay.
- Test components, contracts, migrations, duplicate delivery, and failures.
- Diagnose partial failure from API, database, broker, and worker evidence.

## Contents

Follow these pages in order:

1. [Boundaries and architecture](01-boundaries-and-architecture.md)
2. [Synchronous contracts and resilience](02-synchronous-contracts-resilience.md)
3. [Messaging and distributed data](03-messaging-and-distributed-data.md)
4. [Testing, operations, and evolution](04-testing-operations-evolution.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Model boundaries and contracts](labs/01-boundaries-contracts.md)
7. [Lab 2 — Run the CloudCart delivery path](labs/02-cloudcart-delivery.md)
8. [Independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)

## Tested baseline

The application is in [`capstone/cloudcart`](../../capstone/cloudcart/README.md).
Its exact executed baseline is recorded in the
[version matrix](../../VERSION-MATRIX.md). Required:

- Python 3.12 for local unit tests
- Docker Engine and Docker Compose
- Approximately 2 GB free memory and 2 GB free disk space
- PowerShell or a POSIX-compatible shell for the HTTP exercises

## Recorded verification

From the repository root in PowerShell, run the complete disposable path:

```powershell
./curriculum/03-microservices-distributed-data/scripts/Test-CloudCart.ps1
```

The script generates short-lived credentials in memory, builds a separate test
image, executes all 14 Python tests including PostgreSQL integration, starts
CloudCart, and verifies command idempotency, broker-outage durability, outbox
recovery, poison-message dead lettering, duplicate-event handling, and exact
Compose cleanup. It refuses pre-existing resources with its project or test
image names and does not create an `.env` file.

## Completion

- [ ] **Explain:** defend boundaries, ownership, contracts, and consistency choices.
- [ ] **Build:** run CloudCart and verify its synchronous and asynchronous paths.
- [ ] **Diagnose:** recover a stopped broker and inspect a dead-lettered message.
- [ ] Prove a repeated command and event do not repeat their business effects.
- [ ] Complete the independent design challenge without copying the lab.

## Continue

Continue to [04 — Kubernetes Architecture](../04-kubernetes-architecture/README.md),
or return to the [curriculum index](../README.md).
