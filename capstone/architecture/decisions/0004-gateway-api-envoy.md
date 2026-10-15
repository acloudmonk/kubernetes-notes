# ADR 0004: Use Gateway API with Envoy Gateway for local ingress

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

CloudCart needs a local north-south traffic path that teaches current Kubernetes
routing concepts without coupling the application to one controller's custom
annotations. The learning environment also needs useful status conditions for
diagnosis and a reproducible implementation on the kind baseline.

## Decision

Use the Kubernetes Gateway API `v1` resources with Envoy Gateway 1.8.5 for the
local CloudCart ingress path. A same-namespace `HTTPRoute` maps
`cloudcart.local` and the `/` prefix to the `cloudcart-api` Service. Keep the
Gateway resources separate from the core workload manifests so the application
can be deployed before the controller is installed.

The learning lab pins the official Envoy Gateway installer URL. Learners must
review remote manifests before applying them. Production environments must pin
and verify artifacts through their approved supply-chain process rather than
depending directly on a public URL.

## Consequences

The routing model is portable across conformant Gateway API implementations,
and route acceptance, reference resolution, and backend availability are
observable independently. Envoy Gateway creates its own proxy workload and
Service, adding controller resources to the local cluster.

kind has no built-in cloud load-balancer provider. The top-level Gateway may
therefore report `Programmed=False` with `AddressNotAssigned` even while its
listener, route, proxy Pod, and in-cluster request path work. A production
environment still needs a load-balancer integration, DNS, trusted certificates,
and an explicit TLS policy.

## Validation

- Confirm the GatewayClass is accepted by Envoy Gateway.
- Confirm the Gateway listener is programmed and the generated proxy Pod is Ready.
- Confirm the HTTPRoute is accepted and its references resolve.
- Send an HTTP request through the generated proxy Service with the configured Host header.
- Break a backend selector, observe route/backend evidence, restore it, and retest.
