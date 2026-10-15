# Knowledge Check

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

1. Does Kubernetes RBAC contain deny rules?
2. Does a RoleBinding to a ClusterRole grant that role in every namespace?
3. Can permission to create Pods expose permissions the caller lacks directly?
4. Does disabling token automount remove the ServiceAccount identity field?
5. Does Pod Security Admission run before authorization?
6. Does Restricted Pod Security prove an image is vulnerability-free?
7. Can `warn` reject a violating Pod?
8. Why pin Pod Security profile versions?
9. Does a namespace alone isolate network, nodes, and storage?
10. Can a malformed fail-closed admission policy affect availability?
11. Does a `:latest` denial guarantee immutable image identity?
12. What should be checked after granting an intended RBAC permission?

---

## Answers

1. No; rules are additive allows and no opinion becomes denial.
2. No; namespaced permissions apply only in the RoleBinding’s namespace.
3. Yes; a Pod can consume credentials, identities, volumes, or host access.
4. No; the Pod still names an identity but receives no automatic API token.
5. No; admission follows successful authorization for eligible writes.
6. No; it constrains Pod configuration, not image contents or provenance.
7. No; it returns a warning. `enforce` rejects.
8. To make upgrade-time behavior explicit and allow controlled migration.
9. No; multiple independent controls are required.
10. Yes; therefore scope, tests, staging, rollback, and break-glass matter.
11. No; omitted tags and other mutable tags/digests need broader policy.
12. Re-test intended denials and indirect escalation paths, not only the allow.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
