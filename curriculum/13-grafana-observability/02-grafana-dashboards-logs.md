# Grafana Dashboards and Logs

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Observability model and telemetry pipelines](01-observability-telemetry-pipelines.md) · Next: [Tracing and correlation](03-tracing-opentelemetry-correlation.md)

## Dashboards are decision interfaces

A dashboard should have an audience, question, and action. Executives need
long-window objectives and budget; service owners need RED signals (rate,
errors, duration); platform teams often need USE signals (utilization,
saturation, errors); responders need drill-down and correlation. One giant
dashboard usually serves none of them well.

Start with a top row that answers “is user experience currently unhealthy?”
Then show traffic and saturation context, dependency health, and links to logs,
traces, runbooks, and ownership. Use consistent units, meaningful legends, and
thresholds tied to objectives. Avoid decorative gauges and panels whose result
cannot change a decision.

Grafana variables can reduce duplication, but broad regex variables can create
expensive queries. Set useful time defaults and minimum intervals. A panel that
is correct for five minutes may be misleading for thirty days because rate
windows, downsampling, and missing data semantics change.

## Provisioning as code

The lab provisions data sources, a dashboard provider, and dashboard JSON from
Git. Stable UIDs allow panels and correlation links to refer to data sources
without environment-generated IDs. Provisioned resources are reviewed,
repeatable, and intentionally non-editable in the UI.

UI experimentation is useful, but export the result, remove generated noise,
review the query and units, and commit it. Treat a dashboard change like code:
lint JSON, validate data-source references, test important expressions, and
review query cost. UI edits to a provisioned dashboard are overwritten by its
source of truth.

The lab enables anonymous Viewer access only because Grafana is a local
ClusterIP reached through loopback port-forwarding. Production requires
authentication, TLS, least-privilege roles, tenant isolation, protected data
sources, auditability, and a secrets mechanism. A port-forward is transport,
not an authorization system.

## Loki's model

Loki indexes labels, not every word in each log line. A stream is identified by
its label set. Good labels are bounded and useful for selecting a small set of
streams, such as service, namespace, environment, and severity. Bad labels
include trace IDs, order IDs, request URLs, timestamps, or arbitrary exception
messages.

OpenTelemetry resource attributes can become Loki index labels; other fields
remain structured metadata or log content. Decide promotion centrally and
measure stream growth. Query-time parsing is flexible but costs CPU repeatedly;
ingest-time extraction costs pipeline complexity and may create index cost.

Representative LogQL stages:

```logql
{service_name="cloudcart-api"}
{service_name="cloudcart-api"} |= "rejected"
{service_name="cloudcart-api"} | json | level="WARNING"
sum by (level) (count_over_time({service_name="cloudcart-api"} | json [5m]))
```

First select streams with labels, then filter content, then parse. A naked
high-volume query over all services and long retention is operationally
expensive. Log metric queries are useful, but if a number is a durable SLI,
instrument a metric rather than rebuilding it from best-effort logs.

## Structured logging

JSON establishes a schema; it does not make logs useful. Prefer event names and
bounded outcomes, include service identity through resource metadata, use UTC
timestamps, and keep messages readable. CloudCart records `trace_id` and
`span_id` only when a valid span is active. The order ID stays in the log body,
not a Loki label.

Choose levels consistently:

- DEBUG: temporary development detail, normally sampled or disabled;
- INFO: meaningful lifecycle or business state transition;
- WARNING: handled degradation or rejected work needing attention;
- ERROR: operation failed and needs investigation;
- CRITICAL: process/service cannot continue safely.

Do not log the same exception at every layer. Record it where context and
ownership are clearest, and preserve causality in the trace.

## Retention and deletion

Retention is a policy, not just a disk setting. Separate audit records from
debug telemetry: their correctness, access, immutability, and legal requirements
differ. Plan storage class, replication, compaction, deletion, tenant quotas,
and disaster recovery. Test deletion workflows and document whether backups
retain deleted data.

The lab's Loki filesystem and `emptyDir` disappear with the Pod. This is
deliberate evidence that a successful query is not durability. Production Loki
normally uses object storage and an architecture sized for ingest and query
workloads.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Observability model and telemetry pipelines](01-observability-telemetry-pipelines.md) · Next: [Tracing and correlation](03-tracing-opentelemetry-correlation.md)
