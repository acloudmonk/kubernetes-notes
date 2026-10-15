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
| 02 | Docker | Planned |
| 03 | Microservices architecture | Planned |
| 04 | Kubernetes architecture | Planned |
| 05 | Kubernetes workloads | Planned |
| 06 | Networking and discovery | Planned |
| 07 | Storage and state | Planned |
| 08 | Configuration and secrets | Planned |
| 09 | Scheduling and resources | Planned |
| 10 | Security and policy | Planned |
| 11 | Helm | Planned |
| 12 | Prometheus | Planned |
| 13 | Grafana and observability | Planned |
| 14 | CI/CD and GitOps | Planned |
| 15 | Production operations | Planned |
| 16 | Advanced Kubernetes | Planned |

When a module is published, its change must link the module README from this
table and from the matching `ROADMAP.md` row. The module must also include the
navigation block defined by the template.
