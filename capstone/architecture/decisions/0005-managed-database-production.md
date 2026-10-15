# ADR 0005: Use a StatefulSet for learning and managed PostgreSQL for production

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

CloudCart needs durable relational state. The curriculum must teach Kubernetes
storage APIs, StatefulSet identity, failure behavior, and recovery without
presenting a single database Pod as a production architecture. Operating
PostgreSQL inside Kubernetes also requires replication, fencing, failover,
upgrades, backup, restore, monitoring, and specialist ownership beyond merely
mounting a PVC.

## Decision

Use a single PostgreSQL StatefulSet with a dynamically provisioned, retained PVC
only for the local Module 07 learning environment. Use a provider-managed
PostgreSQL service as the default production direction when organizational,
compliance, latency, availability, and portability requirements allow it.

If production requirements later demand in-cluster PostgreSQL, select a mature
operator through a separate ADR and prove replication, fencing, disruption,
upgrade, backup, point-in-time recovery, and disaster recovery before adoption.

## Consequences

The local lab exposes Kubernetes storage reconciliation and remains inexpensive
and disposable. It is intentionally not HA and its node-local kind volume does
not survive node or cluster deletion. Managed production PostgreSQL reduces the
platform team's database lifecycle burden but introduces provider dependency,
network/IAM integration, service limits, and cost that must be assessed.

Both paths still require explicit RPO/RTO, encrypted and access-controlled
backups, isolated restore tests, migration discipline, observability, and
application-level recovery validation.

## Validation

- Replace the PostgreSQL Pod and prove its original PVC/PV and data are reused.
- Restore a logical backup into an isolated database and verify business data.
- Record node/cluster failure limits of the local provisioner.
- Before production, test the selected service's failover, maintenance,
  backup/PITR, restore, credential rotation, and application reconnection.
