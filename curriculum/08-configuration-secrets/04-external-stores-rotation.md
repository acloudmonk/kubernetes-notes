# External Stores and Rotation

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Consumption and update semantics](03-consumption-update-semantics.md) · Next: [Quick exercises](quick-exercises.md)

## Choose the source of truth deliberately

Common patterns have different exposure and lifecycle properties:

| Pattern | Kubernetes Secret copy? | Strength | Tradeoff |
|---|---:|---|---|
| Pipeline creates Secret | yes | simple native consumption | CI handles plaintext and rotation/reconciliation |
| Encrypted Git artifact/controller | yes | reviewable desired state | decryption identity/key and plaintext Secret still matter |
| External Secrets-style sync | yes | external source with native Secret consumers | controller has broad read/write power; copy exists in etcd |
| Secrets Store CSI volume | optional | provider value mounted through CSI; can avoid API copy | provider/driver/identity availability, file-only integration, rotation reload |
| Application fetches store directly | no | app controls lease/renewal and can avoid copies | SDK coupling, identity, caching, bootstrap, failure handling |

Use workload identity to authenticate to the external store instead of storing a
long-lived credential that merely unlocks other credentials. Scope identity by
namespace/service account/workload and secret path, with audit and short leases.
Controller compromise, CRD visibility, admission behavior, provider outage, and
revocation must be included in the threat model.

## Rotation is a distributed change

Rotation spans credential issuer/backend, source of truth, synchronized or
mounted copy, Pods/application caches and connection pools, rollout/reload,
verification, old-credential revocation, and recovery. Updating a Secret alone
creates drift if the database or broker still accepts only the old value.

Prefer overlapping credentials or versions:

1. Create a new credential while the old remains valid.
2. Publish/deliver the new version.
3. Roll/reload consumers gradually and verify authentication plus business work.
4. Observe stragglers using version metadata, never secret values.
5. Revoke the old credential and verify rejection.
6. Remove old material after the recovery window and audit completion.

Some systems expose only one password. Plan a bounded maintenance/change window,
connection behavior, ordering, rollback, and monitoring. CloudCart's disposable
lab changes PostgreSQL first, replaces the Kubernetes Secret through stdin,
restarts consumers, creates an order, and restores the previous lab credential
if the sequence fails. Production should prefer dual credentials where possible.

## Rotation cadence and emergencies

Cadence follows credential lifetime, exposure risk, compliance, and system
capability—not a universal number. Automate renewal before expiry with jitter,
alerts, ownership, and tested failure behavior. Emergency rotation prioritizes
containment and revocation but still needs dependency inventory and verification.

Certificates require issuer trust, SAN/audience, chain, clock, overlapping trust
bundles, renewal, reload, and revocation decisions. API keys, database passwords,
signing keys, and encryption keys each need different transition procedures;
do not call one generic restart script a rotation strategy.

> **Module:** [08 — Kubernetes Configuration and Secrets](README.md) · Previous: [Consumption and update semantics](03-consumption-update-semantics.md) · Next: [Quick exercises](quick-exercises.md)
