# Progressive Delivery, Policy, and Operations

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [GitOps and Flux](03-gitops-flux-reconciliation.md) · Next: [Quick exercises](quick-exercises.md)

## Release strategies

Rolling updates replace capacity incrementally. Blue/green maintains two complete
environments and switches traffic. Canary exposes a bounded population and uses
analysis before expansion. Strategy names do not guarantee safety: capacity,
session behavior, message consumers, database compatibility, observability, and
abort mechanics decide the real blast radius.

## Verification and rollback

Verify controller health, workload availability, dependency compatibility, and
user-level outcomes. Automated analysis needs a baseline, minimum traffic, stable
queries, bounded evaluation, and a safe no-data decision. Git revert changes
desired state; Helm rollback creates another release revision; neither reverses
database changes or external effects. Prefer forward-compatible expand/contract
and explicit recovery.

## Policy boundaries

CI policy prevents publication or promotion; admission policy prevents cluster
writes; runtime controls limit execution. Use all where their evidence exists,
but avoid duplicating inconsistent rules. Policy bundles are versioned artifacts
requiring tests, staged rollout, ownership, telemetry, and emergency procedures.

## Operating GitOps

Monitor source fetches, reconciliation duration/errors, queue depth, suspended
objects, stale observed generations, artifact storage, API throttling, Helm
actions, and notification delivery. Back up source and external state; controllers
can be reinstalled, but recovery also needs registry artifacts, credentials,
encryption keys, CRDs, data, and documented ordering.

## Incident model

First decide whether source is correct, reachable, and verified. Then inspect
Source readiness, Kustomization build/apply/health, HelmRelease status, admission,
workload conditions, and user signals. Correct the authoritative layer. Direct
cluster repair may be necessary for containment, but record it and reconcile the
source before declaring recovery.

> **Module:** [14 — CI/CD, Supply Chain, and GitOps](README.md) · Previous: [GitOps and Flux](03-gitops-flux-reconciliation.md) · Next: [Quick exercises](quick-exercises.md)
