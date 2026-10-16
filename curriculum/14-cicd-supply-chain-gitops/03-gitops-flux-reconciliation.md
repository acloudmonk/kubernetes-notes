# GitOps and Flux Reconciliation

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Supply-chain evidence](02-supply-chain-evidence.md) · Next: [Delivery policy and operations](04-delivery-policy-operations.md)

## GitOps contract

GitOps uses declarative, versioned desired state and an automated pull-based
reconciler. Git history is evidence of intent, not proof of runtime state. The
controller continuously compares source artifacts with cluster objects, applies
changes, reports conditions, and optionally prunes objects removed from source.

## Flux object flow

Source Controller fetches a GitRepository or OCIRepository and publishes a
content-addressed artifact. Kustomize Controller builds a path, applies with
server-side ownership, performs health checks, and prunes when configured. Helm
Controller turns a HelmRelease plus chart source into Helm revisions. Conditions,
observed generation, artifact revision, inventory, Events, and controller logs
identify the current boundary.

## Drift, ownership, and reconciliation

Manual edits to managed fields are drift and will normally be reverted. Suspend
reconciliation only for a bounded incident procedure, record why, and resume it.
Avoid a CLI user and Flux managing the same release. Use dependency ordering and
health checks deliberately; eventual convergence is not a cross-resource transaction.

## Repository and secret design

Separate application source, reusable deployment definitions, and environment
promotion according to team ownership. Protect branches and require review while
avoiding environment-copy sprawl. Never store plaintext credentials in Git.
Use workload identity and an external secret source or an encrypted-secret
workflow whose decryption keys remain outside the repository.

## Flux and Argo CD

Both reconcile declarative state. Flux emphasizes composable controllers and
Kubernetes APIs; Argo CD provides an Application model and rich UI. Selection
depends on ownership, multi-tenancy, policy, source types, operating model, and
team skills. Neither fixes unsafe manifests, secrets, or artifact identity.

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Supply-chain evidence](02-supply-chain-evidence.md) · Next: [Delivery policy and operations](04-delivery-policy-operations.md)
