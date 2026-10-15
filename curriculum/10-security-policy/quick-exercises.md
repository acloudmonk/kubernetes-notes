# Quick Exercises

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Admission policy and multi-tenancy](04-admission-multitenancy.md) · Next: [Lab 1 — Establish identities and least privilege](labs/01-identity-rbac.md)

1. Classify 401, 403, Pod Security rejection, scheduler Pending, and runtime
   permission denied by responsible component and evidence.
2. Expand “can create Pods” into at least five indirect escalation paths.
3. Write an RBAC matrix for an observer, deployer, security reviewer, workload,
   and break-glass operator; remove every wildcard.
4. Compare RoleBinding-to-ClusterRole with ClusterRoleBinding using one rule.
5. Threat-model theft of a projected ServiceAccount token from `exec`, a
   sidecar, node compromise, logs, and backups.
6. Derive which Restricted-profile fields the compliant lab Pod satisfies.
7. Stage an admission rule through Audit, Warn, limited Deny, and broad Deny;
   define rollback and failure-policy behavior.
8. Decide between namespace, virtual-control-plane, and dedicated-cluster
   tenancy for internal teams, untrusted code, and regulated customers.

For each answer state assumptions, blast radius, evidence, owner, and recovery.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Admission policy and multi-tenancy](04-admission-multitenancy.md) · Next: [Lab 1 — Establish identities and least privilege](labs/01-identity-rbac.md)
