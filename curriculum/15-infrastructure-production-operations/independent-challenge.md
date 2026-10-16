# Independent Challenge

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Cumulative production review](cumulative-exercise.md) · Next: [Troubleshooting](troubleshooting.md)

Design a managed-Kubernetes production platform for CloudCart without copying a
provider reference architecture unchanged.

## Constraints

- two environments have separate identity, state, approval, and failure boundaries;
- production tolerates one zone failure while preserving the stated SLO;
- infrastructure and platform changes use reviewed plans and one apply authority;
- workload identity replaces static cloud keys;
- state, backups, and encryption keys have distinct recovery controls;
- capacity includes rollout, system, and failure headroom;
- every recurring cost has an owner and useful allocation signal; and
- upgrades and one regional recovery scenario are rehearsed.

## Acceptance evidence

Submit a topology and trust diagram, module/state decomposition, responsibility
matrix, capacity/cost model, upgrade runbook, recovery dependency graph,
incident exercise report, and an ADR for the most consequential tradeoff.
Include measured or explicitly assumed RPO/RTO/SLO values and identify how each
is verified. List what remains unproven.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Cumulative production review](cumulative-exercise.md) · Next: [Troubleshooting](troubleshooting.md)
