# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

## Fundamentals and implementation

### 1. How do ConfigMaps and Secrets differ?

**Answer:** Both are namespaced API objects for decoupling values from images.
A Secret communicates confidentiality intent and receives some special handling,
but its API data is only base64-encoded unless additional controls apply. Choose
by data sensitivity, then protect Secrets with least-privilege access, encryption
at rest, secure delivery, redaction, rotation, backup controls, and application
handling. Neither object is a general-purpose database.

### 2. How do environment variables and projected volumes update?

**Answer:** Environment variables are captured when the container starts and do
not change until replacement. Normal ConfigMap and Secret volume projections are
updated eventually by kubelet, but the application must reopen or watch files
and safely reload them. A `subPath` mount does not receive automated projection
updates. Design a rollout or reload protocol instead of assuming object update
equals application update.

### 3. How does a Secret volume update reach a Pod?

**Answer:** Kubelet observes the API object through its configured detection and
sync behavior, prepares a new projected payload, and atomically changes the
mounted directory view. Propagation is asynchronous; open file descriptors and
applications that read only at startup can retain old data. Verify both file
version and application behavior without printing the secret.

### 4. When should ConfigMaps or Secrets be immutable?

**Answer:** Immutability suits versioned configuration that should not change in
place. It prevents accidental mutation and can reduce watch load, but updates
require a new object name plus a controlled consumer rollout and later garbage
collection. It is not a confidentiality feature and cannot be reverted on the
same object.

## Security and architecture

### 5. Why is permission to create Pods relevant to Secret access?

**Answer:** A caller unable to `get` Secrets may create a Pod that consumes a
Secret, attaches a service-account token, mounts a claim, or requests privileged
host access allowed by policy. Kubernetes authorization must therefore be threat-
modeled across indirect capabilities, admission controls, workload identity,
and namespace boundaries—not evaluated verb by verb.

### 6. What does API-server encryption at rest solve?

**Answer:** Properly configured encryption protects the stored etcd representation
and reduces exposure from raw storage or snapshots; key separation and rotation
matter. It does not stop authorized API responses, compromised workloads or
nodes, application logging, memory exposure, or misuse of decrypted values.
Check active provider configuration and rewrite old objects during rotation.

### 7. How do external-secret synchronization and CSI mounting differ?

**Answer:** A synchronization controller copies provider values into Kubernetes
Secrets, preserving native consumers while also placing the value in etcd. A
Secrets Store CSI approach can mount provider data as files without creating a
Secret, though optional sync may do so. CSI adds driver/provider availability,
node trust, file reload, identity, and rotation semantics. Choose from consumer
needs and the complete threat/availability model.

### 8. Why prefer workload identity over static bootstrap credentials?

**Answer:** Workload identity lets a Pod exchange an authenticated, scoped,
short-lived identity for only the external resources it needs. This reduces
long-lived secrets in manifests and simplifies attribution and revocation. It
still requires audience and subject validation, least-privilege provider policy,
token protection, clock and issuer reliability, and monitoring for abuse.

## Operations and incidents

### 9. What causes `CreateContainerConfigError`?

**Answer:** Common causes are a missing required ConfigMap or Secret, a missing
key, or an invalid reference needed before process startup. Read Pod Events and
the container waiting reason before debugging images or application logs—the
process may never have started. Correct the reference, then verify startup and
application behavior.

### 10. Why is changing a Secret not the same as rotating a credential?

**Answer:** Rotation spans multiple systems: create or enable a new backend
credential, publish it, reload or replace consumers and connection pools, verify
new usage, revoke the old credential, verify rejection, and clean up with audit
evidence. A Secret update can propagate late or not at all, while cached sessions
can make a broken rollout appear healthy.

### 11. How do you design zero-downtime credential rotation?

**Answer:** Use an overlap period in which old and new credentials are both
accepted. Publish the new value, progressively reload consumers, prove new
authentication and business operations, then revoke the old value and prove it
fails. Bound overlap, define rollback, avoid value disclosure, and monitor which
identity is actually used. Systems that cannot overlap need a planned disruption
or a different authentication design.

### 12. A real token reached Git. What should happen first?

**Answer:** Revoke or rotate it immediately and investigate exposure and use.
Then remove it from the current tree, decide whether history rewriting is useful,
purge logs or artifacts where possible, notify affected owners, and improve the
preventive control. Deleting the file or rewriting Git does not make a copied
credential safe, so containment precedes repository cleanup.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
