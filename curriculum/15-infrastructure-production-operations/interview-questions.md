# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

### 1. What problem does Terraform state solve?

**Answer:** It binds configuration addresses to remote object identities and
caches metadata used to plan changes. It is not source code or a backup of the
service. Protect it with access control, encryption, versioning, recovery, and
serialized writes because it can expose secrets and destructive authority.

### 2. Why is a successful plan not a safety guarantee?

**Answer:** A plan reflects current inputs, refresh results, provider behavior,
credentials, and state. It cannot prove business intent, data compatibility,
quota, downstream behavior, or what changes before apply. Review replacements,
deletions, privileges, cost, and recovery, then verify after apply.

### 3. How would you divide infrastructure state?

**Answer:** Separate by lifecycle, ownership, privilege, environment, and blast
radius—often landing zone/network, cluster, platform services, and applications.
Too little separation grants broad destructive access; too much creates fragile
cross-state coupling. Prefer explicit published interfaces over full state sharing.

### 4. What remains your responsibility with managed Kubernetes?

**Answer:** Usually network and API exposure, IAM/RBAC, nodes or compute policy,
add-ons, workloads, data, secrets, observability, backup validation, upgrades,
cost, and incidents. The exact line is provider/service-tier specific; record it
and test escalation instead of assuming “managed” means operated end to end.

### 5. How do you design production node pools?

**Answer:** Separate system and application capacity, then group by architecture,
OS, accelerator, trust, disruption tolerance, zone, and purchase model. Define
taints/labels, min/max capacity, upgrades, image lifecycle, and autoscaling.
Verify a zone loss and rollout can coexist without starving critical add-ons.

### 6. Why can inaccurate requests break autoscaling?

**Answer:** HPA utilization uses requests as a denominator and node autoscalers
schedule from requests. Requests that are too low cause contention and misleading
utilization; too high wastes nodes or leaves Pods Pending. Compare distributions,
throttling, OOMs, pending events, and scaling latency under realistic load.

### 7. What does a PodDisruptionBudget guarantee?

**Answer:** It constrains cooperative voluntary eviction when the eviction API is
honored. It does not cover crashes, node loss, force deletion, rollout mistakes,
or application correctness. Validate replica placement, readiness, capacity, and
the actual maintenance tool; an impossible PDB can block upgrades.

### 8. How do you plan capacity for availability?

**Answer:** Model peak demand plus system/DaemonSet overhead, rollout surge,
startup delay, storage/network limits, and the largest tolerated failure domain.
Use request and utilization distributions, quotas, provider limits, and scaling
latency. Prove the degraded system still meets a defined SLO.

### 9. How do you control Kubernetes cost without harming reliability?

**Answer:** Allocate direct and shared cost, compare requests with use, right-size,
remove waste, govern retention/egress/storage, and use interruptible capacity for
tolerant work. Keep explicit recovery and rollout headroom. Optimize cost per
reliable business outcome, not average CPU alone.

### 10. Describe a safe Kubernetes upgrade.

**Answer:** Inventory compatibility and removed APIs; read provider and upstream
notes; rehearse; upgrade in the supported control-plane/add-on/node order; canary
a node pool; drain within PDB/capacity limits; and verify platform signals plus
business transactions. Define stop, forward-fix, and rollback boundaries first.

### 11. Why is backup success not recovery proof?

**Answer:** A backup may be inconsistent, corrupt, encrypted with unavailable
keys, incomplete across dependencies, or incompatible with the target version.
Restore into isolation, verify integrity and business invariants, measure RPO/RTO,
and prevent accidental production side effects.

### 12. What belongs in a Kubernetes disaster-recovery dependency graph?

**Answer:** Landing zone, network, identity, keys, cluster, add-ons, desired state,
secrets, databases, volumes, queues, object stores, DNS, traffic, and external
integrations. Record restore order, owner, source, validation, and what Git or
cluster backup cannot reconstruct.

### 13. How do you handle a suspicious persistent state lock?

**Answer:** Stop new writers, identify the lock and owning run, use backend/audit
evidence to prove that writer ended, then unlock only that identity. Force-unlock
without proof can permit concurrent writes and corrupt coordination. Re-plan
afterward and investigate why cleanup failed.

### 14. How should a production incident be organized?

**Answer:** Declare impact/severity, assign commander, operations, communications,
and experts, keep a timestamped decision log, stabilize with bounded changes,
and publish regular factual updates. One authority coordinates IaC/GitOps writes.
Exit only after business and SLO recovery plus known follow-up risks.

### 15. What makes a postmortem useful?

**Answer:** It presents a causal timeline, contributing system conditions,
detection/response gaps, what helped, and prioritized actions with owners, dates,
and verification. Blaming the last actor hides latent controls. Track completion
and recurrence to prove learning changed the system.

> **Module:** [15 — Infrastructure and Production Operations](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
