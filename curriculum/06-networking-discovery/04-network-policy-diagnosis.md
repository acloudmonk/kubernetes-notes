# NetworkPolicy and Diagnosis

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Gateway API, ingress, and TLS](03-gateway-ingress-tls.md) · Next: [Quick exercises](quick-exercises.md)

NetworkPolicy is additive allow-listing at L3/L4. A Pod becomes isolated for a
direction when any policy selecting it declares that direction; allowed traffic
is the union of applicable rules. Both source egress and destination ingress
must allow a connection when both are isolated. Empty selectors, combined
namespace/pod selectors, YAML list indentation, ports, and IP-block behavior are
common sources of over- or under-permission.

Begin a namespace with default-deny ingress and egress, then permit DNS and each
documented application edge. Allowing DNS to any address on port 53 is broader
than selecting CoreDNS. Policy controls IP/port, not HTTP paths or identities,
and cannot secure traffic before a plugin enforces it.

Diagnose in layers:

1. resolve the exact name and inspect Pod resolver configuration/CoreDNS;
2. inspect Service, EndpointSlices, readiness, ports, and address family;
3. test the endpoint IP and Service separately from a representative source;
4. list policies selecting both source and destination and compute their union;
5. inspect CNI/service-proxy/Gateway evidence only after narrowing the hop;
6. distinguish transport from HTTP route/backend status and application response.

Ephemeral debug containers and test Pods inherit namespace policy and may need
explicit permission. Do not “fix” diagnosis by permanently allowing all traffic.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Gateway API, ingress, and TLS](03-gateway-ingress-tls.md) · Next: [Quick exercises](quick-exercises.md)
