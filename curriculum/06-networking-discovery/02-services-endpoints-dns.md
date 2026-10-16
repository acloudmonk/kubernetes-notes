# Services, EndpointSlices, and DNS

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Network model and packet paths](01-network-model-packet-paths.md) · Next: [Gateway API, ingress, and TLS](03-gateway-ingress-tls.md)

## Services and EndpointSlices

A selector-based Service is stable discovery and a virtual frontend over ready
backends. The EndpointSlice controller maps matching Pods and named target ports
into scalable slices. Check Service selector, Pod labels, target port, endpoint
conditions, and address family before blaming the network.

EndpointSlice conditions distinguish ready, serving, and terminating endpoints.
Consumers decide how to use them, so graceful termination is not a single atomic
event. Services without selectors require endpoints to be managed explicitly and
shift correctness to that owner.

## Service types

- ClusterIP: internal virtual IP and DNS; default.
- headless (`clusterIP: None`): DNS returns endpoint addresses; client handles selection.
- NodePort: exposes a node port; often an implementation building block.
- LoadBalancer: requests external infrastructure from an implementation/provider.
- ExternalName: DNS CNAME only; no proxy and subject to protocol/TLS naming issues.

`externalTrafficPolicy` and `internalTrafficPolicy` influence endpoint locality,
source-address preservation, and failure behavior. Local policies can reduce hops
but return no backend on a node without a local eligible endpoint.

## DNS discovery

CoreDNS watches the API and serves names. A normal Service commonly resolves as
`service.namespace.svc.cluster.local`; search domains allow a short name in the
same namespace. `dnsPolicy`, `/etc/resolv.conf`, `ndots`, upstream forwarding,
negative caching, and query volume affect results. DNS success proves only name
resolution—not endpoints, policy, listening process, or application health.

DNS records have TTLs and clients may cache beyond expectations. Namespace
search paths and `ndots` can expand one apparent lookup into several queries;
use a fully qualified name when separating search-path behavior from DNS health.

## Service data plane

Service data planes watch Services and EndpointSlices and program node behavior,
commonly via kube-proxy or a CNI replacement. ClusterIP is usually not a process
listening on that address. Session affinity and topology preferences are routing
hints/tradeoffs, not substitutes for application state design.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Network model and packet paths](01-network-model-packet-paths.md) · Next: [Gateway API, ingress, and TLS](03-gateway-ingress-tls.md)
