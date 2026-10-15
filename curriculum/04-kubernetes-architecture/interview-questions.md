# Interview Questions

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

Use the answer cues to evaluate reasoning; expand each with evidence and tradeoffs.

## Fundamental

### 1. What is the Kubernetes control plane?

**Answer:** The API server exposes the control boundary, etcd stores API state,
the scheduler binds unscheduled Pods to nodes, and controller managers run
reconciliation loops. Cloud-specific control loops may run separately. DNS,
ingress, and monitoring are commonly add-ons, not all core control-plane parts.

**Common mistake:** describing the API server as the component that starts containers.

**Follow-up:** What can continue during an API-server outage?

### 2. What is desired versus observed state?

**Answer:** `spec` commonly expresses intent and `status` reports observations.
Controllers compare them and take idempotent actions. Convergence is eventual,
so a recent write can legitimately precede an updated status.

**Verification:** compare generation, observed generation, conditions, and owned dependents.

## Internals

### 3. Trace a Deployment from `kubectl apply` to a running process.

**Answer:** Context resolution and discovery precede a TLS request. The API
server authenticates, authorizes, admits, validates, and persists the object.
Deployment and ReplicaSet controllers create dependents; the scheduler binds
Pods; kubelet asks CRI, CNI, and CSI implementations for node-side realization
and reports status.

**Tradeoff:** asynchronous boundaries improve decoupling and repair but require multi-object diagnosis.

### 4. Why are controllers level-triggered and idempotent?

**Answer:** Watches disconnect, events duplicate, processes restart, and actions
partially succeed. Recomputing from current durable state allows safe retries
and repairs missed edges.

**Common mistake:** treating a watch or work queue as the source of truth.

### 5. What do `resourceVersion`, `generation`, and `uid` mean?

**Answer:** `resourceVersion` is an opaque concurrency/watch token, generation
tracks desired-state revisions where supported, and UID identifies one object
lifetime. None should be treated as a wall-clock timestamp.

## Implementation and troubleshooting

### 6. A Pod is Pending. What do you inspect?

**Answer:** First check whether `spec.nodeName` exists and read PodScheduled
condition and Events. Without a node, inspect requests, taints/tolerations,
selectors/affinity, topology and volume constraints. With a node, inspect
image, volume, CNI, runtime, sandbox, and kubelet evidence.

### 7. Why can a Pod be Running but unavailable?

**Answer:** Running phase means containers were created and at least one is
running or starting; it does not guarantee readiness, Service endpoints, or
application correctness. Inspect readiness and workload/controller conditions.

### 8. What should you do with a stuck finalizer?

**Answer:** Identify the finalizer owner, inspect its controller and external
cleanup state, restore or safely complete cleanup, and only then consider an
explicit exceptional removal. Forced removal can orphan resources.

## Architecture, security, and senior

### 9. How does managed Kubernetes change responsibility?

**Answer:** A provider may operate API servers and etcd, but customers retain
responsibility defined by that service—identity/RBAC, workloads, versions,
nodes or node pools, networking policy, integrations, application data,
observability, cost, and recovery validation often remain partly or wholly theirs.

### 10. When would you choose a CRD rather than an admission webhook?

**Answer:** A CRD models a new declarative resource; its controller implements
behavior. Admission evaluates or mutates writes to resources. They solve
different problems and both introduce versioning, availability, security, and
upgrade obligations.

### 11. How would you design a highly available control plane?

**Answer:** Use redundant API endpoints behind a load balancer, scheduler and
controller-manager replicas with leader election, and an odd-sized failure-
tolerant etcd topology. Protect dependencies across failure domains; monitor
and test backup/restore, upgrades, admission, certificates, and capacity.

**Follow-up:** Why do three API servers not compensate for lost etcd quorum?

### 12. Why are Kubernetes Secrets and etcd snapshots sensitive?

**Answer:** Secret values are only base64-encoded by the API representation
unless encryption at rest is configured. Snapshots contain cluster API data.
Restrict access, protect keys, encrypt and rotate appropriately, and never
commit kubeconfigs, tokens, keys, or snapshots.

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
