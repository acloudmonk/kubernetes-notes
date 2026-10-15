# 00 — Prerequisites

**Status:** Draft  
**Estimated time:** 8–12 hours  
**Prerequisites:** None

> **Learning path:** [Curriculum index](../README.md) · Previous: None · Next:
> Container fundamentals (planned)

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

1. [Linux and processes](01-linux-processes.md)
2. [Networking, DNS, HTTP, and TLS](02-networking-dns-http-tls.md)
3. [Git, YAML, and shell](03-git-yaml-shell.md)
4. [Distributed-system foundations](04-distributed-systems.md)
5. [Quick exercises](quick-exercises.md)
6. [Labs](labs/README.md)
7. [Troubleshooting scenario](troubleshooting.md)
8. [Interview questions](interview-questions.md)
9. [Knowledge check](quiz.md)
10. [References](references.md)

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

## Completion

- [ ] Complete the quick exercises and three core labs.
- [ ] Diagnose the scenario before reading its answer.
- [ ] Explain five interview answers aloud.
- [ ] Score at least 80% on the knowledge check.
- [ ] Clean up every process and temporary resource created by the labs.

## Continue

Return to the [curriculum index](../README.md). Module 01 — Container
fundamentals will be linked there when its learning material is available.
