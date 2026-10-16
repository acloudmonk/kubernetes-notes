# Pipelines, Artifacts, and Promotion

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Module overview](README.md) · Next: [Supply-chain evidence](02-supply-chain-evidence.md)

## Delivery model

Continuous integration converts a reviewed commit into test and build evidence.
Continuous delivery makes a verified release promotable; continuous deployment
automatically promotes when policy permits. A pipeline is not trusted merely
because it is automated: identity, source revision, dependency resolution,
runner isolation, approvals, and artifact destination are trust boundaries.

## Build once, promote the same bytes

Build an image and chart once, record their digests, and promote those identities
through environments. Rebuilding per environment creates different bytes and
breaks the claim that production runs what staging tested. Environment-specific
configuration is a separate reviewed input. Tags aid discovery; digests establish
identity. Retention must preserve everything needed for rollback and audit.

## Pipeline stages and evidence

A useful sequence is source validation → unit/integration tests → reproducible
build → SBOM → vulnerability/license policy → signature/provenance → publish →
promotion proposal → deployment reconciliation → user-level verification. Each
stage consumes explicit inputs and emits machine-readable results. A gate should
state what risk it controls, how exceptions expire, and who owns false positives.

## Identity and concurrency

Prefer workload federation and short-lived, repository/environment-scoped tokens
over stored cloud keys. Separate build/publish from promotion/deploy privileges.
Pin third-party pipeline actions by immutable commit, protect environments, and
serialize releases where concurrent writers could race. Cancellation stops the
runner, not necessarily an external publish or deployment already accepted.

## Failure and recovery

Make stages retry-safe and retain the first useful failure evidence. Caches are
performance inputs, not trusted outputs; keys and restoration rules must prevent
cross-branch poisoning. Recovery normally corrects source and reruns from known
artifacts. Do not edit production to make a pipeline green or silently waive a
policy without an auditable, time-bounded exception.

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Module overview](README.md) · Next: [Supply-chain evidence](02-supply-chain-evidence.md)
