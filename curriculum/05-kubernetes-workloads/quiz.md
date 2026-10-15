# Knowledge Check

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

1. Which change creates a Deployment revision: scaling replicas or changing its Pod template?
2. Does readiness failure restart a container?
3. What survives a container restart but not Pod replacement?
4. Why can a Running Pod be absent from Service endpoints?
5. What happens when liveness depends on an unavailable shared database?
6. Which value drives scheduler capacity: live CPU use, request, or limit?
7. Why must a migration Job be idempotent?
8. Does `progressDeadlineSeconds` automatically roll back?
9. What evidence distinguishes CrashLoop from image-pull failure?
10. Why does a ConfigMap environment update not alter a running process?

---

## Answers

1. A Pod-template change; scaling does not create a revision.
2. No. It removes ready endpoint membership; liveness/startup failures restart.
3. An `emptyDir` volume in the same Pod.
4. Readiness can be false, selectors may not match, ports can be wrong, or it may be terminating.
5. Every client can restart during one dependency outage, amplifying failure.
6. Requests drive scheduling; limits constrain runtime; utilization is separate evidence.
7. Controllers/retries/timeouts can execute it again or partially complete it.
8. No; it marks the rollout failed/stalled for an operator or automation to act.
9. Container waiting reason and Events show pull failure; CrashLoop has terminated exit state, restart count, and previous logs.
10. Environment is captured at process start; trigger a controlled rollout after configuration change.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
