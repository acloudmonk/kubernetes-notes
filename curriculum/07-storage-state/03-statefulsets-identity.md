# StatefulSets and Stable Identity

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Binding, topology, access, expansion, and lifecycle](02-binding-topology-lifecycle.md) · Next: [Data protection, backup, and recovery](04-data-protection-recovery.md)

## What a StatefulSet guarantees

A StatefulSet maintains ordinal Pod identity (`name-0`, `name-1`), stable
network identity through its governing Service, and stable storage identity
when `volumeClaimTemplates` are used. Replacing `postgres-0` creates a new Pod
object with the same name and reuses `data-postgres-0`; it does not preserve the
old Pod UID, process, IP, memory, or in-flight connections.

`OrderedReady` creates lower ordinals first and removes higher ordinals first.
`Parallel` relaxes that ordering for applications that do not need it. Rolling
updates normally proceed from the highest ordinal downward. Partitions support
staged updates, but a bad update can require manual repair if readiness blocks
the ordered rollout.

## Governing and client Services

A headless governing Service (`clusterIP: None`) publishes Pod identities such
as `postgres-0.postgres-headless.cloudcart.svc`. A separate normal Service can
give clients a stable virtual endpoint. Stable DNS is not leader election,
replication, failover, or split-brain prevention; those belong to the database
or an operator that understands it.

`publishNotReadyAddresses` is useful for peers that must discover one another
before readiness, but it deliberately exposes unready addresses. Normal clients
should use a readiness-filtered client Service.

## PVC template lifecycle

Each ordinal receives one PVC per `volumeClaimTemplate`; templates do not update
existing claims automatically. The stable
`persistentVolumeClaimRetentionPolicy` controls StatefulSet-generated claims:

- `whenDeleted: Retain` keeps claims when the StatefulSet is deleted.
- `whenScaled: Retain` keeps claims for removed ordinals for later scale-up.
- `Delete` options allow garbage collection for data that is reconstructible.

Defaults retain claims. PVC retention and PV reclaim policy are different
layers: deleting a StatefulSet may delete or retain its PVC; if a PVC is deleted,
the PV's reclaim policy then decides the volume/backend lifecycle.

## StatefulSet does not make a database highly available

Scaling a standalone PostgreSQL image to three replicas creates three separate
databases, not one replicated database. Production data systems need
application-aware initialization, replication, membership, fencing, leader
election, failover, upgrades, backup, restore, and observability. A mature
operator or managed service can encode much of that lifecycle; it still needs
testing and an exit/recovery plan.

Use a Deployment when replicas are interchangeable and state is external or
reconstructible. Use a StatefulSet when stable ordinal/network/storage identity
is part of the application's protocol. Neither controller determines whether
running that database inside Kubernetes is the right organizational choice.

## CloudCart decision

The Module 07 lab uses one PostgreSQL StatefulSet replica to teach identity and
persistence. It is not labeled HA. RabbitMQ remains ephemeral here so the
exercise isolates database persistence; production RabbitMQ would require its
own clustering and durable-volume design or a managed broker.

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [Binding, topology, access, expansion, and lifecycle](02-binding-topology-lifecycle.md) · Next: [Data protection, backup, and recovery](04-data-protection-recovery.md)
