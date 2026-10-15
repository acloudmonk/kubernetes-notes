# Version Matrix

This file records versions against which labs are tested. It does not promise
compatibility with every older or future release.

## Policy

- Pin a baseline before publishing an executable lab.
- Prefer supported stable releases.
- Record Kubernetes client, cluster, and API compatibility separately.
- Avoid floating image tags in reproducible exercises.
- Review baselines when supported tools reach end of life.
- Document intentional deprecated-API use in its migration lab.

## Current baseline

Phase 2A prerequisite labs, the Module 01–02 container labs, and the Module 04–11
Kubernetes labs are verified against the local baseline below.
Module 03 application verification is tracked against the same Docker environment.

| Component | Baseline | Local discovery | Planned phase |
|---|---|---|---|
| Git | 2.46.0.windows.1 | Verified for Phase 2A | All phases |
| Python | 3.12.0 | Verified for Phase 2A | Phase 2A onward |
| Docker Desktop | 4.87.0 | Linux engine verified on 2026-10-15 | Phase 2B |
| Docker Engine | 29.7.2, Linux/amd64 | Verified for Modules 01–02 | Phase 2B |
| Docker CLI | 29.7.2 | Verified for Modules 01–02 | Phase 2B |
| Docker Compose | 5.4.0 | Verified for Module 02 | Phase 2B |
| FastAPI | 0.143.1 | Pinned for CloudCart Module 03 | Phase 3 |
| Uvicorn | 0.53.0 | Pinned for CloudCart Module 03 | Phase 3 |
| Psycopg | 3.3.6 | Pinned for CloudCart Module 03 | Phase 3 |
| Pika | 1.4.4 | Pinned for CloudCart Module 03 | Phase 3 |
| PostgreSQL | 17.11 | Pinned container for CloudCart Module 03 | Phase 3 |
| RabbitMQ | 4.2.9 | Pinned container for CloudCart Module 03 | Phase 3 |
| `kubectl` | 1.36.1 | Verified against Kubernetes 1.36.4 | Phase 3 |
| kind | 0.33.0 | Verified for Modules 04–11 | Phase 3–5 |
| Local Kubernetes | 1.36.4 (`kindest/node`, digest pinned) | Verified for Modules 04–11 | Phase 3–5 |
| Node container runtime | containerd 2.3.4 | Observed on both kind nodes | Phase 3 |
| Envoy Gateway | 1.8.5 | Verified for Module 06 | Phase 3 |
| kind local-path provisioner | `rancher.io/local-path` | Verified for Module 07 | Phase 4 |
| Metrics Server | 0.9.0 | Verified for Module 09 | Phase 4 |
| Helm | 4.3.1 | Verified for Module 11 | Phase 5 |
| Prometheus stack | To be selected | Not selected | Phase 6 |
| GitOps controller | To be selected by ADR | Not selected | Phase 7 |

Executable modules list only the versions they require.

The WSL status command was inaccessible from the validation process, so no WSL
distribution or version is claimed as tested in Phase 2A.

Module 01 was runtime-verified using `alpine:3.22.2`. Verification covered image
identity, process and cgroup evidence, CPU and memory limits, writable-layer
persistence, graceful signal handling, finite-process exit behavior, and scoped
cleanup.

Module 02 was runtime-verified using its multi-stage Python image and Compose
environment. Verification covered clean and cached builds, health checks,
service DNS, controlled dependency failures and recovery, PostgreSQL
initialization and backup restoration, non-root execution, read-only root
filesystem, writable `tmpfs`, graceful shutdown, dropped capabilities,
resource limits, and scoped cleanup.

Module 03 uses Python 3.12, a PostgreSQL-backed FastAPI API, a transactional
outbox relay, RabbitMQ, and an idempotent notification worker. Its status remains
Draft until unit, integration, container, broker-failure, duplicate-delivery,
dead-letter, and cleanup checks have all been executed on this baseline.

Module 04 was runtime-verified with a two-node kind cluster. Verification
covered API discovery, client/server compatibility, Ready nodes, system Pods,
static control-plane manifests, Deployment → ReplicaSet → Pod ownership,
server-side field ownership, worker scheduling, containerd state, replica
reconciliation, control-plane interruption, stale worker heartbeat/Lease
behavior, recovery, and precise cleanup.

Module 05 was runtime-verified with the locally built `cloudcart-app:0.1.0`
image on the same two-node baseline. Verification covered five Deployments,
two ready API endpoints, a completed migration Job, probes, resources,
non-root/read-only application containers, disabled service-account token
mounts, Service discovery, order/outbox/worker completion, dependency-readiness
failure without liveness restarts, migration recovery after disposable data
loss, a failed image rollout with old replicas preserved, rollback, server-side
validation, generated in-cluster credentials, and precise cleanup.

Module 06 was runtime-verified on the same two-node kind baseline with Envoy
Gateway 1.8.5. Verification covered Service DNS, EndpointSlice readiness,
allowed and denied NetworkPolicy paths, Gateway and HTTPRoute conditions,
Gateway-to-backend routing, selector failure and recovery, policy-induced
readiness failure without liveness restarts, the complete order event path,
idempotent deployment, server-side manifest validation, and precise cleanup.

Module 07 was runtime-verified with the kind `standard` StorageClass using the
`rancher.io/local-path` provisioner, `WaitForFirstConsumer`, and `Delete` reclaim
policy. Verification covered dynamic PVC/PV binding, StatefulSet identity,
retained PVC reuse after Pod and StatefulSet replacement, persisted CloudCart
orders, an intentional nonexistent-class Pending claim, isolated PostgreSQL
logical backup/restore, idempotent deployment, server-side validation, and
precise cleanup. The baseline does not advertise volume expansion or snapshots.

Module 08 was runtime-verified on the Module 07 CloudCart baseline. Verification
covered ConfigMap resource updates, unchanged existing process environments,
controlled replacement and baseline restoration, required missing-Secret
`CreateContainerConfigError` evidence, generated PostgreSQL credential rotation,
stdin-only Secret replacement, consumer rollouts, post-rotation order
persistence, failure-path credential restoration, repeat execution, server-side
validation, and precise cleanup. No external secret controller or etcd
encryption configuration is claimed as locally tested.

Module 09 was runtime-verified on a three-node kind cluster with Metrics Server
0.9.0. Verification covered requested-capacity scheduling evidence, two-worker
API spread, node affinity, QoS derivation, non-preempting priority, disruption
budget health, HPA resource metrics, controlled Pending and OOMKilled fixtures,
the persisted CloudCart event path, repeat deployment and test execution,
server-side validation, and precise cleanup.

Module 10 was runtime-verified on a two-node kind cluster with stable native Pod
Security Admission and `admissionregistration.k8s.io/v1`
ValidatingAdmissionPolicy. Verification covered dedicated tokenless CloudCart
identities, namespaced least-privilege RBAC allows and denies, pinned Restricted
admission, CEL policy denial, quota accounting, the persisted CloudCart event
path, repeat deployment and test execution, expected-denial server validation,
and precise cleanup.

Module 11 was runtime-verified with Helm 4.3.1 on the same two-node kind and
Kubernetes baseline. Verification covered strict linting, default rendering,
expected JSON Schema rejection of invalid and unknown values, server-side API
validation, install/upgrade with Job waiting, a completed migration, checksum-
driven configuration rollout, an intentionally failed image revision, rollback,
chart tests, externally owned generated credentials, the persisted CloudCart
event path, chart packaging, repeat execution, and precise cleanup.
