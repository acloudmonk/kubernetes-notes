# Interview Questions

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

1. **[Fundamental] Why not deploy bare Pods?** Controllers replace and scale
   Pods toward durable desired state; a bare Pod has no workload-level repair.
2. **[Implementation] Readiness versus liveness?** Readiness gates traffic;
   liveness restarts a container. A shared dependency belongs in readiness, not
   liveness, unless restart genuinely repairs the problem.
3. **[Internals] Deployment update path?** Template change creates a new
   ReplicaSet; old/new sets scale within surge/unavailable bounds; readiness and
   availability determine progress. Kubernetes reports stalls but does not
   automatically undo them.
4. **[Architecture] Deployment or StatefulSet?** Choose from identity, ordering,
   storage, and application replication semantics—not simply “has a database.”
5. **[Production] How set resources?** Measure normal/peak use, account for
   startup and headroom, set requests for placement/capacity and limits with
   throttling/OOM consequences, then revise from telemetry.
6. **[Security] Is a Secret encrypted?** Not necessarily; base64 is encoding.
   Protect etcd, RBAC, Pod creation, delivery, logs, backups, and rotation.
7. **[Troubleshooting] Pod Running but Service empty?** Inspect readiness,
   selector/labels, named `targetPort`, EndpointSlices, and terminating state.
8. **[Senior] How deploy schema change?** Expand compatible schema, migrate/
   backfill idempotently, deploy compatible code, verify, then contract later.
9. **[Internals] Container restart versus Pod replacement?** Kubelet restart
   policy restarts containers in one Pod UID; controllers create replacement
   Pods with new UIDs when workload desired state requires it.
10. **[Production] What proves rollback safety?** Immutable prior image,
    retained revision, backward-compatible configuration/schema, tested rollback
    procedure, and post-rollback user-level verification.

For each answer add mechanism, observable evidence, tradeoff, common mistake,
and one follow-up question.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
