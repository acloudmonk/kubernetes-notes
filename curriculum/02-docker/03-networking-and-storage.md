# Docker Networking and Storage

## Networking

A user-defined bridge gives containers isolated interfaces and DNS names based
on service/container aliases. `localhost` inside a container refers to that
container, not the host or a sibling.

Port publishing creates a host-to-container forwarding rule:

```text
127.0.0.1:8080:8080
host address : host port : container port
```

Bind explicitly to `127.0.0.1` for a local-only lab. Publishing on all host
interfaces can expose a service to the surrounding network. `EXPOSE` documents
a port; it does not publish it.

Inspect with:

```powershell
docker network ls
docker network inspect <network>
docker port <container>
docker exec <container> getent hosts <service>
```

## Storage choices

| Type | Managed by | Good for | Main risk |
|---|---|---|---|
| Writable layer | Container | Disposable runtime changes | Lost on removal |
| Named volume | Docker | Persistent application data | Backup/ownership still required |
| Bind mount | Host path | Source/config in development | Host coupling and broad access |
| `tmpfs` | Memory-backed mount | Temporary sensitive or scratch data | Lost on stop; consumes memory |

Mounting over an image directory hides the original directory contents for that
container. A read-only root filesystem still needs explicit writable locations
for required runtime files.

## Database persistence

A volume is not a backup. Backups must be application-consistent, stored outside
the failure domain, protected, retained, and restored in a test. File-copying a
live database directory is not automatically a valid database backup.

## Permissions

Container numeric UID/GID and host filesystem ownership must agree. Avoid
solving bind-mount failures with world-writable permissions or root execution.
Inspect identity and ownership on both sides.
