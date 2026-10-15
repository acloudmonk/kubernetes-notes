# Independent Challenge

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Lab 2 — Enforce workload and admission policy](labs/02-admission-boundary.md) · Next: [Troubleshooting](troubleshooting.md)

Design a shared-cluster boundary for two internal teams and one untrusted build
workload. Define identity lifecycle, groups, RBAC matrices, escalation review,
ServiceAccounts/token audiences, Pod Security levels, admission rules and staged
rollout, quota, network and storage isolation, node/runtime separation, Secret
delivery, audit/redaction, break-glass, incident containment, and recovery.

Implement the safe subset in a disposable cluster. Demonstrate one allowed API
action and denials for Secret access, cross-namespace access, privileged Pod,
mutable image rule, quota exhaustion, and forbidden escalation. Submit manifests,
threat model, sanitized access reviews/denials, policy tests, rollback, and exact
cleanup. Do not grant `cluster-admin`, expose a token, or weaken the boundary to
make a test pass.

> **Module:** [10 — Kubernetes Security and Policy](README.md) · Previous: [Lab 2 — Enforce workload and admission policy](labs/02-admission-boundary.md) · Next: [Troubleshooting](troubleshooting.md)
