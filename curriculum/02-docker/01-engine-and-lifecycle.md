# Docker Engine and Lifecycle

## Architecture

The Docker CLI is a client of the Docker API. The daemon manages images,
containers, networks, and volumes and delegates lower-level lifecycle work to
container runtime components. Docker Desktop runs this Linux engine inside a
managed Linux environment on Windows or macOS.

```text
CLI → Docker API → dockerd → containerd → OCI runtime → process
                 ↘ image store / networks / volumes
```

Protect the daemon endpoint. Access to the Docker socket commonly grants control
equivalent to host root because a client can request privileged containers and
host mounts.

## Lifecycle states

`docker run` combines image resolution, create, and start. Learn the separate
operations because troubleshooting depends on the boundary:

```powershell
docker create --name demo alpine:3.22.2 sleep 300
docker start demo
docker stop --time 10 demo
docker start demo
docker rm --force demo
```

Stop sends the configured signal and waits before forcing termination. Restart
policies respond to process exit; they do not repair incorrect configuration.

## Evidence sources

```powershell
docker ps --all
docker inspect <container>
docker logs --timestamps <container>
docker top <container>
docker stats --no-stream <container>
docker events --since 10m
```

Inspect effective command, environment, mounts, networks, health, restart
count, exit code, OOM state, timestamps, and error before changing anything.

## Health

A health check reports application evidence separately from process state. A
container can be running but unhealthy. Health checks must be bounded, cheap,
specific, and available in the image. Health status alone does not restart a
plain Docker container; orchestration or external policy decides the response.
