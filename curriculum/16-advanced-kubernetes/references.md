# References and Videos

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module home](README.md)

## Primary written references

- [Kubernetes custom resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) and [CRD tasks/versioning](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definition-versioning/)
- [Kubernetes controllers](https://kubernetes.io/docs/concepts/architecture/controller/) and [finalizers](https://kubernetes.io/docs/concepts/overview/working-with-objects/finalizers/)
- [Kubernetes API conventions](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md) and [controller conventions](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-api-machinery/controllers.md)
- [Operator pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) and [Kubebuilder book](https://book.kubebuilder.io/)
- [Istio supported releases](https://istio.io/latest/docs/releases/supported-releases/), [ambient architecture](https://istio.io/latest/docs/ambient/architecture/), and [security best practices](https://istio.io/latest/docs/ops/best-practices/security/)
- [Istio authorization policy](https://istio.io/latest/docs/reference/config/security/authorization-policy/) and [ambient getting started](https://istio.io/latest/docs/ambient/getting-started/)
- [Cilium eBPF introduction](https://docs.cilium.io/en/stable/reference-guides/bpf/), [Kubernetes autoscaling](https://kubernetes.io/docs/concepts/workloads/autoscaling/), and [KEDA concepts](https://keda.sh/docs/latest/concepts/)
- [Kubernetes multi-cluster SIG](https://multicluster.sigs.k8s.io/) and [CNCF Cloud Native Security whitepaper](https://github.com/cncf/tag-security/tree/main/security-whitepaper)

## Videos

- [Life of a Kubernetes API Request](https://www.ithome.com.tw/video/110587) — Daniel Smith, KubeCon, 2016. Excellent API-machinery foundation; commands and versions are old, so use current docs for details.
- [Build Your Own Kubernetes Operators with Go and Kubebuilder](https://www.youtube.com/watch?v=odP153inZUo) — Shubham Katara/freeCodeCamp, 2025. Deep controller, informer, idempotency, and finalizer practice; this module uses Python to expose the same API mechanics.
- [Ambient Mesh with Marino Wijay and Matt Turner](https://rawkode.academy/watch/ambient-mesh-with-marino-wijay-and-matt-turner) — Cloud Native Compass, 2023. Explains ztunnel, HBONE, waypoints, and sidecar tradeoffs; verify current 1.31 behavior in official docs.
- [Is Your Kubernetes Disaster Recovery Actually Ready?](https://www.youtube.com/watch?v=21_7qv7J8GI) — Saiyam Pathak and Saloni Narang, CNCF/KubeCon, 2026. Connects fleet design to tested application recovery.

Written primary sources remain authoritative for APIs, support, installation,
and security-sensitive behavior.

> **Module:** [16 — Advanced Kubernetes](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module home](README.md)
