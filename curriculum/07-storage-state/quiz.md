# Knowledge Check

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)

1. Does a Bound PVC prove a Pod mounted it successfully?
2. What does `WaitForFirstConsumer` delay, and why?
3. Does RWO mean only one Pod can mount a volume?
4. Which object carries the backend reclaim policy after claim deletion?
5. What two StatefulSet events can PVC retention configure independently?
6. Will editing a `volumeClaimTemplate` resize existing claims automatically?
7. Why can three StatefulSet database Pods still not be HA?
8. What extra components/capability do VolumeSnapshots require?
9. Why is a crash-consistent snapshot not always application-consistent?
10. What is the minimum useful proof that a backup is recoverable?
11. Which evidence distinguishes provisioning failure from mount failure?
12. What does cluster deletion do to kind's node-local storage?

---

## Answers

1. No; binding proves allocation. Scheduling, attach, mount, permissions, and application startup can still fail.
2. Provisioning/binding until a consuming Pod's scheduling/topology constraints are known.
3. No. RWO is one node; multiple Pods on that node may use it. RWOP expresses one-Pod intent when supported.
4. The PersistentVolume (`persistentVolumeReclaimPolicy`), usually inherited from the StorageClass for dynamic volumes.
5. StatefulSet deletion and scale-down (`whenDeleted`, `whenScaled`).
6. No; existing claims need a separate supported expansion workflow.
7. Stable identities do not configure replication, quorum, fencing, leader election, or failover.
8. Snapshot CRDs, snapshot controller, a VolumeSnapshotClass, and CSI driver snapshot support.
9. In-memory/in-flight database state may not form a valid transactional point without coordination/logs.
10. Restore into an isolated target and validate integrity plus application/business invariants within objectives.
11. PVC/provisioner events versus Pod, VolumeAttachment, CSI node, kubelet, filesystem, and mount events.
12. It destroys the node containers and their local-path data regardless of retained Kubernetes-object intent.

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
