# Isolation and Resource Control

## Namespaces

Linux namespaces limit what a process can see:

| Namespace | Isolates a view of |
|---|---|
| PID | Process identifiers and hierarchy |
| Network | Interfaces, routes, ports, and firewall state |
| Mount | Filesystem mount points |
| UTS | Hostname and domain name |
| IPC | Selected inter-process communication resources |
| User | User and group ID mappings |
| Cgroup | Cgroup hierarchy view |
| Time | Selected clocks and offsets |

Namespaces are isolation mechanisms, not complete security boundaries. A
process still executes on the shared kernel.

## Cgroups

Control groups organize processes and account for or constrain resources such
as memory, CPU, and process count. A memory limit does not reserve memory; it
sets a boundary. A CPU quota usually throttles CPU time rather than reserving a
dedicated CPU.

Out-of-memory behavior is observable through container state, runtime events,
and host/kernel evidence. An exit code alone is not always a complete diagnosis.

## Other boundaries

Container isolation also depends on:

- Linux capabilities
- Seccomp system-call filtering
- AppArmor or SELinux policy
- Filesystem permissions
- Read-only mounts
- Network policy outside the basic namespace
- The runtime and host-kernel security posture

`--privileged`, host namespaces, broad capabilities, and sensitive host mounts
can deliberately remove important boundaries.

## Inspection

```powershell
docker inspect <container>
docker top <container>
docker stats --no-stream <container>
docker exec <container> cat /proc/1/cgroup
```

Inspect effective configuration rather than assuming command-line intent was
applied.
