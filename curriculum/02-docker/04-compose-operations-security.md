# Compose, Operations, and Security

## Compose model

Compose declares services, networks, volumes, configuration, health checks, and
dependencies as one application model. Project naming scopes generated resource
names. Use explicit project names in labs and automation.

```powershell
docker compose config
docker compose up --detach --build --wait
docker compose ps
docker compose logs --timestamps
docker compose down --volumes --remove-orphans
```

`depends_on` controls dependency ordering; a health-based condition can wait for
reported readiness. Applications still need timeouts and retry behavior because
dependencies can fail after startup.

## Configuration and secrets

Compose variable interpolation occurs before the model is sent to Docker. Use
`docker compose config` to inspect the effective model, taking care not to print
real secrets into logs. Environment variables are convenient configuration,
not a high-assurance secret store.

Commit `.env.example`, not `.env`. For production, use a suitable external
secret delivery system and rotate credentials.

## Security baseline

- Run as a dedicated non-root UID/GID.
- Drop capabilities and enable no-new-privileges where possible.
- Use a read-only root filesystem with explicit writable mounts.
- Apply resource limits and bounded logging.
- Avoid privileged mode, host namespaces, and Docker socket mounts.
- Scan dependencies and images; evaluate findings rather than chasing counts.
- Keep development conveniences out of the production model.

## Operations

Treat logs, health, resource usage, image identity, and events as evidence.
Define ownership for upgrades, backups, restoration, credential rotation, and
cleanup. Compose is excellent for local and single-host workflows; it does not
provide Kubernetes scheduling, reconciliation, or multi-node availability.
