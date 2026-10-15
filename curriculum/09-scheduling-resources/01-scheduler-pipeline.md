# Scheduler Pipeline and Resource Accounting

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Module overview](README.md) · Next: [Requests, limits, QoS, and pressure](02-resources-qos-pressure.md)

## Ownership and sequence

The API server stores a Pod without `spec.nodeName`. The scheduler watches such
Pods, chooses a feasible node, and records a binding. The kubelet on that node
then performs admission and starts containers through the runtime. Scheduling
success therefore does not guarantee image pull, mount, sandbox, probe, or
application success.

A scheduling cycle broadly performs queue sorting, pre-filter/filter,
post-filter when no node is feasible, scoring and normalization, reserve,
permit, pre-bind, and bind. Framework plugins implement these extension points;
profiles can select plugins and weights. Binding and asynchronous work run in a
separate binding cycle so the scheduler can continue considering other Pods.

Use events and scheduler logs to identify the failed stage. `Pending` is only a
phase: a Pod may be unscheduled, waiting for an image, or blocked by init work.
Check `spec.nodeName`, conditions, container states, and ordered events before
changing anything.

## What the scheduler accounts

For normal containers, the scheduler sums requests. For init containers, it
uses the maximum relevant init request rather than summing sequential work, and
combines that with app-container demand according to Kubernetes' effective Pod
request rules. Pod overhead can add sandbox/runtime cost. Extended resources
are integer, non-overcommittable requests. The scheduler compares these values
with node **allocatable** and already requested capacity—not live CPU or memory
usage.

Consequences:

- a quiet Pod with a large request still occupies schedulable capacity;
- a busy Pod with no CPU request appears free to the scheduler;
- `kubectl top` cannot explain the original placement decision by itself;
- changing requests changes the Pod template and normally replaces Pods;
- daemon, system, and eviction reservations reduce what workloads may use.

CPU is expressed in cores or millicores (`250m` = 0.25 CPU). Memory uses bytes;
prefer binary units such as `Mi` and `Gi`. `400m` memory means 0.4 bytes, a
classic typo. Inspect both `status.capacity` and `status.allocatable`, then sum
requests per node with `kubectl describe node` or structured API queries.

## Feasibility before preference

Filter plugins eliminate nodes for insufficient resources, unmatched required
affinity, untolerated taints, volume topology, ports, or other hard constraints.
Score plugins rank only the survivors. A high preferred-affinity weight cannot
rescue a node rejected by a hard predicate. When no node remains, the Pod stays
unscheduled; post-filter plugins may attempt preemption, but adding capacity or
fixing a contradictory constraint may be the correct response.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Module overview](README.md) · Next: [Requests, limits, QoS, and pressure](02-resources-qos-pressure.md)
