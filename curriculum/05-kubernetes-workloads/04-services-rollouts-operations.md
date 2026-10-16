# Services, Rollouts, and Operations

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Configuration, probes, and resources](03-configuration-probes-resources.md) · Next: [Quick exercises](quick-exercises.md)

## Service boundary

A ClusterIP Service gives a stable virtual address and DNS name over selected
Pods. Selectors match labels; EndpointSlices contain current backends. Readiness
normally removes an unready Pod from ready endpoints. A Service does not wait
for the application, create Pods, or guarantee successful requests.

`port` is the Service port, `targetPort` resolves to a container port/name, and
`containerPort` is descriptive metadata rather than a firewall. Module 06 will
trace DNS, kube-proxy/data-plane behavior, NetworkPolicy, and external entry.

The Service and workload have separate lifecycles. A selector typo can produce
zero endpoints or select the wrong Pods even when both objects are individually
valid. Named ports reduce coupling only when names and protocols remain consistent.

## Declarative rollout practice

Operate declaratively: diff intended state, apply it with explicit field
ownership, observe generation/conditions/ReplicaSets, and verify application
behavior. `kubectl rollout status`, history, pause/resume, undo, and revision
annotations are tools—not deployment policy by themselves. Mutable tags make
rollback ambiguous; use immutable digests in production.

Separate deployment success from release success: controller availability is
necessary, while synthetic or business verification proves the intended user
path. Define abort and rollback criteria before an update, including database and
message compatibility that Kubernetes cannot infer.

## Evidence-driven diagnosis

Debug in sequence: context/API → object validation → controller status → Pod
condition/Events → scheduling → image/config → init/startup → readiness →
Service endpoints → application logs and dependency evidence. Capture current
and `--previous` logs before replacement. `kubectl exec` is a diagnostic escape
hatch, not configuration management.

Events are scoped, transient evidence rather than a permanent audit trail. Export
important platform and application telemetry, and preserve a minimal incident
timeline before failed Pods, prior logs, or EndpointSlice state disappear.

## CloudCart scope

CloudCart uses a migration Job before application Deployments, two API replicas,
one relay, one worker, and disposable dependency Deployments. PostgreSQL and
RabbitMQ are deliberately not production designs; Modules 07 and 15 address
state and production operations.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Configuration, probes, and resources](03-configuration-probes-resources.md) · Next: [Quick exercises](quick-exercises.md)
