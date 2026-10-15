# ADR 0007: Treat workload placement and capacity as measured policy

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

CloudCart needs predictable availability and cost across failure domains.
Requests, placement, disruption budgets, priority, and autoscaling affect one
another; copying local lab values into production would encode unmeasured
assumptions and can make workloads unschedulable or overload dependencies.

## Decision

Every production workload declares evidence-based CPU, memory, and ephemeral
storage requests. Limits are chosen per resource and workload behavior after
load testing rather than applied as a universal ratio. Required placement is
reserved for correctness, compliance, hardware, or isolation; availability
preferences use topology spread or preferred affinity with defined degraded
behavior.

Replicated request-serving components receive tested disruption budgets and
bounded HPA behavior. PriorityClasses are few, governed, non-global by default,
and preempt only where business criticality justifies starvation risk. Capacity
planning includes rollout surge, one failure domain loss, system reservations,
storage topology, downstream ceilings, and node-autoscaler limits.

The local Module 09 values exist to expose mechanisms and are not production
recommendations.

## Consequences

Teams must collect workload and SLO evidence, revisit settings as behavior
changes, and test interactions among rollout, HPA, PDB, storage, and cluster
capacity. This adds operational work but makes tradeoffs reviewable and avoids
false precision from generic defaults.

## Validation

- Load-test normal, burst, startup, dependency-degraded, and recovery paths.
- Prove placement during a failure-domain loss and rolling update.
- Exercise voluntary drain, involuntary node loss, metrics outage, HPA bounds,
  and maximum node-group capacity.
- Track saturation, throttling, OOM/eviction, Pending duration, SLOs, replica
  changes, headroom, and cost; roll back policy changes that regress them.
