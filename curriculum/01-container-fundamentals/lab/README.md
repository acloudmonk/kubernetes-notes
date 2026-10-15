# Guided Lab — Inspect a Container as a Process

**Time:** 45–75 minutes  
**Cost:** None  
**Requires:** Running Linux container engine and internet for the first pull

## Safety and scope

The lab creates one container named `container-fundamentals-lab` and pulls
`alpine:3.22.2`. Cleanup targets only that name. Do not substitute production
container names.

## 1. Verify the engine and image

```powershell
docker info
docker pull alpine:3.22.2
docker image inspect alpine:3.22.2
docker image history --no-trunc alpine:3.22.2
```

Record the image ID, architecture, OS, layers, and pulled digest. Explain why a
tag and digest provide different guarantees.

## 2. Create an isolated process

```powershell
docker run --detach `
  --name container-fundamentals-lab `
  --hostname isolated-host `
  --memory 128m `
  --cpus 0.5 `
  alpine:3.22.2 `
  sh -c "trap 'echo received-TERM; exit 0' TERM; while :; do sleep 1; done"
```

For Bash, replace PowerShell backtick continuations with backslashes.

## 3. Collect evidence

```powershell
docker ps --filter name=container-fundamentals-lab
docker top container-fundamentals-lab
docker inspect container-fundamentals-lab
docker stats --no-stream container-fundamentals-lab
docker exec container-fundamentals-lab sh -c "hostname; id; ps; cat /proc/1/cgroup"
```

Verify the hostname, PID 1 command, image ID, memory limit, CPU quota, and cgroup
evidence. Note that Docker Desktop processes run in its Linux environment, not
as directly equivalent Windows host processes.

## 4. Observe writable-layer lifetime

```powershell
docker exec container-fundamentals-lab sh -c "echo runtime-state > /tmp/state.txt"
docker stop container-fundamentals-lab
docker start container-fundamentals-lab
docker exec container-fundamentals-lab cat /tmp/state.txt
```

The file survives stop/start because it belongs to the same container writable
layer. It will not survive removal and recreation.

## 5. Observe termination

```powershell
docker stop --time 5 container-fundamentals-lab
docker logs container-fundamentals-lab
docker inspect --format '{{.State.Status}} exit={{.State.ExitCode}}' container-fundamentals-lab
```

Confirm that the trap received the termination signal and exited within the
timeout.

## Controlled failure

```powershell
docker run --name container-fundamentals-exit alpine:3.22.2 echo completed
docker ps --all --filter name=container-fundamentals-exit
docker logs container-fundamentals-exit
docker inspect --format '{{json .State}}' container-fundamentals-exit
```

Explain why the container stopped and why restart is not automatically the
correct fix for an intentionally finite command.

## Optional challenge

Compare the process tree for a container started normally and with `--init`.
Research what the init process is responsible for; do not assume every
application needs an extra init process.

## Cleanup

```powershell
docker rm --force container-fundamentals-lab container-fundamentals-exit
docker ps --all --filter name=container-fundamentals
```

The final command must show no lab containers. Keeping the versioned Alpine
image is harmless; optionally remove it with `docker image rm alpine:3.22.2`.
