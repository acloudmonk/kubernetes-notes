# Troubleshooting

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

## Evidence order

1. Confirm commit/ref, artifact digests, evidence identity, and promotion decision.
2. Inspect Flux source artifact revision and readiness.
3. Inspect Kustomization build/apply/health conditions and inventory.
4. Inspect HelmRelease history, values, hooks, and remediation.
5. Inspect admission, workloads, dependencies, and user-level signals.

| Symptom | Evidence | Likely boundary |
|---|---|---|
| SBOM empty/incomplete | source type, selected image digest, cataloger logs | image availability or cataloging |
| Scan changes without image change | vulnerability database timestamp/version | advisory intelligence |
| Signature verifies for wrong workflow | certificate issuer/subject claims | verification policy |
| GitRepository not Ready | URL/ref/auth/TLS, source-controller logs | source fetch |
| Kustomization build failure | path, kustomization, substitutions | render |
| Apply failure | API response, admission, field ownership | cluster write |
| HelmRelease stalled | revision, hooks, Jobs, workload conditions | Helm/runtime |
| Manual fix disappears | managed fields and Flux inventory | expected reconciliation |

Do not suspend controllers indefinitely or delete finalizers/status to hide a
failure. If emergency mutation is required, record it, correct source, resume,
and verify convergence. Never print credentials while diagnosing source access.

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
