# Disruption, Priority, and Autoscaling

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Placement, isolation, and topology](03-placement-topology.md) · Next: [Quick exercises](quick-exercises.md)

## Availability has several independent layers

A Deployment controls desired replicas and rollout behavior. Probes control
traffic readiness and container restart decisions. A PodDisruptionBudget (PDB)
limits concurrent **voluntary API-initiated evictions** for selected healthy
Pods. It does not protect against node loss, direct Pod deletion, application
failure, or every administrative action, and it creates no replica.

Use `minAvailable` when a minimum count must remain or `maxUnavailable` when a
bounded loss is easier to express. Rounding percentages can surprise small
replica sets. An impossible PDB can block drain indefinitely; a permissive PDB
can permit outage. Test node maintenance, rollout, and unhealthy-Pod behavior.

## Priority and preemption

PriorityClass influences scheduling queue order and eviction decisions.
Preemption may remove lower-priority Pods to make a pending higher-priority Pod
feasible, but it is not instantaneous and cannot solve constraints that remain
after victims disappear. PDBs are respected on a best-effort basis during
preemption. Misused high priority can starve the cluster.

CloudCart uses a non-preempting PriorityClass: its API can move ahead in the
queue without evicting lower-priority workloads. Reserve preempting classes for
carefully governed critical workloads; never make application classes
`globalDefault` casually.

## Horizontal Pod Autoscaling

The HPA periodically reads metrics, computes a desired replica ratio, applies
tolerance and missing/not-ready Pod rules, then respects configured behavior.
For CPU utilization, the denominator is requested CPU. Missing requests can
make the metric undefined; bad requests distort scaling. Metrics Server exposes
the resource metrics API for autoscaling and `kubectl top`, not a durable
monitoring or alerting system.

Set realistic min/max replicas, stabilization windows, and rate policies. Load
test scale-up speed, cold starts, downstream capacity, termination, and
scale-down safety. HPA changes replicas; it does not add nodes. If new Pods are
Pending, a node autoscaler may add capacity only when its simulation finds a
compatible node group. Hard affinity, untolerated taints, volume topology,
quotas, or a maximum node-group size can prevent scale-out.

## Coordinating control loops

Avoid control-loop conflict:

- HPA scales replicas from workload demand.
- VPA recommends or changes per-Pod requests.
- node autoscaling changes cluster capacity from unschedulable demand.
- PDB restricts voluntary eviction concurrency.
- rollouts replace Pods within Deployment strategy bounds.

Define signals, ownership, time constants, maximums, and failure behavior.
Capacity plans must cover simultaneous rollout surge, node loss, traffic burst,
system reservations, and stateful topology—not merely steady-state averages.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Placement, isolation, and topology](03-placement-topology.md) · Next: [Quick exercises](quick-exercises.md)
