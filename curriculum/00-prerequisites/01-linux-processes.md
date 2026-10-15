# Linux, Processes, and Files

> **Module navigation:** [Prerequisites module home](README.md) · Previous: Module home ·
> Next: [Networking, DNS, HTTP, and TLS](02-networking-dns-http-tls.md)

## Process model

A process is a running program with a PID, parent PID, credentials, environment,
open file descriptors, and allocated resources. A container does not replace
this model; it isolates selected views of it.

`SIGTERM` requests graceful termination and gives an application time to stop
accepting work and flush state. `SIGKILL` cannot be handled and should be a last
resort. Kubernetes normally sends `SIGTERM`, waits the grace period, then forces
termination if necessary.

```bash
ps -ef
ps -o pid,ppid,user,stat,cmd -p <pid>
kill -TERM <pid>
ss -lntp
lsof -iTCP:<port> -sTCP:LISTEN
```

In PowerShell, equivalent evidence often comes from:

```powershell
Get-Process
Get-NetTCPConnection -State Listen
Get-Process -Id <pid>
Stop-Process -Id <pid>
```

## Files and permissions

Linux permissions apply to owner, group, and others. Read, write, and execute
mean different things on files and directories. Directory execute permission
allows traversal; directory write permission controls creating or removing
entries. A writable file is not useful if its parent path cannot be traversed.

```bash
id
ls -ld <path>
stat <path>
namei -l <path>
```

Prefer the smallest necessary permission change. `chmod 777` hides the access
model and is not a diagnosis.

## Filesystems and resource symptoms

Disk capacity, inode exhaustion, read-only mounts, ownership, and per-process
limits can look like application failures. Inspect before changing:

```bash
df -h
df -i
mount
ulimit -a
```

## Mental model

When a program fails, ask: did it start, which identity runs it, what is it
waiting on, which files and sockets are open, which signal did it receive, and
which resource limit was reached?

---

[Prerequisites module home](README.md) · Next:
[Networking, DNS, HTTP, and TLS](02-networking-dns-http-tls.md)
