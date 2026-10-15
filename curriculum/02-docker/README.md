# 02 — Docker

**Status:** Verified<br>
**Estimated time:** 16–20 hours<br>
**Prerequisites:** [01 — Container Fundamentals](../01-container-fundamentals/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous:
> [Container fundamentals](../01-container-fundamentals/README.md) · Next:
> [Microservices and distributed data](../03-microservices-distributed-data/README.md)

## Why this matters

Docker turns container primitives into a repeatable build, distribution, and
runtime workflow. Kubernetes later consumes the resulting images, so weak image,
signal, storage, or configuration practices become Kubernetes failures.

## Learning objectives

You can:

- Trace Docker CLI, API, daemon, runtime, and registry interactions.
- Build reproducible, cache-efficient, non-root Python images with BuildKit.
- Explain tags, digests, manifests, build context, and layer invalidation.
- Operate container networking, mounts, volumes, health, logs, and resources.
- Define and troubleshoot a multi-service Compose environment.
- Evaluate security, lifecycle, backup, and production tradeoffs.

## Contents

Follow these pages in order. Every page includes navigation back to this module
home and direct links to the previous and next learning step where applicable.

1. [Engine and lifecycle](01-engine-and-lifecycle.md)
2. [Dockerfiles and BuildKit](02-dockerfiles-and-buildkit.md)
3. [Networking and storage](03-networking-and-storage.md)
4. [Compose, operations, and security](04-compose-operations-security.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Secure Python image](labs/01-secure-python-image.md)
7. [Lab 2 — Compose environment](labs/02-compose-environment.md)
8. [Cumulative independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)
13. [Gate 1 assessment](../ASSESSMENT-GATES.md#gate-1--container-practitioner)

## Tested baseline

The exact executed baseline is recorded in the
[version matrix](../../VERSION-MATRIX.md). Required:

- Docker Engine with Linux containers
- Docker Compose plugin
- BuildKit
- Approximately 1 GB free disk space

## Completion

- [ ] **Explain:** image, build, network, storage, Compose, and lifecycle behavior.
- [ ] **Build:** complete both labs and verify every acceptance criterion.
- [ ] **Diagnose:** resolve the failure scenarios from evidence.
- [ ] Complete the cumulative independent challenge without a copied solution.
- [ ] Complete the [Container practitioner gate](../ASSESSMENT-GATES.md#gate-1--container-practitioner).
- [ ] Remove lab containers, networks, and volumes using scoped cleanup.

## Continue

Continue to
[Module 03 — Microservices and Distributed Data](../03-microservices-distributed-data/README.md),
or return to the [curriculum index](../README.md).
