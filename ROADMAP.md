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
| Microservices architecture | 3 weeks | Produce a reasoned architecture and failure model |
| Kubernetes core | 5 weeks | Deploy and troubleshoot application workloads |
| Networking and storage | 3 weeks | Operate routing, policy, TLS, and stateful workloads |
| Security and resources | 2 weeks | Apply least privilege and workload constraints |
| Helm | 2 weeks | Package, validate, upgrade, and roll back applications |
| Observability | 3 weeks | Use metrics, logs, traces, alerts, and SLOs |
| CI/CD and GitOps | 2 weeks | Automate validation, promotion, and reconciliation |
| Production operations | 3 weeks | Handle scaling, upgrades, incidents, and recovery |

## Planned modules

| ID | Module | Scope |
|---:|---|---|
| 00 | Prerequisites | Linux, networking, Git, YAML, shell, distributed systems |
| 01 | Container fundamentals | Processes, namespaces, cgroups, filesystems, runtimes |
| 02 | Docker | Images, Dockerfiles, BuildKit, Compose, registries, security |
| 03 | Microservices architecture | Boundaries, data, communication, resilience, decisions |
| 04 | Kubernetes architecture | API, control plane, nodes, reconciliation, extensibility |
| 05 | Kubernetes workloads | Pods, controllers, probes, configuration, rollouts |
| 06 | Networking and discovery | CNI, Services, DNS, Gateway API, policy, TLS |
| 07 | Storage and state | PVs, PVCs, StorageClasses, CSI, StatefulSets, recovery |
| 08 | Configuration and secrets | Configuration, secret delivery, and rotation |
| 09 | Scheduling and resources | Requests, QoS, placement, disruption, autoscaling |
| 10 | Security and policy | RBAC, workload security, admission, supply chain |
| 11 | Helm | Templates, values, dependencies, tests, OCI, lifecycle |
| 12 | Prometheus | Collection, PromQL, rules, Alertmanager, cardinality |
| 13 | Grafana and observability | Dashboards, logs, traces, OpenTelemetry, SLOs |
| 14 | CI/CD and GitOps | Builds, validation, promotion, Argo CD or Flux |
| 15 | Production operations | HA, upgrades, incidents, backups, cost, capacity |
| 16 | Advanced Kubernetes | Operators, service mesh, multi-cluster, ecosystem |

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
- **Phase 7:** CI/CD, GitOps, resilience, recovery, and advanced subjects.

Completion means the learner can design the capstone, justify tradeoffs, deploy
it reproducibly, operate it under failure, and reason from evidence.
