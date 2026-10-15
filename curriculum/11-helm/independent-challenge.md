# Independent Challenge

> **Module:** [11 — Helm](README.md) · Previous: [Lab 2 — Upgrade, fail, and roll back](labs/02-upgrade-fail-rollback.md) · Next: [Troubleshooting](troubleshooting.md)

## Brief

Without copying the CloudCart templates, package a small HTTP application and a
one-shot migration or initialization task as a chart. Support two environments
through explicit values files while keeping credentials external.

## Required evidence

- a documented, schema-validated values API with safe defaults;
- deterministic names, standard labels, selectors, security contexts,
  resources, probes, and tokenless ServiceAccounts where appropriate;
- immutable image selection and a configuration checksum rollout;
- a test Pod or Job that checks behavior, not only object existence;
- CI-style lint, render, policy, API validation, install, upgrade, failure,
  rollback, package, and archive-inspection evidence;
- a release/ownership table covering Secrets, PVCs, migrations, and cleanup;
- a migration compatibility plan and explanation of rollback limits;
- chart version, app version, and image version policy;
- an OCI promotion plan that identifies the exact immutable artifact;
- a short GitOps ownership design with one authoritative writer.

## Failure injections

Diagnose at least two: wrong value type, missing Secret, immutable-field change,
unavailable image, failing migration, selector mismatch, hook left behind, or
admission denial. Begin with rendered output and release history; use events,
conditions, logs, and live objects to isolate the Kubernetes failure.

## Review rubric

Pass only when another learner can reproduce the work without receiving a
credential, understand every exposed value, predict cleanup, and recover the
release while preserving data. Bonus complexity does not compensate for an
unclear contract.

> **Module:** [11 — Helm](README.md) · Previous: [Lab 2 — Upgrade, fail, and roll back](labs/02-upgrade-fail-rollback.md) · Next: [Troubleshooting](troubleshooting.md)
