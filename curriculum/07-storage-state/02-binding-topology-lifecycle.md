# Binding, Topology, Access, Expansion, and Lifecycle

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Storage model and CSI](01-storage-model-csi.md) · Next: [StatefulSets and stable identity](03-statefulsets-identity.md)

## Binding and scheduling

`volumeBindingMode: Immediate` provisions/binds before a Pod is scheduled. For
topology-constrained storage this can select a zone or node the Pod cannot use.
`WaitForFirstConsumer` lets scheduling constraints—resource requests, node
selectors, affinity, taints, and storage topology—participate before binding.
Do not set `nodeName` with delayed binding; that bypasses normal scheduling and
can leave the claim Pending.

When a Pod is Pending, inspect both Pod and PVC events. Common causes include a
missing/default StorageClass, no matching static PV, unsupported access mode,
quota, capacity exhaustion, incompatible topology, provisioner failure, or a
PVC intentionally waiting for its first consumer.

## Access modes are not locking guarantees

- `ReadWriteOnce` (RWO): read-write mount by a single node; multiple Pods on
  that node may still access it.
- `ReadOnlyMany` (ROX): read-only mount by many nodes when supported.
- `ReadWriteMany` (RWX): read-write mount by many nodes when supported.
- `ReadWriteOncePod` (RWOP): read-write use by one Pod cluster-wide; CSI support
  and sufficiently current sidecars are required.

The requested mode must be supported by the driver/backend. Filesystem versus
raw-block volume mode is a separate decision. Even RWX does not make an
application safe for concurrent writers; the application and filesystem must
support that pattern.

## Reclaim and deletion

PVC deletion releases its PV. A `Delete` reclaim policy normally removes the PV
and backend asset; `Retain` preserves them for an explicit recovery/sanitization
workflow. Storage-object protection finalizers delay removal while a claim or
volume is still in use. They prevent unsafe ordering, not operator mistakes.

Think through four distinct actions:

| Action | Typical effect |
|---|---|
| Delete/restart container | mounted data remains |
| Delete Pod using a PVC | claim and volume remain; replacement can remount |
| Delete PVC | PV follows its reclaim policy after protection permits |
| Delete cluster/backend | Kubernetes retention fields may offer no protection |

For important data, protect deletion through RBAC/admission, use a Retain class
or provider protection where appropriate, and maintain independent backups.

## Expansion, cloning, and snapshots

PVC expansion requires `allowVolumeExpansion: true` and driver support. Increase
the claim request; do not edit PV capacity directly. Volumes grow, not shrink.
Controller expansion grows the device/backend; node/filesystem expansion may
complete on a mounted volume or during a later mount, depending on driver and
filesystem. Watch PVC conditions and events rather than assuming completion.

CSI volume cloning uses a PVC as a `dataSource`; snapshots use `VolumeSnapshot`,
`VolumeSnapshotContent`, and `VolumeSnapshotClass` plus snapshot CRDs, controller,
and driver capability. Crash-consistent storage snapshots capture blocks at a
point in time. Application-consistent recovery may require write quiescing,
database-native coordination, logs, and a tested restore sequence.

## Security and performance

Storage design includes encryption at rest and in transit, key ownership,
mount permissions, `fsGroup` behavior, backup access, tenant isolation,
sanitization, and audit. It also includes IOPS, throughput, latency, queue depth,
burst limits, filesystem choice, attachment limits, failure domains, capacity,
and cost. CPU/memory scaling cannot repair a storage latency bottleneck.

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Storage model and CSI](01-storage-model-csi.md) · Next: [StatefulSets and stable identity](03-statefulsets-identity.md)
