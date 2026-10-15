# Interview Questions

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

1. Trace a Pod from API creation through scheduler binding and kubelet startup.
2. Why can a Pod be unschedulable when node CPU usage is low?
3. How are app-container, init-container, and Pod-overhead requests accounted?
4. Compare CPU request, CPU limit, memory request, and memory limit enforcement.
5. Derive all three QoS classes. How does QoS differ from PriorityClass?
6. Compare nodeSelector, node affinity, Pod anti-affinity, and topology spread.
7. Why does a toleration not guarantee placement on a tainted node?
8. What can make two individually valid required placement rules contradictory?
9. How does `WaitForFirstConsumer` connect storage and scheduling?
10. What does a PDB protect, and which common disruptions bypass it?
11. Explain preemption and why it might not make a high-priority Pod schedulable.
12. Derive HPA CPU utilization and explain the role of CPU requests.
13. How do HPA, VPA, and node autoscaling interact or conflict?
14. Diagnose `OOMKilled` versus node-pressure `Evicted` versus probe restart.
15. Design capacity for one-node loss plus rolling-update surge.

Strong answers state the responsible component, API contract, evidence, edge
cases, production tradeoff, and a safe validation—not merely a command.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
