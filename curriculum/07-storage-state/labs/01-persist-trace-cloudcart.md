# Lab 1 — Persist and Trace CloudCart State

> **Module:** [07 — Kubernetes Storage and State](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Break, recover, back up, and restore](02-break-recover-restore.md)

## Deploy

Use PowerShell. Build the image if absent, create the pinned disposable cluster,
and deploy the storage variant:

```powershell
$NodeImage = 'kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed'
docker build --tag cloudcart-app:0.1.0 capstone/cloudcart
kind create cluster --config curriculum/07-storage-state/lab/kind-config.yaml --image $NodeImage --wait 120s
./curriculum/07-storage-state/scripts/Deploy-StorageLab.ps1
```

Credentials are generated directly in the disposable cluster and are never
written to the repository. Inspect without decoding their values.

## Trace the contract

```powershell
kubectl get storageclass
kubectl get statefulset,pod,service,pvc -n cloudcart -o wide
kubectl get pv
kubectl describe pvc data-postgres-0 -n cloudcart
kubectl describe pv (kubectl get pvc data-postgres-0 -n cloudcart -o jsonpath='{.spec.volumeName}')
kubectl get pod postgres-0 -n cloudcart -o jsonpath='{.spec.nodeName}{"`n"}'
kubectl get pvc data-postgres-0 -n cloudcart -o jsonpath='{.metadata.uid}{"`n"}'
kubectl get pod postgres-0 -n cloudcart -o jsonpath='{.metadata.uid}{"`n"}'
```

Record the default annotation, provisioner, reclaim policy, binding mode,
expansion flag, requested/capacity values, access mode, selected node, PV node
affinity, claim/PV names, and Pod/PVC UIDs. Explain which fields come from the
workload, platform class, provisioner, and StatefulSet controller.

## Prove the persistence boundary

```powershell
./curriculum/07-storage-state/scripts/Test-StorageLab.ps1
```

The test creates a real order, replaces `postgres-0`, proves the Pod UID changed,
proves the PVC UID/PV stayed the same, and verifies the order remains. Keep the
cluster for Lab 2.

> **Module:** [07 — Kubernetes Storage and State](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Break, recover, back up, and restore](02-break-recover-restore.md)
