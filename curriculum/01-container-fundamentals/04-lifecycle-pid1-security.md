# Lifecycle, PID 1, and Security

## Foreground process

A container is considered running while its configured main process runs. If
that process exits successfully, a short-lived job container is complete. If a
service process exits, the service container has stopped; an interactive shell
or background child does not automatically keep it alive.

## PID 1

The container's main process appears as PID 1 inside its PID namespace. PID 1
has special signal and orphan-reaping responsibilities. Shell wrappers that do
not use `exec` can prevent signals reaching the application. An init process can
forward signals and reap children when the application cannot do so itself.

## Stop sequence

Docker sends the configured stop signal to the main process and waits for a
timeout before forcing termination. Applications should stop accepting work,
finish or safely abandon in-flight work, flush required state, and exit within
the available budget. This prepares for Kubernetes termination later.

## Identity and privilege

Root inside a container is not automatically root on every host resource, but
it increases impact when boundaries are weak or escaped. Prefer a dedicated
non-root user, drop unneeded capabilities, use read-only filesystems where
possible, and avoid mounting the container-engine socket.

## Production questions

- What is the exact main process and command?
- Does it receive and handle termination?
- Are child processes reaped?
- Which user, capabilities, mounts, and namespaces are effective?
- Which CPU, memory, and process constraints apply?
- Which state must survive removal?
- Which image digest actually ran?
