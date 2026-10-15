# Lab 1 — Deploy CloudCart

> **Module:** [05 — Kubernetes Workloads](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Fail, update, and recover](02-fail-update-recover.md)

## Outcome and safety

Build the existing image, create a disposable two-node cluster, deploy the full
CloudCart path, and prove an order reaches the idempotent worker. Credentials
are random and created directly in the cluster. `emptyDir` data is intentionally
lost at cleanup.

From the repository root in PowerShell:

```powershell
$NodeImage = 'kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed'
docker build --tag cloudcart-app:0.1.0 capstone/cloudcart
kind create cluster --config curriculum/05-kubernetes-workloads/lab/kind-config.yaml --image $NodeImage --wait 120s
./curriculum/05-kubernetes-workloads/scripts/Deploy-CloudCartLab.ps1
./curriculum/05-kubernetes-workloads/scripts/Test-CloudCartWorkloads.ps1
```

Inspect, then explain every owner and readiness decision:

```powershell
kubectl get deployment,replicaset,pod,job,service,endpointslice -n cloudcart -o wide
kubectl describe deployment cloudcart-api -n cloudcart
kubectl logs job/cloudcart-migrate -n cloudcart
kubectl logs deployment/cloudcart-relay -n cloudcart
kubectl logs deployment/cloudcart-worker -n cloudcart
kubectl get pod -n cloudcart -l app.kubernetes.io/name=cloudcart-api -o yaml
```

Verify that app Pods do not mount a service-account token, run as UID 10001,
have read-only roots, resource requests/limits, and distinct probe purposes.
Do not print the generated Secret. Keep the cluster for Lab 2.

> **Module:** [05 — Kubernetes Workloads](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Fail, update, and recover](02-fail-update-recover.md)
