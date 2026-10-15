# Independent Challenge

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Cumulative exercise](cumulative-exercise.md) · Next: [Troubleshooting](troubleshooting.md)

Deploy two namespaces: a client and an HTTP API with two ready replicas. Add a
Service, Gateway/HTTPRoute, default-deny ingress/egress, specific DNS permission,
and only the required cross-namespace client path. Deny an unlabeled client.

Prove short and fully qualified DNS, EndpointSlice readiness, Gateway route
conditions, allowed and denied connections, and recovery from a wrong port,
selector, DNS policy, and NetworkPolicy selector. Include a packet-path diagram,
policy matrix, versioned manifests, and exact cleanup. Do not copy CloudCart
names or grant namespace-wide allow-all access.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Cumulative exercise](cumulative-exercise.md) · Next: [Troubleshooting](troubleshooting.md)
