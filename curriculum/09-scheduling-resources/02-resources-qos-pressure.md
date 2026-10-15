# Requests, Limits, QoS, and Pressure

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Scheduler pipeline and resource accounting](01-scheduler-pipeline.md) · Next: [Placement, isolation, and topology](03-placement-topology.md)

## Different controls

A request is primarily a scheduling and sharing signal. On Linux, CPU requests
influence proportional CPU shares and memory requests influence placement and
QoS. A CPU limit is enforced by throttling over a quota period; a memory limit
is reactive and allocation beyond it can end in `OOMKilled`. Neither is a
capacity plan. Measure demand, latency, throttling, working set, OOMs, node
headroom, and failure scenarios before selecting production values.

For latency-sensitive services, tight CPU limits can create tail-latency spikes
even when average use looks low. Omitting every limit is not automatically safe:
tenant isolation, runaway processes, node capacity, and application behavior
still require controls. Make the tradeoff explicit and load-test it.

Ephemeral-storage requests and limits cover writable layers, logs, and eligible
`emptyDir` data. Unbounded logs or scratch files can trigger node disk pressure
or local eviction even when CPU and memory look healthy.

## Pod QoS classes

Kubernetes derives QoS; it is not a user-selected label.

| Class | Resource shape | Pressure implication |
|---|---|---|
| Guaranteed | Every container has equal CPU request/limit and equal memory request/limit | Generally last among lower-priority candidates under node pressure |
| Burstable | At least one CPU/memory request or limit, but not Guaranteed | Ranked using priority and consumption relative to requests |
| BestEffort | No CPU or memory requests/limits on any container | First candidates under pressure |

QoS is not priority, availability, or immunity from OOM. A container can exceed
its memory cgroup limit and be killed while the node has free memory. Under
node pressure, kubelet eviction considers whether usage exceeds requests,
Priority, and relative excess; exact ordering depends on the eviction path.

## Namespace guardrails and rightsizing

`LimitRange` can default or constrain per-container/Pod values. Defaults are
convenient but can silently change QoS or create bad limit-to-request ratios.
`ResourceQuota` constrains aggregate requests, limits, object counts, and some
scoped resources; it does not create capacity or fairly allocate a node.

Rightsizing is a feedback loop: establish representative load, inspect
percentiles and seasonality, include startup/burst and failure load, propose a
change, canary it, measure SLO/cost impact, and retain rollback. VPA can
recommend or mutate resources depending on mode, but production changes may
evict Pods and can conflict conceptually with HPA when both react to CPU or
memory. Define ownership of each scaling dimension.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Scheduler pipeline and resource accounting](01-scheduler-pipeline.md) · Next: [Placement, isolation, and topology](03-placement-topology.md)
