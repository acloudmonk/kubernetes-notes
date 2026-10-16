# Gateway API, Ingress, and TLS

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Services, EndpointSlices, and DNS](02-services-endpoints-dns.md) · Next: [NetworkPolicy and diagnosis](04-network-policy-diagnosis.md)

## API roles and reconciliation

Ingress is a stable, widely implemented HTTP routing API but depends heavily on
controller annotations. Gateway API separates infrastructure and application
ownership through GatewayClass, Gateway listeners, and route resources such as
HTTPRoute. Installing CRDs alone creates no data plane; a conforming controller
must reconcile them.

GatewayClass identifies the implementation; Gateway declares listeners and
infrastructure policy; Route objects declare application routing and attach only
when listener rules permit them. `ReferenceGrant` allows selected cross-namespace
references without giving a Route owner control of arbitrary backends or Secrets.

## Status before traffic tests

CloudCart uses an Envoy-managed Gateway, hostname listener, and same-namespace
HTTPRoute to the API Service. Read `Accepted`, `Programmed`, and `ResolvedRefs`
conditions before testing traffic. In kind the listener/proxy can work while
top-level `Programmed=False` reports `AddressNotAssigned`, because no
LoadBalancer address provider exists. A route can exist yet be unattached because
of listener hostname, namespace policy, parent reference, backend kind/port, or
missing ReferenceGrant for cross-namespace references.

Conditions have an observed generation and reason. Check that status corresponds
to the current spec; an old positive condition is not proof that the latest edit
was reconciled.

## TLS trust boundaries

For TLS termination, a listener references a certificate Secret and the proxy
decrypts traffic; backend traffic is separate and may be plain HTTP, TLS, or
mTLS. Record certificate ownership, SAN/hostname, trust roots, renewal, private-
key access, client-to-Gateway encryption, and Gateway-to-backend encryption.
TLS success does not authorize the caller.

Passthrough preserves end-to-end application TLS but limits HTTP-aware routing
and proxy visibility. Termination enables routing and policy at the Gateway but
makes the proxy a plaintext and key-handling trust boundary unless the backend
hop is separately encrypted.

## Local and production exposure

On local kind without LoadBalancer address management, test the managed proxy
Service in-cluster or use a scoped port-forward. Production exposure depends on
cloud/bare-metal load-balancer and source-IP behavior.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Services, EndpointSlices, and DNS](02-services-endpoints-dns.md) · Next: [NetworkPolicy and diagnosis](04-network-policy-diagnosis.md)
