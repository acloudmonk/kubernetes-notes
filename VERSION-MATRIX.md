# Version Matrix

This file records versions against which labs are tested. It does not promise
compatibility with every older or future release.

## Policy

- Pin a baseline before publishing an executable lab.
- Prefer supported stable releases.
- Record Kubernetes client, cluster, and API compatibility separately.
- Avoid floating image tags in reproducible exercises.
- Review baselines when supported tools reach end of life.
- Document intentional deprecated-API use in its migration lab.

## Current baseline

Phase 2A prerequisite labs and the Module 01–02 container labs are verified
against the local baseline below. Module 03 application verification is tracked
against the same Docker environment.

| Component | Baseline | Local discovery | Planned phase |
|---|---|---|---|
| Git | 2.46.0.windows.1 | Verified for Phase 2A | All phases |
| Python | 3.12.0 | Verified for Phase 2A | Phase 2A onward |
| Docker Desktop | 4.87.0 | Linux engine verified on 2026-10-15 | Phase 2B |
| Docker Engine | 29.7.2, Linux/amd64 | Verified for Modules 01–02 | Phase 2B |
| Docker CLI | 29.7.2 | Verified for Modules 01–02 | Phase 2B |
| Docker Compose | 5.4.0 | Verified for Module 02 | Phase 2B |
| FastAPI | 0.143.1 | Pinned for CloudCart Module 03 | Phase 3 |
| Uvicorn | 0.53.0 | Pinned for CloudCart Module 03 | Phase 3 |
| Psycopg | 3.3.6 | Pinned for CloudCart Module 03 | Phase 3 |
| Pika | 1.4.4 | Pinned for CloudCart Module 03 | Phase 3 |
| PostgreSQL | 17.11 | Pinned container for CloudCart Module 03 | Phase 3 |
| RabbitMQ | 4.2.9 | Pinned container for CloudCart Module 03 | Phase 3 |
| `kubectl` | 1.36.1 | Discovered; cluster not tested | Phase 3 |
| Local Kubernetes | To be selected by ADR | Not selected | Phase 3 |
| Helm | To be tested | Not installed | Phase 5 |
| Prometheus stack | To be selected | Not selected | Phase 6 |
| GitOps controller | To be selected by ADR | Not selected | Phase 7 |

Executable modules list only the versions they require.

The WSL status command was inaccessible from the validation process, so no WSL
distribution or version is claimed as tested in Phase 2A.

Module 01 was runtime-verified using `alpine:3.22.2`. Verification covered image
identity, process and cgroup evidence, CPU and memory limits, writable-layer
persistence, graceful signal handling, finite-process exit behavior, and scoped
cleanup.

Module 02 was runtime-verified using its multi-stage Python image and Compose
environment. Verification covered clean and cached builds, health checks,
service DNS, controlled dependency failures and recovery, PostgreSQL
initialization and backup restoration, non-root execution, read-only root
filesystem, writable `tmpfs`, graceful shutdown, dropped capabilities,
resource limits, and scoped cleanup.

Module 03 uses Python 3.12, a PostgreSQL-backed FastAPI API, a transactional
outbox relay, RabbitMQ, and an idempotent notification worker. Its status remains
Draft until unit, integration, container, broker-failure, duplicate-delivery,
dead-letter, and cleanup checks have all been executed on this baseline.
