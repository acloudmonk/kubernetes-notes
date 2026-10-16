# Interview Questions

> **Module:** [11 — Helm](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

Use claim → mechanism → tradeoff → evidence. Prefer an incident or chart example
over a list of commands.

## Model and rendering

### 1. What is the difference between a chart, release, and revision?

**Answer:** A chart is a versioned package of templates, defaults, schema, and
metadata. A release is an installation of a chart with a name, namespace, and
effective configuration. Each install, upgrade, or rollback produces release
history; a revision records that operation's rendered state and status.

### 2. Where does Helm stop and Kubernetes reconciliation begin?

**Answer:** Helm resolves values, renders and validates manifests, submits them,
and records release state. The API server admits and persists objects, while
Kubernetes controllers, scheduler, kubelets, and operators converge them.
`--wait` observes selected readiness conditions; Helm does not become the
controller for a Deployment or prove application correctness.

### 3. What does Helm store in a release record, and why can values be sensitive?

**Answer:** Release records contain chart and configuration information plus the
rendered manifest and status needed for history and rollback. Values supplied at
runtime can therefore be persisted in cluster release storage and exposed to
readers of it. Reference externally managed Secrets rather than passing secret
material through chart values or command lines.

### 4. How does values precedence work, and why can lists or `--set` be surprising?

**Answer:** Chart defaults are overridden by parent/dependency values, user files
in order, and then command-line setters. Maps merge by key but lists are commonly
replaced, not element-merged. `--set` parses types and dotted paths, so quoting,
commas, or leading zeroes can change meaning; prefer reviewed files and schema,
using `--set-string` only when appropriate.

### 5. Why treat `values.yaml` and its schema as a public API?

**Answer:** Users, automation, and environment overlays depend on value names,
types, defaults, and semantics across chart upgrades. A schema fails invalid
input early, documents constraints, and reduces template branching. Deprecate and
migrate value contracts deliberately; schema validation cannot validate every
cross-field, cluster, or application behavior.

### 6. How would you design helper templates without hiding resource behavior?

**Answer:** Centralize stable mechanical conventions such as names, labels, and
selector labels, with explicit inputs and deterministic output. Keep security,
resources, probes, lifecycle, and workload structure visible in their resource
templates. Deep abstraction makes rendered changes hard to review; rendered YAML
remains the operational truth.

### 7. What defects can lint, template, server dry run, and an ephemeral install detect?

**Answer:** Lint finds chart structure and some template/schema errors. Local
rendering exposes effective YAML but not live APIs. Server dry run adds discovery,
defaulting, schema, and admission without persistence. An ephemeral install adds
reconciliation, scheduling, hooks, dependencies, readiness, and behavioral tests.
Use layered checks because no single one proves production success.

## Lifecycle and data

### 8. What does `--wait --wait-for-jobs --rollback-on-failure` guarantee?

**Answer:** Helm waits up to its timeout for supported resource readiness and Job
completion, and on failure attempts a rollback of release-managed Kubernetes
resources. It does not prove user transactions, external dependencies, message
compatibility, data recovery, or rollback-safe migrations. Verify the application
and inspect the resulting release history.

### 9. Why is a Helm rollback a new revision, and what can it not reverse?

**Answer:** Rollback is another auditable release operation that reapplies an
earlier configuration as a new history entry. It cannot undo database mutations,
external side effects, consumed messages, manually changed unmanaged resources,
or deleted external data. Compatibility and compensating/recovery procedures must
be designed independently.

### 10. How would you deploy a breaking database schema change safely?

**Answer:** Avoid a one-step break. Use expand-and-contract: add compatible
schema, run an idempotent migration/backfill, deploy code compatible with both
forms, verify, then remove the old form later. Serialize migration ownership,
bound locks and runtime, and define recovery; Helm ordering is not transactional
with the database.

### 11. When would you choose an ordinary Job, a hook, or a separate migration pipeline?

**Answer:** Use an ordinary release resource when declarative visibility and
normal ownership are suitable. A hook provides lifecycle ordering but adds
special cleanup, rerun, and failure semantics. A separate pipeline fits tightly
controlled, long, privileged, or independently approved changes. In every case,
make the migration idempotent and observable.

### 12. Why does Helm not upgrade or delete CRDs automatically?

**Answer:** CRDs are cluster-scoped APIs shared by many releases; unsafe schema
replacement or deletion could break all custom resources or destroy data. Helm
installs missing CRDs from `crds/` conservatively but leaves later lifecycle to
an explicit owner. Plan compatible schema conversion, controller ordering,
backup, and multi-release coordination.

### 13. How do you handle a Kubernetes resource that existed before the release?

**Answer:** First identify its authoritative owner. Prefer referencing or
migrating it deliberately rather than forcing adoption. If supported ownership
metadata and adoption are used, compare the live and rendered object, protect
data and finalizers, test upgrade/uninstall behavior, and document the transfer;
two active managers create drift and deletion risk.

## Versioning, distribution, and security

### 14. Differentiate chart `version`, `appVersion`, image tag, and image digest.

**Answer:** Chart `version` identifies the package and follows chart release
semantics. `appVersion` is informational unless templates use it. An image tag is
a registry reference that may be mutable; a digest identifies exact content.
Record and promote the chart and image identities actually tested rather than
assuming these fields automatically synchronize.

### 15. How do dependency locks help, and what supply-chain risks remain?

**Answer:** A lock records resolved dependency versions and digests so builds can
retrieve the intended chart graph. It does not establish publisher trust, scan
templates or images, prevent registry compromise, or make dependencies available
forever. Pin, verify provenance where supported, mirror, review, scan, inventory,
and rebuild reproducibly.

### 16. How would you publish and promote a chart through an OCI registry?

**Answer:** Package a validated chart, authenticate to the registry, push the
immutable version, record its digest and provenance, and promote that exact
artifact through environments rather than rebuilding. Consumers should enforce
approved registries and identities and install by verified version or digest.
Registry retention and access controls are part of the release design.

### 17. How can a ConfigMap or Secret change trigger a Deployment rollout?

**Answer:** Render a deterministic checksum of the consumed configuration into a
Pod-template annotation. A content change alters `spec.template`, producing a new
ReplicaSet. This helps restart-based consumers but can expose secret-derived
hashes and creates no guarantee the new configuration is valid; combine it with
validation, readiness, and rollback-safe versioning.

### 18. Why should a chart reference rather than generate long-lived secrets?

**Answer:** Generated values can enter release records, rendered output, CI logs,
and upgrades, while rotation and recovery ownership become unclear. Prefer a
dedicated secret system or pre-created Secret interface with explicit lifecycle.
Local ephemeral labs may generate disposable credentials directly in the cluster,
but must label that choice as non-production.

## GitOps, troubleshooting, and selection

### 19. How does Helm differ when Flux or Argo CD is the operator?

**Answer:** The GitOps controller continuously reconciles declared source and
values, detects drift, and owns retries and status. Human CLI upgrades compete
with that desired state and may be reverted. Put changes through the controller's
source and use its suspension, rollback, secret, and health semantics; avoid two
authoritative writers for one release.

### 20. A release says `deployed`, but traffic fails. What is your diagnostic path?

**Answer:** `deployed` records Helm operation status, not user success. Inspect
effective values and manifest, workload rollout and Pods, readiness, Services and
EndpointSlices, Gateway/Ingress, policy, DNS, dependencies, and application
telemetry. Test the path layer by layer from a representative client and compare
with the previous revision.

### 21. An upgrade is stuck in a pending state. What evidence do you collect?

**Answer:** Preserve `helm status` and history, the operation timeout/context,
release storage, hook Jobs, events, workload conditions, API/admission errors,
and whether another manager is active. Determine if the original operation still
runs before editing release metadata. Repair the owned failure or safely roll
back; manual record changes are an exceptional last resort.

### 22. How do you test optional features and Kubernetes-version capabilities?

**Answer:** Build a matrix covering features enabled and disabled, supported API
versions, value types, and meaningful combinations. Render with explicit
capabilities, validate against real API servers, and perform ephemeral installs
for behavior. Ensure disabled features leave no dangling references and avoid
using semver checks where API discovery is the real contract.

### 23. When is Helm the wrong abstraction compared with Kustomize or an operator?

**Answer:** Kustomize can be clearer for a small set of patch-based environment
overlays without a distributable values API. An operator fits domain-specific,
continuous reconciliation and lifecycle beyond install/upgrade. Helm fits
packaging and parameterized releases but becomes harmful when templates emulate
a programming platform or when ongoing domain control loops are required.

### 24. What would make you trust a third-party chart in production?

**Answer:** Establish publisher and artifact identity, inspect templates and
defaults, pin chart and images, inventory dependencies/CRDs/hooks, scan and test
rendered workloads under policy, and review privileges, network, storage, secret,
upgrade, rollback, and uninstall behavior. Mirror approved artifacts and monitor
advisories. Popularity or a successful install is not a supply-chain assurance.

> **Module:** [11 — Helm](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
