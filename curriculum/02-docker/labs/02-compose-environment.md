# Lab 2 — Operate a Compose Environment

> **Module navigation:** [Docker module home](../README.md) · Previous:
> [Lab 1 — Secure Python image](01-secure-python-image.md) · Next:
> [Cumulative independent challenge](../independent-challenge.md)

**Time:** 75–120 minutes  
**Cost:** None  
**Run from:** `curriculum/02-docker/lab`

## Prepare configuration

```powershell
Copy-Item .env.example .env
```

Replace the example password with a local learning password. `.env` is ignored
by Git. Inspect the effective model without sharing output containing secrets:

```powershell
docker compose config --quiet
```

## Start and verify

```powershell
docker compose up --detach --build --wait
docker compose ps
docker compose logs --timestamps
curl.exe --fail http://127.0.0.1:8080/healthz
curl.exe --fail http://127.0.0.1:8080/dependency
docker compose exec api getent hosts db
docker compose exec db psql -U learning -d appdb -c "TABLE learning_items;"
```

Verify that `db` is resolvable only in the Compose network, PostgreSQL is not
published to the host, and the API starts only after the database reports healthy.

## Persistence and restoration

Store the backup outside the repository:

```powershell
$backupPath = Join-Path $env:TEMP 'docker-module-appdb.sql'
docker compose exec -T db pg_dump -U learning --data-only --table=learning_items appdb | Set-Content $backupPath
docker compose exec -T db psql -U learning -d appdb -c "DELETE FROM learning_items;"
Get-Content $backupPath | docker compose exec -T db psql -U learning -d appdb
docker compose exec db psql -U learning -d appdb -c "TABLE learning_items;"
```

Explain why the SQL dump is a database-aware backup and why the named volume
alone is not a backup.

## Controlled failures

Inject one failure at a time. A failed `curl.exe --fail` is expected while the
dependency is unavailable.

```powershell
$env:DATABASE_HOST = 'missing-db'
docker compose up --detach --force-recreate --no-deps api
curl.exe --fail http://127.0.0.1:8080/dependency

Remove-Item Env:DATABASE_HOST
docker compose up --detach --force-recreate --no-deps api
curl.exe --fail http://127.0.0.1:8080/dependency

docker compose stop db
curl.exe --fail http://127.0.0.1:8080/dependency
docker compose start db
docker compose up --detach --wait
curl.exe --fail http://127.0.0.1:8080/dependency
```

Classify the first failure as configuration-driven name resolution. For the
stopped service, record the actual evidence: depending on runtime lifecycle and
network timing, the caller may observe a missing DNS record, connection refusal,
or timeout. Explain why startup ordering does not provide permanent dependency
availability.

Use `docker compose config`, `ps`, `logs`, `exec`, `inspect`, and network
inspection before editing unrelated settings.

## Cleanup

```powershell
docker compose down --volumes --remove-orphans
Remove-Item .env
Remove-Item $backupPath -ErrorAction SilentlyContinue
docker compose ps --all
```

The final command should show no project containers. Confirm the project network
and database volume were removed.

---

[Previous: Lab 1 — Secure Python image](01-secure-python-image.md) ·
[Docker module home](../README.md) ·
[Next: Cumulative independent challenge](../independent-challenge.md)
