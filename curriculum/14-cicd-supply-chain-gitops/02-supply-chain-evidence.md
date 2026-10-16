# SBOMs, Scanning, Signing, and Provenance

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Pipelines and promotion](01-pipelines-artifacts-promotion.md) · Next: [GitOps and Flux](03-gitops-flux-reconciliation.md)

## Evidence types

An SBOM inventories components and relationships in a format such as SPDX or
CycloneDX. A vulnerability report matches that inventory to advisory data at a
particular time. A signature authenticates an artifact or attestation. Provenance
describes how an artifact was built—source, builder, invocation, and materials.
None substitutes for the others, and all must bind to the artifact digest.

## SBOM and vulnerability policy

Generate SBOMs from both build metadata and final artifacts when possible; each
view can miss data. Validate format, component identity, licenses, and completeness,
store it beside the artifact, and regenerate after dependency changes. Scanner
results depend on database freshness and package matching. Gates should consider
fix availability, reachability/context, exploitability, severity, ownership, and
expiring exceptions rather than claiming “zero vulnerabilities.”

## Signing and verification

Key-based signing requires protected private keys, rotation, recovery, and trust
distribution. Keyless signing binds an ephemeral certificate to an external
identity and transparency evidence, but verification must constrain issuer,
subject, workflow, repository, and artifact digest. A mathematically valid
signature from an unintended identity is not authorization.

## Provenance and SLSA

Provenance is valuable only when the verifier trusts the builder identity and
checks declared source/materials against policy. SLSA provides incremental
requirements for build integrity; it does not claim vulnerability-free code.
Attestations should be created by the controlled build boundary, not assembled
later from untrusted user input.

## Admission and promotion

Registry publication is not promotion. Promotion records that an immutable
digest and its evidence satisfy a target environment's policy. Admission can
enforce digest pins, approved registries, signatures, provenance, and exceptions,
but fail-closed policy affects availability. Stage policies, monitor denials,
protect break-glass access, and preserve audit evidence.

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Pipelines and promotion](01-pipelines-artifacts-promotion.md) · Next: [GitOps and Flux](03-gitops-flux-reconciliation.md)
