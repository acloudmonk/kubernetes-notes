# ADR 0003: Use kind for the local Kubernetes baseline

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decision owners:** Repository maintainers

## Context

The curriculum needs a reproducible local Kubernetes cluster for architecture,
workload, networking, security, Helm, observability, and failure labs. The host
already has Docker Desktop with a Linux engine and `kubectl`, but no Kubernetes
context. Candidate baselines are Docker Desktop Kubernetes, kind, and minikube.

Docker Desktop Kubernetes is convenient but couples cluster behavior and
lifecycle to desktop settings. Minikube offers multiple drivers and useful
addons, but that variability adds choices before the control-plane model is
understood. kind runs Kubernetes nodes as Docker containers, supports pinned
node images and multi-node topologies, and makes node and static-Pod internals
easy to inspect.

## Decision

Use kind 0.33.0 with the digest-pinned Kubernetes 1.36.4 node image as the
primary local baseline. Start with one control-plane node and one worker. Use a
unique cluster name, context guards in validation and cleanup, and no host port
mapping unless a later lab requires it.

The pinned node image is:

```text
kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed
```

## Consequences

Learners can inspect kubeadm-managed static Pods, kubelet/containerd state, and
multi-node scheduling using the existing Docker engine. Cluster state is
disposable and cleanup is explicit. kind is not a production distribution: it
does not teach cloud load balancers, managed control planes, durable storage,
or provider IAM by itself. Those are introduced through later ADRs and labs.

## Validation

- Create the two-node cluster from the versioned configuration.
- Verify client/server skew, node readiness, system Pods, API discovery, and
  control-plane static-Pod manifests.
- Trace a declarative object through API storage, controllers, scheduling, and
  kubelet execution.
- Stop a worker node, observe status and reconciliation, restore it, and verify
  recovery.
- Delete only the named lab cluster and confirm its context and node containers
  are removed.
