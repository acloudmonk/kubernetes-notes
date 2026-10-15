# Lab 1 — Establish Identities and Least Privilege

> **Module:** [10 — Kubernetes Security and Policy](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Enforce workload and admission policy](02-admission-boundary.md)

## Goal

Give each CloudCart application component a distinct identity without an API
token, and prove a separate audit identity has exactly one namespaced read role.

## Procedure

1. Build `cloudcart-app:0.1.0`, then create the cluster and deploy the lab.
2. Inspect the three ServiceAccounts and Deployment Pod templates. Confirm
   `automountServiceAccountToken: false` and absence of projected token volumes.
3. Use `kubectl auth can-i --as` to build a permission matrix for
   `security-auditor`: Pod read in `security-lab` is allowed; Secret read,
   Deployment create, and CloudCart Pod read are denied.
4. Explain why CloudCart receives no RoleBinding and why database/broker access
   is not Kubernetes RBAC.
5. Run the verification script without generating or printing a token.

```powershell
kind create cluster --config curriculum/10-security-policy/lab/kind-config.yaml `
  --image kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed
./curriculum/10-security-policy/scripts/Deploy-SecurityLab.ps1
kubectl auth can-i get pods -n security-lab `
  --as system:serviceaccount:security-lab:security-auditor
./curriculum/10-security-policy/scripts/Test-SecurityLab.ps1
```

Impersonation is used here from a local cluster-admin context. Production
impersonation permission must itself be narrowly controlled and audited.

> **Module:** [10 — Kubernetes Security and Policy](../README.md) · Previous: [Quick exercises](../quick-exercises.md) · Next: [Lab 2 — Enforce workload and admission policy](02-admission-boundary.md)
