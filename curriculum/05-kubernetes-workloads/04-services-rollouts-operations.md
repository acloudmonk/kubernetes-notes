# Services, Rollouts, and Operations

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Configuration, probes, and resources](03-configuration-probes-resources.md) · Next: [Quick exercises](quick-exercises.md)

A ClusterIP Service gives a stable virtual address and DNS name over selected
Pods. Selectors match labels; EndpointSlices contain current backends. Readiness
normally removes an unready Pod from ready endpoints. A Service does not wait
for the application, create Pods, or guarantee successful requests.

`port` is the Service port, `targetPort` resolves to a container port/name, and
`containerPort` is descriptive metadata rather than a firewall. Module 06 will
trace DNS, kube-proxy/data-plane behavior, NetworkPolicy, and external entry.

Operate declaratively: diff intended state, apply it with explicit field
ownership, observe generation/conditions/ReplicaSets, and verify application
behavior. `kubectl rollout status`, history, pause/resume, undo, and revision
annotations are tools—not deployment policy by themselves. Mutable tags make
rollback ambiguous; use immutable digests in production.

Debug in sequence: context/API → object validation → controller status → Pod
condition/Events → scheduling → image/config → init/startup → readiness →
Service endpoints → application logs and dependency evidence. Capture current
and `--previous` logs before replacement. `kubectl exec` is a diagnostic escape
hatch, not configuration management.

CloudCart uses a migration Job before application Deployments, two API replicas,
one relay, one worker, and disposable dependency Deployments. PostgreSQL and
RabbitMQ are deliberately not production designs; Modules 07 and 15 address
state and production operations.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Configuration, probes, and resources](03-configuration-probes-resources.md) · Next: [Quick exercises](quick-exercises.md)
