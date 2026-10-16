# Workload Controllers

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Pods and lifecycle](01-pods-and-lifecycle.md) · Next: [Configuration, probes, and resources](03-configuration-probes-resources.md)

## Controller selection

Choose a controller from workload semantics:

| Resource | Use | Key behavior |
|---|---|---|
| Deployment | interchangeable long-running replicas | owns ReplicaSets; supports rolling update and rollback |
| StatefulSet | stable identity/order, commonly persistent state | ordinal identity and volume-claim templates; application must supply replication correctness |
| DaemonSet | one eligible Pod per node | node-local agents such as networking or log collection |
| Job | finite work | retries Pods until declared completion or failure |
| CronJob | scheduled Job creation | scheduling can be missed or duplicated; task must be idempotent |

Controllers reconcile current objects toward desired state. Ownership references
and selectors connect controllers to their dependents; labels alone do not prove
ownership. Repair is eventual, so temporary extra or missing Pods can exist while
controllers converge.

## Deployments and ReplicaSets

Do not run a bare Pod for a service that needs repair. A Deployment selector is
effectively immutable and must match its Pod-template labels. Updating the
template creates a ReplicaSet revision; scaling alone does not.

RollingUpdate balances capacity and disruption using `maxSurge` and
`maxUnavailable`. Readiness controls whether a Pod counts as available, while
`minReadySeconds` can require stability. `progressDeadlineSeconds` reports a
stalled rollout; it does not automatically roll back. Revision history enables
rollback only when the previous ReplicaSet and image remain usable.

Deployment strategy values are capacity and availability policy. Percentages are
rounded according to the field and can behave unexpectedly for small replica
counts. A rollout can also be blocked by quota, placement, image, admission,
probes, or termination—not only faulty application code.

## StatefulSets and DaemonSets

StatefulSets provide ordinal identity, ordered operations, and claim templates;
they do not implement replication, consensus, or backup. DaemonSets track
eligible nodes and are appropriate for node-local functions, but tolerations,
priority, update strategy, and resource cost must account for node bootstrap and
pressure.

## Jobs and scheduled work

A Job migration must be compatible with concurrent old/new application
versions. Use expand → migrate/backfill → deploy → contract rather than a
destructive schema change coupled to every Pod startup. Set bounded retries and
deadlines, retain enough evidence, and make reruns safe.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Pods and lifecycle](01-pods-and-lifecycle.md) · Next: [Configuration, probes, and resources](03-configuration-probes-resources.md)
