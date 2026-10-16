# Capacity, Availability, Tenancy, and Cost

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Managed Kubernetes platform design](02-managed-kubernetes-platform.md) · Next: [Upgrades, recovery, and incident operations](04-upgrades-recovery-incidents.md)

Capacity planning begins with demand distributions and failure scenarios, not
average utilization. Model requests, limits, daemon overhead, system reserve,
startup surges, rollout surge, pending work, storage/network ceilings, zone
loss, node drains, and provider quotas. Keep measured headroom for both growth
and recovery; unused capacity can be an availability control.

## Scaling loops

- HPA changes workload replicas from metrics and configured targets.
- VPA recommends or changes Pod requests, often requiring recreation.
- Node autoscaling changes data-plane capacity when Pods are unschedulable or
  nodes are safely removable.
- Event-driven scaling maps queue or external demand to replicas.

These are delayed feedback loops. Requests connect workload and node scaling;
bad requests create waste or unschedulable bursts. Test stabilization, cooldown,
quota, PDB, topology, storage attachment, image-pull, and cold-start behavior.
Autoscaling does not repair an overloaded database or a hard service quota.

## Availability is end to end

Spread replicas across real failure domains, but verify there is capacity to
reschedule after losing one. PDBs constrain supported voluntary eviction only;
they do not prevent crashes, node loss, force deletion, or application errors.
Readiness protects routing, not data integrity. Stateful systems also need
replication, quorum, fencing, backup, and restoration.

## Tenancy and fairness

Namespaces, RBAC, quotas, LimitRanges, network policy, admission, priority,
storage classes, and workload identity create governance layers. They do not
turn a shared kernel or control plane into a hostile-tenant boundary. Define
who owns namespace creation, quota changes, privileged exceptions, audit review,
and charge allocation.

## Cost as an engineering signal

Allocate shared and direct costs using stable ownership metadata. Track request
cost, actual utilization, idle/headroom, storage snapshots and IOPS, network
egress, load balancers, observability ingestion/retention, control planes, and
support. Spot or interruptible capacity fits disruption-tolerant workloads only.
Optimize against SLO and recovery risk: the cheapest steady state may be unable
to roll out or survive failure.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Managed Kubernetes platform design](02-managed-kubernetes-platform.md) · Next: [Upgrades, recovery, and incident operations](04-upgrades-recovery-incidents.md)
