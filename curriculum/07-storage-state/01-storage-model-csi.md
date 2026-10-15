# Storage Model and CSI

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Module overview](README.md) · Next: [Binding, topology, access, expansion, and lifecycle](02-binding-topology-lifecycle.md)

## Start with the lifetime requirement

A container writable layer disappears with the container. An `emptyDir`
belongs to a Pod: it survives container restarts but disappears when that Pod
object is removed. ConfigMap, Secret, projected, image, and CSI ephemeral
volumes solve other input or scratch-data problems. None is automatically a
database durability strategy.

Persistent storage separates four contracts:

| Object/component | Owner | Question it answers |
|---|---|---|
| PersistentVolumeClaim (PVC) | application namespace | What capacity, class, mode, and optional data source does the workload request? |
| PersistentVolume (PV) | cluster | Which concrete provisioned storage satisfies one claim? |
| StorageClass | platform | Which provisioner and lifecycle/topology/expansion policy implements a class of service? |
| CSI driver | storage/platform | How is backend storage created, attached, staged, mounted, resized, snapped, and deleted? |

A PVC and PV bind one-to-one. Capacity and access modes participate in the
match, but an access mode is an attachment/mount capability, not database
concurrency control. A bound PV has a lifecycle independent of an individual
Pod; the underlying backend's durability is still implementation-specific.

## Dynamic path

Trace a dynamically provisioned volume without skipping controllers:

1. The API stores a PVC naming a StorageClass.
2. Immediate binding starts provisioning now; `WaitForFirstConsumer` waits for
   a schedulable Pod so topology can be selected coherently.
3. An external CSI provisioner or implementation-specific provisioner creates
   backend storage and a PV, then binds it to the PVC.
4. The scheduler considers volume topology and attachment constraints.
5. CSI controller components attach the volume when required.
6. Kubelet calls the CSI node plugin to stage and publish/mount it.
7. The runtime starts the container with the requested mount.

Evidence spans PVC/PV status and events, StorageClass fields, Pod scheduling
events, `VolumeAttachment` where applicable, CSI controller/node logs, kubelet,
and the storage provider. `Bound` proves allocation, not a successful mount or
an application-consistent filesystem.

## CSI boundaries

CSI standardizes calls between an orchestrator and storage plugin; Kubernetes
sidecars commonly implement provisioning, attachment, resizing, snapshots, and
health integration around the driver. Capabilities are advertised, not
universal. Check the driver, StorageClass, snapshot CRDs/controller/class, and
backend before promising resize, clone, snapshot, RWX, encryption, or topology.

Inline `hostPath` is unsafe as a portable production abstraction and bypasses
the normal claim lifecycle. Local PVs and kind local-path volumes remain tied
to a node even though they use PV/PVC APIs. Network or cloud block storage may
reattach elsewhere, subject to zones, attachment limits, and fencing.

## Static versus dynamic provisioning

Static provisioning creates PVs ahead of claims and requires deliberate
capacity, class, topology, reclaim, and sanitization management. Dynamic
provisioning turns a PVC into backend allocation through a StorageClass. It
reduces ticket-driven operations but can also turn an accidental claim or
deletion into real cost or data loss. Admission, quotas, class design, and
recovery controls remain platform responsibilities.

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Module overview](README.md) · Next: [Binding, topology, access, expansion, and lifecycle](02-binding-topology-lifecycle.md)
