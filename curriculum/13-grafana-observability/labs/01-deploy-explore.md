# Lab 1 — Deploy and Explore the Observability Stack

> **Module:** [13 — Grafana and observability](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Correlate and diagnose](02-correlate-diagnose.md)

## Goal

Build the instrumented CloudCart image, deploy Prometheus, Loki, Tempo, an
OpenTelemetry Collector, and Grafana, then prove that data sources, dashboards,
logs, traces, recording rules, and exemplars are connected.

## Prerequisites and resource note

Use Docker Desktop's Linux engine, at least 4 CPUs and 6 GiB available to Docker,
`kubectl`, kind 0.33.0, Helm 4.3.1, and the repository root. The stack is heavier
than one-topic labs because correlation requires real backends, but it remains
bounded: one Grafana/Loki/Tempo/Prometheus replica and one Collector per node.
Stop other local clusters if memory is constrained.

## Deploy

```powershell
docker build --tag cloudcart-app:0.1.0 ./capstone/cloudcart
kind create cluster --config curriculum/12-prometheus/lab/kind-config.yaml `
  --name cloudcart-observability `
  --image kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed
./curriculum/13-grafana-observability/scripts/Deploy-ObservabilityLab.ps1
```

The context guard prevents accidental changes to another cluster. The deploy
script reuses the Helm and Prometheus baselines, creates the dashboard ConfigMap,
server-validates manifests, enables exemplar storage, deploys the backends,
configures CloudCart OTLP export, and validates Prometheus and Collector config.

## Inspect before viewing

```powershell
kubectl get pods,services,configmaps -n monitoring
kubectl get daemonset otel-collector -n monitoring -o wide
kubectl logs -n monitoring daemonset/otel-collector --tail=100
kubectl logs -n monitoring deployment/loki --tail=50
kubectl logs -n monitoring deployment/tempo --tail=50
kubectl get deployment cloudcart-api -n cloudcart `
  -o jsonpath='{.spec.template.spec.containers[0].env}'
```

Explain why the Collector is a DaemonSet, why Grafana is not the signal store,
and why the three in-cluster backends have no public Service.

## Explore Grafana

Forward only to loopback and stop the process afterward:

```powershell
kubectl port-forward -n monitoring service/grafana 3000:3000
```

Open `http://127.0.0.1:3000`, then inspect:

- **Dashboards → CloudCart → CloudCart RED and SLO overview**;
- **Explore → Loki** with `{service_name="cloudcart-api"} | json`;
- **Explore → Tempo** with `{ resource.service.name = "cloudcart-api" }`;
- the Prometheus availability and burn-rate recording rules.

Create several orders using the documented API workflow. From a Loki log, click
the derived TraceID link. From a Prometheus histogram exemplar, open its Tempo
trace. Explain which mappings make both links work.

## Automated evidence

```powershell
./curriculum/13-grafana-observability/scripts/Test-ObservabilityLab.ps1
```

Success requires three provisioned data sources, the provisioned dashboard, a
trace-correlated log, its trace in Tempo, a populated SLI recording rule, and a
Prometheus exemplar with the same trace ID. The temporary client Pod is removed
in a `finally` block.

Keep the cluster for Lab 2. To remove it precisely when finished:

```powershell
kind delete cluster --name cloudcart-observability
```

> **Module:** [13 — Grafana and observability](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Correlate and diagnose](02-correlate-diagnose.md)
