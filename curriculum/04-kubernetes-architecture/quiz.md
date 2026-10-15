# Knowledge Check

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Interview questions](interview-questions.md) · Next:
> [References and videos](references.md)

Answer before reading below the separator.

1. Which component persists a valid Deployment request, and which component creates its ReplicaSet?
2. Put authentication, authorization, mutating admission, and validating admission in request order.
3. A Pod has no `nodeName`. Is kubelet the first component to investigate? Why?
4. Predict what happens immediately and later when a worker stops sending heartbeats.
5. Why can a controller recover from a disconnected watch?
6. What is wrong with using `resourceVersion` as a creation timestamp?
7. A delete sets `deletionTimestamp`, but the object remains. What mechanism is likely involved?
8. Does installing a CRD implement reconciliation for its objects?
9. Why does an etcd snapshot not satisfy application database recovery requirements?
10. Name two differences between an API-server outage and a worker-node outage.
11. A scheduler reports insufficient CPU although dashboards show 5% usage. Reconcile the evidence.
12. What evidence proves a controller has observed the latest desired state?

---

## Answers

1. The API server persists through its etcd storage layer; the Deployment controller creates the ReplicaSet.
2. Authentication → authorization → mutating admission → schema/defaulting/validation and validating admission. Exact internal validation phases are implementation detail; the key boundary is that admission follows authorization and mutation precedes final validation.
3. No. First inspect scheduler-facing evidence: PodScheduled condition, Events, requests, selectors, affinity, taints, topology, and volume constraints. Kubelet acts after assignment.
4. Existing containers may continue. The Lease stops renewing; after configured grace periods the Node becomes Unknown/NotReady. Eviction or replacement occurs according to tolerations, controller policy, storage, and capacity rather than instantly.
5. Durable API state is the source of truth. Relist/resync plus idempotent level-triggered reconciliation reconstructs current work.
6. It is an opaque token for concurrency and watch semantics; ordering and format are not a wall clock contract.
7. One or more finalizers are holding deletion until their controllers complete cleanup.
8. No. A CRD serves and stores the type; a controller or other actor must implement behavior.
9. It protects Kubernetes API state, not bytes stored in an external PostgreSQL, object store, or other application data system.
10. API outage prevents management and reconciliation while existing node processes may run. Worker outage leaves the API reachable but stops that node's heartbeat and node-side execution.
11. Scheduling uses resource requests and allocatable capacity, not live utilization. Existing requests can reserve the remaining schedulable CPU.
12. Where implemented, status/conditions with an `observedGeneration` equal to the object's current generation, together with the expected dependent state. Equality alone does not prove application health.

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Interview questions](interview-questions.md) · Next:
> [References and videos](references.md)
