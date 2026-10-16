# PromQL and Metric Correctness

> **Module:** [12 — Prometheus](README.md) · Previous: [Discovery, scraping, and relabeling](02-discovery-scraping.md) · Next: [Rules, Alertmanager, storage, and scale](04-alerting-storage-scale.md)

## Types and evaluation

PromQL evaluates at timestamps. An instant-vector selector returns one recent
sample per matching series, subject to lookback and staleness. A range-vector
selector returns samples over a window for each series. Scalars and strings are
the other expression types. A graph is a range query repeatedly evaluating an
instant expression; `[5m]` is the input window at each step, not the displayed
time range.

Start with a question, identify the metric's type and labels, select a window
large enough for multiple samples, then aggregate at the intended ownership
boundary. Preserve labels needed for later matching or alert routing and remove
labels that create meaningless splits.

## Counters, ratios, and aggregation

Apply `rate()` to each counter series before aggregating so resets are detected:

```promql
sum by (route) (rate(cloudcart_http_requests_total[5m]))
```

For an error ratio, aggregate compatible numerator and denominator over the same
window and dimensions:

```promql
sum by (route) (rate(cloudcart_http_requests_total{status_code=~"5.."}[5m]))
/
sum by (route) (rate(cloudcart_http_requests_total[5m]))
```

Protect alert logic from zero traffic, and decide whether missing data means
healthy, unknown, or failed. `increase()` is useful for human-readable counts
over a window but is extrapolated from `rate`; it is not an audit total.

## Histograms and latency

Classic histogram buckets are cumulative. Aggregate bucket rates by `le` before
`histogram_quantile`:

```promql
histogram_quantile(
  0.95,
  sum by (le, route) (rate(cloudcart_http_request_duration_seconds_bucket[5m]))
)
```

A quantile is an estimate shaped by buckets and traffic volume. For an SLO such
as “99% below 250 ms,” the exact fraction below the `le="0.25"` bucket is often
more direct than an estimated p99. Average duration is
`rate(_sum[5m]) / rate(_count[5m])`; it can hide tail latency.

## Matching and joins

Binary operations match labels. Use `on(...)` or `ignoring(...)` deliberately;
`group_left`/`group_right` allow many-to-one enrichment but can multiply series
or fail when uniqueness assumptions break. Prefer instrumentation with the
dimensions needed for the question, while respecting cardinality, over fragile
query-time joins.

## Absence, offsets, and subqueries

`absent()` detects no matching series; `up == 0` detects a discovered target that
failed scraping. They are different failure modes. `offset` compares another
time, `@` fixes evaluation time, and subqueries create range data from an
expression. These are powerful but can be expensive and misleading around
deployments, traffic cycles, and retention. Validate queries on controlled data,
edge cases, empty inputs, resets, and multiple replicas.

> **Module:** [12 — Prometheus](README.md) · Previous: [Discovery, scraping, and relabeling](02-discovery-scraping.md) · Next: [Rules, Alertmanager, storage, and scale](04-alerting-storage-scale.md)
