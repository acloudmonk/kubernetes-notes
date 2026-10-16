# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

Strong answers state assumptions, measurement points, failure modes, privacy and
cost limits, and concrete verification—not only product definitions.

## Signals and telemetry pipelines

### 1. How do monitoring and observability differ in practice?

**Answer:** Monitoring evaluates known health questions through defined signals,
dashboards, and alerts. Observability is the system's ability to support novel
questions from its externally available telemetry and context. They overlap:
observability does not remove the need for intentional monitoring, and installing
a visualization product supplies neither instrumentation nor operational practice.

### 2. When would you choose a metric, log, trace, or profile?

**Answer:** Metrics efficiently quantify bounded trends and alert conditions;
logs record discrete contextual events; traces follow causal work across service
boundaries; profiles attribute resource cost to code over time. Start with the
question and required resolution, then combine signals through stable context.
Cost, retention, sampling, and privacy differ for each signal.

### 3. What are OpenTelemetry API, SDK, OTLP, semantic conventions, and Collector?

**Answer:** The API is what instrumentation calls; an SDK implements sampling,
processing, and export. OTLP is the telemetry transport protocol. Semantic
conventions standardize names and meanings. The Collector receives, processes,
and exports telemetry. These are separable: using the API does not guarantee an
SDK/exporter, and a Collector does not instrument an application.

### 4. Why send telemetry through a Collector instead of directly to every backend?

**Answer:** A Collector centralizes credentials, retries, batching, redaction,
sampling, enrichment, routing, and backend changes while reducing application
exporter coupling. It also becomes a capacity and failure boundary: overloaded
queues can drop data and bad processors can corrupt context. Monitor it and keep
critical application behavior independent of telemetry delivery.

### 5. Compare Collector agent and gateway topologies.

**Answer:** Agents run near workloads or per node, giving local collection and
isolation—especially for node-local logs—but multiplying configuration and
resource cost. Gateways centralize processing, credentials, and tail sampling
but require network capacity and HA. Production systems often combine agents for
local receivers with gateways for global policy.

### 6. What happens when an exporter backend applies backpressure?

**Answer:** The exporter may block, retry with backoff, buffer in memory or a
persistent queue, and eventually reject or drop telemetry when bounds are reached.
Unbounded buffering would endanger the application or Collector. Define queue,
retry, memory, and drop policy; expose accepted/refused/dropped counts and test a
backend outage plus recovery.

### 7. Which fields belong in resource attributes versus span attributes?

**Answer:** Resource attributes describe the producing entity—service name,
version, instance, deployment environment, cluster, or namespace. Span attributes
describe one operation—HTTP route, method, status, messaging destination, or
database operation. Stable resource identity enables grouping; request-specific
values belong on spans and must still obey privacy/cardinality policy.

### 8. How do you prevent credentials and personal data entering telemetry?

**Answer:** Minimize collection at instrumentation, use allowlists and semantic
reviews, scrub at the earliest trusted processor, and restrict headers, bodies,
URLs, database statements, and exception content. Enforce access, encryption,
retention, deletion, tenancy, and audit downstream. Test canary secrets and
redaction; backend masking alone leaves earlier pipeline copies exposed.

## Logs, dashboards, and correlation

### 9. Why is a trace ID a bad Prometheus or Loki stream label?

**Answer:** It is unique per trace and therefore creates unbounded Prometheus
series or Loki streams and expensive indexes. Keep it in structured log content
and span data; use bounded labels such as service, environment, namespace, level,
or route. Exemplars can attach selected trace context to metric observations
without turning every trace into a label value.

### 10. How does Loki indexing differ from full-text log indexing?

**Answer:** Loki primarily indexes stream labels and stores compressed log chunks;
queries use labels to narrow streams and then scan/filter content. This controls
index cost when labels are bounded but makes broad content searches expensive.
Design a small label set, structured log format, retention, and query limits
instead of promoting every JSON field to a label.

### 11. What makes a dashboard operationally useful rather than decorative?

**Answer:** It serves a defined audience and decision, starts with user impact and
SLOs, provides meaningful comparisons and thresholds, links to diagnosis, and
states units, scope, and freshness. Panels should answer what changed and what to
do next. Validate queries and no-data behavior against backend APIs; visual polish
cannot repair incorrect telemetry.

### 12. How do you manage Grafana dashboards and data sources as code?

**Answer:** Store reviewed provisioning and dashboard definitions, use stable
data-source identities, parameterize environment-specific endpoints safely, and
promote them through CI with JSON/schema and query tests. Define whether files,
Terraform, an operator, or UI owns each object to avoid drift. Keep credentials
outside source and test upgrade compatibility and rollback.

### 13. Explain trace context propagation across HTTP and a message broker.

**Answer:** An HTTP producer injects standard trace context into headers and the
server extracts it to create a child span. A message producer injects context into
message properties; the consumer extracts it and chooses parent/linked semantics
that reflect asynchronous work. Brokers and retry/DLQ paths must preserve allowed
headers without treating untrusted incoming context as authorization.

### 14. Compare automatic and manual instrumentation.

**Answer:** Automatic instrumentation quickly covers common frameworks, clients,
and propagation with low code change, but may create generic names or collect
unwanted data. Manual instrumentation captures domain operations, attributes,
events, and business boundaries but costs engineering effort. Combine them,
avoid duplicate spans, and test semantic stability and overhead.

### 15. Compare head sampling, tail sampling, and adaptive sampling.

**Answer:** Head sampling decides near trace start and is cheap but cannot know
the eventual outcome. Tail sampling buffers completed traces and can retain errors
or high latency, at higher memory, latency, and coordination cost. Adaptive
policies adjust rates from traffic or budget. Preserve unbiased metrics separately
and record sampling probability when statistical interpretation needs it.

### 16. Why does absence of a trace not prove absence of a request?

**Answer:** The request may not be instrumented, may be head-sampled out, may lose
context, or may be dropped during queue, export, network, backend, retention, or
query failure. Confirm the sampling and pipeline health and correlate metrics and
logs. Observability data is evidence with known loss modes, not an audit ledger by
default.

### 17. What is a Prometheus exemplar, and what does it not guarantee?

**Answer:** An exemplar attaches metadata such as a trace ID to a representative
metric observation, commonly a histogram bucket. It creates a navigation hint
from aggregate behavior to one trace. It does not retain every request, prove the
linked trace reached Tempo, or make the example statistically representative;
storage, query, and UI support must all preserve it.

### 18. How do metric-to-trace, trace-to-log, and log-to-trace links work?

**Answer:** Metric-to-trace commonly uses an exemplar containing trace context.
Trace-to-log constructs a log query from span/resource attributes and time range.
Log-to-trace extracts a trace ID from structured log content into a derived link.
All require consistent IDs, timestamps, service/resource names, tenancy, and data-
source configuration; verify with one known request end to end.

## Reliability and operations

### 19. Define SLI, SLO, SLA, error budget, and burn rate.

**Answer:** An SLI is a measured service outcome; an SLO is its target over a
window. An SLA is an external commitment with consequences. The error budget is
the allowed non-good fraction or events, and burn rate is the current consumption
rate relative to the sustainable rate. Each definition needs population, success
criteria, window, exclusions, and data-quality ownership.

### 20. Why is “p95 under 250 ms” different from “99% under 250 ms”?

**Answer:** A p95 target constrains the estimated 95th percentile value. “99%
under 250 ms” defines a threshold SLI counting good events, which directly yields
an error ratio and budget. A percentile can move within histogram interpolation
and does not reveal how many requests crossed a fixed threshold; choose the form
matching the user promise.

### 21. Explain a multi-window, multi-burn-rate alert.

**Answer:** It compares error-budget burn over a short and a long window at a high
threshold for fast severe incidents, plus another pair at a lower threshold for
slower sustained consumption. Requiring both windows reduces transient noise
while retaining speed. Tune thresholds from the SLO window and response urgency,
then replay realistic traffic and no-traffic cases.

### 22. Which 4xx responses should count against availability?

**Answer:** Classify by product semantics rather than status class alone. A valid
user operation rejected because the service is overloaded, inconsistent, or
misconfigured may be bad; malformed input or correctly enforced authentication
may be excluded. Define the eligible population and outcome at the user boundary,
version it, and audit exclusions so teams cannot improve SLOs by reclassification.

### 23. How would you monitor the observability pipeline itself?

**Answer:** Monitor receiver acceptance, processor failures, queue occupancy,
export retries/drops, backend ingestion/query health, storage/retention, clock
skew, sampling, cardinality, and dashboard/data-source errors. Add synthetic
canary telemetry and an external check so the same failed pipeline is not the
only reporter of its outage. Alert on user-visible observability loss and capacity.

### 24. What must change before the lab stack is production-ready?

**Answer:** Replace single replicas and `emptyDir` with capacity-planned HA and
durable storage; add authenticated, encrypted, tenant-isolated endpoints; remove
anonymous Grafana access; manage secrets and certificates; add retention, backup,
resource, disruption, scaling, and upgrade plans; harden Pods/network; and monitor
the stack. Validate cost, recovery, data governance, and failure-domain design.

### 25. Diagnose a slow CloudCart order without starting from logs.

**Answer:** Start with the latency/error SLI by route and time to confirm user
impact and scope. Follow a relevant histogram exemplar into a trace, identify the
slow span and dependency, then query correlated logs by trace ID for discrete
evidence. Compare saturation, queue, database, and messaging metrics; test the
hypothesis and confirm SLI recovery rather than searching all logs for “error.”

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
