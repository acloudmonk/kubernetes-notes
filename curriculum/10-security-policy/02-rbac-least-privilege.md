# RBAC and Privilege-Escalation Paths

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [API access, authentication, and identity](01-api-access-identity.md) · Next: [Workload, node, and runtime security](03-workload-runtime-security.md)

## Model precisely

Roles and ClusterRoles contain additive allow rules; RoleBindings and
ClusterRoleBindings connect them to users, groups, or ServiceAccounts. There is
no deny rule in Kubernetes RBAC. A RoleBinding can reference a ClusterRole but
grants its namespaced permissions only in that binding’s namespace. A
ClusterRoleBinding grants applicable permissions cluster-wide.

Rules combine API groups, resources/subresources, verbs, and optional
`resourceNames`. `get`, `list`, and `watch` are distinct; `pods/log` and
`pods/exec` are subresources; non-resource URLs are separate. Avoid wildcards:
new API types can silently expand them. `resourceNames` does not generally
restrict `create`, and list/watch clients require matching field-selector
behavior, so test the real client workflow.

RBAC authorizes request attributes, not arbitrary fields in an object. Use
admission policy for securityContext, image, label, replica, or hostPath rules.
Use `kubectl auth can-i`, SelfSubjectAccessReview, SubjectAccessReview, and
impersonation for controlled tests; remember that impersonation itself is a
powerful permission.

## Permissions with hidden power

Review capabilities, not object names. Examples include:

- reading Secrets or ConfigMaps containing credentials;
- creating Pods that mount a Secret, ServiceAccount token, hostPath, or PVC;
- `pods/exec`, ephemeral containers, or workload updates that run attacker code;
- creating RoleBindings to a powerful existing ClusterRole;
- `bind`, `escalate`, or `impersonate` verbs;
- creating/altering admission webhooks, policy bindings, CRDs, or operators;
- reading node proxy endpoints, kubelet credentials, CertificateSigningRequests,
  TokenRequests, or service-account token subresources;
- controlling a namespace where privileged controllers watch resources.

An operator’s CRD may be an indirect privileged API. Authorization reviews must
include controller behavior and reachable credentials.

## Lifecycle and review

Grant roles to groups, not individual humans; keep production write access
time-bound; separate deployment, observation, security, and break-glass duties.
Version bindings, record owners and expiry, and periodically compare granted
permissions with observed need. Review aggregate ClusterRoles carefully because
labels can add rules to default roles. Preserve `system:` objects unless you
understand auto-reconciliation.

The lab grants one ServiceAccount `get/list/watch` on Pods in one namespace and
proves denial for Secrets, Deployment creation, and cross-namespace Pod reads.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [API access, authentication, and identity](01-api-access-identity.md) · Next: [Workload, node, and runtime security](03-workload-runtime-security.md)
