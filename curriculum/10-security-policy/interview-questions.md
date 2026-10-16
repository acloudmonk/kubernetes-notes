# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

Strong answers connect the threat, control, bypass, evidence, safe rollout, and
recovery rather than naming a security feature in isolation.

## API identity and authorization

### 1. Trace authentication, authorization, mutation, validation, and persistence.

**Answer:** The API server authenticates credentials, authorizes the resulting
identity and request attributes, then runs mutating admission, schema/defaulting
and validation, and validating admission before persistence. Exact internal
validation ordering has implementation detail, but admission cannot grant a
request authorization denied. Audit records and admission responses help locate
the boundary; controllers act asynchronously after the write.

### 2. Compare 401, 403, admission denial, and runtime permission failure.

**Answer:** A 401 indicates missing or rejected authentication. A 403 means an
authenticated identity was not authorized. Admission denial rejects an otherwise
authorized write because policy or validation failed. Runtime denial occurs after
creation—for example filesystem, seccomp, network, cloud IAM, or application
authorization. Preserve the exact response, identity, Events, and runtime logs.

### 3. Explain projected ServiceAccount tokens, audience, lifetime, and automount.

**Answer:** Modern projected tokens are signed, bounded in lifetime, and scoped
to an audience; recipients must validate issuer, signature, expiry, and audience.
Kubelet refreshes mounted tokens before expiry. Disabling automount removes the
default token projection, not the Pod's ServiceAccount identity, and explicit
projections can still be requested. Prefer the smallest audience and permissions.

### 4. Compare Role, ClusterRole, RoleBinding, and ClusterRoleBinding.

**Answer:** A Role defines permissions in one namespace. A ClusterRole defines a
reusable rule set that can include cluster-scoped resources. A RoleBinding grants
a Role or ClusterRole within the binding's namespace; a ClusterRoleBinding grants
a ClusterRole cluster-wide. Verify effective permissions and intended denials
for the exact subject rather than inferring scope from the role name.

### 5. Why are RBAC wildcards and `cluster-admin` operational risks?

**Answer:** Wildcards automatically include future resource types, subresources,
and verbs, silently expanding privilege as APIs evolve. `cluster-admin` broadly
bypasses namespace boundaries and can create further access. Prefer explicit
task-aligned permissions, time-bound elevation, audit, and periodic review; test
indirect paths such as Pod creation and role binding.

### 6. How can Pod creation indirectly grant Secret or node access?

**Answer:** A Pod creator may mount Secrets, service-account tokens, PVCs, or
host paths; select powerful identities; or request privileged host namespaces and
devices if admission permits. Those capabilities can exceed direct RBAC reads.
Constrain workload creation with dedicated identities, admission, Pod Security,
node isolation, quotas, and separate namespaces or clusters where warranted.

### 7. What do `bind`, `escalate`, and `impersonate` authorize?

**Answer:** `bind` allows assigning a role even when the caller lacks all its
permissions. `escalate` permits creating or updating a role with permissions
beyond the caller's own. `impersonate` lets requests act as another user, group,
or service account. These are privilege-escalation primitives; scope and audit
them explicitly and avoid hiding them inside broad wildcards.

## Workload and admission controls

### 8. Explain the major Restricted Pod Security controls and their limitation.

**Answer:** Restricted constrains host namespaces and paths, privileged mode,
privilege escalation, capabilities, unsafe volume types, root execution, and
seccomp expectations. It reduces common container-to-node paths but does not scan
images, enforce network isolation, secure application code, protect every kernel
defect, or prove multi-tenant isolation. Combine it with the other trust layers.

### 9. Compare Pod Security Admission, ValidatingAdmissionPolicy, Gatekeeper, and Kyverno.

**Answer:** Pod Security Admission enforces versioned Pod Security profiles by
namespace. ValidatingAdmissionPolicy provides native CEL validation for API
requests. Gatekeeper and Kyverno are extensible policy engines with different
languages, reporting, mutation, and ecosystem features. Choose the smallest
tool meeting policy and operational needs, and account for its availability and
upgrade path.

### 10. How do you roll out an admission policy safely?

**Answer:** Define threat and scope, test against representative and historical
objects, begin with audit or warning where possible, exclude platform and break-
glass paths deliberately, then enforce progressively. Monitor denials and webhook
latency/errors, pin versions, and keep a tested rollback. Choose fail-open or
fail-closed from the policy's risk and availability consequence—not convenience.

### 11. Why is a namespace not a complete tenant security boundary?

**Answer:** Namespaces scope many API objects and policies, but tenants can still
share nodes, kernel, network implementation, storage drivers, admission, cluster-
scoped APIs, and control plane. Add RBAC, policy, quotas, network and storage
isolation, workload hardening, and node placement. Strong hostile-tenancy needs
virtual control planes, sandboxing, or dedicated clusters based on threat model.

### 12. Compare namespace, virtual-control-plane, and dedicated-cluster isolation.

**Answer:** Namespaces are low-cost and operationally simple but share most
cluster infrastructure. Virtual control planes increase API and policy autonomy
while often sharing worker infrastructure. Dedicated clusters offer the clearest
control-plane and worker boundary at greater cost and fleet-management burden.
Choose from adversary strength, compliance, blast radius, customization, and toil.

## Operations and incident response

### 13. What changes after a node is considered compromised?

**Answer:** Treat workload credentials, mounted data, tokens, logs, and images on
that node as potentially exposed. Isolate and replace rather than “clean” it,
preserve forensic evidence where policy requires, rotate reachable credentials,
reschedule onto trusted capacity, and investigate entry and lateral movement.
Control-plane trust may also be affected if node credentials were abused.

### 14. How do you design useful audit policy without leaking Secret bodies?

**Answer:** Capture identity, verb, resource, namespace, response, authorization,
and high-value mutations at an appropriate metadata or request level. Avoid
request/response bodies for Secrets and other sensitive APIs, bound volume and
retention, protect transport/storage, restrict access, and alert on escalation
patterns. Test that investigations are possible without turning logs into a new
credential store.

### 15. Outline containment and credential rotation after workload identity theft.

**Answer:** Contain the workload and network path, preserve evidence, revoke or
disable affected identity and sessions, and identify accessible resources and
actions. Issue a new narrowly scoped identity through a trusted deployment,
rotate downstream credentials where exposure is possible, verify service and
denial of the old path, then remediate the cause and monitor for recurrence.
Deleting one Pod alone is not containment.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
