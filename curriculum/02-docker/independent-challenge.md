# Cumulative Independent Challenge — Secure Two-Service Environment

> **Module navigation:** [Docker module home](README.md) · Previous:
> [Lab 2 — Compose environment](labs/02-compose-environment.md) · Next:
> [Troubleshooting](troubleshooting.md)

**Time:** 90–150 minutes  
**Cost:** None  
**Prerequisites:** Modules 00, 01, and 02

## Outcome

Create and diagnose a two-service container environment without copying the
guided lab commands. The result must demonstrate Linux and network reasoning,
container lifecycle knowledge, and secure Docker implementation.

You may reuse the provided Python application as a starting point, but create
your own Dockerfile and Compose model outside the repository or in an ignored
working directory. Do not modify the guided lab while completing the challenge.

## Constraints

- Build a versioned application image with a deliberate cache strategy.
- Run the application as a numeric non-root user with an immutable root
  filesystem, a writable temporary filesystem, dropped capabilities, and
  explicit CPU and memory limits.
- Run one stateful dependency on a private Compose network. Do not publish its
  port to the host.
- Use service-name DNS and environment-based configuration. Do not place a
  password in the image, Dockerfile, Compose file, command history, or evidence.
- Add bounded health checks and dependency timeouts.
- Persist dependency data in a named volume and produce a separate,
  application-consistent backup.
- Pin image and application dependency versions; record the resolved image
  identities used during the exercise.

## Failure investigation

Ask another person—or use a shuffled list—to introduce two failures without
telling you which ones were selected:

- An invalid dependency hostname
- A stopped dependency
- An incorrect published application port
- A read-only-path write attempt
- A memory limit too small for reliable startup
- An application process that exits immediately

For each failure, record expected behavior, observed evidence, one falsifiable
hypothesis at a time, root cause, smallest correction, recovery evidence, and a
prevention measure. Do not solve a network failure by disabling isolation or a
filesystem failure by running as root.

## Acceptance criteria

### Explain

- Trace the CLI-to-daemon-to-runtime flow and the application-to-dependency
  request path.
- Explain tag versus digest, image layer versus writable layer, and volume
  versus backup.
- Justify each security and resource setting, including what it cannot protect.

### Build

- A clean build and a cached rebuild both succeed.
- Both services become healthy and the application reaches its dependency by
  service name.
- Identity, limits, capabilities, mounts, image digest, and published ports are
  verified from runtime evidence.
- Data survives container recreation and is successfully restored from backup.

### Diagnose

- Both injected failures are isolated using effective configuration, state,
  health, logs, DNS, TCP, and process evidence as appropriate.
- Recovery is verified from the caller's perspective, not only from container
  state.

## Evidence and cleanup

Keep a short report containing commands, selected output, explanations, and the
two incident records. Redact credentials and machine-specific private data.

Remove only the challenge's explicitly named containers, network, volume,
temporary files, and locally built image. Prove that no challenge resource
remains. Do not use global prune commands.

---

[Previous: Lab 2 — Compose environment](labs/02-compose-environment.md) ·
[Docker module home](README.md) · [Next: Troubleshooting](troubleshooting.md)
