# ADR 0001: Use Python and FastAPI for the capstone

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

The capstone needs readable application code for APIs, workers, testing,
telemetry, and container exercises without turning the curriculum into a
language course.

## Decision

Use supported Python 3 with FastAPI as the primary application stack. Use type
hints, dependency locking, automated tests, explicit timeouts, structured logs,
Prometheus instrumentation, and OpenTelemetry. Runtime dependencies will be
chosen and pinned when application implementation begins.

## Consequences

Python enables fast, approachable implementation and is useful for DevOps
automation. Compared with a compiled Go binary, it normally produces larger
images, requires interpreter and dependency management, and needs deliberate
process design for CPU-bound concurrency. The course will treat these as
container, scaling, and operations lessons rather than hiding them.

## Validation

Phase 2C will verify tests, graceful shutdown, non-root execution, image size,
dependency scanning, telemetry, and horizontal scaling behavior.
