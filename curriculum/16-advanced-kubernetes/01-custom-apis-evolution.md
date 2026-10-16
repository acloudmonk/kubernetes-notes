# Custom APIs and API Evolution

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Module home](README.md) · Next: [Controllers and operators](02-controllers-operators.md)

A CRD adds persisted, discoverable API objects with Kubernetes authentication,
authorization, admission, schemas, metadata, watches, and deletion semantics.
It does not add behavior: a controller must interpret desired state. Prefer a
ConfigMap or existing API when the domain does not need a durable declarative
contract, status, ownership, or ecosystem integration.

Design spec as user intent and status as controller observation. Conditions need
stable types, reasons, messages, and `observedGeneration` so automation can tell
whether status describes the current spec. Use structural OpenAPI schemas,
bounded fields, defaults carefully, and CEL for deterministic validation.

CRD versions have served and storage roles. Compatible evolution preserves old
clients; incompatible schema changes require conversion, storage migration, and
rollback planning. Test unknown-field pruning, defaulting, round trips, and
objects stored before the upgrade. A conversion webhook is a synchronous API
dependency and must be highly available, observable, secure, and recoverable.

Finalizers delay deletion until a controller completes external cleanup. They
are not executable hooks. Cleanup must be idempotent and bounded; an unavailable
controller or permanent external failure leaves objects Terminating. Owner
references enable garbage collection only within supported scope and do not
replace cleanup for external systems.

Admission webhooks mutate or validate requests synchronously; controllers
reconcile asynchronously after persistence. Use built-in schema/CEL/policy when
possible. A fail-closed webhook protects policy but can stop cluster writes;
design timeout, failure policy, match scope, version compatibility, monitoring,
and break-glass procedures explicitly.

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Module home](README.md) · Next: [Controllers and operators](02-controllers-operators.md)
