# Rules, Alertmanager, Storage, and Scale

> **Module:** [12 — Prometheus](README.md) · Previous: [PromQL and metric correctness](03-promql.md) · Next: [Quick exercises](quick-exercises.md)

## Recording and alerting rules

Recording rules precompute expensive or standardized expressions as new series.
Name them by level, metric, and operation; retain the labels consumers need; and
budget their cardinality. Rules trade query cost for continuous evaluation and
additional storage. Test syntax with `promtool`, unit-test semantics with fixed
input series, and inspect evaluation duration/failures in production.

An alerting expression returns one alert instance per output label set. `for`
keeps it pending until continuously true; evaluation interval affects timing.
`keep_firing_for` can reduce flapping after the expression clears. Labels route
and identify the alert; annotations carry human context. Every actionable alert
needs ownership, impact, urgency, evidence, and a maintained runbook.

Alert on user-visible symptoms or exhausted budgets where possible, and use
cause alerts selectively. Multi-window burn-rate alerts are stronger than fixed
thresholds for SLOs; Module 13 develops SLOs in depth.

## Alertmanager

Prometheus evaluates; Alertmanager notifies. Alertmanager fingerprints alerts,
deduplicates repeats, groups related instances, routes by labels, applies
silences and time intervals, and inhibits lower-signal alerts when a stronger
known cause fires. HA peers coordinate notification state but clients must send
to every replica; a load balancer to one replica defeats that model.

Test the whole route, including receiver credentials, templates, provider
responses, grouping delay, resolved notifications, and dead-man signals. A
firing alert visible in Prometheus does not prove Alertmanager received it, and
an Alertmanager alert does not prove a human was notified. The lab receiver is
intentionally empty to avoid sending external messages.

## Local storage and durability

Prometheus writes a WAL, compacted blocks, and head data to local storage.
Retention can be time- and size-based; actual disk needs include WAL/head and
compaction overhead. Backups require snapshots or storage-aware procedures.
Network filesystems are generally a poor fit for the local TSDB. Monitor disk,
ingestion, compaction, WAL, query load, rule health, and scrape health.

A standalone replica has gaps during failure and no durable lab data here.
Two independent replicas scraping the same targets provide collection
availability but duplicate series; query/deduplication and Alertmanager routing
must understand replica labels.

## Beyond one server

Remote write sends samples to another system and has queues, shards, backpressure,
retries, and WAL coupling. It is not a free backup. Federation selects aggregated
series between Prometheus servers. Thanos, Cortex/Mimir, VictoriaMetrics, and
compatible services offer different long-term, global-query, multi-tenant, and
HA tradeoffs. Evaluate consistency, deduplication, object storage, tenancy,
query limits, cost, restore, and exit strategy rather than choosing by scale alone.

Control scale at the source: bounded labels, sensible intervals, sample limits,
relabel drops, recording-rule budgets, query concurrency/time/sample limits, and
ownership. Measure before adding a distributed backend.

> **Module:** [12 — Prometheus](README.md) · Previous: [PromQL and metric correctness](03-promql.md) · Next: [Quick exercises](quick-exercises.md)
