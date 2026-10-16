# Study Plan

> **Navigation:** [Execution kit](README.md) ·
> [Progress tracker](PROGRESS.md) ·
> [Curriculum roadmap](../ROADMAP.md)

The module estimates total approximately 382–492 hours. The standard plan uses
48 weeks at 8–12 focused hours per week, leaving room for gates and spaced
review. The ranges are planning boundaries, not deadlines. Pause and reassess
when a competency dimension scores below 2.

## Standard 48-week path

| Weeks | Module | Required outcome before continuing |
|---:|---|---|
| 1 | [00 — Prerequisites](../curriculum/00-prerequisites/README.md) | Trace process, network, configuration, Git, and distributed-failure boundaries |
| 2 | [01 — Container fundamentals](../curriculum/01-container-fundamentals/README.md) | Explain runtime, isolation, image, filesystem, and lifecycle mechanics |
| 3–4 | [02 — Docker](../curriculum/02-docker/README.md) | Pass [Gate 1](../curriculum/ASSESSMENT-GATES.md#gate-1--container-practitioner) |
| 5–7 | [03 — Microservices and distributed data](../curriculum/03-microservices-distributed-data/README.md) | Defend boundaries and prove idempotent synchronous/asynchronous behavior |
| 8–9 | [04 — Kubernetes architecture](../curriculum/04-kubernetes-architecture/README.md) | Trace API, control-plane, node, and reconciliation behavior |
| 10–12 | [05 — Kubernetes workloads](../curriculum/05-kubernetes-workloads/README.md) | Pass [Gate 2](../curriculum/ASSESSMENT-GATES.md#gate-2--kubernetes-application-operator) |
| 13–15 | [06 — Networking and discovery](../curriculum/06-networking-discovery/README.md) | Trace and repair discovery, routing, policy, and TLS paths |
| 16–18 | [07 — Storage and state](../curriculum/07-storage-state/README.md) | Provision, protect, diagnose, back up, and restore state |
| 19–21 | [08 — Configuration and secrets](../curriculum/08-configuration-secrets/README.md) | Demonstrate safe delivery, update, rotation, and failure recovery |
| 22–24 | [09 — Scheduling and resources](../curriculum/09-scheduling-resources/README.md) | Defend placement, requests, limits, disruption, and scaling behavior |
| 25–27 | [10 — Security and policy](../curriculum/10-security-policy/README.md) | Apply least privilege and diagnose identity, admission, and runtime controls |
| 28–30 | [11 — Helm](../curriculum/11-helm/README.md) | Pass [Gate 3](../curriculum/ASSESSMENT-GATES.md#gate-3--kubernetes-platform-practitioner) |
| 31–33 | [12 — Prometheus](../curriculum/12-prometheus/README.md) | Instrument, query, alert, and control cardinality |
| 34–36 | [13 — Grafana and observability](../curriculum/13-grafana-observability/README.md) | Pass [Gate 4](../curriculum/ASSESSMENT-GATES.md#gate-4--observability-practitioner) |
| 37–39 | [14 — CI/CD, supply chain, and GitOps](../curriculum/14-cicd-supply-chain-gitops/README.md) | Trace reviewed source to verified artifact, desired state, and runtime |
| 40–43 | [15 — Infrastructure and production operations](../curriculum/15-infrastructure-production-operations/README.md) | Rehearse capacity, disruption, upgrade, recovery, incident, and cost decisions |
| 44–48 | [16 — Advanced Kubernetes](../curriculum/16-advanced-kubernetes/README.md) | Pass [Gate 5](../curriculum/ASSESSMENT-GATES.md#gate-5--production-readiness) and complete the [graduation review](../capstone/GRADUATION.md) |

## Weekly rhythm

Use the repository's 30/60/10 balance across the week:

- **Theory — 30%:** concepts, internals, primary references, and selected videos.
- **Hands-on — 60%:** exercises, guided labs, controlled failures, and the
  evolving CloudCart capstone.
- **Explanation — 10%:** interview responses, diagrams, ADRs, evidence summaries,
  and recall without notes.

A practical session sequence is predict → execute → observe → explain → break →
diagnose → recover → clean up. Do not paste a solution before recording a
hypothesis and the evidence that would falsify it.

## Faster paths

Faster paths preserve every lab, assessment, failure, cleanup, and gate. They
change weekly time or use demonstrated prior knowledge; they do not omit scope.

- **36-week accelerated:** approximately 11–14 hours per week plus diagnostic
  credit for existing skills.
- **26-week intensive:** approximately 15–20 hours per week. This is a demanding
  workload, not the 8–12-hour default.

Return to the standard pace when any gate dimension is below 2, total score is
below 7, cleanup is incomplete, retention declines, or the learner can replay
commands but cannot adapt them to a changed failure.

## Gate weeks

Treat a gate as a practical review, not an open-book rerun. Start from a clean
environment, use a changed scenario, time-box the incident portion, and preserve
only sanitized evidence. A failed dimension becomes the next study objective;
it is not averaged away by a stronger dimension.

## Completion

The program completes when Gate 5 and the CloudCart graduation review pass.
Finishing week 48 without that evidence means the schedule ended, not that the
learning objective was achieved.

---

[Execution kit](README.md) · [Progress tracker](PROGRESS.md) ·
[Begin Module 00](../curriculum/00-prerequisites/README.md)
