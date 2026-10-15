# References and Videos

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

## Primary references

- [Kubernetes networking](https://kubernetes.io/docs/concepts/services-networking/) and [cluster networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)
- [Services](https://kubernetes.io/docs/concepts/services-networking/service/), [EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/), and [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) and [Gateway API](https://gateway-api.sigs.k8s.io/)
- [Gateway API getting started](https://gateway-api.sigs.k8s.io/guides/getting-started/) and [security model](https://gateway-api.sigs.k8s.io/concepts/security-model/)
- [Envoy Gateway YAML installation](https://gateway.envoyproxy.io/v1.8/install/install-yaml/) and [quickstart](https://gateway.envoyproxy.io/v1.8/tasks/quickstart/) for the pinned 1.8.5 lab controller.
- [CoreDNS Kubernetes plugin](https://coredns.io/plugins/kubernetes/) and [CNI specification](https://www.cni.dev/docs/spec/)

## Videos

- [Surviving Day 2 — How to Troubleshoot Kubernetes Networking](https://www.youtube.com/watch?v=920BZXvQpVs) — Thomas Graf, CNCF/KubeCon Europe, 2023. Use it for layered DNS, Service, CNI, policy, and observability diagnosis; verify commands against current implementations.
- [Kubernetes Network Policy: From Basics to Advanced](https://www.youtube.com/watch?v=LoljdaEaHjY) — Thomas Graf, CNCF, 2021. Use it to reason about isolation, selector composition, and policy unions. **Age warning:** implementation-specific features and tooling may have changed; the current Kubernetes API docs are authoritative.

> **Module:** [06 — Kubernetes Networking and Discovery](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
