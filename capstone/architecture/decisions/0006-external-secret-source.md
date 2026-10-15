# ADR 0006: Use external secret sources with workload identity in production

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

CloudCart needs database, broker, TLS, and delivery credentials across
environments. Committing base64-encoded Kubernetes Secret manifests would expose
values through Git and CI. Manually generated cluster Secrets do not provide a
production source of truth, rotation workflow, cross-cluster recovery, or
central audit.

## Decision

Keep production secret values in an approved external secret manager and let
workloads/controllers authenticate with scoped, short-lived workload identity.
Select either a CSI-mounted-file pattern or controlled synchronization into
Kubernetes Secrets per consumer requirements and platform capabilities.

Do not commit plaintext or base64 values. Version only non-sensitive references,
policies, schemas, and delivery configuration. If synchronization creates a
Kubernetes Secret, enable API-data encryption, restrict direct and indirect
access, and treat etcd/backups as part of the secret boundary.

The local curriculum continues to generate random disposable credentials
directly in kind because it has no cloud identity or external manager.

## Consequences

Central policy, audit, versioning, and provider rotation improve, while provider,
identity, controller/CSI, network, and key-management availability become
dependencies. CSI mounts can avoid an etcd copy but require file consumption and
reload behavior. Synchronization supports native environment/Secret consumers
but materializes another copy and gives the controller sensitive permissions.

## Validation

- Prove a workload identity can access only its named secret paths.
- Confirm unauthorized service accounts and Pod-creation paths are denied.
- Rotate with overlapping versions, reload/roll consumers, verify business work,
  revoke the old version, and test rollback/provider outage behavior.
- Audit access without recording values and test recovery of identity, provider,
  encryption keys, and delivery controllers.
