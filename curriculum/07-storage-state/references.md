# References and Videos

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

## Primary references

- [Kubernetes storage concepts](https://kubernetes.io/docs/concepts/storage/)
- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) and [StorageClasses](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [Dynamic volume provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/) and [CSI volume cloning](https://kubernetes.io/docs/concepts/storage/volume-pvc-datasource/)
- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) and [apps/v1 StatefulSet API](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/stateful-set-v1/)
- [Volume Snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/) and [CSI documentation](https://kubernetes-csi.github.io/docs/)
- [PostgreSQL backup and restore](https://www.postgresql.org/docs/17/backup.html)
- [kind known issues: persistent volumes](https://kind.sigs.k8s.io/docs/user/known-issues/#unable-to-mount-a-hostpath-pv)

## Videos

- [Kubernetes Storage in Action](https://www.youtube.com/watch?v=vpcTC2C4qZ8) — Sheng Yang, CNCF webinar, 2020. Use it for PV/PVC/StorageClass, access-mode, and StatefulSet demonstrations. **Age warning:** commands and product examples may have changed; current upstream docs are authoritative.
- [Introduction to Using the Container Storage Interface Primitives](https://www.youtube.com/watch?v=AnfAd6goq-o) — Michael Mattsson, CNCF/KubeCon, 2020. Use it to connect provisioning, expansion, block, snapshot, clone, and ephemeral CSI capabilities. **Age warning:** verify feature state and sidecar requirements against current CSI/Kubernetes documentation.

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
