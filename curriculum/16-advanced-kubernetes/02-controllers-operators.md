# Controllers and Operators

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Custom APIs and API evolution](01-custom-apis-evolution.md) · Next: [Service mesh, identity, and traffic](03-service-mesh-identity-traffic.md)

A controller observes desired and actual state, computes a convergent action,
records status, and repeats. Events are hints, not a complete durable queue;
resync and retries must recover missed or duplicated notifications. Reconciliation
must be idempotent, level-based, safe under partial failure, and bounded by
backoff and rate limits.

Use caches/informers to avoid list storms, work queues to coalesce keys, and
resource versions for optimistic concurrency. Scope watches, RBAC, and writes.
Multiple replicas require leader election or idempotent concurrent behavior.
Expose queue depth, reconcile duration/results, API errors, work age, and object
conditions without high-cardinality object labels.

An operator encodes domain lifecycle knowledge: provisioning, configuration,
upgrade, backup, failover, repair, and deletion. Maturity is evidence, not the
number of automated actions. Evaluate upgrade compatibility, data safety,
ownership conflicts, privilege, CRD backup/restore, support, release cadence,
escape paths, and what happens when the operator is absent.

Status should report useful truth, not optimism. Set `observedGeneration` only
after processing that generation. Distinguish progressing, ready, degraded, and
terminal conditions. Never hide repeated errors behind Ready=True.

The lab deliberately uses polling and the raw API to expose mechanics. Production
controllers normally use generated clients, shared informers, queues, leader
election, structured events, metrics, tests, and safe upgrade/version machinery.

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Custom APIs and API evolution](01-custom-apis-evolution.md) · Next: [Service mesh, identity, and traffic](03-service-mesh-identity-traffic.md)
