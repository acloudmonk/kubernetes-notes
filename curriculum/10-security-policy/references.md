# References and Videos

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

## Primary references

- [Controlling access to the Kubernetes API](https://kubernetes.io/docs/concepts/security/controlling-access/) and [authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)
- [Authorization overview](https://kubernetes.io/docs/reference/access-authn-authz/authorization/), [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/), and [RBAC good practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)
- [ServiceAccounts](https://kubernetes.io/docs/concepts/security/service-accounts/) and [bound ServiceAccount tokens](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) and [Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)
- [SecurityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) and [application security checklist](https://kubernetes.io/docs/concepts/security/security-checklist/)
- [Admission controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/) and [ValidatingAdmissionPolicy](https://kubernetes.io/docs/reference/access-authn-authz/validating-admission-policy/)
- [Multi-tenancy](https://kubernetes.io/docs/concepts/security/multi-tenancy/) and [auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)

## Ecosystem references

- [Kyverno documentation](https://kyverno.io/docs/) and [OPA Gatekeeper documentation](https://open-policy-agent.github.io/gatekeeper/website/docs/)
- [Kubernetes threat model](https://kubernetes.io/docs/concepts/security/kubernetes-security/) and [MITRE ATT&CK Containers matrix](https://attack.mitre.org/matrices/enterprise/containers/)

## Videos

- [The Hitchhiker’s Guide to Pod Security](https://www.youtube.com/watch?v=gcz5VsvOYmI) — Lachlan Evenson, CNCF/KubeCon, 2021. Use it for the Pod Security model and migration reasoning. **Age warning:** the talk predates stable PSA; current Kubernetes docs are authoritative.
- [Kubernetes RBAC 101](https://www.cncf.io/online-programs/kubernetes-rbac-101/) — CNCF webinar, 2020. Use it to reinforce subjects, roles, bindings, and external identity integration. **Age warning:** verify token and API behavior against current docs.
- [Kubernetes Security Best Practices](https://www.youtube.com/watch?v=wqsUfvRyYpw) — Ian Lewis, CNCF/KubeCon, 2019. Use it for layered container/node/runtime thinking. **Age warning:** PodSecurityPolicy is removed; use current Pod Security Admission guidance.
- [Cloud Native Live: Leveling Up with CEL in Kyverno 1.14](https://www.cncf.io/online-programs/cloud-native-live-leveling-up-with-cel-in-kyverno-1-14/) — CNCF, 2025. Use it to compare native CEL and policy-engine workflows; confirm current Kyverno versions separately.

Treat videos as conceptual reinforcement. Record version-sensitive claims and
resolve them against the primary documentation and tested baseline.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
