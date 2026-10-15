# Interview Questions

## 1. `CMD` versus `ENTRYPOINT`?

**Tags:** `fundamental`, `implementation`  
`ENTRYPOINT` defines the executable and `CMD` provides default arguments when
both use exec form. Explain the effective command and signal implications.

## 2. How do you optimize Docker build cache?

**Tags:** `build`, `production`  
Use a narrow context, precise `.dockerignore`, stable instructions first,
dependency metadata before source, cache mounts, and multi-stage outputs.

## 3. Why can deleting a secret in a later layer be unsafe?

**Tags:** `security`  
An earlier immutable layer can retain it. Use BuildKit secret mounts and keep
secrets out of context, arguments, environment, layers, and logs.

## 4. Bind mount versus named volume?

**Tags:** `storage`  
Bind mounts expose a host path and are host-coupled. Volumes are Docker-managed.
Both require ownership, backup, restoration, and lifecycle decisions.

## 5. Why does `localhost` fail between containers?

**Tags:** `networking`, `troubleshooting`  
Loopback reaches the same container. Use a shared network and service DNS name.

## 6. Does `depends_on` guarantee dependency availability?

**Tags:** `compose`, `distributed-systems`  
No. It controls ordering and can wait for health, but dependencies can fail
later. Clients still need bounded timeouts and suitable retries.

## 7. Why use multi-stage builds?

**Tags:** `build`, `security`  
They separate build tooling from runtime artifacts, reducing size and attack
surface, but do not guarantee trusted dependencies or reproducibility.

## 8. Is a healthy container necessarily a healthy service?

**Tags:** `operations`  
No. A check covers only its signal and may miss downstream correctness,
capacity, or partial failure.

## 9. Why is the Docker socket sensitive?

**Tags:** `security`, `senior`  
API access can create privileged containers or mount host files, commonly
providing host-level control.

## 10. Tags versus digests?

**Tags:** `registry`, `production`  
Tags are mutable names; digests identify content. Digest pinning still requires
an explicit discovery, test, and update process.
