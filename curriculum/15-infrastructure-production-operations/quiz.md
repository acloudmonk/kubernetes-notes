# Knowledge Check

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

1. Is Terraform state the desired configuration?
2. Does marking an output sensitive keep its value out of state?
3. Why should production applies have one serialized authority?
4. Does a managed control plane make the provider responsible for workloads?
5. What capacity must a zone-loss model include besides steady-state requests?
6. Can a PDB prevent an involuntary node failure?
7. Why can CPU utilization look low while Pods remain Pending?
8. Is the cheapest steady-state node count necessarily cost-optimal?
9. What must be checked before removing a Kubernetes API version?
10. Does a successful backup job prove RTO?
11. What is the first goal during an incident?
12. What turns a postmortem action into evidence of improvement?

---

## Answers

1. No; configuration declares intent, while state maps that intent to remote identities and cached attributes.
2. No; `sensitive` redacts presentation but values can remain in state.
3. To prevent conflicting plans/writes and ensure every apply starts from the current state.
4. No; responsibility varies, but workload operation and business outcomes remain the customer's.
5. System overhead, rollout surge, remaining-zone rescheduling, scaling delay, and storage/network/provider limits.
6. No; it constrains cooperative voluntary evictions only.
7. Requests, quota, topology, affinity, volumes, or node-pool limits—not current CPU—may block scheduling.
8. No; insufficient headroom can increase outage, rollout, and recovery cost.
9. Stored objects, manifests, clients, webhooks, operators, add-ons, and migration/rollback behavior.
10. No; only a timed, validated restore demonstrates achieved recovery behavior.
11. Stabilize customer impact safely while establishing command and preserving evidence.
12. An owner completes it and a test or operational metric verifies the control works.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
