# Interview Questions

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

1. **[Fundamental] ConfigMap versus Secret?** Both are namespaced configuration APIs; Secret communicates confidentiality intent and gains handling protections, but needs encryption/RBAC and base64 is not encryption.
2. **[Implementation] `env` versus volume?** Environment is fixed at container start; normal projected files update eventually but the application must reload; `subPath` does not update.
3. **[Security] Why is Pod creation relevant to Secret RBAC?** A creator can often schedule a Pod that consumes namespace Secrets even without direct `get`.
4. **[Internals] How does a Secret volume update?** Kubelet detects API changes and atomically refreshes projected content after propagation/sync delay.
5. **[Troubleshooting] What causes `CreateContainerConfigError`?** Missing required object/key or invalid reference; inspect Pod events before image/process debugging.
6. **[Architecture] External sync versus CSI mount?** Sync preserves native consumers but copies into etcd; CSI can mount provider data without an API copy but adds driver/provider/file lifecycle concerns.
7. **[Security] What does etcd encryption solve?** Stored representation/backup exposure when correctly configured; not authorized API reads, Pod/node compromise, logs, or application handling.
8. **[Reliability] Why is Secret update not credential rotation?** Backend acceptance, consumer reload/pools, verification, revocation, rollback, and audits are separate states.
9. **[Production] Why use workload identity?** It replaces static bootstrap keys with scoped, short-lived, auditable identity to retrieve allowed secrets.
10. **[Senior] Design zero-downtime rotation.** Create overlapping credential, publish, gradually reload, verify use/business work, revoke old, verify rejection, clean up.
11. **[Implementation] When use immutable ConfigMaps/Secrets?** Versioned stable configuration, accidental-change protection, and watch reduction; replacement and garbage collection are required.
12. **[Incident] A token reached Git. First action?** Revoke/rotate and assess use/exposure; removing or rewriting Git alone does not make it safe.

Extend every answer with mechanism, evidence, tradeoff, common mistake, and a follow-up scenario.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
