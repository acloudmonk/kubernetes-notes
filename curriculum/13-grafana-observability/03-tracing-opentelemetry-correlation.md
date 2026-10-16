# Tracing, OpenTelemetry, and Signal Correlation

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Grafana dashboards and logs](02-grafana-dashboards-logs.md) · Next: [SLIs, SLOs, alerting, and operations](04-slos-alerting-operations.md)

## Trace structure and context

A trace models one causal operation. Spans form a parent/child graph and carry
start time, duration, status, attributes, events, resource identity, and links.
A trace ID identifies the trace; a span ID identifies one operation. IDs are
correlation keys, not authentication or randomness guarantees.

Distributed tracing depends on context propagation. W3C Trace Context commonly
uses `traceparent` and optional `tracestate` headers. An inbound server extracts
context and creates a server span. Outbound clients inject the current context.
Queues require propagation in message metadata, and consumer spans often use
consumer semantics or links when processing is detached from the producer's
lifetime.

Do not trust arbitrary baggage. It crosses service boundaries and may be logged
or exported. Establish an allowlist, size limits, and a privacy model.

## Instrumentation choices

Automatic instrumentation quickly covers frameworks and libraries. Manual
instrumentation names domain work and records outcomes that libraries cannot
infer. Library instrumentation should depend on the OTel API; application
startup configures the SDK and exporter. Avoid vendor SDK calls throughout
domain code.

CloudCart deliberately implements a small HTTP server-span middleware so the
learner can see extraction, span naming, attributes, status, and export. In a
larger service, use maintained FastAPI, database, HTTP, and messaging
instrumentations, then add manual spans around business boundaries. Do not
create a span around every function.

Span names must be bounded: `POST /api/orders`, not a raw URL or order ID.
Attributes should follow stable semantic conventions where possible. Record
exceptions once with useful context, set error status deliberately, and never
attach credentials or full request bodies by default.

## Sampling

Head sampling decides near trace creation and is cheap, but it cannot know the
final latency or error. Tail sampling waits for enough of a trace to decide and
can retain errors or slow traces, but requires state, memory, consistent routing,
and a timeout. Adaptive strategies protect budgets during bursts.

Sampling changes what trace queries can prove. A missing trace does not prove a
request did not occur. Metrics remain the source for exact aggregate rates.
Preserve sampling probability when estimating from traces and keep high-value
classes without defaulting to “100% forever.”

## Tempo and TraceQL

Tempo stores traces and exposes search/query APIs; Grafana renders them. Useful
TraceQL exploration starts with resource and span attributes:

```traceql
{ resource.service.name = "cloudcart-api" }
{ resource.service.name = "cloudcart-api" && status = error }
{ name = "POST /api/orders" && duration > 250ms }
```

A local single-binary Tempo is suitable for learning, not a horizontally
scalable or durable production design. Production planning includes object
storage, tenancy, authentication proxying, ingest architecture, query limits,
retention, replication/failure domains, upgrades, and backup expectations.

## Three correlation directions

1. **Metric → trace:** a Prometheus histogram observation carries a sampled
   trace ID exemplar. Grafana shows a representative trace beside the latency
   or error series.
2. **Trace → logs:** Tempo's data source maps `service.name` to Loki's
   `service_name`, applies the trace time range, and filters by trace ID.
3. **Log → trace:** Loki's derived field extracts `trace_id` from JSON and opens
   that trace in Tempo.

An exemplar is a representative observation, not all observations in a bucket.
It reduces the time from “this panel moved” to “show me one concrete request.”
The trace then identifies a slow/error span, and its trace ID narrows the logs.

Correlation fails when IDs use different formats, time ranges do not overlap,
resources are named inconsistently, context was not propagated, the relevant
trace was not sampled, or the log pipeline transformed the field. Test links in
both directions and keep the mapping in provisioned configuration.

## Beyond the API span

The lab proves one API request because that is the smallest honest vertical
slice. A complete CloudCart trace should next include PostgreSQL calls, outbox
creation, relay publishing, RabbitMQ propagation, worker consumption, and the
notification side effect. Asynchronous work may continue long after the HTTP
span closes, so model causality rather than forcing misleading parent durations.

When expanding instrumentation, confirm:

- database statements are parameterized/redacted;
- broker headers preserve approved trace context;
- retries and duplicate deliveries are distinguishable;
- span volume and attribute cardinality remain budgeted;
- the business event ID is searchable without becoming an index label.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Grafana dashboards and logs](02-grafana-dashboards-logs.md) · Next: [SLIs, SLOs, alerting, and operations](04-slos-alerting-operations.md)
