# Admission Policy and Multi-Tenancy

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Workload, node, and runtime security](03-workload-runtime-security.md) · Next: [Quick exercises](quick-exercises.md)

## Admission is a production dependency

Admission runs after authorization on eligible writes. Built-in controllers
handle concerns such as Pod Security and ResourceQuota. Stable
ValidatingAdmissionPolicy executes CEL in-process without a webhook service.
Its policy defines logic; bindings select scope, parameters, and Deny/Warn/Audit
actions. Use explicit match rules and namespace/object selectors, test create and
update, and inspect type-check warnings.

`failurePolicy: Fail` protects the boundary when evaluation errors but can block
deployments if policy is wrong. `Ignore` favors availability but can fail open.
Roll out new rules through offline tests, dry-run/server validation, Audit/Warn,
limited namespaces, measured denial telemetry, then Deny. Maintain break-glass,
versioning, owner, rollback, and bootstrap/recovery design.

Webhooks or policy engines such as Kyverno and OPA Gatekeeper remain useful for
mutation, generated resources, inventory/background evaluation, reporting,
external data, reusable libraries, or broader workflows. They add certificates,
networking, availability, ordering, upgrade, and failure-policy dependencies.
Choose from requirements, not fashion. Never let a webhook call an unreliable
external service on every cluster write without explicit failure design.

The lab’s CEL rule rejects explicit `:latest` only in a labeled namespace. That
teaches scoping and evidence; it is not supply-chain verification and does not
reject every mutable reference form.

## Multi-tenant boundaries

A namespace scopes names and many policies; it is not a complete security
boundary. A shared-cluster tenant design combines:

- external identity, namespace-scoped RBAC, and controlled delegation;
- Pod Security/admission, quota, LimitRange, and API-rate protections;
- default-deny ingress/egress with explicit DNS and dependency paths;
- storage classes, snapshots/backups, encryption keys, and Secret isolation;
- node pools, taints/affinity, runtime isolation, and noisy-neighbor controls;
- observability redaction, tenant-aware logs/metrics, audit, and incident ownership.

Namespace sharing is usually appropriate for trusted internal teams with
policy guardrails. Virtual control planes add API isolation but still require
data-plane design. Dedicated clusters give a stronger blast-radius and lifecycle
boundary at greater operational cost. Regulatory, hostile-code, kernel-risk,
custom-control-plane, and independent-upgrade needs often push toward stronger
separation.

## Audit and governance

Kubernetes audit policy chooses events, stages, resources, and metadata/body
detail. Avoid recording Secret bodies and authentication material. Send logs to
protected remote storage, control reader access, define retention, detect gaps,
and correlate principal, source, object, decision, admission annotations, and
cloud/runtime evidence. Audit without review and response is only storage cost.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Workload, node, and runtime security](03-workload-runtime-security.md) · Next: [Quick exercises](quick-exercises.md)
