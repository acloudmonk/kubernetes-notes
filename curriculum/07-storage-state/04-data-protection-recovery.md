# Data Protection, Backup, and Recovery

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [StatefulSets and stable identity](03-statefulsets-identity.md) · Next: [Quick exercises](quick-exercises.md)

## Persistence is not backup

A PVC protects data from an ordinary Pod replacement. It does not protect
against application corruption, accidental deletion, compromised credentials,
bad migrations, storage/backend failure, cluster loss, or a reclaim-policy
mistake. Replication improves availability but can replicate deletion or
corruption. A snapshot can share the source system's failure domain. A backup
must be recoverable independently enough to meet the threat model.

Define objectives before tooling:

- RPO: maximum acceptable data loss measured in time or transactions.
- RTO: maximum acceptable time to restore useful service.
- Retention: how many restore points exist and for how long.
- Recovery scope: row/table, database, volume, namespace, cluster, region.
- Consistency: crash-, filesystem-, or application-consistent.
- Security: encryption, immutability, access separation, audit, and deletion.

## Database-aware protection

Logical dumps are portable and useful for schema/object-level recovery, but can
be slower for large databases and must capture roles/extensions separately when
needed. Physical/base backups plus write-ahead logs support faster full recovery
and point-in-time recovery but are version- and engine-aware. Storage snapshots
can be fast; coordinate them with the database and retain required logs.

Back up configuration and recovery metadata as well as bytes: engine version,
extensions, schema migrations, roles, keys, backup catalog, checksums, and the
runbook. Never commit real dumps or credentials. Store them in approved,
encrypted locations with least-privilege identities and retention controls.

## Restore is the evidence

A successful backup job proves only that a job completed. Recovery evidence is
an isolated restore with integrity and application checks:

1. Select a restore point that meets the incident and RPO.
2. Restore into an isolated target; do not overwrite the only good copy.
3. Verify archive checksum/authenticity and engine compatibility.
4. Run database checks plus business invariants and representative reads.
5. Reconcile messages, caches, search indexes, and external side effects.
6. Decide cutover, DNS/connection handling, and rollback criteria.
7. Record achieved RPO/RTO, gaps, ownership, and follow-up actions.

CloudCart's lab restores a custom-format PostgreSQL archive into a separate
database and compares order counts before cleanup. Count equality is a useful
lab assertion, not sufficient production validation.

## Failure-domain planning

Map node, rack/zone, storage array/account, cluster, credential, region, and
operator failure domains. Node-local kind storage demonstrates API mechanics
but cannot survive deletion of its kind node or cluster. Production choices
should state topology, replication, quorum, fencing, disruption behavior,
backup location, cross-region needs, and tested recovery ownership.

> **Module:** [07 — Kubernetes Storage and State](README.md) · Previous: [StatefulSets and stable identity](03-statefulsets-identity.md) · Next: [Quick exercises](quick-exercises.md)
