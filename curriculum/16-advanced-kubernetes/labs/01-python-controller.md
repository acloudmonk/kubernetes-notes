# Lab 1 — Build and Recover a Python Controller

> **Module:** [16 — Advanced Kubernetes](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Enforce ambient mesh identity](02-ambient-mesh.md)

## Goal and safety

Use a standard-library Python controller to reconcile a namespaced
`CloudCartPolicy` into an owned ConfigMap, publish status, correct drift, clean
up through a finalizer, and recover after controller downtime. The lab creates
a disposable three-node kind cluster and uses namespace-scoped RBAC.

Use PowerShell, Docker, kubectl, kind 0.33.0, 8 GB free memory, and 12 GB disk.
No cloud resources or credentials are required.

```powershell
python -m unittest curriculum/16-advanced-kubernetes/operator/test_controller.py
./curriculum/16-advanced-kubernetes/scripts/Deploy-OperatorLab.ps1
kubectl get crd,ccp -A
kubectl auth can-i --as=system:serviceaccount:operator-lab:cloudcart-policy-controller `
  create deployments -n operator-lab
./curriculum/16-advanced-kubernetes/scripts/Test-OperatorLab.ps1
```

The final authorization check must be `no`: the controller manages ConfigMaps,
not arbitrary workloads. Inspect generation, status, owner references, logs,
and deletion timestamps. The polling loop is educational; document why a
production controller needs watches/informers, a queue, backoff, leader election,
metrics, events, and version/upgrade tests.

Keep the cluster for Lab 2. Final cleanup appears there.

> **Module:** [16 — Advanced Kubernetes](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Enforce ambient mesh identity](02-ambient-mesh.md)
