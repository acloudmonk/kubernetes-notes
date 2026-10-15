# Lab 1 — Place and Protect CloudCart

> **Module:** [09 — Kubernetes Scheduling and Resources](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Diagnose scheduling and resource failures](02-diagnose-resources.md)

## Goal

Run CloudCart on two application workers, spread API replicas, protect voluntary
disruption, and feed CPU metrics to an HPA without claiming production sizing.

## Procedure

1. Build `cloudcart-app:0.1.0` using the earlier capstone instructions.
2. Create the lab cluster from `lab/kind-config.yaml`. If its embedded name is
   changed, pass the same name to both scripts.
3. Run `scripts/Deploy-SchedulingLab.ps1`. It composes the Module 08 deployment,
   patches placement, installs pinned Metrics Server 0.9.0, and applies HPA/PDB.
4. Inspect node labels, Pod `nodeName`, API spread, requests, PriorityClass,
   PDB status, HPA conditions, and the resource metrics API.
5. Run `scripts/Test-SchedulingLab.ps1` and retain non-secret PASS evidence.

```powershell
kind create cluster --config curriculum/09-scheduling-resources/lab/kind-config.yaml `
  --image kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed
./curriculum/09-scheduling-resources/scripts/Deploy-SchedulingLab.ps1
kubectl get pods -n cloudcart -o wide
kubectl get pdb,hpa -n cloudcart
kubectl top pods -n cloudcart
./curriculum/09-scheduling-resources/scripts/Test-SchedulingLab.ps1
```

The kind-only `--kubelet-insecure-tls` Metrics Server setting compensates for
local kubelet serving certificates. Do not copy it into production; establish
trusted certificates instead. Review external manifests before applying them.

## Evidence and cleanup

Explain why the API is Burstable, why each API replica occupies a distinct
hostname, why HPA CPU percentage depends on requests, and which disruption
paths bypass the PDB. Cleanup is explicit:

```powershell
kind delete cluster --name cloudcart-scheduling
```

> **Module:** [09 — Kubernetes Scheduling and Resources](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Diagnose scheduling and resource failures](02-diagnose-resources.md)
