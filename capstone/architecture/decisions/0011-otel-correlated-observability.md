# ADR 0011 — Use OpenTelemetry for Correlated Observability

- **Status:** Accepted for the learning baseline
- **Date:** 2026-10-16

## Context

CloudCart already exposes bounded Prometheus metrics and structured stdout
logs. Module 13 needs a vendor-neutral trace path and a demonstrable way to move
between aggregate symptoms and per-request evidence without coupling application
domain code to one backend.

## Decision

CloudCart emits W3C-correlated OpenTelemetry traces over OTLP/HTTP to an
OpenTelemetry Collector. The Collector exports traces to Tempo and tails
CloudCart API container logs to Loki. JSON logs include trace and span IDs only
inside an active span. Prometheus histogram observations carry trace exemplars.
Grafana provisions Prometheus, Loki, and Tempo data sources with correlation
links and version-controlled dashboards.

The local lab uses one Collector DaemonSet for node-log acquisition and trace
gateway duties. Production must evaluate separate agent and gateway tiers,
sampling, authenticated/TLS transport, tenancy, durable storage, and limits.

## Consequences

- Application instrumentation remains backend-neutral.
- Metrics retain bounded labels while trace/log detail stays searchable.
- One trace ID can connect an exemplar, JSON log, and Tempo trace.
- The Collector becomes critical pipeline infrastructure requiring its own
  health, queue, retry, capacity, and drop monitoring.
- Trace and log completeness depend on sampling, export, node-log access, and
  backend retention; absence is not proof an operation never occurred.
- The lab's anonymous and ephemeral components cannot be promoted unchanged.

## Alternatives considered

- Direct-to-backend exporters: simpler initially, but duplicate routing,
  batching, filtering, and migration concerns in every service.
- Trace IDs as metric or Loki stream labels: easy lookup but unacceptable
  cardinality and index cost.
- A full production Helm stack: operationally realistic but obscures signal
  flow and makes the local learning lab too heavy.

## Validation

The Module 13 automated test must prove provisioned data sources/dashboard, one
trace-correlated log, the same trace in Tempo, an SLI recording rule, and a
Prometheus exemplar carrying that trace ID.
