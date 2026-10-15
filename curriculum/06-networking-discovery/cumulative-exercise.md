# Cumulative Exercise — Find the First Broken Boundary

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Lab 2 — Enforce, break, and recover](labs/02-enforce-break-recover.md) · Next: [Independent challenge](independent-challenge.md)

This exercise combines Modules 04–06. Seed three failures without telling the
operator which layer owns each: a stale workload template/configuration error,
a Service selector mismatch, and a NetworkPolicy omission. The visible symptom
is an unavailable Gateway request.

The operator must trace API reconciliation and owner references; Deployment
generation, ReplicaSets, probes, and readiness; DNS, Service, EndpointSlice,
Gateway/HTTPRoute conditions; and source/destination policy unions. Capture
evidence before each correction and repair only the first failed boundary.

Acceptance requires a causal timeline, component ownership map, exact symptom
classification, successful end-to-end order/event path, prevention controls,
and scoped cleanup. Deleting/recreating the namespace is not a diagnosis.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Lab 2 — Enforce, break, and recover](labs/02-enforce-break-recover.md) · Next: [Independent challenge](independent-challenge.md)
