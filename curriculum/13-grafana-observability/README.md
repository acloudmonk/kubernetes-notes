# 13 — Grafana and Observability

**Status:** Verified<br>
**Estimated time:** 28–36 hours<br>
**Prerequisites:** [12 — Prometheus](../12-prometheus/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Prometheus](../12-prometheus/README.md) · Next: [CI/CD, supply chain, and GitOps](../14-cicd-supply-chain-gitops/README.md)

## Why this matters

Observability is the ability to ask new questions of a running system without
shipping new diagnostic code. It is not a synonym for “having dashboards.” A
useful system preserves context across metrics, logs, and traces; controls cost
and cardinality; expresses user reliability as SLOs; and gives responders a
short path from symptom to cause.

This module extends CloudCart with OpenTelemetry traces, trace-correlated JSON
logs, Prometheus exemplars, provisioned Grafana data sources and dashboards,
Loki, Tempo, and multi-window SLO thinking. The lab is intentionally small and
transparent: every configuration is inspectable, every image is digest-pinned,
and no external credentials are required.

## Learning objectives

You can distinguish monitoring, observability, telemetry, and profiling;
design signals around questions and service boundaries; explain OTLP and the
Collector; instrument and propagate trace context; correlate a metric exemplar,
log, and trace; write useful LogQL and TraceQL; provision Grafana safely;
design dashboards for audiences and decisions; define SLIs, SLOs, error budgets,
and burn-rate alerts; reason about sampling, retention, redaction, tenancy,
cost, and failure modes; and diagnose CloudCart using evidence rather than
dashboard-shaped guesswork.

## Contents

1. [Observability model and telemetry pipelines](01-observability-telemetry-pipelines.md)
2. [Grafana dashboards and logs](02-grafana-dashboards-logs.md)
3. [Tracing, OpenTelemetry, and signal correlation](03-tracing-opentelemetry-correlation.md)
4. [SLIs, SLOs, alerting, and operating the stack](04-slos-alerting-operations.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Deploy and explore the observability stack](labs/01-deploy-explore.md)
7. [Lab 2 — Correlate a request and diagnose a failure](labs/02-correlate-diagnose.md)
8. [Independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)

## Tested design

The verified baseline is Grafana 13.1.6, Loki 3.7.7, Tempo 3.1.0, OpenTelemetry
Collector Contrib 0.160.0, OpenTelemetry Python 1.45.1, Prometheus 3.15.0,
kind 0.33.0, Kubernetes 1.36.4, and Helm 4.3.1. Deployment and the cross-signal
test passed twice on the recorded local baseline.

The lab uses single replicas, `emptyDir` storage, anonymous read-only Grafana,
and unauthenticated in-cluster telemetry endpoints. These choices keep a local
learning environment inspectable; they are explicitly unsuitable as a
production security, availability, or durability design.

## Completion

- [ ] **Explain:** follow a signal from application code through collection, storage, query, visualization, and response.
- [ ] **Build:** provision correlated metrics, logs, traces, a dashboard, an SLI, and an SLO.
- [ ] **Diagnose:** move from an SLO symptom to a representative trace and supporting logs.
- [ ] **Operate:** defend sampling, retention, label, access, durability, and cost controls.
- [ ] Complete the independent challenge and [Gate 4](../ASSESSMENT-GATES.md#gate-4--observability-practitioner).

## Continue

After completing the checklist and Gate 4, continue to
[Module 14 — CI/CD, Supply Chain, and GitOps](../14-cicd-supply-chain-gitops/README.md),
or return to the [curriculum index](../README.md).
