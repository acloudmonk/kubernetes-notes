# 04 — Kubernetes Architecture

**Status:** Verified<br>
**Estimated time:** 18–24 hours<br>
**Prerequisites:** [03 — Microservices and Distributed Data](../03-microservices-distributed-data/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous:
> [Microservices and distributed data](../03-microservices-distributed-data/README.md) ·
> Next: [Kubernetes workloads](../05-kubernetes-workloads/README.md)

## Why this matters

Kubernetes is an API-driven control system, not a collection of imperative
deployment commands. Operators diagnose it effectively when they can locate
desired state, observe current state, identify the responsible controller, and
follow the request or reconciliation path between them. This module builds
that model before introducing workload configuration in depth.

## Learning objectives

You can:

- Assign responsibilities to control-plane, node, runtime, networking, and
  storage components without confusing interfaces with implementations.
- Trace a request through authentication, authorization, admission, storage,
  watches, reconciliation, scheduling, and kubelet execution.
- Read Kubernetes objects as API records with identity, desired state,
  observed state, ownership, versions, and deletion lifecycle.
- Explain level-triggered reconciliation, controller ownership, scheduling,
  leases, leader election, and common failure behavior.
- Compare local, self-managed, and managed cluster responsibilities.
- Use API discovery and cluster evidence to diagnose a deliberately failed
  control plane or node.

## Contents

Follow these pages in order:

1. [Cluster components and responsibility boundaries](01-cluster-components.md)
2. [API requests and the object model](02-api-request-and-object-model.md)
3. [Reconciliation, scheduling, and node execution](03-reconciliation-scheduling-node.md)
4. [Lifecycle, availability, and extensibility](04-cluster-lifecycle-extensibility.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Create and inspect a kind cluster](labs/01-create-and-inspect-cluster.md)
7. [Lab 2 — Trace reconciliation](labs/02-trace-reconciliation.md)
8. [Lab 3 — Observe control-plane and node failure](labs/03-control-plane-and-node-failure.md)
9. [Independent challenge](independent-challenge.md)
10. [Troubleshooting](troubleshooting.md)
11. [Interview questions](interview-questions.md)
12. [Knowledge check](quiz.md)
13. [References and videos](references.md)

## Tested baseline

The exact executed baseline is recorded in the
[version matrix](../../VERSION-MATRIX.md). The lab uses:

- Docker Desktop with the Linux container engine
- `kubectl` 1.36.1
- kind 0.33.0
- Kubernetes 1.36.4 using a digest-pinned kind node image
- one control-plane node and one worker node

Allow approximately 4 GB free memory and 5 GB free disk space. The cluster is
local, temporary, non-production, and contains no credentials worth retaining.

## Completion

- [ ] **Explain:** trace an API write and a Pod from manifest to running process.
- [ ] **Build:** create, inspect, verify, and precisely delete the lab cluster.
- [ ] **Diagnose:** distinguish API-server unavailability from node unavailability.
- [ ] Explain which component owns each observed transition and which evidence proves it.
- [ ] Complete the independent challenge without copying the guided lab.

## Continue

Continue to [05 — Kubernetes Workloads](../05-kubernetes-workloads/README.md),
or return to the [curriculum index](../README.md).
