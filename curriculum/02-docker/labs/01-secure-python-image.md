# Lab 1 — Build and Run a Secure Python Image

**Time:** 60–90 minutes  
**Cost:** None  
**Run from:** `curriculum/02-docker/lab`

## Objective

Build a multi-stage Python image, verify cache behavior and runtime identity,
then run it with explicit security and resource controls.

## Build

```powershell
docker build --progress=plain --tag docker-module-api:1.0 .
docker image inspect docker-module-api:1.0
docker image history docker-module-api:1.0
```

Build it again and identify cached steps. Then change only `app/app.py`, rebuild,
and explain why dependency installation should remain cached.

## Run

```powershell
docker run --detach `
  --name docker-module-api `
  --publish 127.0.0.1:8080:8080 `
  --memory 256m `
  --cpus 0.5 `
  --read-only `
  --tmpfs /tmp:size=16m `
  --cap-drop ALL `
  --security-opt no-new-privileges `
  docker-module-api:1.0
```

## Verify

```powershell
curl.exe --fail http://127.0.0.1:8080/healthz
docker top docker-module-api
docker exec docker-module-api id
docker inspect docker-module-api
docker stats --no-stream docker-module-api
docker logs docker-module-api
```

Acceptance criteria:

- The health endpoint returns success.
- UID and GID are `10001`, not root.
- Root filesystem is read-only and `/tmp` is writable.
- All Linux capabilities are dropped and no-new-privileges is enabled.
- Memory and CPU limits match the run command.

## Signal exercise

```powershell
docker stop --time 15 docker-module-api
docker inspect --format '{{.State.Status}} exit={{.State.ExitCode}}' docker-module-api
docker logs docker-module-api
```

Confirm Gunicorn performs a graceful shutdown before the timeout.

## Cleanup

```powershell
docker rm --force docker-module-api
```
