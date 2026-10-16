# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

## Fundamentals and internals

### 1. What are a PersistentVolume, PersistentVolumeClaim, and StorageClass?

**Answer:** A PVC is a namespaced workload request for storage. A PV is the
cluster-scoped resource bound to that request and represents provisioned storage.
A StorageClass describes a provisioning implementation and policy such as
parameters, binding mode, expansion support, and reclaim behavior. These API
objects describe lifecycle and attachment; they do not make application data
consistent or backed up.

### 2. Trace dynamic volume provisioning and mounting.

**Answer:** A claim is admitted, then the binder and external CSI provisioner
coordinate allocation using its StorageClass. With delayed binding, scheduling
constraints help select topology before provisioning. After PV/PVC binding and
Pod scheduling, CSI controller operations may attach the volume; kubelet invokes
CSI node operations to stage and publish it into the Pod. Each boundary emits
different Events and status, so “PVC is Bound” proves allocation, not mounting.

### 3. How do `ReadWriteOnce` and `ReadWriteOncePod` differ?

**Answer:** RWO permits read-write mounting from one node; multiple Pods on that
node may still use it. RWOP expresses exclusive read-write use by one Pod across
the cluster and depends on compatible CSI components. Neither mode provides
database locking, replication, or fencing. Confirm driver support and test the
actual rescheduling and attachment behavior.

### 4. Why use `WaitForFirstConsumer`?

**Answer:** Immediate provisioning can allocate storage in a topology that no
eligible workload node can access. `WaitForFirstConsumer` delays provisioning
or binding until the scheduler knows the consuming Pod's placement constraints,
allowing storage and compute topology to agree. The tradeoff is that a claim may
remain Pending until a consumer exists, which is expected rather than failure.

## Stateful design and lifecycle

### 5. What survives StatefulSet Pod replacement?

**Answer:** The ordinal Pod name, stable DNS identity, ordering semantics, and
the mapping from each `volumeClaimTemplate` claim to its ordinal can survive.
The Pod UID, IP, processes, memory, and connections do not. Claim retention and
PV reclaim policies independently decide what happens during scale-down,
StatefulSet deletion, and claim deletion.

### 6. How do `Retain` and `Delete` reclaim policies differ?

**Answer:** `Delete` asks the provisioner to remove backend storage after the
released PV lifecycle, reducing orphaned cost but increasing accidental-loss
risk. `Retain` preserves the PV/backend for explicit recovery, sanitization, or
reuse and therefore needs ownership, access control, cost monitoring, and a
documented cleanup procedure. The policy is on the PV and is not a backup.

### 7. Why is replication not backup?

**Answer:** Replication improves availability by maintaining additional current
copies, but it commonly propagates deletion, corruption, malicious writes, and
software defects. Replicas can also share credentials, control planes, or failure
domains. A backup has separate retention and recovery properties, and it is only
credible after an isolated restore validates integrity and business invariants.

### 8. When should a database run as a StatefulSet versus a managed service?

**Answer:** Decide from operational expertise, required control, latency, data
gravity, portability, compliance, cost, and provider dependency. In-cluster
operation gives control but transfers responsibility for quorum, fencing,
upgrades, backup, restore, capacity, and on-call response. A managed service
reduces some toil but does not remove schema, access, recovery validation, cost,
or application resilience responsibilities.

## Troubleshooting, security, and recovery

### 9. Why is a PVC Pending?

**Answer:** Check claim Events and StorageClass first. Causes include a missing
or wrong default class, delayed binding without a consumer, unsupported access
mode, quota, lack of matching static capacity, topology conflict, or provisioner
failure. Do not edit randomly: identify whether admission, binding, scheduling,
or provisioning owns the current wait.

### 10. A PVC is Bound but the Pod reports `FailedMount`. What succeeded and what failed?

**Answer:** Allocation and binding succeeded. Investigate VolumeAttachment and
Pod Events, CSI controller/node Pods, kubelet logs, device/filesystem state,
mount options, permissions, node topology, and multi-attach rules. Recreating
the claim risks data loss and does not repair a node-side mount problem.

### 11. What belongs in a storage security design?

**Answer:** Include least-privilege API and backend access, tenant and node
isolation, encryption with separated key control, filesystem ownership, snapshot
and backup access, immutable or offline copies, audit, retention, secure deletion,
and incident recovery. A Pod able to mount a claim can read its data regardless
of whether the user can directly read a Secret containing database credentials.

### 12. What proves a backup is recoverable?

**Answer:** Restore it into an isolated, version-compatible target using a
documented procedure. Validate checksums or database integrity, schema and row
expectations, application business invariants, dependent-system reconciliation,
and measured RPO/RTO. A successful backup command, object existence, or
crash-consistent snapshot alone is insufficient evidence.

**Follow-up:** How are encryption keys and external objects restored without
reconnecting the isolated test to production?

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
