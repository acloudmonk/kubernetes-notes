# Lifecycle, Hooks, Migrations, and CRDs

> **Module:** [11 — Helm](README.md) · Previous: [Values, schemas, and dependencies](02-values-schema-dependencies.md) · Next: [Testing, distribution, security, and GitOps](04-testing-distribution-gitops.md)
## Release lifecycle

`helm install` creates revision 1. `helm upgrade` renders the desired chart and
values, applies the change, and records a revision. `helm history`, `helm status`,
`helm get values`, and `helm get manifest` expose complementary evidence.
`helm rollback` applies a previous revision as a new revision; it does not turn
back time or erase history.

Helm 4 uses `--rollback-on-failure` for transactional-style CLI behavior. Pair
it with `--wait`, `--wait-for-jobs`, and a deliberate timeout. This can restore
Kubernetes objects after failure, but cannot reverse an incompatible database
migration, an external API call, lost data, or side effects produced by a hook.
Backward-compatible schema changes and tested recovery remain application work.

`helm uninstall` removes release-owned resources, subject to resource policy
and API behavior, and normally removes release history. Persistent volumes,
external secrets, CRDs, cloud resources, and hook side effects may remain.
Always define ownership and cleanup before installation.

## Hooks and migration Jobs

Hook annotations place resources at lifecycle points such as pre-upgrade or
post-install, with weight and deletion policies controlling order and retention.
Hooks are not ordinary release resources and can outlive failure. Name, observe,
time out, retry, and delete them deliberately.

A database migration must be idempotent or uniquely versioned, safe under
concurrent deployment, observable, and compatible with both old and new
application versions during rollout. Use expand/migrate/contract for breaking
changes. Back up and test restore independently; rollback is not a database
restore mechanism.

CloudCart uses a normal revision-named migration Job and waits for Jobs during
the release. This keeps it visible in the rendered release and allows the lab's
idempotent SQL to rerun. A production team might choose a pre-upgrade hook or a
separate migration pipeline, but must document ordering and failure ownership.

## CRDs

Files in a chart's `crds/` directory are installed before templates and are not
templated. Helm deliberately avoids upgrading or deleting those CRDs because a
schema mistake can affect every custom resource and delete data. Keep CRD
lifecycle ownership explicit—often a dedicated chart or operator release—and
upgrade stored versions, conversion webhooks, and instances in a tested order.

Do not put a CustomResource in the same render path that assumes a just-created
CRD can already be discovered by every validation step. Split bootstrap when
necessary. Never claim that uninstalling an application removes its CRDs.

## Drift and concurrency

Manual `kubectl` changes, mutating admission, controllers, and defaulting can
make live state differ from rendered output. Inspect managed fields and define
which actor owns each field. Do not run two Helm clients or a CLI and GitOps
controller as competing writers for one release. Serialize release operations
and make the deployment system authoritative.

> **Module:** [11 — Helm](README.md) · Previous: [Values, schemas, and dependencies](02-values-schema-dependencies.md) · Next: [Testing, distribution, security, and GitOps](04-testing-distribution-gitops.md)
