# Architecture, Data Model, and Instrumentation

> **Module:** [12 — Prometheus](README.md) · Previous: [Module overview](README.md) · Next: [Discovery, scraping, and relabeling](02-discovery-scraping.md)

## The data path

An instrumented process exposes cumulative measurements over HTTP. Prometheus
discovers targets, scrapes snapshots, attaches target labels, and appends samples
to its local time-series database. PromQL selects and combines series. Recording
rules persist query results; alerting rules create alert instances; Prometheus
sends those instances to Alertmanager, which groups, deduplicates, silences,
inhibits, and routes notifications.

Prometheus is pull-oriented. A successful scrape proves that the monitoring
server reached an endpoint at one moment, not that user traffic works. Exporters
translate third-party systems. Pushgateway is for a narrow class of service-level
batch jobs, not a substitute for normal service discovery or a durable event bus.

## Series identity and cost

A time series is identified by metric name plus its complete label set. Every
new label-value combination is a new series with memory, storage, and query cost.
`order_id`, user ID, request ID, raw URL, exception text, timestamp, and unbounded
hostnames do not belong in labels. Put per-request identity in structured logs or
traces. CloudCart records the route template `/api/orders/{order_id}`, never the
actual UUID.

Estimate cardinality before shipping: multiply possible values for every label,
then multiply by replicas and generated series. A classic histogram creates a
series per bucket plus `_sum` and `_count`. Observe actual head series, churn,
scrape samples, memory, disk, and top label pairs after deployment.

## Metric types

- **Counter:** monotonic total reset only by process restart; use `rate()` or
  `increase()` over a window. Examples: requests, accepted orders, failures.
- **Gauge:** value can rise and fall. Examples: queue depth, in-flight work,
  last-success timestamp. Never apply counter-only reasoning to a gauge.
- **Histogram:** observations distributed into cumulative buckets with count and
  sum; aggregates across replicas and supports server-side quantiles.
- **Summary:** client-side quantiles over a configured window; quantiles generally
  cannot be aggregated across replicas. Count and sum remain useful.

Choose buckets from user expectations and observed distributions. A p99 above
the largest bucket is not measurable. Native histograms reduce manual bucket
design in supported ecosystems but require explicit compatibility, schema,
storage, and query decisions.

## Instrumentation contract

Metric names include units and use base units: `_seconds`, `_bytes`, `_total`.
HELP text states meaning; labels state bounded dimensions. Instrument outcomes,
not implementation trivia. The RED method covers request Rate, Errors, and
Duration; USE covers resource Utilization, Saturation, and Errors. Business
metrics connect technical behavior to outcomes but must not expose sensitive data.

Instrumentation must not break the request path. Measure exceptions, cancellation,
and retries correctly; avoid double counting; understand multiprocess behavior;
and test exposition. The CloudCart middleware records method, route template,
status, duration, and in-progress requests. The order endpoint records only the
bounded results `accepted`, `conflict`, and `invalid`.

> **Module:** [12 — Prometheus](README.md) · Previous: [Module overview](README.md) · Next: [Discovery, scraping, and relabeling](02-discovery-scraping.md)
