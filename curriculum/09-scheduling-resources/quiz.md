# Knowledge Check

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

1. Does the scheduler use current CPU usage to decide basic resource fit?
2. Can preferred affinity make a node pass a failed required rule?
3. Does a toleration select a tainted node?
4. Does a PDB prevent direct Pod deletion or node failure?
5. What happens when a container exceeds a CPU limit versus a memory limit?
6. Can a Guaranteed Pod be killed?
7. Why can HPA CPU utilization be undefined?
8. Does HPA add cluster nodes?
9. Does `requiredDuringSchedulingIgnoredDuringExecution` evict after label drift?
10. Why might adding a node in another zone not help a stateful Pending Pod?
11. Does PriorityClass equal QoS class?
12. What first proves a Pending Pod has never been scheduled?

---

## Answers

1. No. It compares requests and constraints with allocatable/committed capacity.
2. No. Scoring happens only after hard filtering.
3. No. It permits placement; selection needs other policy or scoring.
4. No. It constrains supported voluntary evictions.
5. CPU is throttled; memory excess can cause an OOM kill.
6. Yes—by its cgroup limit, node failure, eviction, deletion, or other causes.
7. Resource-utilization HPA needs relevant requests and available metrics.
8. No. A separate node autoscaler may react to compatible unschedulable Pods.
9. Normally no; “IgnoredDuringExecution” describes that behavior.
10. Its bound volume or provisioning topology may require a specific zone/node.
11. No. They are independent scheduling/eviction and resource classifications.
12. Empty `spec.nodeName` plus `PodScheduled=False` and scheduler events.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
