# Lab 2 — Enforce Workload and Admission Policy

> **Module:** [10 — Kubernetes Security and Policy](../README.md) · Previous: [Lab 1 — Establish identities and least privilege](01-identity-rbac.md) · Next: [Independent challenge](../independent-challenge.md)

The `security-lab` namespace pins the Kubernetes 1.36 Restricted Pod Security
profile in enforce, audit, and warn modes. It also carries a label selected by a
native ValidatingAdmissionPolicy binding, plus a small LimitRange and quota.

Before running the test, predict all three outcomes:

- `compliant-pod.yaml` is admitted and runs with no token, non-root UID,
  RuntimeDefault seccomp, no added capabilities, no privilege escalation, and a
  read-only root filesystem;
- `psa-violation.yaml` is rejected by Pod Security Admission for privileged and
  missing Restricted controls;
- `latest-image-violation.yaml` passes Pod Security but is rejected by the CEL
  rule for an explicit `:latest` tag.

Inspect the policy/binding scope and `status.typeChecking`, then run
`Test-SecurityLab.ps1`. Capture sanitized denial messages and prove no rejected
Pod was stored. The CloudCart namespace uses warn/audit during migration because
upstream database/broker images need separate compatibility remediation; it does
not falsely claim Restricted enforcement.

Delete the entire disposable environment only after preserving evidence:

```powershell
kind delete cluster --name cloudcart-security
```

> **Module:** [10 — Kubernetes Security and Policy](../README.md) · Previous: [Lab 1 — Establish identities and least privilege](01-identity-rbac.md) · Next: [Independent challenge](../independent-challenge.md)
