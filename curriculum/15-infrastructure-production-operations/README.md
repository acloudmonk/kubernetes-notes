# 15 — Infrastructure and Production Operations

**Status:** Verified<br>
**Estimated time:** 30–40 hours<br>
**Prerequisites:** [14 — CI/CD, supply chain, and GitOps](../14-cicd-supply-chain-gitops/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous: [CI/CD, supply chain, and GitOps](../14-cicd-supply-chain-gitops/README.md) · Next: [Advanced Kubernetes](../16-advanced-kubernetes/README.md)

## Why this matters

Production Kubernetes is a socio-technical system, not only a cluster. Network,
identity, state, node pools, add-ons, delivery, recovery, cost, and ownership
must converge under tested change and incident processes. A managed control
plane reduces toil but does not operate workloads or accept business risk.

## Learning objectives

You can design reviewable infrastructure as code; protect state and credentials;
evaluate managed Kubernetes responsibility; plan networking, identity, node
pools, add-ons, capacity, availability, tenancy, and cost; execute an upgrade;
define RPO/RTO; rehearse restoration; and run evidence-led incidents and
blameless reviews.

## Contents

1. [Infrastructure as code, state, and change](01-infrastructure-as-code-state.md)
2. [Managed Kubernetes platform design](02-managed-kubernetes-platform.md)
3. [Capacity, availability, tenancy, and cost](03-capacity-availability-cost.md)
4. [Upgrades, recovery, and incident operations](04-upgrades-recovery-incidents.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Model and test a production topology](labs/01-model-test-topology.md)
7. [Lab 2 — Rehearse disruption and recovery](labs/02-rehearse-disruption-recovery.md)
8. [Cumulative production review](cumulative-exercise.md)
9. [Independent challenge](independent-challenge.md)
10. [Troubleshooting](troubleshooting.md)
11. [Interview questions](interview-questions.md)
12. [Knowledge check](quiz.md)
13. [References and videos](references.md)

## Recorded baseline

Terraform 1.14.8, Helm 4.3.1, kind 0.33.0, Kubernetes 1.36.4,
kubectl 1.36.1, Docker Engine 29.7.2, and CloudCart 0.1.0. The Terraform lab is
provider-free and creates no billable resources. The Kubernetes lab is local;
generated state, plans, kubeconfigs, credentials, backups, and tools stay under
ignored `tmp/module15` or tool-managed temporary storage and are removed.

Runtime verification passed three provider-free Terraform tests, strict Helm
lint, server-side manifest validation, chart installation and upgrade, and two
consecutive operations rehearsals. Each rehearsal began with API replicas on
separate workers, retained one available replica during a PDB-aware drain,
completed a distinct order/event path, restored PostgreSQL into an isolated
database with matching order counts, removed restore artifacts, and returned
the drained node and API deployment to service.

## Completion

- [ ] **Explain:** defend platform, ownership, state, capacity, cost, and recovery boundaries.
- [ ] **Build:** validate a production topology and operate a disposable rehearsal environment.
- [ ] **Diagnose:** separate IaC, control-plane, node, workload, storage, and dependency failures.
- [ ] **Recover:** demonstrate disruption tolerance and an isolated data restore against stated objectives.
- [ ] Complete the cumulative exercise and independent challenge.

## Continue

Continue to [16 — Advanced Kubernetes](../16-advanced-kubernetes/README.md),
or return to the [curriculum index](../README.md).
