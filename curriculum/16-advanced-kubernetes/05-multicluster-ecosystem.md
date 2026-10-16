# Multi-cluster and Ecosystem Decisions

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [eBPF, policy, and advanced scaling](04-ebpf-policy-scaling.md) · Next: [Quick exercises](quick-exercises.md)

Multiple clusters can reduce some blast radii, meet geography/regulation, or
separate trust and lifecycle. They multiply control planes, identity, policy,
networking, GitOps, observability, upgrades, capacity, cost, and incident paths.
Use namespaces or node pools when they satisfy the actual boundary.

Choose topology deliberately: independent regional clusters, hub-and-spoke fleet
management, active/passive recovery, or active/active serving. Define cluster
identity, workload identity, configuration source, secret delivery, discovery,
traffic steering, data authority, consistency, and ownership. Avoid direct
cross-cluster calls unless latency, partial failure, retries, and dependency
cycles are understood.

Failover has separate layers: infrastructure capacity, platform readiness,
desired state, secrets/keys, data recovery or replication, dependency access,
traffic shift, client caching, and side-effect fencing. A healthy standby API is
not recovery proof. Rehearse under realistic DNS TTLs, quotas, data lag, and
operator access; measure RPO/RTO and a business transaction.

Fleet policy must expose drift without creating an omnipotent single point of
failure. Separate global invariants from cluster-specific configuration, stage
rollouts, preserve local emergency control, and audit authority. Aggregate
telemetry with tenant/region context while retaining a path to diagnose a
cluster when the central plane is unavailable.

Treat portability as tested interfaces and recovery procedures, not identical
YAML. Storage, identity, load balancing, CNI, CSI, and managed-service semantics
remain provider-specific.

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [eBPF, policy, and advanced scaling](04-ebpf-policy-scaling.md) · Next: [Quick exercises](quick-exercises.md)
