# Troubleshooting Production Operations

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

Start with customer impact, recent change, authoritative writer, and the first
failed boundary. Preserve timestamps and identifiers; never paste state,
credentials, kubeconfigs, or private diagnostics into tickets or chat.

| Symptom | Likely boundary | Evidence | Safe response |
|---|---|---|---|
| Plan wants mass replacement | address/schema/input or provider change | plan JSON summary, moved/import blocks, provider lock | stop apply; correct mapping or migration |
| State lock persists | interrupted writer or active run | backend lock ID, run system, audit log | prove writer ended; unlock only its lock |
| Cluster API healthy, apps fail | data plane/add-on/workload | nodes, DNS/CNI/CSI, events, SLO signals | isolate layer; avoid control-plane guesses |
| Pods Pending during surge | requests, quota, topology, capacity | scheduler events, allocatable, pool limits | preserve critical capacity; scale/fix constraint |
| Drain hangs | PDB, local storage, unmanaged Pod, finalizer | eviction errors, PDB status, Pod owners | do not force blindly; restore budget or reschedule safely |
| Upgrade stalls | add-on/webhook/API incompatibility | deprecated APIs, webhook logs, provider status | pause rollout; use tested forward fix or supported rollback |
| Backup succeeded, restore fails | consistency, key, version, dependency order | catalog, checksums, restore logs, invariants | restore in isolation; repair runbook/control gap |
| Cost rises without traffic | requests, idle nodes, egress, storage, telemetry | allocation and utilization by owner | correct driver without removing recovery headroom |
| Autoscaling oscillates | delayed/conflicting feedback loops | HPA events, metrics, pending Pods, node churn | stabilize targets/cooldowns and fix requests |
| Incident changes conflict | command/ownership failure | timeline, audit, GitOps/IaC runs | establish one commander and one writer |

After correction, verify business behavior and SLO recovery, reconcile desired
state, remove temporary access, preserve non-secret evidence, and create a
prevention action with an owner and due date.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
