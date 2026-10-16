# ADR 0010: Use bounded Prometheus metrics as the first telemetry signal

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

CloudCart needs operational signals before dashboards, logs, traces, SLOs, and
automated delivery are layered on. Application metrics must support aggregation
across replicas without exposing identifiers or creating uncontrolled time
series. The learning path must expose Prometheus mechanics before introducing an
operator-managed stack.

## Decision

Instrument the Python API with the official Prometheus client. Record HTTP
method, route template, status, duration, and in-progress work plus a bounded
order-request outcome. Never use order, product, customer, idempotency, request,
or trace identifiers as metric labels.

Use direct EndpointSlice discovery and explicit relabeling for Module 12. Keep
Prometheus and Alertmanager single-replica and ephemeral only in the disposable
lab. A production monitoring design must add protected access, durable storage,
HA collection and notification paths, cardinality/sample/query limits,
monitoring of the monitoring system, tested receivers, retention/recovery, and
an explicit long-term storage decision. Prometheus Operator adoption belongs to
the next abstraction layer, not the instrumentation contract.

## Consequences

The initial metrics aggregate safely across API replicas and make cardinality
measurable. They do not identify an individual order; operators correlate to
structured logs or traces for that investigation. The exposed endpoint and
Prometheus APIs contain operational information and require network/access
controls in non-lab environments.

The lab explains native configuration in detail but requires manual ConfigMap
rollout and lacks operator reconciliation. The placeholder Alertmanager receiver
proves delivery only, not human notification.

## Validation

- Unit-test exposition and verify route labels never contain resource IDs.
- Discover both API endpoints and prove healthy scrapes and recording rules.
- measure TSDB head series against the lab budget;
- remove expected targets, observe the alert in Prometheus and Alertmanager,
  restore replicas, and confirm application recovery;
- validate configuration/rules with `promtool` and scan repository/history for secrets.
