# Kubernetes Discovery, Scraping, and Relabeling

> **Module:** [12 — Prometheus](README.md) · Previous: [Architecture and instrumentation](01-architecture-instrumentation.md) · Next: [PromQL and metric correctness](03-promql.md)

## Discovery is not scraping

Kubernetes service discovery watches API objects and produces candidate targets
with `__meta_kubernetes_*` labels. Relabeling transforms or drops candidates
before a scrape. The remaining target address, path, scheme, parameters, and
labels define the scrape. Metric relabeling runs later on individual samples and
is more expensive; use it only when dropping or rewriting ingested series is
actually required.

This lab uses `role: endpointslice`, limits discovery to `cloudcart`, keeps only
Services annotated for scraping and the named `http` port, changes the metrics
path from an annotation, and promotes namespace, Service, and Pod identity to
stable labels. It scrapes both API Pod endpoints rather than the load-balanced
Service virtual IP.

## Target labels and collisions

Prometheus adds `job` and `instance`; scraped labels can collide with target
labels depending on `honor_labels`. Set an intentional ownership convention.
External labels identify the Prometheus replica/cluster when communicating with
external systems; they do not appear automatically on every local query result.
Do not promote all Kubernetes annotations or labels: that creates churn,
cardinality, and accidental sensitive metadata.

## Scrape health

`up` is generated per target: `1` means the most recent scrape succeeded and `0`
means it failed. `scrape_duration_seconds`, `scrape_samples_scraped`,
`scrape_samples_post_metric_relabeling`, and target UI errors explain cost and
failure. A target that is no longer discovered has no `up` series after staleness;
alert separately on absence when the target is expected.

Scrape interval controls resolution and load. Timeout must be shorter than the
interval. A 5-second interval is useful for this short lab, not a universal
production default. Secure endpoints with network policy, TLS, authentication,
and narrow discovery RBAC. Prometheus contains sensitive topology and operational
data; do not expose its UI or lifecycle reload endpoint publicly.

## Operator abstraction

Prometheus Operator turns `Prometheus`, `ServiceMonitor`, `PodMonitor`,
`PrometheusRule`, and `Alertmanager` custom resources into configuration and
managed workloads. It improves delegation and reconciliation but introduces CRD,
selector, namespace, RBAC, upgrade, and controller-availability concerns. This
module uses raw configuration so the underlying target and relabel pipeline is
visible. Module 13 can layer the operator and dashboards on that model.

> **Module:** [12 — Prometheus](README.md) · Previous: [Architecture and instrumentation](01-architecture-instrumentation.md) · Next: [PromQL and metric correctness](03-promql.md)
