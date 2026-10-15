# Services, EndpointSlices, and DNS

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Network model and packet paths](01-network-model-packet-paths.md) · Next: [Gateway API, ingress, and TLS](03-gateway-ingress-tls.md)

A selector-based Service is stable discovery and a virtual frontend over ready
backends. The EndpointSlice controller maps matching Pods and named target ports
into scalable slices. Check Service selector, Pod labels, target port, endpoint
conditions, and address family before blaming the network.

- ClusterIP: internal virtual IP and DNS; default.
- headless (`clusterIP: None`): DNS returns endpoint addresses; client handles selection.
- NodePort: exposes a node port; often an implementation building block.
- LoadBalancer: requests external infrastructure from an implementation/provider.
- ExternalName: DNS CNAME only; no proxy and subject to protocol/TLS naming issues.

CoreDNS watches the API and serves names. A normal Service commonly resolves as
`service.namespace.svc.cluster.local`; search domains allow a short name in the
same namespace. `dnsPolicy`, `/etc/resolv.conf`, `ndots`, upstream forwarding,
negative caching, and query volume affect results. DNS success proves only name
resolution—not endpoints, policy, listening process, or application health.

Service data planes watch Services and EndpointSlices and program node behavior,
commonly via kube-proxy or a CNI replacement. ClusterIP is usually not a process
listening on that address. Session affinity and topology preferences are routing
hints/tradeoffs, not substitutes for application state design.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Network model and packet paths](01-network-model-packet-paths.md) · Next: [Gateway API, ingress, and TLS](03-gateway-ingress-tls.md)
