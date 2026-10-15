# Knowledge Check

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

1. Does creating a NetworkPolicy prove enforcement?
2. What does a normal Service DNS A record usually return?
3. What does headless Service DNS return?
4. DNS resolves but EndpointSlices are empty. Which layer succeeded?
5. Are NetworkPolicy rules ordered first-match rules?
6. What must be allowed when both client egress and server ingress are isolated?
7. Which Gateway condition indicates backend references are valid?
8. Why can a route be Accepted while requests return 503?
9. Does `containerPort` open a firewall?
10. Why test from a representative source Pod?

---

## Answers

1. No; the installed network plugin must implement it.
2. The Service ClusterIP (and family-appropriate records).
3. Ready endpoint Pod addresses, subject to Service/settings.
4. DNS/service-name publication; backend selection/readiness did not.
5. No. Applicable allows form a union; there are no explicit deny rules beyond isolation/non-allow.
6. Client egress and server ingress must each allow the connection.
7. `ResolvedRefs=True`; also inspect Accepted and parent/listener status.
8. Attachment can be valid while backend endpoints are absent/unready/unreachable.
9. No; it documents a port and supports named references.
10. Namespace, labels, policies, DNS search, node, and address family can change the path.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
