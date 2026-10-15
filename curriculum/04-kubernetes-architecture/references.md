# References and Videos

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

Written upstream documentation is authoritative for version-sensitive behavior.

## Primary references

- [Kubernetes components](https://kubernetes.io/docs/concepts/overview/components/) — official responsibility map.
- [Cluster architecture](https://kubernetes.io/docs/concepts/architecture/) — nodes, control plane, communication, controllers, and leases.
- [Controllers](https://kubernetes.io/docs/concepts/architecture/controller/) — control-loop and desired-state model.
- [The Kubernetes API](https://kubernetes.io/docs/concepts/overview/kubernetes-api/) — resources, groups, versions, and compatibility.
- [Kubernetes API concepts](https://kubernetes.io/docs/reference/using-api/api-concepts/) — discovery, resource versions, watches, updates, and deletion.
- [Admission control](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/) — built-in request admission behavior.
- [Dynamic admission control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/) — webhook semantics and operational cautions.
- [Scheduling framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/) — scheduler extension and execution phases.
- [Leases](https://kubernetes.io/docs/concepts/architecture/leases/) — node heartbeats and leader election records.
- [Extending Kubernetes](https://kubernetes.io/docs/concepts/extend-kubernetes/) — CRDs, aggregation, and extension tradeoffs.
- [Kubernetes version-skew policy](https://kubernetes.io/releases/version-skew-policy/) — supported component and client relationships.
- [Operating etcd clusters for Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/) — backup and recovery foundations.
- [kind quick start](https://kind.sigs.k8s.io/docs/user/quick-start/) and
  [kind v0.33.0 release](https://github.com/kubernetes-sigs/kind/releases/tag/v0.33.0) — local cluster behavior and pinned node images.

## Videos

- [The Life (or Death) of a Kubernetes API Request, 2025 Edition](https://www.youtube.com/watch?v=Hc0jj-654lA) — Abu Kashem and Stefan Schimanski, CNCF/KubeCon Europe, 2025. Use it to connect API request phases, storage, and failure behavior. Verify flags and implementation details against the current official docs.
- [Kubernetes Deconstructed: Understanding Kubernetes by Breaking It Down](https://www.youtube.com/watch?v=90kZRyPcRZw) — Carson Anderson, CNCF/KubeCon, 2018. Use it for the durable component and control-loop mental model. **Age warning:** commands, component defaults, APIs, and installation practices shown may be obsolete; do not copy them without current documentation.

## Reading strategy

1. Read components and controllers before memorizing commands.
2. Use API concepts while running Lab 2 and inspect real metadata.
3. Read Leases and etcd operations before Lab 3.
4. Treat the videos as explanatory supplements, then resolve any version-sensitive claim through current primary documentation.

> **Module:** [04 — Kubernetes Architecture](README.md) · Previous:
> [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
