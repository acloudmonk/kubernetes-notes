# Troubleshooting

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

| Symptom | First evidence | Likely boundary |
|---|---|---|
| NXDOMAIN | query/FQDN, search list, CoreDNS logs | name/namespace/DNS configuration |
| name resolves, timeout | EndpointSlices, policies, routes, listener | dropped path or unavailable backend |
| connection refused | endpoint IP/port and listening socket | wrong targetPort or process not listening |
| Service has no ready endpoints | selector, labels, Pod readiness | discovery/controller state |
| Gateway 404 | listener hostname and route matches | no attached/matching HTTPRoute |
| Gateway 503 | route conditions and backend endpoints | resolved route, unavailable backend |
| only some requests fail | endpoint readiness, family, node/zone, rollout | one bad backend or path |

Test from the real source namespace/labels. Compare direct endpoint, Service,
and Gateway paths without assuming one result proves another. Inspect
`Accepted`, `Programmed`, and `ResolvedRefs`; list every NetworkPolicy selecting
source/destination; confirm the CNI actually enforces policy. Capture evidence
before broadening policy or restarting CoreDNS.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
