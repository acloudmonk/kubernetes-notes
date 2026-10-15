# Testing, Distribution, Security, and GitOps

> **Module:** [11 — Helm](README.md) · Previous: [Lifecycle, hooks, migrations, and CRDs](03-lifecycle-hooks-crds.md) · Next: [Quick exercises](quick-exercises.md)

## A layered validation pipeline

No single Helm command proves correctness. Use progressively more realistic
evidence:

1. parse and schema-check values; run `helm lint --strict`;
2. render representative value combinations with `helm template`;
3. inspect and policy-scan the rendered objects;
4. perform client and server dry runs against the target API capabilities;
5. install into an ephemeral cluster, wait for workloads and Jobs, and run chart tests;
6. exercise upgrades, failed upgrades, rollback, uninstall, and data behavior;
7. promote the exact tested chart archive and image digests.

Golden/unit tests catch helper logic, while integration tests catch API
defaulting, admission, scheduling, controllers, storage, and application
behavior. Test optional branches, not only defaults. Avoid snapshots so large
that reviewers stop reading semantic changes.

## Packaging and OCI

Use SemVer for chart versions and publish immutable packages. `helm package`
produces a `.tgz`; OCI registries can store charts beside other artifacts.
Authenticate through a scoped credential helper, push the exact archive, and
install a version or digest that CI verified. Tags can move; digests identify
content. Protect registry deletion, enforce retention, scan dependencies, and
produce provenance/signatures according to the organization's trust model.

Do not place registry tokens in repository files or command examples. A chart
archive can leak bundled files and defaults, so inspect its contents before
publishing.

## Helm and GitOps

Flux, Argo CD, and similar controllers can consume a chart and values, render
resources, and continuously reconcile them. The desired source, drift behavior,
upgrade orchestration, hook interpretation, and release-state representation
depend on the controller. Do not assume `helm history` or CLI rollback is the
authoritative workflow for a controller-managed application.

Use one owner. Commit chart/version/value changes, review rendered diffs, let
the controller report reconciliation health, and revert the desired Git state
when appropriate. Keep emergency changes auditable and reconcile them back into
source. Module 14 implements the delivery and GitOps model in depth.

## Security review

Treat charts and dependencies as executable deployment code. Review template
functions, RBAC, ServiceAccounts, host access, security contexts, network
exposure, image references, hooks, Jobs, and generated objects. Enforce value
schema, pin artifacts, use least-privilege registry credentials, and avoid
rendering secrets. Helm does not make an insecure Kubernetes workload secure.

> **Module:** [11 — Helm](README.md) · Previous: [Lifecycle, hooks, migrations, and CRDs](03-lifecycle-hooks-crds.md) · Next: [Quick exercises](quick-exercises.md)
