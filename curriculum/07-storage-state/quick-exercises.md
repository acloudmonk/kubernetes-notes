# Quick Exercises

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Data protection, backup, and recovery](04-data-protection-recovery.md) · Next: [Lab 1 — Persist and trace CloudCart state](labs/01-persist-trace-cloudcart.md)

1. Classify container writable layer, `emptyDir`, ConfigMap, generic ephemeral PVC, and normal PVC by owner and deletion boundary.
2. Draw PVC → StorageClass → provisioner → PV → scheduler → attach → mount, and place one evidence source at each transition.
3. Predict the result of RWO with two Pods on one node versus two nodes.
4. Compare Immediate and `WaitForFirstConsumer` for zonal block storage.
5. Build the StatefulSet/PVC/PV deletion matrix using both PVC retention and PV reclaim policies.
6. Design a restore test with stated RPO, RTO, business invariants, and cleanup.

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Data protection, backup, and recovery](04-data-protection-recovery.md) · Next: [Lab 1 — Persist and trace CloudCart state](labs/01-persist-trace-cloudcart.md)
