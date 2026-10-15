# Interview Questions

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

1. **[Fundamental] PV versus PVC versus StorageClass?** A PVC is a namespaced request, a PV is the bound cluster resource, and a class selects provisioning/lifecycle policy.
2. **[Internals] Trace dynamic provisioning.** Claim admission, binding mode, external provisioner/backend allocation, PV binding, topology-aware scheduling, attach, kubelet/CSI mount.
3. **[Implementation] RWO versus RWOP?** RWO limits read-write mounting to one node; RWOP targets one Pod cluster-wide and requires CSI support.
4. **[Troubleshooting] Why is a PVC Pending?** Missing class/default, delayed binding without a consumer, unsupported mode, no capacity/PV, quota, topology, or provisioner failure; use events.
5. **[Architecture] Why use `WaitForFirstConsumer`?** It delays topology-constrained allocation until workload scheduling requirements are known.
6. **[Internals] What survives StatefulSet Pod replacement?** Ordinal name, network identity, and its claim/storage mapping; not Pod UID, IP, process, or connections.
7. **[Production] Retain versus Delete?** Retain supports deliberate recovery/sanitization but costs and needs workflow; Delete automates cleanup but raises accidental-loss risk.
8. **[Security] What belongs in storage security?** Least privilege, tenant isolation, encryption/key separation, mount ownership, backup access, immutability, audit, sanitization.
9. **[Reliability] Why is replication not backup?** It improves availability but commonly propagates logical deletion/corruption and shares operational failure modes.
10. **[Senior] Managed database or StatefulSet?** Decide from expertise, control, latency, portability, HA/upgrade/recovery burden, compliance, cost, and provider dependency.
11. **[Troubleshooting] Bound PVC but FailedMount?** Binding succeeded; inspect node plugin/kubelet, attachment, device/filesystem, mount options, permissions, and topology.
12. **[Recovery] What proves a backup?** An isolated, version-compatible restore plus integrity, database, business, and dependency reconciliation checks within RPO/RTO.

Extend each answer with mechanism, evidence, tradeoff, common mistake, and a follow-up scenario.

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
