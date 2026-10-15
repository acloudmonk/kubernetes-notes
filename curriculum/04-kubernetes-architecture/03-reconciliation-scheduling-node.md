# Reconciliation, Scheduling, and Node Execution

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [API requests and the object model](02-api-request-and-object-model.md) ·
> Next: [Lifecycle, availability, and extensibility](04-cluster-lifecycle-extensibility.md)

## Reconciliation is level-triggered

A controller compares desired state with observed state and makes bounded,
idempotent changes. It should be safe to run the same reconciliation again
after a timeout, duplicate queue entry, restart, or partially completed action.
The current level matters more than receiving every edge. Periodic resync and
relisting help repair missed notifications.

A common controller shape is:

1. list and watch relevant resources through a shared cache;
2. enqueue an object key when potentially relevant state changes;
3. read the latest state for that key;
4. calculate the next idempotent action;
5. write an object or call an external system;
6. update status or emit diagnostic evidence;
7. retry transient failures with rate limiting.

The work queue is not the source of truth. Durable API state is.

## Deployment to process

Creating a Deployment does not directly create containers:

```text
Deployment controller -> ReplicaSet -> ReplicaSet controller -> Pod
Pod with no node -> scheduler -> binding/nodeName
assigned Pod -> kubelet -> CRI runtime -> sandbox and containers
network setup -> CNI implementation
declared volumes -> kubelet/CSI implementation
status -> kubelet and controllers -> API server
```

Each arrow can be delayed or fail independently. Owner references reveal the
controller chain. Conditions, status, Events, scheduler evidence, kubelet
evidence, and runtime evidence locate the stalled boundary.

## Scheduling

The scheduler considers unscheduled Pods. It first filters nodes that cannot
satisfy hard requirements such as resource requests, node selectors, affinity,
taints/tolerations, topology, or volume constraints. It scores feasible nodes
using configured plugins and records a binding. Extenders and framework
plugins can alter behavior.

Scheduling uses requested resources, not recent utilization. A Pod can be
unschedulable even while a node appears idle if its allocatable resources are
already reserved by requests. Conversely, missing requests can make placement
look feasible and later produce contention.

The scheduler's successful binding does not prove the image can be pulled, a
volume can mount, CNI can attach networking, or the process becomes healthy.
Those are later node-side transitions.

## Kubelet and node status

The kubelet watches Pods assigned to its node, drives the runtime toward the
Pod specification, and reports Pod and node status. Node heartbeats and Lease
objects allow the control plane to detect stale nodes without writing the full
Node object for every heartbeat.

When a node stops reporting, the control plane eventually marks it unknown or
not ready. Workloads do not necessarily move immediately: tolerations,
eviction policy, controller behavior, storage attachment, and termination
timing matter. A stopped process inside a healthy node is a different failure
from an unreachable node.

## Conditions are observations, not commands

Conditions describe aspects such as Available, Progressing, Ready, or
PodScheduled. Read the condition type, boolean status, reason, message, and
observed generation together. A top-level phase is a summary, not a complete
diagnosis. “Running” can coexist with an unready container.

## Debug from the outside inward

Use a causal sequence:

1. confirm context, API reachability, identity, and authorization;
2. read the desired object and its current generation;
3. inspect status, conditions, owner references, and Events;
4. follow the owner chain and selector matches;
5. if unscheduled, examine requests and placement constraints;
6. if scheduled, inspect kubelet-facing symptoms: image, volume, CNI, probes,
   runtime state, and node conditions;
7. inspect component logs and metrics only after narrowing the boundary.

Avoid deleting a failing Pod before capturing evidence. A controller may simply
recreate the same failure and the most useful status can disappear.

## Review prompts

- Why can a controller recover even if it misses an individual watch event?
- A Pod has `nodeName` but no running container. Which component completed its work?
- Why can low CPU utilization coexist with `Insufficient cpu` during scheduling?

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [API requests and the object model](02-api-request-and-object-model.md) ·
> Next: [Lifecycle, availability, and extensibility](04-cluster-lifecycle-extensibility.md)
