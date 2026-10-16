# Cumulative Production Review

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Lab 2 — Rehearse disruption and recovery](labs/02-rehearse-disruption-recovery.md) · Next: [Independent challenge](independent-challenge.md)

Review CloudCart as if it must enter production in 30 days. Use evidence from
[storage and recovery](../07-storage-state/README.md), [scheduling and
resources](../09-scheduling-resources/README.md), [observability](../13-grafana-observability/README.md),
and [GitOps/supply chain](../14-cicd-supply-chain-gitops/README.md).

Produce:

1. a shared-responsibility and RACI table for provider, platform, security,
   application, database, and incident roles;
2. a topology/capacity model for zone loss, rollout surge, platform DaemonSets,
   stateful placement, quotas, and recovery headroom;
3. an artifact-to-runtime trace covering digest, evidence, desired state,
   infrastructure plan, cluster reconciliation, and telemetry;
4. an RPO/RTO recovery sequence for infrastructure, identity, Kubernetes state,
   database, broker, secrets, DNS, and traffic;
5. a 45-minute game-day plan with hypothesis, stop conditions, signals,
   communications, cleanup, and acceptance evidence; and
6. three prioritized readiness gaps with owner, due date, risk, and verification.

Do not paste credentials, kubeconfigs, state, customer data, or raw diagnostic
bundles. A diagram without ownership, measurable objectives, and failure evidence
does not pass.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Lab 2 — Rehearse disruption and recovery](labs/02-rehearse-disruption-recovery.md) · Next: [Independent challenge](independent-challenge.md)
