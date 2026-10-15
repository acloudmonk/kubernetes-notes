# Version Matrix

This file records versions against which labs are tested. It does not promise
compatibility with every older or future release.

## Policy

- Pin a baseline before publishing an executable lab.
- Prefer supported stable releases.
- Record Kubernetes client, cluster, and API compatibility separately.
- Avoid floating image tags in reproducible exercises.
- Review baselines when supported tools reach end of life.
- Document intentional deprecated-API use in its migration lab.

## Current baseline

Phase 1 has no executable lab, so runtime versions are not yet pinned.

| Component | Baseline | Local discovery | Planned phase |
|---|---|---|---|
| Git | To be recorded | Available | All phases |
| Docker | To be tested | Available | Phase 2 |
| Docker Compose | To be tested | Not verified | Phase 2 |
| `kubectl` | To be tested | Available | Phase 3 |
| Local Kubernetes | To be selected by ADR | Not selected | Phase 3 |
| Helm | To be tested | Not installed | Phase 5 |
| Prometheus stack | To be selected | Not selected | Phase 6 |
| GitOps controller | To be selected by ADR | Not selected | Phase 7 |

Executable modules list only the versions they require.
