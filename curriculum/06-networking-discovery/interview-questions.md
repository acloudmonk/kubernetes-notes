# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

## Fundamentals and internals

### 1. What does the Kubernetes network model require?

**Answer:** Every Pod receives a cluster address, Pods can communicate with
other Pods without application-managed NAT, and agents on a node can reach its
Pods. Kubernetes defines this model but not the implementation: the CNI plugin,
routes or overlays, service data plane, DNS, and policy engine realize it.
Reachability outside the cluster and policy enforcement are separate concerns.

### 2. Trace traffic sent to a normal Service name.

**Answer:** The client resolver asks cluster DNS, which normally returns the
Service ClusterIP. A node or network service-data-plane implementation uses
Service and EndpointSlice state to select an eligible backend and translate or
route the connection. The ClusterIP is usually a virtual address, not a process
listening on that address. The backend application then accepts the connection
on the resolved target port.

**Evidence:** Verify DNS, Service ports/selectors, EndpointSlices, data-plane
rules, policy, and the backend independently.

### 3. How do EndpointSlices differ from the legacy Endpoints API?

**Answer:** EndpointSlices partition backend data so large Services can update
and distribute changes more efficiently. They carry address family, readiness,
serving, terminating, topology, and port information used by consumers. The
legacy Endpoints object is deprecated and has scale limitations, so diagnosis
should use EndpointSlices while recognizing that readiness and publication
settings affect which addresses appear usable.

### 4. How do NetworkPolicies combine?

**Answer:** A Pod becomes isolated for ingress or egress when a policy selecting
it contains that direction. Applicable allow rules are additive; they are not
ordered first-match firewall rules and there is no explicit deny rule. For a
connection between isolated client and server Pods, client egress and server
ingress must both permit it. Enforcement still depends on the installed network
implementation.

**Common mistake:** Assuming a policy object proves packets are being filtered.

## Design and implementation

### 5. When should you use a headless Service instead of ClusterIP?

**Answer:** A ClusterIP supplies one virtual frontend and lets the data plane
select a backend. A headless Service publishes endpoint addresses through DNS,
allowing the client or an application protocol to discover individual members.
Headless discovery is useful for stateful membership but moves selection,
retry, topology, and stale-DNS behavior toward the client; it is not inherently
more available.

### 6. How do Ingress and Gateway API differ?

**Answer:** Ingress is a compact, widely implemented HTTP routing API whose
advanced behavior often depends on controller-specific annotations. Gateway API
separates infrastructure-owned Gateways/listeners from application-owned Routes,
uses typed attachment and references, and exposes richer status. Choose based on
required protocols, organizational ownership, implementation support, and
migration cost—not only API novelty.

### 7. Where should TLS terminate?

**Answer:** State two trust boundaries explicitly: client to edge proxy and
proxy to backend. TLS may terminate at the edge, be re-encrypted to the backend,
or pass through when the application must own it. The decision includes hostname
and certificate ownership, private-key storage, rotation, client identity,
policy visibility, and what traffic is plaintext on each hop.

### 8. Why can policy YAML exist without network protection?

**Answer:** The API server validates and stores NetworkPolicy objects but does
not enforce packets. The CNI or another data-plane component must implement the
API semantics. Unsupported fields or directions may also vary by implementation.
Confirm plugin capability and run positive and negative connectivity tests from
representative Pods rather than inferring enforcement from object creation.

## Troubleshooting and production

### 9. DNS works but a request times out. How do you proceed?

**Answer:** Preserve the successful DNS evidence and move down the path. Inspect
Service port mapping and ready EndpointSlices, test the backend directly, check
client egress and server ingress policy, then inspect routing and node/CNI
evidence. A timeout suggests dropping or an unresponsive endpoint, while refusal
usually indicates a reachable address with no listener; verify instead of using
the symptom as proof.

### 10. A Gateway route is Accepted but returns 503. What does that mean?

**Answer:** `Accepted=True` shows the Route attached to a compatible parent; it
does not prove the backend is valid or healthy. Inspect `ResolvedRefs`, Service
name and port, ready EndpointSlices, cross-namespace grants, policies, backend
protocol, and controller logs/status. A 503 commonly means the proxy has no
usable upstream even though route attachment succeeded.

**Follow-up:** How would the investigation change for 404, TLS failure, or 502?

### 11. What are the tradeoffs of preserving client source IP?

**Answer:** Policies such as `externalTrafficPolicy: Local` can preserve the
external source address and avoid an extra cross-node hop, but a node without a
local ready endpoint cannot serve that traffic and load can become uneven.
Provider health checks and load-balancer behavior matter. Verify the address seen
by the application and availability during rollout and node loss.

### 12. How do MTU and address-family mismatches present in production?

**Answer:** Small connections or DNS may work while larger packets stall when
encapsulation exceeds path MTU and fragmentation discovery is blocked. IPv4/IPv6
selection can send clients toward an unsupported path or endpoint family. Compare
interface/overlay MTUs, packet sizes, ICMP behavior, DNS records, EndpointSlice
address types, and captures at adjacent hops before changing global settings.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
