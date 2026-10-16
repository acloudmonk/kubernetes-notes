# Lab 2 — Correlate a Request and Diagnose a Failure

> **Module:** [13 — Grafana and observability](../README.md) · Previous: [Lab 1 — Deploy and explore](01-deploy-explore.md) · Next: [Independent challenge](../independent-challenge.md)

## Goal

Move from a user symptom through metrics, an exemplar, a trace, and logs; then
inject a dependency failure, restore it, and verify recovery. This lab gives the
guided method. The independent challenge removes the sequence.

## Establish a healthy control

Run the automated test once and preserve its trace ID. In Grafana, record the
current request rate, availability SLI, p95 latency, API logs, and trace shape.
Write a hypothesis for how database loss should appear in each signal.

## Inject the failure

Save the current PostgreSQL Service selector, then make it select no Pods:

```powershell
$selector = kubectl get service cloudcart-postgres -n cloudcart `
  -o jsonpath='{.spec.selector.app\.kubernetes\.io/component}'
kubectl patch service cloudcart-postgres -n cloudcart --type=merge `
  -p '{"spec":{"selector":{"app.kubernetes.io/component":"database-fault"}}}'
kubectl get endpointslice -n cloudcart `
  -l kubernetes.io/service-name=cloudcart-postgres
```

Send an order request with a short client timeout. Bound the incident start
time. Observe the readiness response and API Pod restart counts; dependency
unavailability should affect readiness without causing liveness restarts.

## Diagnose with correlation

Work in this order and save one fact at each step:

1. Does the availability/burn metric show impact, or did the client time out
   before a response became a counted event?
2. Did a request span arrive, and where does its duration/status diverge?
3. Do trace-correlated logs contain a database exception?
4. Does the PostgreSQL Service have ready endpoints?
5. Are PostgreSQL Pods healthy, proving the fault is selection rather than the
   database process?

Explain any telemetry blind spot. A request that never completes may not
increment a completion counter; that is a reason to add timeout metrics or
upstream measurement, not to rewrite the evidence.

## Restore and verify

Always restore the selector, even if diagnosis is incomplete:

```powershell
$restorePatch = @{
  spec = @{selector = @{'app.kubernetes.io/component' = $selector}}
} | ConvertTo-Json -Compress
kubectl patch service cloudcart-postgres -n cloudcart --type=merge `
  --patch $restorePatch
kubectl rollout status deployment/cloudcart-api -n cloudcart --timeout=180s
./curriculum/13-grafana-observability/scripts/Test-ObservabilityLab.ps1
```

Confirm endpoints return, readiness recovers, a new order completes, and the
correlated test passes. Write a short incident note: impact, timeline, evidence,
root cause, mitigation, recovery proof, observability gap, and one prevention.

## Safety

This fault targets only the exact kind context and namespaced Service. It does
not delete data or expose a credential. If `$selector` is empty, stop rather
than patching; do not guess restoration state.

> **Module:** [13 — Grafana and observability](../README.md) · Previous: [Lab 1 — Deploy and explore](01-deploy-explore.md) · Next: [Independent challenge](../independent-challenge.md)
