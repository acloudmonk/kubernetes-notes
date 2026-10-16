# 12 — Prometheus

**Status:** Verified<br>
**Estimated time:** 26–32 hours<br>
**Prerequisites:** [11 — Helm](../11-helm/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Helm](../11-helm/README.md) · Next: [Grafana and observability](../13-grafana-observability/README.md)

## Why this matters

Metrics turn system behavior into bounded, queryable time series. Prometheus is
simple to start and easy to misuse: an identifier in one label can create
millions of series, a mathematically plausible query can be wrong, and a firing
alert can still fail to notify anyone. This module connects instrumentation,
discovery, storage, PromQL, alert evaluation, routing, and operational limits.

## Learning objectives

You can explain the Prometheus pull model and TSDB; design counters, gauges,
histograms, and bounded labels; instrument Python services; discover Kubernetes
targets and reason through relabeling; write correct PromQL for rates, ratios,
quantiles, joins, absence, and aggregation; create recording and alerting rules;
route, group, inhibit, silence, and test alerts with Alertmanager; control
cardinality and query cost; and design retention, HA, remote-write, and long-term
storage without overstating standalone Prometheus guarantees.

## Contents

1. [Architecture, data model, and instrumentation](01-architecture-instrumentation.md)
2. [Kubernetes discovery, scraping, and relabeling](02-discovery-scraping.md)
3. [PromQL and metric correctness](03-promql.md)
4. [Rules, Alertmanager, storage, and scale](04-alerting-storage-scale.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Instrument, discover, and query CloudCart](labs/01-instrument-discover-query.md)
7. [Lab 2 — Fire, route, and recover an alert](labs/02-alert-route-recover.md)
8. [Independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)

## Tested baseline

The lab targets Prometheus 3.15.0, Alertmanager 0.34.1,
`prometheus-client` 0.26.0, Helm 4.3.1, kind 0.33.0, and Kubernetes 1.36.4.
CloudCart exposes bounded HTTP and business metrics. A transparent monitoring
stack uses EndpointSlice discovery, relabeling, five-second lab intervals,
recording/alerting rules, and a no-notification Alertmanager receiver.

The lab uses `emptyDir`, one replica, a short retention window, and no external
receiver. It is intentionally not a production monitoring platform.

## Completion

- [ ] **Explain:** trace a sample from instrumentation through scrape, TSDB, PromQL, rule, and Alertmanager.
- [ ] **Build:** create bounded metrics, discovery, recording rules, and actionable alerts.
- [ ] **Diagnose:** distinguish missing discovery, scrape failure, query error, pending alert, and notification failure.
- [ ] **Operate:** measure cardinality, series growth, query cost, retention, and monitoring-system health.
- [ ] Complete the independent challenge.

## Continue

Continue to [Module 13 — Grafana and observability](../13-grafana-observability/README.md)
for logs, traces, OpenTelemetry, dashboards, correlation, and SLOs.
