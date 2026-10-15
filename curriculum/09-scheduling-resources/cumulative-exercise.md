# Cumulative Exercise — Operate State Under Constrained Capacity

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Lab 2 — Diagnose scheduling and resource failures](labs/02-diagnose-resources.md) · Next: [Independent challenge](independent-challenge.md)

This exercise combines Modules 07–09. Give an operator a CloudCart environment
with a retained PostgreSQL PVC, a recently rotated database credential, and an
API replica that is Pending because hard placement and available capacity do
not intersect. During recovery, a voluntary worker drain must not remove all
healthy API replicas.

Without recreating the namespace or exposing a credential, the operator must:

1. map Pod, controller, Secret/ConfigMap, PVC/PV, node, topology, PDB, and HPA
   ownership and dependencies;
2. distinguish storage topology, authentication, readiness, and scheduling
   evidence, then identify the first broken boundary;
3. repair the smallest safe constraint or capacity issue and justify why data
   correctness and isolation remain intact;
4. prove the original PVC/PV is reused, the active credential works, both API
   replicas become Ready, the PDB permits only safe voluntary disruption, and a
   new order reaches the idempotent worker;
5. document rollback, prevention, capacity headroom, and precise cleanup.

Assessment requires a timestamped causal narrative and sanitized commands/output,
not only green status. A replacement database or newly generated Secret without
explaining the original failure loses the storage/configuration evidence.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Lab 2 — Diagnose scheduling and resource failures](labs/02-diagnose-resources.md) · Next: [Independent challenge](independent-challenge.md)
