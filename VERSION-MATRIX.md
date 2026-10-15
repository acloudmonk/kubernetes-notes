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

Phase 2A prerequisite labs are verified against the local baseline below.

| Component | Baseline | Local discovery | Planned phase |
|---|---|---|---|
| Git | 2.46.0.windows.1 | Verified for Phase 2A | All phases |
| Python | 3.12.0 | Verified for Phase 2A | Phase 2A onward |
| Docker CLI | 29.7.2 | Available; engine validation pending | Phase 2B |
| Docker Compose | 5.4.0 | Available; runtime validation pending | Phase 2B |
| `kubectl` | 1.36.1 | Discovered; cluster not tested | Phase 3 |
| Local Kubernetes | To be selected by ADR | Not selected | Phase 3 |
| Helm | To be tested | Not installed | Phase 5 |
| Prometheus stack | To be selected | Not selected | Phase 6 |
| GitOps controller | To be selected by ADR | Not selected | Phase 7 |

Executable modules list only the versions they require.

The WSL status command was inaccessible from the validation process, so no WSL
distribution or version is claimed as tested in Phase 2A.

The Docker Desktop Linux engine was not running during Module 01 authoring.
Documentation and commands were statically reviewed, but the guided container
lab remains `Draft` until executed against the recorded engine baseline.
