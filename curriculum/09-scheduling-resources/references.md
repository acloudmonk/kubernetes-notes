# References and Videos

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)

## Primary references

- [Kubernetes scheduler](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/) and [scheduling framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/)
- [Resource management for Pods and containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) and [Pod QoS classes](https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/)
- [Assigning Pods to nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/), [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/), and [topology spread](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/)
- [Pod priority and preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/) and [PodDisruptionBudget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) and [node autoscaling](https://kubernetes.io/docs/concepts/cluster-administration/node-autoscaling/)
- [Node-pressure eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/) and [API-initiated eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/api-eviction/)
- [Metrics Server documentation](https://github.com/kubernetes-sigs/metrics-server) and [0.9.0 release](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.9.0)

## Videos

- [Kubernetes SIG-Scheduling Introduction and Deep Dive](https://www.classcentral.com/course/youtube-sig-scheduling-intro-deep-dive-wei-huang-apple-kante-yin-daocloud-286677) — Wei Huang and Kante Yin, CNCF/KubeCon. Use it to connect framework stages and plugins. **Age warning:** verify APIs and defaults in current upstream docs.
- [Cloud Native Live: Kubernetes automatic rightsizing](https://www.cncf.io/online-programs/cloud-native-live-kubernetes-automatic-rightsizing/) — Andy Suderman, CNCF. Use it to compare requests, utilization, and rightsizing automation. **Age warning:** tool behavior evolves; the concepts here do not replace current project documentation.

## Reading method

For each source, record the responsible control loop, inputs, persisted/status
fields, failure modes, and evidence. Treat videos as conceptual reinforcement;
the current upstream documentation and tested repository baseline remain
authoritative.

> **Module:** [09 — Kubernetes Scheduling and Resources](README.md) · Previous: [Knowledge check](quiz.md) · Next: [Module completion](README.md#completion)
