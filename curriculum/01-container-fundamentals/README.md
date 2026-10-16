# 01 — Container Fundamentals

**Status:** Verified<br>
**Estimated time:** 8–12 hours  
**Prerequisites:** [00 — Prerequisites](../00-prerequisites/README.md)

> **Learning path:** [Curriculum index](../README.md) · Previous:
> [Prerequisites](../00-prerequisites/README.md) · Next:
> [Docker](../02-docker/README.md)

## Why this matters

A container is an isolated process, not a small virtual machine. Kubernetes
operates containers through runtimes, so process lifecycle, namespaces,
cgroups, image content, writable layers, and signals explain many later Pod
failures.

## Learning objectives

You can:

- Trace a container request from client to runtime and process.
- Explain namespace isolation and cgroup resource control.
- Distinguish image, manifest, layer, container, and registry.
- Explain copy-on-write and ephemeral writable-layer behavior.
- Reason about PID 1, signals, shutdown, users, and resource limits.
- Inspect a container using evidence rather than treating it as a VM.

## Contents

Follow these pages in order. Every page includes navigation back to this module
home and direct links to the previous and next learning step where applicable.

1. [Container and runtime model](01-container-runtime-model.md)
2. [Isolation and resource control](02-isolation-and-resources.md)
3. [Images and filesystems](03-images-and-filesystems.md)
4. [Lifecycle, PID 1, and security](04-lifecycle-pid1-security.md)
5. [Quick exercises](quick-exercises.md)
6. [Guided lab](lab/README.md)
7. [Independent challenge](independent-challenge.md)
8. [Troubleshooting](troubleshooting.md)
9. [Interview questions](interview-questions.md)
10. [Knowledge check](quiz.md)
11. [References](references.md)

## Requirements

- Docker CLI and a running Linux container engine
- Approximately 250 MB free space
- Network access for the first image pull

Run `docker info` before the lab. A working client with an unreachable daemon is
not a working container environment.

## Recorded verification

From the repository root in PowerShell:

```powershell
./curriculum/01-container-fundamentals/scripts/Test-ContainerLab.ps1
```

The script refuses conflicting container names and verifies the Linux engine,
image identity, process/cgroup evidence, CPU and memory limits, writable-layer
lifetime, graceful termination, finite-process exit, and scoped cleanup. See
the [version matrix](../../VERSION-MATRIX.md) for the executed baseline.

## Completion

- [ ] **Explain:** trace runtime, isolation, image, filesystem, and lifecycle mechanisms.
- [ ] **Build:** complete, verify, and clean up the guided lab.
- [ ] **Diagnose:** complete the controlled failure and independent challenge from evidence.
- [ ] Explain the runtime flow and isolation limits without using “mini-VM.”
- [ ] Score at least 80% on the knowledge check.

## Continue

Continue to [Module 02 — Docker](../02-docker/README.md), or return to the
[curriculum index](../README.md).
