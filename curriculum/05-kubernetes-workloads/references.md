# References and Videos

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

## Primary references

- [Workloads](https://kubernetes.io/docs/concepts/workloads/), [Pods](https://kubernetes.io/docs/concepts/workloads/pods/), and [Pod lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/), [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/), and [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
- [Init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) and [container lifecycle hooks](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)
- [Liveness, readiness, and startup probes](https://kubernetes.io/docs/concepts/workloads/pods/probes/)
- [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) and [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) and [Pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
- [Services](https://kubernetes.io/docs/concepts/services-networking/service/) and [EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/)
- [Kustomize](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/) for the committed plain-manifest grouping used by the lab.

## Videos

- [Cloud Native Live: Automating Kubernetes Deployments](https://www.youtube.com/watch?v=rK1Y6d1A9Ck) — CNCF, 2023. Use it to compare manual workload changes with repeatable deployment automation. **Age warning:** verify tool versions and commands against current docs.
- [Kubernetes Liveness Probes: Keep Pods Healthy](https://www.youtube.com/watch?v=9a5o2eg4RtM) — Pravin Mishra, 2025. Use the hands-on failure demo to contrast restart behavior with readiness gating; treat official Kubernetes probe documentation as authoritative.

Read the primary pages before the videos, reproduce behavior in the labs, and
recheck any version-sensitive defaults against the baseline.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
