# ADR 0009: Package CloudCart as a first-party Helm release

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

CloudCart's plain manifests demonstrate Kubernetes mechanics but duplicate
configuration across modules and do not define a versioned consumer interface.
The learning path needs repeatable rendering, validation, installation,
upgrade, failure, rollback, testing, and distribution exercises without
claiming that local stateful dependencies are production-ready.

## Decision

Maintain a first-party application chart with a small schema-validated values
contract. The chart owns CloudCart workloads, Services, configuration,
identities, migration Job, and disposable learning dependencies. A credential
Secret is a prerequisite with separate ownership; secret values never enter
chart defaults, overrides, archives, or release state.

Use SemVer for immutable chart packages and promote the tested package and image
digests. Database migrations must be idempotent, observable, compatibility-
reviewed, and tested independently of rollback. Production uses managed
PostgreSQL and an explicitly designed broker/secret solution. One deployment
system—CLI automation or a GitOps controller—owns a release at a time.

## Consequences

Learners operate one coherent release and can validate interface errors before
the API server. Chart changes now require contract/version review and lifecycle
tests. Helm adds release state, template complexity, and ownership rules; it
does not provide continuous reconciliation, secret management, database
recovery, or production HA.

The local chart deliberately repeats some dependency manifests so their
behavior remains inspectable. A future production chart may replace them with
external endpoints or separately governed dependencies rather than embedding
larger third-party subcharts.

## Validation

- Lint, schema, render, server dry run, install, wait, and chart test.
- Prove a configuration rollout and an intentionally failed image upgrade.
- Roll back, then verify the complete application event path and data behavior.
- Inspect the packaged archive and confirm no credential value or unnecessary
  file is present.
- Repeat the workflow from a clean disposable cluster and clean it precisely.
