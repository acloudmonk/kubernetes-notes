# SLIs, SLOs, Alerting, and Operating the Stack

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Tracing and correlation](03-tracing-opentelemetry-correlation.md) · Next: [Quick exercises](quick-exercises.md)

## Reliability in user terms

A service-level indicator is a measured ratio or distribution representing
user experience. A service-level objective is a target for that indicator over
a window. A service-level agreement is a business contract and may have
consequences; do not use SLA as a casual synonym for an internal SLO.

Every SLI needs an event definition:

- population: which requests or jobs count;
- good: which outcomes satisfy the user need;
- valid exclusions: explicit, rare, and reviewable;
- measurement point: load balancer, service, client, or synthetic;
- window and data-quality behavior.

CloudCart's teaching availability SLI is non-5xx HTTP requests divided by all
counted HTTP requests. Its objective is 99.5%. Whether 4xx responses are “good”
depends on the product contract: a correct rejection may be successful service,
while an authentication outage returning 401 to everyone is not. Refine the
population rather than hiding failures.

The latency SLI is the fraction completed within 250 ms. It is not the average
and is different from a p95 threshold. A percentile says where one quantile
falls; a threshold ratio directly counts good versus total events and composes
naturally with an objective.

## Error budgets

For a 99.5% objective, the bad-event budget is 0.5% over the window. Burn rate
is observed bad-event ratio divided by 0.005:

```text
burn rate 1    consumes the budget exactly across the whole window
burn rate 2    consumes it twice as fast
burn rate 14.4 consumes 2% of a 30-day budget in one hour
```

An error budget is a decision mechanism, not permission to cause avoidable
failures. Teams define what happens as budget is consumed: continue delivery,
require risk review, prioritize reliability work, or stop risky changes.

## Multi-window, multi-burn alerts

Short windows detect rapid incidents but are noisy. Long windows are stable but
slow. Pair them: alert only when both a short and a longer window exceed the
same burn threshold. Common patterns include a high fast-burn page and a lower
slow-burn ticket. Tune windows to the SLO period, traffic, and response process;
the lab's short evaluation intervals accelerate feedback but are not production
recommendations.

Alert on a user-impacting symptom when possible. Every page should be urgent,
actionable, owned, and supported by a runbook. Put stable routing dimensions in
labels and diagnostic text in annotations. Dashboard thresholds do not replace
alert evaluation, and an SLO alert does not replace monitoring of telemetry
pipeline health.

## Operating Grafana, Loki, Tempo, and the Collector

Production questions include:

| Concern | Decisions |
|---|---|
| Availability | replicas, zones, quorum/ring behavior, load balancing |
| Durability | object storage, WAL, replication, backup, restore testing |
| Security | TLS, authn/authz, tenants, network policy, secret delivery |
| Capacity | ingest rate, active series/streams, spans/s, query concurrency |
| Cost | sampling, retention, compression, index labels, cache, quotas |
| Lifecycle | version skew, canary upgrades, schema migration, rollback |

Monitor each observability component with an independent path when practical.
If Grafana is the only view of Grafana health, a failure removes both the system
and its explanation. Keep backend APIs and command-line checks in runbooks.

Loki and Tempo do not provide a complete authentication boundary by themselves
in the lab topology. Put authenticated gateways in front of shared production
endpoints. Isolate tenants, enforce per-tenant limits, and treat query access as
data access: logs and traces can contain operationally sensitive information.

## Failure response loop

Use a repeatable loop:

1. confirm user impact and the SLI window;
2. bound time, service, route, version, and environment;
3. compare traffic, errors, and latency with deploy/config events;
4. open a representative exemplar/trace;
5. find the first divergent span, then correlated logs;
6. test a falsifiable hypothesis with another signal;
7. mitigate, verify the SLI recovery, and preserve evidence;
8. correct detection, runbooks, or instrumentation after the incident.

Avoid searching random logs until a plausible error appears. Correlation narrows
evidence; it does not remove the need to understand architecture.

## Production gap review

Before promoting this lab design, replace ephemeral storage, anonymous access,
and unauthenticated OTLP endpoints; separate Collector agent/gateway roles;
instrument dependencies and asynchronous propagation; select sampling and
retention budgets; add pipeline self-monitoring, tenant limits, NetworkPolicies,
TLS, credential delivery, backups, restore tests, and capacity/load evidence.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Tracing and correlation](03-tracing-opentelemetry-correlation.md) · Next: [Quick exercises](quick-exercises.md)
