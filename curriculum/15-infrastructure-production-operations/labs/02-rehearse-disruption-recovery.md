# Lab 2 — Rehearse Disruption and Recovery

> **Module:** [15 — Infrastructure and Production Operations](../README.md) · Previous: [Lab 1 — Model and test a production topology](01-model-test-topology.md) · Next: [Cumulative production review](../cumulative-exercise.md)

## Goal and prerequisites

Deploy CloudCart across two disposable kind workers, enforce namespace capacity,
verify topology spread and a PDB, drain one API placement, complete a business
transaction during disruption, and restore a database backup in isolation.

Use PowerShell, Docker, kubectl, kind 0.33.0, Helm 4.3.1, at least 8 GB free
memory, and 12 GB free disk. This local lab has no cloud charge. It creates
random in-cluster credentials and never prints them.

## Run and observe

```powershell
./curriculum/15-infrastructure-production-operations/scripts/Deploy-OperationsLab.ps1
kubectl get nodes -L topology.kubernetes.io/zone,learning.cloudcart.io/role
kubectl get pods,pdb,resourcequota -n cloudcart -o wide
./curriculum/15-infrastructure-production-operations/scripts/Test-OperationsLab.ps1
```

The test uses a label-bounded drain, always uncordons the node, removes its
in-Pod backup and restore database, and returns the API to two ready replicas.
Explain why the PDB covers voluntary eviction but the isolated restore provides
a different guarantee. Capture only non-secret evidence.

## Cleanup

```powershell
kind delete cluster --name cloudcart-production-ops
Remove-Item -LiteralPath tmp/module15 -Recurse -Force -ErrorAction SilentlyContinue
```

Confirm the exact cluster name and resolved repository-local temporary path
before deletion. Production needs managed backup storage, key recovery,
multi-zone data architecture, external monitoring, and measured RPO/RTO.

> **Module:** [15 — Infrastructure and Production Operations](../README.md) · Previous: [Lab 1 — Model and test a production topology](01-model-test-topology.md) · Next: [Cumulative production review](../cumulative-exercise.md)
