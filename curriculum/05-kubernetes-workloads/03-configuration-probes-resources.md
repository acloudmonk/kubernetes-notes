# Configuration, Probes, and Resources

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Workload controllers](02-workload-controllers.md) · Next: [Services, rollouts, and operations](04-services-rollouts-operations.md)

## Configuration delivery

ConfigMaps hold non-confidential configuration; Secrets are intended for
sensitive values but are not safe merely because their API representation is
base64. Protect etcd, RBAC, Pod-creation permission, delivery, logs, backups,
and rotation. CloudCart commits only references and generates random lab values
inside its disposable namespace.

Environment variables are read at process start. Mounted ConfigMap/Secret
volumes update eventually, but applications must reload them; `subPath` mounts
do not receive updates. Pin behavior through a rollout when configuration must
change atomically. Validate required keys using non-optional references.

Configuration has a contract: names, keys, types, defaults, validation, owner,
reload behavior, and compatibility across old/new replicas. Kubernetes delivers
bytes; the application remains responsible for parsing and safe activation.

## Probe semantics

Probes answer different questions:

- startup: has slow initialization completed? Until success, other probes wait;
- readiness: should this Pod receive Service traffic? Failure does not restart it;
- liveness: is restart likely to repair a stuck process? Failure restarts it.

Do not make liveness depend on a shared database: an outage would restart every
client and add load. CloudCart liveness checks its API process; readiness checks
database usability. The relay/worker lack a truthful progress endpoint, so fake
exec probes are intentionally omitted.

Probe timing must reflect measured startup and failure behavior. Aggressive
timeouts can create self-inflicted outages under CPU pressure; overly generous
thresholds delay detection. Probe success is component-local evidence, not an
end-to-end user transaction.

## Requests, limits, and QoS

Requests drive scheduling and reserved capacity; limits constrain runtime.
CPU limits throttle, memory-limit breaches can cause OOM termination, and
ephemeral storage also needs consideration. QoS classification follows request/
limit relationships, but “Guaranteed” is not an availability promise. Start
with measured usage plus headroom and refine from telemetry.

Requests cover every app and sidecar container and affect rollout and failure
headroom. Limits are not capacity reservations. Later modules derive effective
Pod requests, QoS, throttling, eviction, placement, and autoscaling in detail.

## Workload security baseline

Default service-account tokens are disabled for CloudCart Pods because they do
not call the Kubernetes API. Containers run non-root, drop capabilities, use a
read-only root filesystem where supported, and use RuntimeDefault seccomp.
Do not copy one security context onto an untested vendor image: PostgreSQL and
RabbitMQ entrypoints require startup ownership/user transitions in this baseline.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Workload controllers](02-workload-controllers.md) · Next: [Services, rollouts, and operations](04-services-rollouts-operations.md)
