# Network Model and Packet Paths

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Module overview](README.md) · Next: [Services, EndpointSlices, and DNS](02-services-endpoints-dns.md)

Containers in one Pod share a network namespace, IP, ports, and localhost.
Different Pods receive routable addresses from the cluster network; applications
must not depend on those replaceable IPs. Nodes, Pods, and Services use distinct,
non-overlapping CIDRs.

Kubelet/runtime invokes CNI plugins to attach interfaces, allocate addresses,
and establish routes. CNI is an interface specification; routing, encapsulation,
eBPF, IPAM, encryption, and NetworkPolicy support depend on the implementation.
The API accepting a NetworkPolicy does not prove enforcement.

Trace four paths separately:

1. same Pod: process → localhost/shared namespace;
2. Pod to Pod: source namespace → CNI data plane → destination Pod IP;
3. Pod to Service: DNS/ClusterIP → service data plane → ready endpoint Pod;
4. external HTTP: client/load balancer → Gateway proxy → HTTPRoute → Service → Pod.

At every hop record source/destination IP, port, protocol, translation or
encapsulation, policy decision, and component that programmed the path. A
timeout, refusal, NXDOMAIN, HTTP 404, and HTTP 503 identify different layers.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Module overview](README.md) · Next: [Services, EndpointSlices, and DNS](02-services-endpoints-dns.md)
