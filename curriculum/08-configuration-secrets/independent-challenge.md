# Independent Challenge

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Lab 2 — Diagnose and rotate safely](labs/02-diagnose-rotate.md) · Next: [Troubleshooting](troubleshooting.md)

Deploy a small application with validated non-secret configuration and a
credential generated outside Git. Use explicit key references rather than
importing unrelated values. Demonstrate environment or file update semantics,
a missing-key failure, staged credential rotation with old/new overlap when the
backend supports it, business verification, old credential revocation, rollback,
and precise cleanup.

Submit only manifests/scripts without values, a consumer/source inventory, RBAC
and indirect-access analysis, exposure-path threat model, external-store pattern
decision, rotation state machine, metadata-only evidence, and proof that ignored
or temporary artifacts contain no retained credentials.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Lab 2 — Diagnose and rotate safely](labs/02-diagnose-rotate.md) · Next: [Troubleshooting](troubleshooting.md)
