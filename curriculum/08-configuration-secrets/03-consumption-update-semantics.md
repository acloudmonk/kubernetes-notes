# Consumption and Update Semantics

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Secrets, threat model, and cluster controls](02-secrets-threat-model.md) · Next: [External stores and rotation](04-external-stores-rotation.md)

## Environment variables

`env` maps explicit keys and supports required-key validation; `envFrom` imports
an entire object and increases coupling/exposure. Values are fixed when the
container starts. Updating the source object does not mutate a process
environment, so restart/reload orchestration is required. Environment variables
can appear in crash reports, diagnostics, child processes, and process inspection;
never log a full environment.

A missing non-optional Secret/ConfigMap or key prevents container creation and
typically shows `CreateContainerConfigError` plus kubelet events. `optional: true`
can avoid startup failure but shifts absence handling into the application; use
it only when a documented safe behavior exists.

## Volume projection

ConfigMap and Secret volumes present keys as files, allowing key selection,
paths, and file modes. Kubelet updates normal projections eventually based on
its change-detection strategy and sync interval. Applications must reopen/watch
files correctly. A `subPath` mount does not receive automatic updates.

Updates are implemented through atomically switched data directories/symlinks;
watching only a file inode can miss replacement. Validate a complete generation
before activation. File mode, container UID/GID, `fsGroup`, read-only mounts,
and image behavior determine actual access. YAML numeric modes are octal; JSON
represents them as decimal.

Projected volumes can combine ConfigMap, Secret, downward API, service-account
token, and cluster trust bundle sources into one tree. Bound service-account
token projections are audience-scoped and time-limited; applications must
reload them. Do not replace workload identity with long-lived token Secrets.

## Immutable objects and versioning

`immutable: true` prevents changes to data and reduces kubelet watch load at
large scale. It cannot be reversed; replace the object/name and recreate Pods.
Immutability protects against accidental mutation but not read access or deletion.

Versioned names make rollout/rollback explicit and work well with GitOps, but
require garbage collection and references that change with each version.
Mutable names simplify references but require coordination to avoid mixed
generations. Atomic multi-value changes should be one version/object rather than
independent key updates when consumers need consistency.

## Rollout evidence

Prove source resourceVersion/generation, Pod template change, old/new Pod UIDs,
consumer-observed version (never secret value), readiness, error rate, backend
authentication, and business transaction. A successful `kubectl apply` proves
only API acceptance; a successful rollout does not prove an external credential
was changed or old access was revoked.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Secrets, threat model, and cluster controls](02-secrets-threat-model.md) · Next: [External stores and rotation](04-external-stores-rotation.md)
