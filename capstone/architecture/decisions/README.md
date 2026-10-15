# Architecture Decision Records

Use an ADR for choices that materially affect architecture, operations,
security, or the learning path.

Name files `NNNN-short-title.md`, beginning at `0001`. Never reuse a number.
Keep superseded decisions and link to their replacement. Valid statuses are
Proposed, Accepted, Superseded, Rejected, and Deprecated.

Copy [`0000-template.md`](0000-template.md) to start a decision.

## Decision index

- [ADR 0001: Use Python and FastAPI for the capstone](0001-python-fastapi.md) — Accepted
- [ADR 0002: Use RabbitMQ with a transactional outbox](0002-rabbitmq-outbox.md) — Accepted
- [ADR 0003: Use kind for the local Kubernetes baseline](0003-kind-local-kubernetes.md) — Accepted
- [ADR 0004: Use Gateway API with Envoy Gateway for local ingress](0004-gateway-api-envoy.md) — Accepted
- [ADR 0005: Use a StatefulSet for learning and managed PostgreSQL for production](0005-managed-database-production.md) — Accepted
- [ADR 0006: Use external secret sources with workload identity in production](0006-external-secret-source.md) — Accepted
- [ADR 0007: Treat workload placement and capacity as measured policy](0007-workload-placement-capacity.md) — Accepted
