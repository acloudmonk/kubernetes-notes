# 07 — Kubernetes Storage and State

**Status:** Verified<br>
**Estimated time:** 24–30 hours<br>
**Prerequisites:** [06 — Kubernetes Networking and Discovery](../06-networking-discovery/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Networking and discovery](../06-networking-discovery/README.md) · Next: [Configuration and secrets](../08-configuration-secrets/README.md)

## Why this matters

Restarting a stateless Pod is cheap; losing a database volume is not. Kubernetes
can request, attach, mount, retain, resize, snapshot, and reattach storage, but
it cannot decide application consistency, replication, backup, or recovery for
you. This module separates those responsibilities and tests them with CloudCart.

## Learning objectives

You can trace a claim from StorageClass through provisioning, binding,
scheduling, attachment, and mount; choose access modes and reclaim behavior;
operate StatefulSet identity and PVC retention; diagnose Pending and mount
failures; and design application-consistent backup and tested recovery.

## Contents

1. [Volumes, PVs, PVCs, StorageClasses, and CSI](01-storage-model-csi.md)
2. [Binding, topology, access, expansion, and lifecycle](02-binding-topology-lifecycle.md)
3. [StatefulSets and stable identity](03-statefulsets-identity.md)
4. [Data protection, backup, and recovery](04-data-protection-recovery.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Persist and trace CloudCart state](labs/01-persist-trace-cloudcart.md)
7. [Lab 2 — Break, recover, back up, and restore](labs/02-break-recover-restore.md)
8. [Independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)

## Tested baseline

Uses kind 0.33.0, Kubernetes 1.36.4, the kind `standard` local-path
StorageClass, PostgreSQL 17.11, and `cloudcart-app:0.1.0`. The lab requests a
1 GiB volume. Allow 5 GB memory, 8 GB disk, and local Docker image access.

The kind provisioner is node-local learning storage, not a highly available or
production durability claim. Snapshot APIs are studied but not installed
because the baseline driver does not provide a snapshot service.

## Completion

- [ ] **Explain:** trace PVC provisioning and distinguish Pod, claim, volume, and data lifecycles.
- [ ] **Build:** run CloudCart PostgreSQL with stable identity and persistent storage.
- [ ] **Diagnose:** repair a Pending claim and reason about topology/mount evidence.
- [ ] **Recover:** restore and validate an isolated database from a logical backup.
- [ ] Complete the independent challenge.

## Continue

Continue to [08 — Kubernetes Configuration and Secrets](../08-configuration-secrets/README.md),
or return to the [curriculum index](../README.md).
