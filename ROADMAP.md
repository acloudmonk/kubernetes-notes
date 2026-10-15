# Curriculum Roadmap

## Goal

Develop practitioner-to-senior-level knowledge of containerized applications
and Kubernetes platforms through theory, implementation, operations, and
interview practice. The core path is approximately 26 weeks at 8–12 hours per
week; progress is based on demonstrated outcomes, not elapsed time.

## Stages

| Stage | Duration | Outcome |
|---|---:|---|
| Prerequisites | 2 weeks | Diagnose Linux, DNS, HTTP, TLS, and Git problems |
| Containers and Docker | 3 weeks | Build and operate secure, efficient images |
| Microservices and distributed data | 3 weeks | Design boundaries, contracts, consistency, and failure handling |
| Kubernetes core | 5 weeks | Deploy and troubleshoot application workloads |
| Networking and storage | 3 weeks | Operate routing, policy, TLS, and stateful workloads |
| Security and resources | 2 weeks | Apply least privilege and workload constraints |
| Helm | 2 weeks | Package, validate, upgrade, and roll back applications |
| Observability | 3 weeks | Use metrics, logs, traces, alerts, and SLOs |
| CI/CD, supply chain, and GitOps | 2 weeks | Produce evidence, promote safely, and reconcile delivery |
| Infrastructure and production operations | 3 weeks | Provision, scale, upgrade, recover, and control cost |

## Planned modules

Follow this table from top to bottom. A linked module is available to study;
plain text identifies planned content that is not ready yet.

| Order | Module | Status | Scope |
|---:|---|---|---|
| 00 | [Prerequisites](curriculum/00-prerequisites/README.md) | Draft | Linux, networking, Git, YAML, shell, distributed systems |
| 01 | [Container fundamentals](curriculum/01-container-fundamentals/README.md) | Draft | Processes, namespaces, cgroups, filesystems, runtimes |
| 02 | [Docker](curriculum/02-docker/README.md) | Verified | Images, Dockerfiles, BuildKit, Compose, registries, security |
| 03 | [Microservices and distributed data](curriculum/03-microservices-distributed-data/README.md) | Draft | Boundaries, APIs, transactions, messaging, consistency, resilience |
| 04 | [Kubernetes architecture](curriculum/04-kubernetes-architecture/README.md) | Verified | API, control plane, nodes, reconciliation, extensibility |
| 05 | [Kubernetes workloads](curriculum/05-kubernetes-workloads/README.md) | Verified | Pods, controllers, probes, configuration, rollouts |
| 06 | [Networking and discovery](curriculum/06-networking-discovery/README.md) | Verified | CNI, Services, DNS, Gateway API, policy, TLS |
| 07 | [Storage and state](curriculum/07-storage-state/README.md) | Verified | PVs, PVCs, StorageClasses, CSI, StatefulSets, recovery |
| 08 | [Configuration and secrets](curriculum/08-configuration-secrets/README.md) | Verified | Configuration, secret delivery, and rotation |
| 09 | [Scheduling and resources](curriculum/09-scheduling-resources/README.md) | Verified | Requests, QoS, placement, disruption, autoscaling |
| 10 | [Security and policy](curriculum/10-security-policy/README.md) | Verified | Identity, RBAC, workload security, admission, multi-tenancy |
| 11 | [Helm](curriculum/11-helm/README.md) | Verified | Templates, values, dependencies, tests, OCI, lifecycle |
| 12 | Prometheus | Planned | Collection, PromQL, rules, Alertmanager, cardinality |
| 13 | Grafana and observability | Planned | Dashboards, logs, traces, OpenTelemetry, SLOs |
| 14 | CI/CD, supply chain, and GitOps | Planned | Tests, SBOMs, signing, policy, promotion, reconciliation |
| 15 | Infrastructure and production operations | Planned | IaC, managed Kubernetes, HA, upgrades, recovery, cost |
| 16 | Advanced Kubernetes | Planned | Operators, service mesh, multi-cluster, ecosystem |

## Capstone milestones

1. Define requirements, boundaries, APIs, events, risks, and SLOs.
2. Implement a tested modular application.
3. Containerize it and run dependencies with Docker Compose.
4. Decompose selected workflows to demonstrate service communication.
5. Deploy it with plain Kubernetes manifests.
6. Add persistence, routing, TLS, policy, resources, and autoscaling.
7. Package it as a reusable Helm chart.
8. Add telemetry, dashboards, alerts, and runbooks.
9. Deliver it through CI and GitOps.
10. Exercise load, disruption, rollback, backup, and recovery.

## Delivery phases

- **Phase 1:** navigation, content contract, policies, and capstone design.
- **Phase 2:** prerequisites, Docker, foundational labs, and containerization.
- **Phase 3:** architecture, Kubernetes core, services, and plain manifests.
- **Phase 4:** networking, storage, resources, security, and policy.
- **Phase 5:** Helm curriculum and a tested capstone chart.
- **Phase 6:** observability, SLOs, dashboards, alerts, and runbooks.
- **Phase 7:** CI/CD, supply chain, GitOps, IaC, managed Kubernetes,
  resilience, recovery, and advanced subjects.

Completion means the learner can design the capstone, justify tradeoffs, deploy
it reproducibly, operate it under failure, and reason from evidence.

## Competency gates

Module completion is local evidence; these gates are cumulative practical
assessments. A gate requires the learner to explain, build, and diagnose.

| Gate | After | Required demonstration |
|---|---|---|
| Container practitioner | Module 02 | Build, inspect, constrain, secure, and troubleshoot containers |
| Kubernetes application operator | Module 05 | Deploy, update, observe, debug, and recover an application |
| Kubernetes platform practitioner | Module 11 | Operate networking, storage, policy, scheduling, and Helm releases |
| Observability practitioner | Module 13 | Diagnose a multi-component failure with metrics, logs, and traces |
| Production readiness | Module 16 | Deliver, scale, secure, upgrade, back up, and restore the platform |

See [`curriculum/ASSESSMENT-GATES.md`](curriculum/ASSESSMENT-GATES.md) for
evidence and scoring.

## Cross-cutting depth tracks

- **Troubleshooting:** configuration → API → reconciliation → scheduling →
  image → process → readiness → discovery → network → dependency → response.
- **Testing:** unit → integration → contract → container → manifest → Helm →
  end-to-end → load → failure → restore.
- **Security:** identity → least privilege → secrets → image supply chain →
  admission → runtime → audit and response.
- **Reliability:** timeouts → retries → idempotency → SLOs → capacity →
  disruption → recovery.
- **Delivery:** source → build → evidence → registry → promotion → GitOps →
  rollback.

## Depth additions

- **Module 03:** contracts, migrations, transaction boundaries, delivery
  semantics, ordering, idempotency, outbox, Saga, dead letters, replay,
  reconciliation, caching, and contract tests.
- **Module 06:** packet and request paths, CoreDNS, CNI, Gateway API, network
  policy, TLS, and evidence-driven diagnosis.
- **Module 10:** workload identity, RBAC, Pod Security, policy, tenant
  boundaries, secret delivery, and runtime controls.
- **Module 14:** locking, SBOMs, scanning, provenance, signing, registry policy,
  admission verification, CI/CD, and GitOps.
- **Module 15:** Terraform or OpenTofu, state, cloud networking and IAM, managed
  Kubernetes, node pools, upgrades, deprecations, restore tests, incidents,
  capacity, multi-tenancy, and cost.
- **Module 16:** operators, CRDs, service mesh, eBPF, and multi-cluster only
  after production-readiness foundations.
