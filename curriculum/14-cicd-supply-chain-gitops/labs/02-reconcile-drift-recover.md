# Lab 2 — Reconcile, Drift, Fail, and Recover

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](../README.md) · Previous: [Lab 1](01-build-verify-evidence.md) · Next: [Independent challenge](../independent-challenge.md)

## Outcome and resource budget

Install Flux into an isolated kind cluster, reconcile the CloudCart HelmRelease
from a selected repository branch, prove business processing, mutate a managed
ConfigMap, and observe Flux restore desired state. Allow 6 GB memory, 10 GB disk,
and network access. The generated credential exists only in the cluster.

## Deploy

After the module branch is available remotely, test it explicitly; after merge,
omit `GitBranch` to use `main`.

```powershell
./curriculum/14-cicd-supply-chain-gitops/scripts/Deploy-GitOpsLab.ps1 `
  -GitBranch codex/module-14-cicd-supply-chain-gitops
./curriculum/14-cicd-supply-chain-gitops/scripts/Test-GitOpsLab.ps1
```

Inspect `flux get all -A`, GitRepository artifact revision, Kustomization inventory,
HelmRelease conditions/history, managed fields, Events, and CloudCart workloads.

## Failed desired-state exercise

On a disposable branch, change the image tag to a missing value and push. Observe
the Git source advance while Helm/workload health fails. Revert that commit in
Git, reconcile, and prove HelmRelease readiness plus a processed order. Do not
repair the Deployment directly; Flux or Helm will overwrite competing changes.

## Cleanup

```powershell
kind delete cluster --name cloudcart-gitops
```

Confirm `kind get clusters` no longer lists it. Remove any disposable remote test
branch through the repository's normal reviewed workflow.

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](../README.md) · Previous: [Lab 1](01-build-verify-evidence.md) · Next: [Independent challenge](../independent-challenge.md)
