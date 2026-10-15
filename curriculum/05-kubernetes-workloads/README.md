# 05 — Kubernetes Workloads

**Status:** Verified<br>
**Estimated time:** 22–28 hours<br>
**Prerequisites:** [04 — Kubernetes Architecture](../04-kubernetes-architecture/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous:
> [Kubernetes architecture](../04-kubernetes-architecture/README.md) ·
> Next: Networking and discovery (planned)

## Why this matters

Kubernetes operates Pod templates through controllers. Reliable deployment
requires more than valid YAML: lifecycle, restart behavior, truthful probes,
resource requests, configuration ownership, rollout safety, and observable
failure modes must agree with application behavior.

## Learning objectives

You can select and operate Pods, Deployments, ReplicaSets, Jobs, DaemonSets,
and StatefulSets; design probes and graceful termination; inject configuration
without committing credentials; expose ready backends through a Service;
perform and reverse a rollout; and diagnose Pending, image-pull, crash-loop,
configuration, and readiness failures from evidence.

## Contents

1. [Pods and container lifecycle](01-pods-and-lifecycle.md)
2. [Workload controllers](02-workload-controllers.md)
3. [Configuration, probes, and resources](03-configuration-probes-resources.md)
4. [Services, rollouts, and operations](04-services-rollouts-operations.md)
5. [Quick exercises](quick-exercises.md)
6. [Lab 1 — Deploy CloudCart](labs/01-deploy-cloudcart.md)
7. [Lab 2 — Fail, update, and recover](labs/02-fail-update-recover.md)
8. [Independent challenge](independent-challenge.md)
9. [Troubleshooting](troubleshooting.md)
10. [Interview questions](interview-questions.md)
11. [Knowledge check](quiz.md)
12. [References and videos](references.md)
13. [Gate 2 — Kubernetes application operator](../ASSESSMENT-GATES.md#gate-2--kubernetes-application-operator)

## Tested baseline

The lab uses the [Module 04 baseline](../../VERSION-MATRIX.md), the local
`cloudcart-app:0.1.0` image, PostgreSQL 17.11, and RabbitMQ 4.2.9. Dependency
data uses disposable `emptyDir`; persistence is Module 07. Allow 5 GB memory
and 6 GB disk. Generated lab credentials exist only inside the temporary cluster.

## Completion

- [ ] **Explain:** choose a controller and predict Pod/probe/rollout behavior.
- [ ] **Build:** deploy and verify the full CloudCart request-to-event path.
- [ ] **Diagnose:** recover a readiness failure and a bad rollout using evidence.
- [ ] Complete the independent challenge and Gate 2 assessment.

## Continue

Return to the [curriculum index](../README.md). Module 06 will be linked when
networking and discovery material is available.
