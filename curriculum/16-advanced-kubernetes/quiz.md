# Knowledge Check

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

1. Does creating a CRD create reconciliation behavior?
2. What shows status describes the current spec?
3. Are watch events a durable exactly-once work queue?
4. Why should a controller avoid writing unchanged status?
5. Can an owner reference clean an external cloud resource?
6. What happens when a finalizer's controller is unavailable?
7. Does mesh namespace enrollment alone prove every request is encrypted?
8. Why should authorization use workload identity rather than Pod IP?
9. Can a mesh make an unsafe POST retry safe?
10. Does eBPF automatically make a network faster or more secure?
11. What is the main risk of independent HPA and node-scaler loops?
12. What business evidence must a fleet failover include?

---

## Answers

1. No; a controller supplies behavior.
2. `status.observedGeneration` matching `metadata.generation`, plus meaningful conditions.
3. No; they may be missed, duplicated, coalesced, or replayed, so reconcile level state.
4. It creates API load, watch churn, conflicts, and possible reconcile storms.
5. No; external cleanup normally needs idempotent controller logic and a finalizer.
6. The object remains deletion-marked and Terminating until the finalizer is completed or safely removed.
7. No; verify data-plane enrollment, peer identity, policy, path, and request evidence.
8. IPs are ephemeral routing attributes; ServiceAccount-derived identity expresses stable workload authority.
9. No; retries require application-level idempotency or another duplicate-safety mechanism.
10. No; outcome depends on hooks, programs, kernel support, policy, resources, and bypasses.
11. Delayed feedback can oscillate or amplify demand when requests/metrics/capacity are inconsistent.
12. Measured RPO/RTO and a valid transaction without stale authority or duplicate side effects.

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
