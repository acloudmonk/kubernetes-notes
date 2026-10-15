# Docker Troubleshooting Scenarios

> **Module navigation:** [Docker module home](README.md) · Previous:
> [Cumulative independent challenge](independent-challenge.md) · Next:
> [Interview questions](interview-questions.md)

Use this order: effective configuration → image/build → process → health →
network → dependency → storage → resources.

## Build unexpectedly reinstalls dependencies

Inspect Dockerfile order, context, `.dockerignore`, copied metadata, and plain
build output. A broad `COPY . .` before dependency installation often
invalidates the expensive layer whenever source changes.

## Published port is unreachable

Check process state, logs, health, application bind address, container port,
published host address/port, and firewall. Publishing cannot fix an application
listening only on container loopback.

## Service name works in Compose but not on the host

Compose DNS exists inside its network. Host callers use the published endpoint.
Do not conceal a network-scope error with global host-file entries.

## Bind-mounted file is denied

Inspect container UID/GID, host ownership and ACLs, mount mode, path, and
security policy. Avoid `chmod 777` or root as the first response.

## Database is running but unavailable

Process state is not readiness. Inspect health and database logs. Verify
credentials, database, storage permissions, initialization, and client network.

## Read-only filesystem breaks startup

Find the required write path. Provide a narrowly scoped volume or `tmpfs`, or
reconfigure the application; do not make the whole root writable blindly.

## Container repeatedly restarts

Inspect restart count, exit state, OOM flag, command, and logs. A restart policy
is availability behavior, not root-cause remediation.

---

[Previous: Cumulative independent challenge](independent-challenge.md) ·
[Docker module home](README.md) ·
[Next: Interview questions](interview-questions.md)
