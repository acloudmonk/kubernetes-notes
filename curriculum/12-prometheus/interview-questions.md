# Interview Questions

> **Module:** [12 — Prometheus](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

## Data model and instrumentation

### 1. Trace a metric from code to a notification. Who owns each boundary?

**Answer:** Application instrumentation exposes samples; discovery and relabeling
select a target; Prometheus scrapes and stores series; PromQL and rules evaluate
them; Prometheus sends alert instances to Alertmanager, which groups, inhibits,
silences, and routes notifications to a receiver. Delivery and human response are
additional boundaries. Verify each hop independently instead of equating a firing
rule with a delivered page.

### 2. Why does Prometheus pull, and when is Pushgateway appropriate?

**Answer:** Pull centralizes scrape scheduling, target health, timeout, and label
policy and lets Prometheus observe `up`. Pushgateway is for metrics from short-
lived service-level batch jobs that cannot be scraped. It is not a general event
bus or per-instance replacement; pushed series persist until deleted and require
explicit lifecycle ownership.

### 3. What defines a time series, and how do you estimate cardinality?

**Answer:** A metric name plus its complete label set identifies a series.
Estimate the reachable combinations of label values, accounting for correlations,
targets, replicas, and churn, then measure active series and ingestion. Multiplying
every label's maximum is a useful worst-case warning, but production measurement
and growth rate determine memory, disk, and query impact.

### 4. How do you choose counter, gauge, histogram, or summary?

**Answer:** Counters track cumulative events and are queried with rates/increases;
gauges represent values that rise and fall. Histograms count observations in
buckets and support aggregatable server-side quantiles. Summaries calculate
client-side quantiles that generally cannot be aggregated meaningfully. Choose
from the question, aggregation boundary, accuracy, cost, and reset behavior.

### 5. Why are user IDs, request IDs, and raw paths dangerous labels?

**Answer:** Their unbounded or rapidly changing values create a new series per
identity, causing memory, storage, and query growth and potentially leaking data.
Use bounded route templates, status classes, methods, regions, or service names.
Put request-specific identity in logs/traces and link through exemplars where
appropriate, with privacy controls.

### 6. How do classic histogram quantiles work, and what errors do buckets introduce?

**Answer:** Bucket counters are cumulative; apply `rate` to each series, aggregate
while retaining `le`, then use `histogram_quantile`. The result interpolates
within the containing bucket, so wide or poorly placed buckets reduce accuracy,
especially near an SLO threshold. Bucket count also multiplies series, making
boundary design an accuracy/cost decision.

## PromQL and discovery

### 7. Explain instant vectors, range vectors, query range, and evaluation step.

**Answer:** An instant vector contains one current sample per matching series at
an evaluation time. A range vector contains samples over a lookback for each
series and feeds functions such as `rate`. A range query repeatedly evaluates an
instant expression between start and end; its step controls display resolution,
not scrape frequency or the function's lookback window.

### 8. Why should `rate` usually happen before aggregation?

**Answer:** Counter reset detection requires each original series. `sum(rate(x[5m]))`
handles replicas that restart independently, while aggregating raw counters first
can hide a reset behind another series' increase. Aggregate the rates over the
dimensions relevant to the question, and preserve labels required for later
matching or histogram calculation.

### 9. How do you construct a correct error ratio?

**Answer:** Use rates over the same event counter, window, and aligned label
population: error rate divided by total rate. Define which outcomes count as
errors, aggregate numerator and denominator consistently, guard zero traffic
according to the intended semantics, and test label matching. Never average
per-instance percentages when traffic volumes differ.

### 10. What is vector matching, and when are `group_left` or `group_right` risky?

**Answer:** Binary vector operations pair series by label identity, modified by
`on` or `ignoring`. Group modifiers permit many-to-one matching and copy selected
labels from the one side. They can silently duplicate values or attach misleading
metadata if uniqueness changes. Prove cardinality and uniqueness before the join,
and record complex, stable joins when justified.

### 11. Compare `up == 0`, `absent(up)`, exporter failure, and stale series.

**Answer:** `up == 0` means a discovered scrape target was attempted and failed.
`absent(up{...})` means no matching series exists, perhaps due to discovery or
label errors. An exporter can return successfully while its collector metrics
show partial failure. When a target disappears, prior series become stale rather
than remaining zero. Alert separately on these failure classes.

### 12. Explain service discovery, target relabeling, and metric relabeling.

**Answer:** Service discovery produces candidate targets and metadata. Target
relabeling selects targets and constructs scrape labels before a request; it can
drop unwanted targets cheaply. Metric relabeling runs on scraped samples before
ingestion and can drop or reshape series, but scrape transport cost already
occurred. Bad rules can silently erase coverage, so inspect discovered targets
and stored labels.

### 13. What does a successful scrape prove—and not prove?

**Answer:** It proves Prometheus reached the metrics endpoint, received a valid
response within limits, and accepted the scrape. It does not prove the service's
user path, dependencies, metric correctness, freshness of every collector, or
notification path. Pair scrape health with semantic metrics and black-box or
business checks.

## Rules and Alertmanager

### 14. When should a recording rule exist, and what does it cost?

**Answer:** Record an expensive, frequently reused, well-defined expression or a
stable interface used by dashboards and alerts. Rules reduce repeated query work
and can centralize semantics, but evaluate continuously and create additional
stored series. Name, label, test, document, and retire them; they do not reduce
raw ingestion unless collection changes.

### 15. Describe inactive, pending, firing, silenced, inhibited, and resolved alerts.

**Answer:** A false expression is inactive. A true expression held by `for` is
pending; after the duration it fires. Alertmanager may silence it explicitly or
inhibit it because another alert explains it. When the expression clears, it is
resolved and may send a resolution notification. Pending/firing belong to rule
evaluation; silence/inhibition/routing belong to Alertmanager.

### 16. What belongs in alert labels versus annotations?

**Answer:** Labels are stable, bounded identity and routing fields such as alert
name, service, severity, and team. Annotations contain human context, summaries,
runbook/dashboard links, and templated values. Changing a label creates a distinct
alert instance and affects grouping/deduplication, so volatile values and long
messages belong in annotations.

### 17. How do grouping, deduplication, inhibition, and routing interact?

**Answer:** Alertmanager matches routes and groups related alert instances before
notification. It deduplicates repeated updates for the same fingerprints and
timing state; inhibition suppresses symptoms when a causal alert is firing;
silences are operator-defined matchers. Poor labels can defeat all four, so test
the complete route tree and timing with representative alerts.

### 18. Why can a firing Prometheus alert produce no page?

**Answer:** Prometheus may not reach Alertmanager; Alertmanager may silence,
inhibit, group-delay, or route it elsewhere; the receiver can reject it; or the
notification integration can fail. Inspect rule state, Prometheus notification
metrics, Alertmanager UI/API/logs, route match, inhibition/silence, and receiver
delivery. A firing rule is only one stage.

### 19. How would you test metrics, PromQL, rules, and notification routing?

**Answer:** Unit-test instrumentation names, labels, and increments; lint and
unit-test rules with synthetic input series; exercise queries against fixtures or
an ephemeral Prometheus; validate Alertmanager configuration and send labeled
test alerts through the route tree to a safe receiver. Also test absence, reset,
zero-traffic, delayed-data, recovery, and duplicate scenarios.

## Storage, scale, and operations

### 20. How does local Prometheus storage work and fail?

**Answer:** Recent samples enter memory and a write-ahead log, then compact into
immutable time blocks with indexes; retention removes old blocks. Disk exhaustion,
WAL corruption/replay time, high cardinality, slow queries, and loss of the local
volume threaten availability or history. Snapshots and persistent disks help but
do not create HA or long-term global querying.

### 21. What does two-replica Prometheus HA require from Alertmanager and queries?

**Answer:** Both replicas normally scrape and evaluate the same rules, producing
duplicate alert instances. Send to a clustered Alertmanager set that can
deduplicate consistent labels, and use a query layer or client strategy that
deduplicates replica series. Separate failure domains and external labels, and
test partial outages; two replicas alone do not coordinate TSDB contents.

### 22. Compare federation, remote write, and long-term compatible backends.

**Answer:** Federation pulls selected aggregated or raw series from another
Prometheus. Remote write streams samples to a receiver asynchronously and needs
queue/backpressure monitoring. Systems such as Thanos, Mimir, or Cortex-pattern
backends add durable object storage, global query, and tenancy with substantial
operational cost. Choose from retention, query, availability, and ownership needs.

### 23. How do you detect and contain a cardinality incident?

**Answer:** Watch active/head series, ingestion rate, label-value counts, memory,
WAL/disk growth, and query latency. Identify the metric and labels creating churn,
then stop or relabel-drop the source while preserving essential coverage. Fix
instrumentation, safely retire data under retention policy, and add budgets and
tests. Scaling hardware alone leaves the unbounded cause active.

### 24. What changes when Prometheus Operator owns configuration?

**Answer:** Custom resources such as ServiceMonitor, PodMonitor, PrometheusRule,
and AlertmanagerConfig become inputs to an operator that renders underlying
configuration and workloads. Debug resource selection, namespace selectors,
generated config, reconciliation status, and operator logs—not only a hand-written
file. RBAC and admission determine who can expand monitoring scope or routing.

### 25. How do you monitor the monitoring system without circular blind spots?

**Answer:** Monitor scrape health, rule evaluation, notification delivery,
cardinality, disk/WAL, remote-write queues, and component availability from the
stack itself, but add an independent external check for critical user paths and
notification delivery. Use dead-man alerts with an external receiver and avoid
placing every signal, dashboard, and pager behind one failure domain.

> **Module:** [12 — Prometheus](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
