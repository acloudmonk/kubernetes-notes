# Interview Questions

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

Strong answers identify the responsible component, API contract, evidence,
edge cases, production tradeoff, and a safe validation.

## Scheduling and accounting

### 1. Trace a Pod from API creation through scheduler binding and kubelet startup.

**Answer:** The API server authenticates, authorizes, admits, validates, and
persists the Pod. The scheduler watches unscheduled Pods, filters and scores
feasible nodes, then records a binding. The selected kubelet admits the Pod
against node resources and invokes CRI, CNI, and CSI implementations to create
the sandbox, networking, storage, and containers before reporting status.

### 2. Why can a Pod be unschedulable when node CPU usage is low?

**Answer:** Basic scheduling resource fit compares Pod requests with node
allocatable capacity minus requests already committed, not current utilization.
Hard placement, taints, topology, volume constraints, Pod overhead, and reserved
capacity can also eliminate nodes. Use `PodScheduled=False` and scheduler Events
to identify the failed filters rather than relying on a utilization dashboard.

### 3. How are app-container, init-container, and Pod-overhead requests accounted?

**Answer:** For each resource, effective Pod demand is the greater of the sum of
regular container requests and the largest effective init-container request,
plus declared Pod overhead. Sidecars expressed with native sidecar semantics
affect the calculation according to their overlap. Scheduling is resource-by-
resource; do not add all init containers as if they run concurrently.

### 4. Compare CPU request, CPU limit, memory request, and memory limit enforcement.

**Answer:** Requests influence scheduling and CPU share under contention; memory
requests influence placement and eviction/QoS. CPU limits are normally enforced
by throttling, whereas exceeding a memory cgroup limit can invoke an OOM kill.
Node pressure can evict a container below its limit, and a limit does not reserve
capacity. Validate latency, throttling, working set, OOM, and eviction behavior.

### 5. Derive all three QoS classes. How does QoS differ from PriorityClass?

**Answer:** Guaranteed requires every relevant container to have equal CPU and
memory requests and limits. BestEffort has none; all other combinations are
Burstable. QoS influences cgroup and node-pressure eviction behavior, while
PriorityClass affects scheduling order and possible preemption. Neither makes a
Pod immune to deletion, node failure, limits, or every eviction.

## Placement and disruption

### 6. Compare nodeSelector, node affinity, Pod anti-affinity, and topology spread.

**Answer:** `nodeSelector` is a simple hard label match; node affinity supports
expressive required and preferred node rules. Pod affinity/anti-affinity relates
placement to other Pods and can be computationally expensive. Topology spread
targets balanced counts across domains. Use hard rules only for real constraints
and soft rules for preferences so capacity loss does not deadlock placement.

### 7. Why does a toleration not guarantee placement on a tainted node?

**Answer:** A toleration only removes a taint's blocking effect for that Pod.
The node must still pass resources, affinity, topology, volume, port, and other
filters, and other nodes may score higher. Pair tolerations with an intentional
selector or affinity when dedicating nodes, and verify isolation from both sides.

### 8. What can make two individually valid required placement rules contradictory?

**Answer:** Their intersection may contain no node—for example, required node
affinity selects one zone while a bound volume is accessible only in another, or
anti-affinity forbids the only eligible topology. Inspect the complete combined
constraint set and scheduler Events. Weakening one rule without understanding
the invariant can create availability or isolation failures.

### 9. How does `WaitForFirstConsumer` connect storage and scheduling?

**Answer:** It delays topology-sensitive provisioning or binding until a Pod is
considered for placement. The scheduler and storage components can then choose a
node and volume topology that agree. A claim remaining Pending without a
consumer can be expected; a consumer Pending with provisioning Events indicates
the boundary to investigate.

### 10. What does a PDB protect, and which disruptions bypass it?

**Answer:** A PodDisruptionBudget limits supported voluntary evictions so enough
selected replicas remain available. It does not prevent direct Pod or controller
deletion, node crash, OOM, involuntary eviction, or every forceful drain action.
It also cannot create capacity. Test maintenance together with replica placement
and surge headroom.

### 11. Explain preemption and why it may not make a high-priority Pod schedulable.

**Answer:** When no node fits, the scheduler may nominate a node where evicting
lower-priority Pods could free required resources while respecting relevant
constraints and PDBs. Preemption cannot fix affinity, topology, volume, host-port,
or resource-type mismatch, and victims take time to terminate. Priority should
express business importance, not substitute for capacity planning.

## Autoscaling and diagnosis

### 12. Derive HPA CPU utilization and explain the role of CPU requests.

**Answer:** Resource CPU utilization is current CPU usage divided by requested
CPU for eligible Pods, aggregated by the controller's algorithm to estimate a
desired replica count. Missing requests can make utilization undefined for those
containers/Pods. Requests therefore affect scheduling and the meaning of the
signal; choose them from measured behavior and test stabilization and scaling.

### 13. How do HPA, VPA, and node autoscaling interact or conflict?

**Answer:** HPA changes replica count, VPA recommends or changes per-Pod resources,
and node autoscaling changes cluster capacity when compatible Pods remain
unschedulable. If HPA scales on utilization while VPA changes its denominator,
the loops can fight. More replicas or larger requests can trigger nodes, but
hard constraints can still prevent scale-up. Define ownership and simulate peaks.

### 14. Diagnose `OOMKilled` versus node-pressure `Evicted` versus probe restart.

**Answer:** `OOMKilled` appears in terminated container state and relates to a
container/cgroup or system OOM event. An evicted Pod has an eviction reason and
node-condition/resource-pressure evidence. Probe restarts show kubelet probe
failure Events, restart increments, and previous logs. Correlate Pod status,
Events, node conditions, metrics, and kubelet evidence before changing limits.

### 15. How would you design capacity for one-node loss plus rolling-update surge?

**Answer:** Reserve enough allocatable capacity in the remaining failure domains
for the desired replicas after one node disappears and for the Deployment's
maximum temporary surge, including system overhead and all container requests.
Ensure topology rules, PDBs, volumes, quotas, and autoscaler limits allow that
placement. Prove it with a controlled drain/failure and rollout under realistic
load, measuring scheduling and user availability.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
