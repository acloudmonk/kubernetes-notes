# Quick Exercises

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Disruption, priority, and autoscaling](04-disruption-autoscaling.md) · Next: [Lab 1 — Place and protect CloudCart](labs/01-place-protect.md)

1. A node has 4 CPU allocatable and existing requests of 3500m. Explain why a
   600m-request Pod stays Pending while `kubectl top node` shows 20% use.
2. Predict the QoS class when memory request equals limit but CPU request is
   smaller than CPU limit. Verify with a disposable Pod.
3. Draw the feasible-node intersection for required zone affinity, a dedicated
   taint, and a zonal PVC. Identify which change would weaken correctness.
4. For three replicas across two zones, calculate possible skew for
   `maxSkew: 1`. Compare `DoNotSchedule` with `ScheduleAnyway` during zone loss.
5. Explain why a toleration without affinity can place a Pod on ordinary nodes.
6. Given current CPU utilization 90%, target 60%, and two replicas, estimate
   the raw HPA recommendation before tolerance and behavior policies.
7. Design a drain test for a two-replica API with `minAvailable: 1`; list what
   the PDB proves and what it cannot prove.
8. Separate evidence for cgroup OOM, node-pressure eviction, probe restart, and
   application exit. Name the fields/events you would inspect first.

Record predictions before commands, then explain any difference from observed
behavior. Delete only the named disposable resources.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Disruption, priority, and autoscaling](04-disruption-autoscaling.md) · Next: [Lab 1 — Place and protect CloudCart](labs/01-place-protect.md)
