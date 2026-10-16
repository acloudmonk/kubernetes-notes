# 14 — CI/CD, Supply Chain, and GitOps

**Status:** Verified<br>
**Estimated time:** 28–36 hours<br>
**Prerequisites:** [13 — Grafana and observability](../13-grafana-observability/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [Grafana and observability](../13-grafana-observability/README.md) · Next: [Infrastructure and production operations](../15-infrastructure-production-operations/README.md)

## Why this matters

A deployment is trustworthy only when teams can identify the reviewed source,
reproduce its artifacts, verify evidence, promote the same immutable bytes, and
observe a controller converge desired state. CI that can mutate production
directly, mutable image tags, unreviewed generated YAML, and “green scanner”
claims leave gaps between code and runtime.

This module builds a complete evidence chain for CloudCart: tests, image digest,
SBOM, vulnerability policy, Helm package, signature/provenance, promotion, Flux
reconciliation, drift correction, failed-release recovery, and audit boundaries.

## Learning objectives

You can design stage and trust boundaries; make builds reproducible; distinguish
artifacts from attestations; generate and validate SBOMs; apply vulnerability
policy without false certainty; explain signing, transparency, provenance, and
SLSA; promote digests; compare push delivery with GitOps; operate Flux sources,
Kustomizations, and HelmReleases; diagnose reconciliation; manage secrets and
identity; and recover safely from drift or a bad desired-state change.

## Contents

1. [Pipelines, artifacts, and promotion](01-pipelines-artifacts-promotion.md)
2. [SBOMs, scanning, signing, and provenance](02-supply-chain-evidence.md)
3. [GitOps and Flux reconciliation](03-gitops-flux-reconciliation.md)
4. [Progressive delivery, policy, and operations](04-delivery-policy-operations.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Build and verify supply-chain evidence](labs/01-build-verify-evidence.md)
7. [Lab 2 — Reconcile, drift, fail, and recover](labs/02-reconcile-drift-recover.md)
8. [Independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)

## Recorded baseline

Flux 2.9.6, Cosign 3.0.5, Syft 1.54.1, Grype 0.120.1, Helm 4.3.1,
kind 0.33.0, Kubernetes 1.36.4, Docker Engine 29.7.2, and CloudCart 0.1.0.
All generated keys, credentials, scanner databases, SBOMs, and packages belong
under ignored `tmp/module14`; none are committed.

Runtime verification produced and checked a CycloneDX SBOM, vulnerability
report, strict Helm lint/package, chart checksum, disposable Cosign signature,
and provenance summary. Flux fetched the exact feature-branch revision into a
disposable kind cluster; its source, Kustomization, and HelmRelease became
Ready; Helm drift correction restored a changed ConfigMap; and two consecutive
tests created distinct orders whose events increased the processed-event count.

## Completion

- [ ] **Explain:** trace source → evidence → promotion → reconciliation → runtime.
- [ ] **Build:** produce immutable artifacts and verifiable supply-chain evidence.
- [ ] **Diagnose:** isolate source, controller, Helm, workload, policy, and credential failures.
- [ ] **Recover:** correct drift and a failed release through the authoritative source.
- [ ] Complete the independent challenge.

## Continue

Continue to [15 — Infrastructure and production operations](../15-infrastructure-production-operations/README.md),
or return to the [curriculum index](../README.md).
