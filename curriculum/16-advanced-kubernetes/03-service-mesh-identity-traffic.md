# Service Mesh, Identity, and Traffic

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Controllers and operators](02-controllers-operators.md) · Next: [eBPF, policy, and advanced scaling](04-ebpf-policy-scaling.md)

A service mesh moves transport identity, encryption, authorization, telemetry,
and selected traffic behavior into a shared data plane controlled by a control
plane. It does not fix application authorization, data classification, unsafe
retries, schema compatibility, or dependency architecture.

Sidecar mode places a proxy beside each workload. Ambient mode uses node-level
secure tunnels for Layer 4 and optional waypoint proxies for Layer 7. Compare
isolation, resource attribution, upgrade blast radius, protocol visibility,
latency, debugging, node privilege, and feature maturity—not proxy count alone.

mTLS provides authenticated encrypted transport when both endpoints participate
and trust the issuing roots. Authorization policy must use stable workload
identity and least-privilege defaults. Verify actual peer identity and policy
enforcement; a namespace label or “strict” setting is not evidence by itself.

Retries multiply load and must be limited to safe, idempotent operations with a
shared deadline and retry budget. Timeouts exist at application, proxy, gateway,
and client layers. Traffic shifting and mirroring require measurable acceptance,
privacy controls, and rollback. Mesh telemetry adds CPU, memory, cardinality,
retention, and control-plane dependencies.

Operate certificate lifetime/rotation, trust-domain migration, policy rollout,
control/data-plane skew, CNI/ztunnel or injection failures, egress, and emergency
bypass. Prefer ordinary NetworkPolicy and application libraries when mesh value
does not exceed this permanent platform cost.

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Controllers and operators](02-controllers-operators.md) · Next: [eBPF, policy, and advanced scaling](04-ebpf-policy-scaling.md)
