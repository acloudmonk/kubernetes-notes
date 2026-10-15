# Lab 1 — Observe Configuration Lifecycle

> **Module:** [08 — Kubernetes Configuration and Secrets](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Diagnose and rotate safely](02-diagnose-rotate.md)

## Deploy

Use PowerShell. Build the image if absent, create the pinned disposable cluster,
and deploy the persisted CloudCart baseline:

```powershell
$NodeImage = 'kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed'
docker build --tag cloudcart-app:0.1.0 capstone/cloudcart
kind create cluster --config curriculum/08-configuration-secrets/lab/kind-config.yaml --image $NodeImage --wait 120s
./curriculum/08-configuration-secrets/scripts/Deploy-ConfigurationLab.ps1
```

The script generates credentials directly in the disposable cluster. Do not
decode, print, export, or commit them.

## Map configuration without values

```powershell
kubectl get configmap cloudcart-config -n cloudcart -o jsonpath='{.metadata.resourceVersion}{"`n"}{range $k,$v := .data}{$k}{"`n"}{end}'
kubectl get secret cloudcart-credentials -n cloudcart -o jsonpath='{.metadata.resourceVersion}{"`n"}{range $k,$v := .data}{$k}{"`n"}{end}'
kubectl get deployment cloudcart-api cloudcart-relay cloudcart-worker -n cloudcart -o yaml
kubectl auth can-i get secrets -n cloudcart
kubectl auth can-i list secrets -n cloudcart
```

Record only names, keys, references, consumers, and resourceVersions. Explain
why access as your cluster-admin lab identity is not a suitable workload RBAC
design and why Pod creation can imply indirect Secret access.

## Prove environment update behavior

```powershell
./curriculum/08-configuration-secrets/scripts/Test-ConfigurationReload.ps1
```

The script changes a non-secret ConfigMap value, proves the existing process
environment remains unchanged, rolls the relay, proves the replacement consumes
the new value, and restores the committed baseline in `finally`.

Keep the cluster for Lab 2.

> **Module:** [08 — Kubernetes Configuration and Secrets](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Diagnose and rotate safely](02-diagnose-rotate.md)
