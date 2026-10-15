# API Requests and the Object Model

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Cluster components](01-cluster-components.md) · Next:
> [Reconciliation, scheduling, and node execution](03-reconciliation-scheduling-node.md)

## Objects are durable API records

A manifest normally identifies an API resource with `apiVersion`, `kind`,
`metadata`, and a desired `spec`. The API may expose observed information in
`status`. Resource endpoints use plural names and may be namespaced or
cluster-scoped; do not infer scope from YAML indentation.

`apps/v1` is an API group and version, while core resources use `v1`. A kind
such as `Deployment` is a human-facing object type; discovery maps it to a
resource endpoint such as `/apis/apps/v1/namespaces/demo/deployments`.

Important metadata has distinct jobs:

- `name` plus namespace addresses an object; `uid` distinguishes one lifetime
  from a later object reusing the same name.
- `resourceVersion` supports optimistic concurrency and watch continuation. It
  is opaque and is not an object generation or wall-clock timestamp.
- `generation` changes for desired-state updates on resources that implement
  it. A condition's `observedGeneration` can show whether a controller has
  processed that generation.
- labels are indexed identity and selection data; annotations are non-identifying metadata.
- owner references support dependency relationships and garbage collection.
- finalizers delay deletion until a responsible controller completes cleanup.
- `managedFields` records field-management ownership for apply and update workflows.

## Trace a write request

For `kubectl apply -f workload.yaml`, reason through this path:

1. `kubectl` resolves the current context, cluster endpoint, and user from kubeconfig.
2. Client discovery and REST mapping identify the API endpoint.
3. TLS protects the connection and authenticates the server; configured client
   credentials participate in authentication.
4. The API server authenticates the caller and authorization decides whether
   the verb is allowed for the resource, namespace, and name.
5. Mutating admission may change the object; schema/defaulting and validation
   reject invalid state; validating admission may accept or reject it.
6. The API server persists the accepted representation through its storage layer to etcd.
7. The response includes server-assigned metadata. Watches notify interested
   clients and controllers, which reconcile independently.

Admission is not a substitute for authorization. Authentication answers “who,”
authorization answers “may this identity do this,” and admission evaluates or
mutates a request that has already passed authorization.

## Read, list, and watch

Controllers commonly list current objects, then watch changes from a returned
resource version. A watch is a stream of changes, not a permanent perfect event
log. Connections close, history is compacted, and clients must relist and
resume. Informers maintain local caches and queue keys for reconciliation,
reducing direct API calls.

Kubernetes Events are useful, best-effort diagnostic records. They can expire,
aggregate, or be absent; they are not an audit trail or durable business-event
system. Combine them with object status, conditions, component logs, metrics,
and audit data when available.

## Updates, patches, and field ownership

- A replacement-style update sends a complete current representation and uses
  `resourceVersion` to reject conflicting writes.
- JSON or merge patch changes selected paths with different list semantics.
- Strategic merge patch is Kubernetes-aware for built-in types but is not a
  general CRD mechanism.
- Server-side apply expresses field intent and uses a named field manager.
  Conflicts expose competing ownership rather than silently overwriting it.

Choose a mutation method intentionally. Automation that repeatedly overwrites
whole objects can remove fields owned by another actor.

## Deletion is a state transition

A delete can set `deletionTimestamp` before the object disappears. Finalizers
identify pending cleanup responsibilities. Removing an unknown finalizer by
force may orphan cloud resources or dependent data. First identify its owner,
inspect that controller, and verify the external cleanup obligation.

## Review prompts

- Why can `generation` advance while `status.observedGeneration` remains old?
- What does an authorization failure prove about admission execution?
- Why are Kubernetes Events unsafe as an application message bus?

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Cluster components](01-cluster-components.md) · Next:
> [Reconciliation, scheduling, and node execution](03-reconciliation-scheduling-node.md)
