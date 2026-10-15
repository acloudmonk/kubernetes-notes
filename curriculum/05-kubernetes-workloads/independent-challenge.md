# Independent Challenge

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Lab 2 — Fail, update, and recover](labs/02-fail-update-recover.md) · Next: [Troubleshooting](troubleshooting.md)

Deploy a small HTTP application with two replicas, non-secret configuration,
an uncommitted generated Secret, resource requests/limits, truthful probes, a
ClusterIP Service, and hardened container settings. Add a finite idempotent Job.
Seed one Pending, one CrashLoop, one readiness, and one image-pull incident in
turn; diagnose each before correction. Perform a successful update and rollback.

Acceptance evidence includes manifests, controller/owner graph, conditions and
Events, ready EndpointSlices, revision history, application response, preserved
failure logs, precise cleanup, and a Gate 2 rubric score of at least 2 in every
dimension. Do not reuse CloudCart names or copy its manifests verbatim.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Lab 2 — Fail, update, and recover](labs/02-fail-update-recover.md) · Next: [Troubleshooting](troubleshooting.md)
