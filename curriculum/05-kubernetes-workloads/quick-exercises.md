# Quick Exercises

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Services, rollouts, and operations](04-services-rollouts-operations.md) · Next: [Lab 1 — Deploy CloudCart](labs/01-deploy-cloudcart.md)

1. Choose Deployment, StatefulSet, DaemonSet, or Job for an API, database,
   node log agent, and migration; state the invariant behind each choice.
2. Predict Pod phase, container state, readiness, Service endpoints, and restart
   behavior when CloudCart's database disappears.
3. Design separate startup, readiness, and liveness questions for a slow API.
4. Calculate peak Pods for replicas 4, `maxSurge: 25%`, `maxUnavailable: 25%`.
5. Explain why changing a ConfigMap environment value does not change a running process.
6. Decide what evidence to save before deleting a CrashLooping Pod.

Success requires mechanisms and evidence, not only commands.

> **Module:** [05 — Kubernetes Workloads](README.md) · Previous: [Services, rollouts, and operations](04-services-rollouts-operations.md) · Next: [Lab 1 — Deploy CloudCart](labs/01-deploy-cloudcart.md)
