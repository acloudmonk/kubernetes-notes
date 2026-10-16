# Curriculum

The curriculum introduces each abstraction after its prerequisites. The module
sequence is in [`ROADMAP.md`](../ROADMAP.md).

## Module contract

A complete module contains objectives and prerequisites; concepts and internal
mechanics; minimal and realistic implementations; production and security
considerations; a guided lab; an independent challenge; troubleshooting
scenarios; interview questions; a knowledge check; and primary references.

Use [`_template`](_template/README.md) for new modules. Remove sections that do
not apply rather than filling them with generic text.

## Status values

- **Planned:** scope exists but content is not ready.
- **Draft:** usable but incomplete or not fully verified.
- **Verified:** examples pass against the recorded baseline.
- **Needs review:** dependency or version changes may have invalidated it.

Number modules with two digits and lowercase kebab-case, such as
`04-kubernetes-architecture`.

## Ordered learning path

Start at the first available module and follow the order. Only modules with
published learning material are linked.

| Order | Module | Status |
|---:|---|---|
| 00 | [Prerequisites](00-prerequisites/README.md) | Draft |
| 01 | [Container fundamentals](01-container-fundamentals/README.md) | Draft |
| 02 | [Docker](02-docker/README.md) | Verified |
| 03 | [Microservices and distributed data](03-microservices-distributed-data/README.md) | Draft |
| 04 | [Kubernetes architecture](04-kubernetes-architecture/README.md) | Verified |
| 05 | [Kubernetes workloads](05-kubernetes-workloads/README.md) | Verified |
| 06 | [Networking and discovery](06-networking-discovery/README.md) | Verified |
| 07 | [Storage and state](07-storage-state/README.md) | Verified |
| 08 | [Configuration and secrets](08-configuration-secrets/README.md) | Verified |
| 09 | [Scheduling and resources](09-scheduling-resources/README.md) | Verified |
| 10 | [Security and policy](10-security-policy/README.md) | Verified |
| 11 | [Helm](11-helm/README.md) | Verified |
| 12 | [Prometheus](12-prometheus/README.md) | Verified |
| 13 | [Grafana and observability](13-grafana-observability/README.md) | Verified |
| 14 | [CI/CD, supply chain, and GitOps](14-cicd-supply-chain-gitops/README.md) | Verified |
| 15 | Infrastructure and production operations | Planned |
| 16 | Advanced Kubernetes | Planned |

When a module is published, its change must link the module README from this
table and from the matching `ROADMAP.md` row. The module must also include the
navigation block defined by the template.

## Assessment model

Every module collects three types of evidence:

- **Explain:** mechanisms, guarantees, limitations, and tradeoffs.
- **Build:** reproducible implementation without copying a solution.
- **Diagnose:** recovery of a deliberately broken system using evidence.

The cumulative [competency gates](ASSESSMENT-GATES.md) occur after Modules 02,
05, 11, 13, and 16. Every third module also revisits earlier concepts through a
cumulative troubleshooting or design exercise.
