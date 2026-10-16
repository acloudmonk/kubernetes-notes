# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

### 1. When should you create a CRD?

**Answer:** Use one for a durable declarative domain contract needing schema,
status, ownership, watches, RBAC, and controller behavior. Prefer existing APIs
or configuration when no new lifecycle exists. CRDs add compatibility, backup,
admission, upgrade, and controller ownership obligations.

### 2. What separates spec from status?

**Answer:** Spec is user intent; status is controller-observed reality. Status
should include stable conditions and `observedGeneration` so consumers know
which spec was processed. Users should not write optimistic status, and the
controller should not rewrite unchanged status every loop.

### 3. How does a controller recover missed events?

**Answer:** It reconciles current level state, not an assumed event sequence.
List/watch caches, resync, durable API state, idempotent actions, queues, retries,
and backoff let duplicated or missed hints converge. Verify desired versus actual
state after controller restart.

### 4. Why must reconciliation be idempotent?

**Answer:** Retries, duplicate events, crashes, and leader changes are normal.
Repeating the same desired state must converge without duplicate side effects.
Use stable identities, compare before writing, record external operation IDs,
and test failures between each read/write boundary.

### 5. What is a finalizer and how do you repair one safely?

**Answer:** It is a key that keeps a deletion-marked object until its controller
finishes cleanup. Restore the controller, inspect deletion/status/logs and the
external resource, complete or safely abandon cleanup, then remove only the
owned key. Blind removal can leak infrastructure or violate data guarantees.

### 6. How do owner references differ from labels?

**Answer:** Owner references express garbage-collection dependency and controller
ownership under scope rules; labels are query/grouping metadata. A controller
reference also prevents multiple controlling owners. Neither cleans external
systems, which may require a finalizer.

### 7. What makes an operator production-ready?

**Answer:** Evidence across CRD evolution, upgrades, data safety, idempotency,
leader/concurrency behavior, least privilege, status/metrics/events, backup and
restore, failure recovery, support, and uninstall/escape paths. Automation count
or an “operator maturity” label is insufficient.

### 8. Compare admission webhooks and controllers.

**Answer:** Webhooks synchronously accept, reject, or mutate API requests and can
affect API availability. Controllers asynchronously converge persisted state.
Prefer schema, CEL, and built-ins for deterministic admission; design webhook
timeouts, failure policy, TLS, scope, HA, observability, and break glass.

### 9. What does mesh mTLS prove?

**Answer:** When correctly enrolled, it proves encrypted transport and peer
identity anchored in the mesh trust domain. It does not prove user authorization,
application correctness, safe payload, or that every path enters the mesh.
Verify certificates/identity, data-plane state, policy, and actual request outcome.

### 10. Compare sidecar and ambient mesh models.

**Answer:** Sidecars give per-Pod proxies and mature Layer-7 locality but add Pod
resources and injection/lifecycle coupling. Ambient uses node tunnels for Layer 4
and optional waypoints for Layer 7, changing privilege, isolation, attribution,
and upgrade boundaries. Select from required features and measured operations.

### 11. Why can mesh retries cause an outage?

**Answer:** Independent retry layers multiply failing demand, consume deadlines,
and may duplicate non-idempotent effects. Use end-to-end deadlines, bounded retry
budgets, backoff/jitter, safe operations, load shedding, and metrics separating
original attempts from retries.

### 12. What should an eBPF-based platform evaluation include?

**Answer:** Required outcome, kernel/runtime matrix, program attachment and bypass
paths, privileges, verifier/map limits, resource use, observability, fallback,
upgrade/rollback, support, and comparison with simpler CNI or application tools.
Packet and policy tests matter more than the implementation label.

### 13. How do multiple autoscalers interact safely?

**Answer:** Give each a clear dimension and reliable metric, accurate requests,
compatible min/max limits, stabilization, capacity/quota awareness, and disruption
controls. Load-test cold starts and dependency ceilings. Detect oscillation from
HPA/VPA/node-scaler feedback rather than tuning each loop independently.

### 14. When is multi-cluster justified?

**Answer:** When geography, regulation, hostile-tenancy, lifecycle, or blast-radius
requirements exceed namespace/node-pool controls and justify fleet cost. Prove
identity, network, configuration, data authority, observability, upgrades,
capacity, incident ownership, and failover—not only cluster creation.

### 15. What proves multi-cluster failover works?

**Answer:** A timed rehearsal establishes authority/fencing, restores every
dependency in order, accounts for data lag and DNS/traffic behavior, completes a
business transaction without unsafe duplicate side effects, measures RPO/RTO,
and can abort or fail back. Healthy Pods alone are not proof.

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)
