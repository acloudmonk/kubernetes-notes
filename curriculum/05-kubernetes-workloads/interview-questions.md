# Interview Questions

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

Use each answer as a model, then add an example from the CloudCart lab and the
observable evidence you would collect in a real cluster.

## Fundamentals and internals

### 1. Why not deploy bare Pods?

**Answer:** A bare Pod has no workload controller maintaining its desired
state. If its node fails or the Pod is deleted, Kubernetes does not create a
replacement. A Deployment, StatefulSet, DaemonSet, or Job adds the appropriate
repair, rollout, identity, placement, or completion semantics. The choice must
match the workload; wrapping every Pod in a Deployment is also incorrect for
one-time work or node-local agents.

**Evidence:** Inspect `metadata.ownerReferences`, the owning controller's
status, and whether a replacement Pod with a new UID appears after deletion.

### 2. What is the difference between readiness and liveness?

**Answer:** Readiness controls whether a Pod receives Service traffic; failure
does not restart the container. Liveness asks whether restarting this container
can repair it; repeated failure triggers restarts. A startup probe can protect a
slow start from premature liveness checks. A shared dependency usually belongs
in readiness rather than liveness, because restarting every client during a
database outage amplifies failure.

**Common mistake:** Reusing one deep health endpoint for all three probes.

### 3. Trace a Deployment update.

**Answer:** A change to `spec.template` produces a new Deployment revision and
ReplicaSet. The Deployment controller scales old and new ReplicaSets within
`maxSurge` and `maxUnavailable`; the scheduler and kubelets realize new Pods,
and readiness determines availability. `progressDeadlineSeconds` reports a
stalled rollout but does not automatically roll it back.

**Evidence:** Compare Deployment conditions, ReplicaSet revisions, Pod template
hashes, Events, and ready/available replica counts.

### 4. What is the difference between a container restart and Pod replacement?

**Answer:** Kubelet can restart a container according to the Pod restart policy
while retaining the Pod UID, IP, sandbox, and `emptyDir` volumes. A controller
replaces a Pod by creating a new object with a new UID and usually a new IP;
Pod-local state and active connections disappear. Persistent volumes survive
only according to their separate lifecycle.

**Follow-up:** Which evidence—restart count, previous logs, UID, and creation
timestamp—distinguishes the two cases?

## Design and implementation

### 5. When should you choose a Deployment or StatefulSet?

**Answer:** Use a Deployment when replicas are interchangeable and do not need
stable ordinal identity or per-replica claims. Use a StatefulSet when the
application protocol requires stable names, ordered operations, or persistent
storage mapped to a particular ordinal. Having a database does not alone make
a StatefulSet sufficient: replication, quorum, fencing, backup, and failover
remain application or operator responsibilities.

**Tradeoff:** Stateful identity helps stateful protocols but makes replacement,
scaling, and recovery more deliberate.

### 6. How should resource requests and limits be set?

**Answer:** Measure normal, peak, and startup behavior. Set requests to represent
the capacity the scheduler should reserve and use limits only with understood
runtime consequences: CPU limits can throttle, while memory limits can cause an
OOM kill. Include sidecars and init-container accounting, leave failure and
rollout headroom, observe throttling and working sets, and revise from evidence.

**Common mistake:** Copying identical request/limit values to every workload
without testing latency, burst, or node-capacity effects.

### 7. Is a Kubernetes Secret encrypted?

**Answer:** Not necessarily. The API representation uses base64, which is
encoding. Confidentiality depends on API authorization, encryption at rest,
key management, node and Pod security, delivery method, application handling,
logs, backups, and rotation. Permission to create Pods can also provide an
indirect path to namespace Secrets.

**Verification:** Check the cluster's encryption configuration and RBAC paths;
never print secret values merely to prove access.

### 8. How should a schema change be deployed?

**Answer:** Use expand-and-contract. First add a backward-compatible schema,
run an idempotent migration or backfill, deploy code that works with both old
and new forms, verify business behavior, and remove the old form in a later
release. Coordinate locks, runtime, retry behavior, and rollback; rolling back
manifests does not undo committed data changes.

**Follow-up:** What happens if old and new application replicas run together?

## Troubleshooting and production

### 9. A Pod is Running but the Service has no usable backend. What do you inspect?

**Answer:** Running phase does not imply readiness. Compare Service selectors
with Pod labels, inspect readiness conditions and EndpointSlices, verify named
`targetPort` resolution, and check whether the Pod is terminating. Then test the
application on the Pod port. This separates selection, readiness, port mapping,
and application failure instead of treating “networking” as one layer.

### 10. What proves a rollback is safe?

**Answer:** Safety requires an immutable prior image, a retained or reproducible
manifest revision, configuration and schema compatible with that version, a
tested rollback procedure, and post-rollback user-level verification. It also
requires knowing what rollback cannot reverse, such as external side effects,
messages already published, and destructive migrations.

**Common mistake:** Treating `kubectl rollout undo` success as proof that the
service and its data have recovered.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
