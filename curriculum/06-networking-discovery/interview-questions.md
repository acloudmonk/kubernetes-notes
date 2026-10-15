# Interview Questions

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

1. **[Fundamental] What does the Kubernetes network model require?** Pods have
   unique cluster addresses and communicate without application-managed NAT;
   implementations supply interfaces, routes, and policy.
2. **[Internals] Trace Service traffic.** DNS returns a ClusterIP; a service
   data plane programmed from Service/EndpointSlice state selects a ready
   backend. ClusterIP is generally not a listening process.
3. **[Troubleshooting] DNS works but request times out.** Inspect endpoints,
   target port, both policy directions, representative source path, and backend.
4. **[Implementation] Headless versus ClusterIP?** Headless DNS returns endpoint
   addresses and delegates selection; ClusterIP provides a virtual frontend.
5. **[Security] How do policies combine?** Isolation begins per direction;
   applicable allows are unioned, and isolated source/destination directions
   must both permit the flow.
6. **[Architecture] Ingress versus Gateway API?** Gateway API provides explicit
   infrastructure/application roles, typed routes, attachment, and status;
   Ingress is simpler and widely supported but annotation-heavy.
7. **[Production] Where terminate TLS?** State client-to-proxy and proxy-to-
   backend trust separately, including certificate ownership and rotation.
8. **[Senior] Why can policy YAML exist without protection?** Enforcement is
   supplied by the network implementation, not the API server.
9. **[Internals] EndpointSlice versus Endpoints?** Slices scale updates and carry
   richer readiness/topology/address-family data; legacy Endpoints is deprecated.
10. **[Troubleshooting] Gateway route Accepted but 503?** Attachment is valid;
    inspect ResolvedRefs, Service port, ready EndpointSlices, policy, and backend.

Extend every response with mechanism, evidence, tradeoff, common mistake, and follow-up.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
