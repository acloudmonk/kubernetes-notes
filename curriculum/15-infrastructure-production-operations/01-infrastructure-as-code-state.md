# Infrastructure as Code, State, and Change

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Module home](README.md) · Next: [Managed Kubernetes platform design](02-managed-kubernetes-platform.md)

Infrastructure as code (IaC) turns intended infrastructure into reviewable,
repeatable inputs. Declarative configuration describes a desired graph;
providers translate graph operations into remote API calls. A successful plan
is a proposal based on configuration, state, provider behavior, credentials,
and refreshed remote data—not proof that the change is safe.

## State is a protected coordination record

Terraform state binds configuration addresses to remote object identities and
caches attributes. It is neither source code nor a general inventory. State may
contain secrets even when CLI output marks a value `sensitive`. A production
backend needs encryption, narrowly scoped access, versioning, backup, recovery,
and locking or serialized execution. State boundaries should limit blast radius
without creating an unmanageable web of cross-state dependencies.

Never hand-edit state. Prefer configuration moves, import blocks, `moved`
blocks, and reviewed state commands. A force-unlock is safe only after proving
the original writer no longer exists and recording the lock identity.

## A controlled change path

1. Pin CLI and provider constraints; commit the dependency lock file.
2. Format, validate, lint, test, and scan configuration.
3. Produce a speculative plan with short-lived identity and current state.
4. Review replacement, deletion, privilege, network, cost, and data effects.
5. Apply the reviewed revision through one serialized authority.
6. verify remote behavior, ownership tags, monitoring, and recovery controls.
7. Preserve non-secret evidence and reconcile unexpected drift deliberately.

`-target` and `-refresh=false` are recovery tools, not normal workflows: each
can produce an incomplete view. Provisioners create hidden imperative coupling;
prefer image builds, cloud-init with clear ownership, or configuration systems.

## Modules and environments

Modules should express stable capabilities, typed inputs, useful outputs, and
policy-relevant invariants—not wrap every provider argument. Separate production
environments with distinct credentials, state, approval, quotas, and failure
domains. CLI workspaces alone are not a strong security boundary.

## Terraform and OpenTofu

Both use HCL and share much workflow vocabulary, but licensing, releases,
providers, state features, and language behavior can diverge. Select one tested
baseline per platform, pin it, and prove migration rather than assuming permanent
drop-in compatibility. This module executes Terraform 1.14.8; the concepts apply
to OpenTofu, but commands and tests must be revalidated against a pinned version.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Module home](README.md) · Next: [Managed Kubernetes platform design](02-managed-kubernetes-platform.md)
