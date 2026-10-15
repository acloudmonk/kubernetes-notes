# Competency Gates

Competency gates test integrated ability rather than command recall. Evidence
may include configuration, terminal output, diagrams, ADRs, incident notes, and
a short explanation. Never submit credentials or private diagnostic data.

## Scoring rubric

| Score | Explain | Build | Diagnose |
|---:|---|---|---|
| 0 | Cannot describe behavior | Cannot produce a working system | Guesses without evidence |
| 1 | Recalls terms with major gaps | Works only by copying steps | Collects unrelated evidence |
| 2 | Explains mechanism and limits | Reproducible with minor help | Isolates and corrects the fault |
| 3 | Justifies tradeoffs | Secure, tested, maintainable | Finds root cause and prevents recurrence |

A gate requires at least 2 in every dimension. A total below 7 means the
weakest dimension should be repeated before continuing.

## Gate 1 — Container practitioner

**After Module 02**

- Build a versioned, non-root image with an efficient layer strategy.
- Explain runtime, namespace, cgroup, image, and writable-layer behavior.
- Verify CPU, memory, filesystem, identity, and signal configuration.
- Diagnose exit, port, permission, and resource failures.
- Produce and safely clean up a Compose environment.

## Gate 2 — Kubernetes application operator

**After Module 05**

- Deploy with configuration, probes, resources, and rollout behavior using
  plain manifests.
- Trace API validation, reconciliation, scheduling, image acquisition, startup,
  and readiness.
- Perform an update and rollback.
- Diagnose Pending, image-pull, crash-loop, and readiness failures.

## Gate 3 — Kubernetes platform practitioner

**After Module 11**

- Operate discovery, routing, storage, placement, identity, policy, disruption,
  and Helm release state.
- Package the capstone with schema-validated Helm values.
- Diagnose DNS, connectivity, PVC, scheduling, RBAC, and upgrade failures.
- Demonstrate least privilege and recover a failed release.

## Gate 4 — Observability practitioner

**After Module 13**

- Instrument one request across service boundaries.
- Define useful metrics, logs, traces, dashboards, alerts, an SLI, and an SLO.
- Diagnose injected latency or errors by correlating telemetry.
- Correct a high-cardinality or noisy-alert design.

## Gate 5 — Production readiness

**After Module 16**

- Reproduce infrastructure and delivery from versioned sources.
- Demonstrate supply-chain evidence and admission controls.
- Test scaling, disruption, upgrade, rollback, backup, and restoration.
- Run a timed incident and write a blameless postmortem.
- Defend architecture, capacity, security, cost, and recovery decisions.

## Reassessment

Repeat failed dimensions with a changed scenario. Replaying the same scripted
steps does not demonstrate transfer of learning.
