# Lab 1 — Author and Validate the CloudCart Chart

> **Module:** [11 — Helm](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Upgrade, fail, and roll back](02-upgrade-fail-rollback.md)
## Goal

Understand the first-party chart as a release contract, validate it in layers,
and install a working CloudCart release without storing credentials in Git or
Helm values.

## Prerequisites

- Docker Desktop Linux engine, `kubectl`, kind 0.33.0, and Helm 4.3.1
- repository root as the current directory
- no production kube-context; the script accepts only the named kind context

The commands create the disposable `cloudcart-helm` cluster and local image.
The script then loads the image and generates credentials directly in a
Kubernetes Secret. It does not print or write those values to disk.

## Procedure

1. Read `Chart.yaml`, `values.yaml`, `values.schema.json`, helpers, and each
   rendered resource. Predict names, ownership, dependencies, and Pod security.
2. Create the cluster and deploy:

```powershell
docker build --tag cloudcart-app:0.1.0 ./capstone/cloudcart
kind create cluster --config curriculum/11-helm/lab/kind-config.yaml `
  --image kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed
./curriculum/11-helm/scripts/Deploy-HelmLab.ps1
```

3. Inspect values, rendered manifests, release metadata, workload ownership,
   Job completion, and application readiness without decoding the Secret:

```powershell
helm status cloudcart --namespace cloudcart
helm get values cloudcart --namespace cloudcart --all
helm get manifest cloudcart --namespace cloudcart
kubectl get all,pvc,configmap,secret --namespace cloudcart
kubectl get secret cloudcart-credentials --namespace cloudcart `
  -o jsonpath='{.metadata.labels.app\.kubernetes\.io/managed-by}'
```

The last command should not say `Helm`: the prerequisite Secret has a separate
lifecycle. Never print `.data` or decoded credentials merely to prove existence.

4. Trigger two expected schema failures:

```powershell
helm template cloudcart ./capstone/cloudcart/helm/cloudcart `
  --set-string config.relayIntervalSeconds=invalid
helm template cloudcart ./capstone/cloudcart/helm/cloudcart `
  --set unexpectedValue=true
```

5. Render to a temporary ignored path and ask the API server to validate it:

```powershell
New-Item -ItemType Directory -Force tmp/module11 | Out-Null
helm template cloudcart ./capstone/cloudcart/helm/cloudcart `
  --namespace cloudcart | Set-Content tmp/module11/rendered.yaml
kubectl apply --dry-run=server --filename tmp/module11/rendered.yaml
```

Explain why schema, rendering, API acceptance, readiness, and application tests
are different claims.

## Success criteria

- strict lint, schema, render, and server validation behave as predicted;
- migration completes and all application components become Ready;
- `helm test` reaches the API readiness endpoint;
- an order completes the API → outbox → broker → worker path;
- the credential Secret is external to release ownership.

Do not delete the cluster yet; Lab 2 uses the same release.

> **Module:** [11 — Helm](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Upgrade, fail, and roll back](02-upgrade-fail-rollback.md)
