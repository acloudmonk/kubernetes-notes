# 06 — Kubernetes Networking and Discovery

**Status:** Verified<br>
**Estimated time:** 24–30 hours<br>
**Prerequisites:** [05 — Kubernetes Workloads](../05-kubernetes-workloads/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Kubernetes workloads](../05-kubernetes-workloads/README.md) · Next: Storage and state (planned)

## Why this matters

An application can be healthy while DNS, Service selection, the data plane,
Gateway routing, or policy makes it unreachable. This module follows traffic
from name lookup to a ready Pod and separates each ownership boundary.

## Learning objectives

You can trace container, Pod, Service, and external HTTP paths; explain CNI,
CoreDNS, EndpointSlice, and service-proxy roles; select Service types; configure
Gateway API routes; apply default-deny NetworkPolicy; distinguish TLS boundaries;
and diagnose lookup failures, empty endpoints, refusal, timeout, and route status.

## Contents

1. [Network model and packet paths](01-network-model-packet-paths.md)
2. [Services, EndpointSlices, and DNS](02-services-endpoints-dns.md)
3. [Gateway API, ingress, and TLS](03-gateway-ingress-tls.md)
4. [NetworkPolicy and diagnosis](04-network-policy-diagnosis.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Trace CloudCart networking](labs/01-trace-cloudcart-networking.md)
7. [Lab 2 — Enforce and break network paths](labs/02-enforce-break-recover.md)
8. [Cumulative exercise](cumulative-exercise.md)
9. [Independent challenge](independent-challenge.md)
10. [Troubleshooting](troubleshooting.md)
11. [Interview questions](interview-questions.md)
12. [Knowledge check](quiz.md)
13. [References and videos](references.md)

## Tested baseline

Uses the Module 05 CloudCart baseline, Envoy Gateway 1.8.5, Gateway API `v1`,
CoreDNS, kube-proxy, and a NetworkPolicy-capable kind network. Allow 6 GB memory,
8 GB disk, and network access for pinned controller images/manifests.

## Completion

- [ ] **Explain:** trace DNS → Service → EndpointSlice → ready Pod and Gateway → route → backend.
- [ ] **Build:** expose CloudCart and enforce only declared application flows.
- [ ] **Diagnose:** repair DNS, selector, policy, and HTTPRoute failures from evidence.
- [ ] Complete the cumulative and independent exercises.

## Continue

Return to the [curriculum index](../README.md). Module 07 will be linked when storage and state material is available.
