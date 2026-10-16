# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

### 1. What is the difference between continuous integration, delivery, and deployment?

**Answer:** CI integrates reviewed changes through automated build and test evidence.
Continuous delivery keeps verified releases promotable; continuous deployment
automatically promotes them under policy. None guarantees safe architecture or
correct tests, so define trust boundaries and post-deployment verification.

### 2. Why build once and promote by digest?

**Answer:** A digest identifies the exact artifact already tested. Rebuilding per
environment changes bytes and dependencies, invalidating evidence. Promote the
same image/chart identities while reviewing environment configuration separately.

### 3. What should be trusted in a pipeline?

**Answer:** Constrain source revision, runner and builder identity, pinned actions,
dependencies, credentials, network access, artifact destinations, approvals, and
outputs. Automation is not a trust claim; each boundary needs least privilege,
tamper evidence, and recovery.

### 4. How do SBOM and vulnerability scan differ?

**Answer:** An SBOM inventories components; a scan matches inventory to advisory
data at a point in time. Scan absence is not vulnerability absence. Preserve the
SBOM, database timestamp, policy, exceptions, and artifact digest.

### 5. What does a signature prove?

**Answer:** It proves a holder of a key or certified identity signed particular
bytes or an attestation. Verification must authorize issuer, subject, workflow,
artifact digest, time/transparency evidence, and policy. It does not prove safety.

### 6. What is build provenance?

**Answer:** Provenance is an attestation describing source, builder, invocation,
materials, and output identity. Its value depends on a trusted isolated builder
and verification policy; self-authored metadata from an untrusted job is weak.

### 7. Why use workload identity in CI?

**Answer:** Federation exchanges bounded job identity for short-lived credentials,
avoiding stored cloud keys. Scope repository, ref, workflow, audience, environment,
and permissions; identity still requires protected workflow code and audit.

### 8. What distinguishes push deployment from GitOps?

**Answer:** Push deployment grants an external job cluster write access for an
operation. GitOps controllers pull declared state and continuously reconcile it.
GitOps reduces credential distribution and repairs drift, but adds controller,
source, and policy dependencies.

### 9. Trace Flux from Git commit to Helm release.

**Answer:** Source Controller fetches Git and emits an artifact/revision.
Kustomize Controller builds and applies the configured path. A HelmRelease then
drives Helm Controller to render, act, wait, and report conditions. Kubernetes
controllers realize workloads; each layer has separate evidence.

### 10. How do you diagnose a Flux Kustomization that is not Ready?

**Answer:** Check generation/revision, source readiness, build errors, decryption/
substitution, API/admission responses, inventory, health checks, dependencies,
Events, and controller logs. Correct source or dependency rather than repeatedly
forcing reconciliation.

### 11. What does prune do and why is it risky?

**Answer:** Prune deletes previously inventoried objects removed from desired
state. It prevents abandoned drift but a path/ref mistake can delete valid state.
Protect data resources, review inventory, stage changes, and test recovery.

### 12. How should secrets enter a GitOps deployment?

**Answer:** Prefer workload identity and external secret retrieval, or encrypted
source decrypted only in a controlled cluster boundary. Keep plaintext, keys, and
rendered secret output out of Git, CI logs, status, and broad RBAC.

### 13. How do you recover a bad GitOps release?

**Answer:** Preserve evidence, revert or fix authoritative source, reconcile, and
verify controller plus user outcomes. Direct cluster edits are temporary incident
actions and will drift. Data/schema effects need separate forward repair or restore.

### 14. When is canary analysis unsafe?

**Answer:** It is unsafe with insufficient traffic, biased routing, wrong queries,
missing baselines, delayed signals, shared irreversible effects, or undefined
no-data behavior. Bound exposure and time, then require explicit abort semantics.

### 15. How do you secure third-party pipeline actions and controllers?

**Answer:** Pin immutable revisions/images, verify publisher/provenance, review
permissions and network access, inventory transitive dependencies, isolate runners,
scan and update deliberately, and monitor advisories. A marketplace badge or
popular repository is not authorization.

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
