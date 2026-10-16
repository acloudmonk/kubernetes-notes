# Lab 2 — Enforce Ambient Mesh Identity

> **Module:** [16 — Advanced Kubernetes](../README.md) · Previous: [Lab 1 — Build and recover a Python controller](01-python-controller.md) · Next: [Lab 3 — Design and rehearse fleet failover](03-fleet-failover.md)

## Goal and prerequisites

Install checksum-verified Istio 1.31.2 in ambient mode, enroll a namespace,
run a two-replica server and two client identities, allow only `mesh-client`,
and prove `mesh-other` is denied. Reuse the Lab 1 kind cluster.

Review the installer and image sources before use. Ambient components are
privileged node/control-plane software; the lab is isolated and disposable.

```powershell
./curriculum/16-advanced-kubernetes/scripts/Deploy-MeshLab.ps1
kubectl get pods -n istio-system -o wide
kubectl get authorizationpolicy -n mesh-lab -o yaml
istioctl ztunnel-config workloads --workload-namespace mesh-lab
./curriculum/16-advanced-kubernetes/scripts/Test-MeshLab.ps1
```

Explain which evidence demonstrates enrollment, transport identity, and policy
outcome—and which does not prove encryption on its own. Compare the node-level
ztunnel boundary with a sidecar and with ordinary NetworkPolicy.

## Cleanup

```powershell
kind delete cluster --name cloudcart-advanced
Remove-Item -LiteralPath tmp/module16 -Recurse -Force -ErrorAction SilentlyContinue
```

Confirm the exact cluster and resolved repository-local temporary path first.
Never reuse the lab trust roots, generated kubeconfig, or diagnostics.

> **Module:** [16 — Advanced Kubernetes](../README.md) · Previous: [Lab 1 — Build and recover a Python controller](01-python-controller.md) · Next: [Lab 3 — Design and rehearse fleet failover](03-fleet-failover.md)
