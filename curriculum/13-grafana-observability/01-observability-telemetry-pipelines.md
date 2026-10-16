# Observability Model and Telemetry Pipelines

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Module overview](README.md) · Next: [Grafana dashboards and logs](02-grafana-dashboards-logs.md)

## Start with questions

Monitoring answers anticipated questions such as “is request error rate above
the threshold?” Observability supports investigation of questions that were not
known when the software was deployed. Both require instrumentation, storage,
queries, and operational discipline. Neither is achieved merely by installing
a vendor agent.

For each signal, write the decision it supports:

| Signal | Good question | Common misuse |
|---|---|---|
| Metric | Is the user-visible failure rate rising? | Put order IDs in labels |
| Log | What happened at this decision point? | Log every variable at debug forever |
| Trace | Where did this request spend time or fail? | Sample everything without a budget |
| Profile | Which code consumes CPU or allocation over time? | Treat one profile as permanent truth |

Metrics are cheap to aggregate but lose per-request detail. Logs preserve
events but can be expensive and inconsistent. Traces preserve causal structure
but sampling means they are evidence, not an exact request counter. Profiles
explain resource use statistically. The signals complement rather than replace
one another.

## The telemetry path

CloudCart uses this data path:

```text
request
  ├─ Prometheus client → /metrics ← Prometheus pull → PromQL/rules
  ├─ JSON stdout → node log file → Collector filelog → OTLP/HTTP → Loki
  └─ OTel SDK → OTLP/HTTP → Collector → OTLP/HTTP → Tempo
                                      ↓
                         Grafana queries all three
```

Instrumentation creates telemetry. A Collector receives, processes, batches,
and exports it. A backend indexes or stores it. Grafana queries the backend; it
is not the durable source of the telemetry. Keeping these roles separate makes
failure diagnosis possible.

## OpenTelemetry data model

OpenTelemetry defines APIs, SDKs, semantic conventions, OTLP, and a Collector.
It does not require one backend. A resource describes the entity producing data,
for example `service.name=cloudcart-api` and
`deployment.environment.name=learning`. A span describes timed work in a trace.
A log record has time, severity, body, attributes, and optional trace context.

Use resource attributes for stable identity. Use span/log attributes for facts
about an operation. Never turn high-cardinality request or customer identifiers
into metric labels or Loki stream labels. A trace or structured log can carry a
request identifier without multiplying metric series or log streams.

OTLP supports gRPC and HTTP/protobuf. The lab uses HTTP/protobuf to keep network
inspection simple. The application sends to a Collector rather than directly to
Tempo so routing, batching, retries, enrichment, filtering, and backend changes
remain outside application code.

## Collector topology and backpressure

Common topologies are:

- an agent/DaemonSet close to workloads for node log files and local buffering;
- a gateway Deployment for centralized sampling, tenancy, policy, and export;
- both, when agents handle node-local acquisition and gateways handle shared
  processing.

The lab combines agent and gateway responsibilities in one DaemonSet for
clarity. A production design normally separates them. Each pipeline contains
receivers, processors, and exporters. Ordering matters: memory limiting should
act before a batch grows; redaction must occur before data leaves the trust
boundary; tail sampling requires enough trace state and memory.

When a backend slows, exporter queues grow, retries consume memory, and data may
be dropped after retry limits or process failure. Monitor the Collector itself:
accepted versus refused records, queue capacity, send failures, retries, memory,
and dropped telemetry. An observability pipeline that silently loses evidence
is an incident amplifier.

## Quality, privacy, and cost

Define a telemetry contract per service:

- stable service/resource identity;
- bounded metric and log label dimensions;
- standard trace propagation format;
- timestamp and clock expectations;
- fields prohibited from collection;
- sampling and retention class;
- owners and deletion requirements.

Secrets, authorization headers, session tokens, payment data, and unnecessary
personal data do not belong in telemetry. Redaction at query time is too late:
the sensitive value has already crossed boundaries and been stored. Prefer not
to collect it; otherwise filter at the earliest controlled point and test the
filter.

Cost is approximately ingest volume × retention × replication plus index and
query work. Control it with event value, sampling, aggregation, bounded labels,
shorter retention for verbose classes, quotas, and query limits—not by disabling
the signals needed during an incident.

## Failure matrix

| Symptom | Check first | Do not conclude |
|---|---|---|
| No metric | target discovery, scrape response, relabeling | application emitted nothing |
| No log | stdout, node file, filelog receiver, exporter | request never happened |
| No trace | SDK enablement, propagation, sampling, exporter | backend is healthy |
| Broken correlation | trace ID format/context, resource mapping, time range | all three signals are absent |
| Grafana panel empty | data source health and raw backend query | backend contains no data |

Always query the backend API before blaming a dashboard. Inspect Collector
internal telemetry before blaming the application. Preserve timestamps and
trace IDs in evidence, but never publish confidential payloads.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Module overview](README.md) · Next: [Grafana dashboards and logs](02-grafana-dashboards-logs.md)
