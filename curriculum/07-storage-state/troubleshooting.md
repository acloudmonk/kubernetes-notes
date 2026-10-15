# Troubleshooting Storage and State

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

## Evidence order

1. Confirm context, namespace, object name, and recent changes.
2. Inspect Pod phase/conditions/events and PVC phase/events together.
3. Inspect StorageClass provisioner, binding mode, reclaim, expansion, parameters.
4. Inspect bound PV claimRef, capacity, modes, source/CSI driver, and node affinity.
5. Check scheduler constraints, CSI controller/node Pods, `VolumeAttachment`, and
   driver/provider events where applicable.
6. On the node, distinguish attach, stage, mount, permission, filesystem, and
   capacity failures from application startup failures.
7. Verify recovery at the application layer, not merely `Bound` or `Mounted`.

## Symptom map

| Symptom | Likely boundary | Evidence/correction |
|---|---|---|
| PVC Pending, no class | default/class selection | name an existing class or establish one intentionally |
| PVC says waiting for consumer | delayed binding | create/inspect the consuming Pod and scheduler constraints |
| Pod Pending, topology conflict | scheduling + PV affinity | align placement and storage topology; do not force `nodeName` |
| `FailedAttachVolume` | controller/backend | attachment limits, stale attachment, zone, permissions, provider health |
| `FailedMount` | node/filesystem/permissions | CSI node/kubelet events, device, fs, mount options, ownership |
| Bound but app fails | application/path/identity | mount path, data layout, UID/GID/fsGroup, engine logs and probes |
| Resize remains pending | class/driver/node expansion | class flag, driver capability, PVC conditions, filesystem support |
| StatefulSet rollout stuck | ordered readiness | first failing ordinal, revision, image/config/data compatibility |
| Backup job succeeded, restore fails | recovery design | archive integrity, versions, roles/extensions, keys, logs, runbook |

Never fix an unknown mount problem by deleting the PVC. Capture names, UIDs,
events, claimRef, reclaim policy, backend identity, and a recovery point first.

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
