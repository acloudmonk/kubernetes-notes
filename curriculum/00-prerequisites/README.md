# 00 — Prerequisites

**Status:** Verified<br>
**Estimated time:** 8–12 hours  
**Prerequisites:** None

> **Learning path:** [Curriculum index](../README.md) · Previous: None · Next:
> [Container fundamentals](../01-container-fundamentals/README.md)

## Why this matters

Kubernetes failures often surface as ordinary process, port, DNS, HTTP, TLS,
configuration, or dependency failures. This module establishes an evidence-first
troubleshooting foundation before containers add more layers.

## Learning objectives

After completing this module, you can:

- Inspect processes, signals, permissions, files, ports, and listeners.
- Trace DNS, TCP, HTTP, and TLS behavior with platform-appropriate tools.
- distinguish YAML structure from strings and shell interpolation.
- Explain Git working-tree, index, commit, branch, and remote state.
- Reason about timeouts, retries, idempotency, and partial failure.
- Apply a repeatable troubleshooting method.

## Contents

Follow these pages in order. Every page includes navigation back to this module
home and direct links to the previous and next learning step where applicable.

1. [Linux and processes](01-linux-processes.md)
2. [Networking, DNS, HTTP, and TLS](02-networking-dns-http-tls.md)
3. [Git, YAML, and shell](03-git-yaml-shell.md)
4. [Distributed-system foundations](04-distributed-systems.md)
5. [Quick exercises](quick-exercises.md)
6. [Labs](labs/README.md)
7. [Independent challenge](independent-challenge.md)
8. [Troubleshooting scenario](troubleshooting.md)
9. [Interview questions](interview-questions.md)
10. [Knowledge check](quiz.md)
11. [References](references.md)

## Environment check

From PowerShell:

```powershell
./scripts/Test-Prerequisites.ps1
```

From Linux or WSL:

```bash
bash ./scripts/check-prerequisites.sh
```

These scripts inspect only; they install and modify nothing.

## Recorded verification

From PowerShell on Windows, run the repeatable local lab verification:

```powershell
./curriculum/00-prerequisites/scripts/Test-Labs.ps1 -IncludeNetwork
```

The script refuses occupied ports, creates two local-only Python listeners,
checks process/socket/HTTP evidence, detects a bind conflict, distinguishes
configuration and connection failures, and optionally verifies valid and
invalid DNS/TLS paths. It stops only the processes it created and proves both
listeners are gone. The recorded baseline is in the
[version matrix](../../VERSION-MATRIX.md); WSL remains a learner-run path because
it is inaccessible from this validation process.

## Completion

- [ ] **Explain:** trace process, socket, DNS, TCP, TLS, HTTP, configuration, and Git boundaries.
- [ ] **Build:** complete and clean up the quick exercises and three core labs.
- [ ] **Diagnose:** classify the independent challenge and troubleshooting scenario from evidence.
- [ ] Explain five interview answers aloud.
- [ ] Score at least 80% on the knowledge check.

## Continue

Continue to [Module 01 — Container fundamentals](../01-container-fundamentals/README.md),
or return to the [curriculum index](../README.md).
