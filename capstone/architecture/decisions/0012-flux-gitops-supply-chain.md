# ADR 0012 — Use Flux with immutable supply-chain evidence

- **Status:** Accepted for the learning baseline
- **Date:** 2026-10-16

## Context

CloudCart has a tested Helm chart, but imperative CLI deployment does not prove
which reviewed source produced a running release. Module 14 needs a transparent
delivery path that separates artifact creation, promotion, reconciliation, and
runtime verification without committing registry or cluster credentials.

## Decision

Use Flux as the local GitOps reconciler. A Flux GitRepository and Kustomization
read the versioned module path; a HelmRelease installs the first-party CloudCart
chart while credentials remain externally generated. CI concepts produce an
immutable image digest, CycloneDX SBOM, vulnerability report, chart checksum,
signature bundle, and provenance statement before promotion.

The lab uses a public repository and branch only as a learning source. Production
must use protected promotion branches or immutable OCI sources, workload identity,
policy-enforced signature/provenance verification, and separated deployment roles.

## Consequences

- Git records desired state and Flux reports reconciliation evidence and drift.
- Helm remains the package/lifecycle engine; Flux becomes its authoritative writer.
- Artifact identity and deployment configuration are reviewable separately.
- Generated credentials, signing keys, scanner caches, and bundles stay in ignored
  temporary storage.
- Source availability, controller health, credentials, and policy become delivery
  dependencies that require monitoring and recovery.

## Alternatives considered

- Argo CD: strong UI and application model, but Flux is smaller for the transparent
  CLI/status-first local lab. Its concepts are still compared in the curriculum.
- CI directly running Helm: simple, but grants CI cluster write access and creates
  no continuous drift reconciliation.
- Mutable tags: convenient, but cannot identify the tested artifact.

## Validation

The lab must prove source and Kustomization readiness, HelmRelease convergence,
CloudCart business flow, deliberate drift correction, failed desired-state
recovery, no stored credentials, repeat execution, and precise cleanup.
