# eBPF, Policy, and Advanced Scaling

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Service mesh, identity, and traffic](03-service-mesh-identity-traffic.md) · Next: [Multi-cluster and ecosystem decisions](05-multicluster-ecosystem.md)

eBPF programs run in verified kernel hooks and can implement networking,
observability, and security with rich kernel context. Kubernetes products may
replace kube-proxy, enforce policy, trace syscalls, or accelerate paths, but
“uses eBPF” is not an outcome. Verify kernel/runtime support, verifier limits,
map pressure, fallback behavior, privileges, upgrade safety, and evidence when
traffic bypasses the expected hook.

Policy engines add expressive admission and audit beyond built-ins. Start in
audit/warn, scope exceptions with owner and expiry, test old and new API shapes,
measure latency/availability, and promote gradually. Do not deploy overlapping
writers or policies without an authoritative ownership model.

HPA, VPA, node autoscaling, and event-driven scaling form delayed feedback loops.
Combining them requires request quality, ownership of each dimension, stabilization,
capacity limits, disruption controls, and dependency ceilings. Scaling replicas
cannot repair a saturated database, serialized lock, exhausted IP range, or API
quota. Predict cost and failure behavior before enabling automated actuation.

Advanced ecosystem choices should pass a capability test: concrete requirement,
measurable benefit, supported baseline, least privilege, failure containment,
upgrade/recovery plan, operational owner, total cost, and exit/migration path.
Avoid stacking overlapping platforms because each demo looks attractive.

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Service mesh, identity, and traffic](03-service-mesh-identity-traffic.md) · Next: [Multi-cluster and ecosystem decisions](05-multicluster-ecosystem.md)
