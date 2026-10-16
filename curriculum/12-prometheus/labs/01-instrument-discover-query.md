# Lab 1 — Instrument, Discover, and Query CloudCart

> **Module:** [12 — Prometheus](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Fire, route, and recover](02-alert-route-recover.md)

## Goal

Build instrumented CloudCart, deploy the Helm baseline, discover both API Pod
endpoints through EndpointSlices, validate configuration/rules, generate bounded
traffic, and prove PromQL and cardinality behavior.

## Prerequisites

Docker Desktop Linux engine, `kubectl`, kind 0.33.0, Helm 4.3.1, and the
repository root as the current directory. The exact lab context guard prevents
accidental execution against another cluster.

## Procedure

```powershell
docker build --tag cloudcart-app:0.1.0 ./capstone/cloudcart
kind create cluster --config curriculum/12-prometheus/lab/kind-config.yaml `
  --name cloudcart-prometheus `
  --image kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed
./curriculum/12-prometheus/scripts/Deploy-PrometheusLab.ps1
```

Read the CloudCart metrics module and `monitoring.yaml`. Build a table for every
application metric: type, unit, labels, possible values, series estimate, owner,
and question answered. Then inspect without exposing the UIs publicly:

```powershell
kubectl get endpointslice -n cloudcart -l kubernetes.io/service-name=cloudcart-api
kubectl get pods,services,configmaps -n monitoring
kubectl logs -n monitoring deployment/prometheus
kubectl exec -n monitoring deployment/prometheus -- `
  promtool check config /etc/prometheus/prometheus.yml
```

Use a short-lived `kubectl port-forward` only on loopback if interactive query
exploration is useful, stop it afterward, and never treat it as access control:

```powershell
kubectl port-forward -n monitoring service/prometheus 9090:9090
```

Explore these expressions and explain their output labels:

```promql
up{job="cloudcart-api"}
sum by (route) (rate(cloudcart_http_requests_total[1m]))
cloudcart:http_requests:rate1m
histogram_quantile(0.95, sum by (le, route) (rate(cloudcart_http_request_duration_seconds_bucket[1m])))
sum(scrape_samples_post_metric_relabeling{job="cloudcart-api"})
```

Run the automated evidence collection; it also performs Lab 2's controlled
failure so that restoration is guaranteed in a `finally` block:

```powershell
./curriculum/12-prometheus/scripts/Test-PrometheusLab.ps1
```

## Success criteria

- two application targets are discovered and `up == 1`;
- route labels contain templates, never UUIDs;
- a recording rule produces nonzero request rate;
- head series remain beneath the documented lab bound;
- configuration and rules pass `promtool` validation.

Keep the cluster for Lab 2 analysis.

> **Module:** [12 — Prometheus](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Fire, route, and recover](02-alert-route-recover.md)
