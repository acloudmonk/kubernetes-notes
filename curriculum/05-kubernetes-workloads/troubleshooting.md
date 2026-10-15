# Troubleshooting

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)

| Symptom | First evidence | Typical boundary |
|---|---|---|
| Pending, no node | PodScheduled condition, Events | requests, taints, selectors, volumes |
| `ImagePullBackOff` | waiting reason, Events, image reference | name/tag/digest, registry auth/network |
| `CreateContainerConfigError` | waiting message, ConfigMap/Secret keys | missing referenced configuration |
| `CrashLoopBackOff` | exit code, reason, current and `--previous` logs | process/config/runtime failure |
| Running but 0/1 Ready | probe result, app/dependency evidence | readiness contract |
| Deployment stalled | conditions, new/old ReplicaSets, Pod evidence | template failure or capacity |
| Service has no traffic | selector, Pod readiness, EndpointSlices | label/port/readiness mismatch |
| Job retries/exhausts | Job conditions, Pods, logs, deadline | non-idempotent or persistent task failure |

Never start with “delete the Pod.” Record context, object generation, owner,
conditions, Events, restart count, exit reason, previous logs, node, and endpoint
membership. Correct desired state, then verify controller convergence and user
behavior. For OOM, confirm `OOMKilled` and usage before increasing a limit; for
probe failure, test the exact path from the Pod network context.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
