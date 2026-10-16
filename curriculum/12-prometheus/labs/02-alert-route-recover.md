# Lab 2 — Fire, Route, and Recover an Alert

> **Module:** [12 — Prometheus](../README.md) · Previous: [Lab 1 — Instrument, discover, and query](01-instrument-discover-query.md) · Next: [Independent challenge](../independent-challenge.md)

## Goal

Understand every state transition in an actionable alert by removing all API
targets, observing pending/firing evaluation, verifying Alertmanager delivery,
and restoring the service without external notification.

## Exercise

`Test-PrometheusLab.ps1` records the original replica count, generates traffic,
scales the API to zero, waits for `CloudCartAPITargetsMissing`, verifies that
Alertmanager received it, and restores replicas in `finally`. Before running it,
predict the minimum time to fire from scrape, evaluation, and `for` intervals.

While the failure is active, inspect:

```promql
up{job="cloudcart-api"}
absent(up{job="cloudcart-api"})
ALERTS{alertname="CloudCartAPITargetsMissing"}
```

Compare Prometheus `/api/v1/alerts` with Alertmanager `/api/v2/alerts`. Explain
why discovery removal differs from scrape failure and why an empty lab receiver
proves routing but not human notification. After restoration, confirm two
healthy targets, application behavior, and alert resolution.

## Production redesign

Replace the placeholder runbook, choose a symptom tied to user impact, define
severity/ownership labels, set traffic guards, test notification credentials,
add dead-man monitoring, and design HA client delivery. Do not copy the
five-second intervals or 20-second `for` duration to production.

## Cleanup

```powershell
kind delete cluster --name cloudcart-prometheus
```

Delete only this exact disposable cluster. Generated credentials exist only in
that cluster; no secret value belongs in notes or evidence.

> **Module:** [12 — Prometheus](../README.md) · Previous: [Lab 1 — Instrument, discover, and query](01-instrument-discover-query.md) · Next: [Independent challenge](../independent-challenge.md)
