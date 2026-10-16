# Pods and Container Lifecycle

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Module overview](README.md) · Next: [Workload controllers](02-workload-controllers.md)

## Pod mental model

A Pod is the smallest schedulable API object: one or more containers sharing a
network namespace, IP, localhost, and declared volumes. Put containers together
only when they share lifecycle and placement. A Pod is not a durable machine;
replacement creates a new UID and usually a new IP.

The scheduler assigns the Pod as a unit; kubelet realizes that assignment on one
node. Containers in a Pod cannot be independently placed or scaled. Use a
multi-container Pod only for tightly coupled processes that must share fate,
local networking, or volumes—not merely because two services communicate.

## Phase, conditions, and container state

Pod phase (`Pending`, `Running`, `Succeeded`, `Failed`, `Unknown`) is coarse.
Container state (`Waiting`, `Running`, `Terminated`), reason, exit code, restart
count, conditions, and Events explain behavior. `CrashLoopBackOff` is a kubectl
status presentation of repeated failure and increasing restart delay, not a Pod phase.

Conditions answer separate questions such as whether scheduling, initialization,
container readiness, and overall readiness have succeeded. A Running Pod can be
unready, repeatedly restarting, or serving incorrect responses. Always combine
phase with conditions, container state, Events, and application evidence.

## Initialization, restart, and sidecars

`restartPolicy` applies to containers on a node: `Always`, `OnFailure`, or
`Never`. Controllers replace terminal or deleted Pods according to their own
desired state. An init container runs to successful completion before app
containers; make it idempotent because it can retry. A native sidecar has its
own lifecycle semantics; avoid using an ordinary helper whose shutdown ordering
can block the main process.

Ephemeral containers are a diagnostic facility added to an existing Pod. They
do not participate like normal app containers in probes, ports, resources, or
restart behavior and should not become a hidden deployment mechanism.

## Graceful termination

On deletion, the kubelet starts graceful termination: lifecycle hooks and
SIGTERM are followed by the grace period, then forced termination. Applications
must stop accepting work, finish bounded in-flight work, and exit. `preStop`
does not replace signal handling and consumes the same grace period.

Endpoint removal and process termination are coordinated but not an instantaneous
global transaction; clients, proxies, and load balancers may retain connections.
Applications need bounded draining, idempotent work handling, and timeouts that
fit inside the termination budget.

## Pod-local storage

Use `emptyDir` for Pod-lifetime scratch data. It survives container restarts in
the same Pod but disappears with the Pod. Never mistake it for durable storage.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Module overview](README.md) · Next: [Workload controllers](02-workload-controllers.md)
