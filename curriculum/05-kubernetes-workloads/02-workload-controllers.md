# Workload Controllers

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Pods and lifecycle](01-pods-and-lifecycle.md) · Next: [Configuration, probes, and resources](03-configuration-probes-resources.md)

Choose a controller from workload semantics:

| Resource | Use | Key behavior |
|---|---|---|
| Deployment | interchangeable long-running replicas | owns ReplicaSets; supports rolling update and rollback |
| StatefulSet | stable identity/order, commonly persistent state | ordinal identity and volume-claim templates; application must supply replication correctness |
| DaemonSet | one eligible Pod per node | node-local agents such as networking or log collection |
| Job | finite work | retries Pods until declared completion or failure |
| CronJob | scheduled Job creation | scheduling can be missed or duplicated; task must be idempotent |

Do not run a bare Pod for a service that needs repair. A Deployment selector is
effectively immutable and must match its Pod-template labels. Updating the
template creates a ReplicaSet revision; scaling alone does not.

RollingUpdate balances capacity and disruption using `maxSurge` and
`maxUnavailable`. Readiness controls whether a Pod counts as available, while
`minReadySeconds` can require stability. `progressDeadlineSeconds` reports a
stalled rollout; it does not automatically roll back. Revision history enables
rollback only when the previous ReplicaSet and image remain usable.

A Job migration must be compatible with concurrent old/new application
versions. Use expand → migrate/backfill → deploy → contract rather than a
destructive schema change coupled to every Pod startup. Set bounded retries and
deadlines, retain enough evidence, and make reruns safe.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Pods and lifecycle](01-pods-and-lifecycle.md) · Next: [Configuration, probes, and resources](03-configuration-probes-resources.md)
