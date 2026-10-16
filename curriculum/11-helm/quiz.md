# Knowledge Check

> **Module:** [11 — Helm](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
Answer every question before reading the answer section.

1. Does `helm template` contact the Kubernetes API server?
2. Which value source wins: chart default, first `-f`, second `-f`, or `--set`?
3. Does `appVersion` control the container image automatically?
4. Why can `--set-string` be safer for a value such as `00123`?
5. Does a successful lint prove the application will become Ready?
6. Does rollback restore database contents changed by a migration?
7. Why is a checksum annotation placed on a Pod template?
8. Are hook-created resources managed like ordinary release resources?
9. Does Helm automatically upgrade and delete CRDs from `crds/`?
10. Why install an OCI chart by digest rather than a mutable tag?
11. Should a CLI user and GitOps controller manage the same release concurrently?
12. Which evidence distinguishes a chart render from the manifest stored for a revision?

---

## Answers

1. No; it renders locally, although capability flags affect the simulated API context.
2. `--set`; later files override earlier files for overlapping values.
3. No. The template must explicitly use whatever image value the contract defines.
4. It prevents type inference from dropping leading zeroes or changing the value's type.
5. No. Lint cannot prove API admission, scheduling, dependency health, or behavior.
6. No. Rollback reapplies Kubernetes resources; data recovery needs its own design.
7. Changing the checksum changes the Pod template hash and triggers a rollout.
8. No. Hook lifecycle and deletion must be designed explicitly.
9. No. CRD lifecycle is intentionally conservative and separately owned.
10. A digest identifies the exact content that was tested and approved.
11. No. Competing authoritative writers create drift and unpredictable ownership.
12. Compare a reproducible `helm template` with `helm get manifest` for that release/revision and its effective values/chart.

> **Module:** [11 — Helm](README.md) · Previous: [Interview questions](interview-questions.md) · Next: [References and videos](references.md)
