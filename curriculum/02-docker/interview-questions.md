# Interview Questions

> **Module navigation:** [Docker module home](README.md) · Previous:
> [Troubleshooting](troubleshooting.md) · Next: [Knowledge check](quiz.md)

### 1. What is the difference between `CMD` and `ENTRYPOINT`?

**Tags:** `fundamental`, `implementation`

**Answer:** With exec-form instructions, `ENTRYPOINT` defines the executable and
`CMD` supplies default arguments that users can replace. If only `CMD` exists,
the whole command can be replaced. Shell form introduces a shell that changes
argument expansion and signal behavior; derive the effective command and test
termination rather than memorizing a slogan.

### 2. How do you optimize Docker build cache safely?

**Tags:** `build`, `production`

**Answer:** Use a narrow context and precise `.dockerignore`, place stable
instructions before frequently changing ones, copy dependency metadata before
source, and use BuildKit cache mounts where suitable. Multi-stage builds copy
only required runtime artifacts. Optimize after inspecting cache evidence;
incorrect caching can preserve stale dependencies or leak build inputs.

### 3. Why can deleting a secret in a later layer be unsafe?

**Tags:** `security`

**Answer:** Image layers are immutable, so the earlier layer can still contain
the bytes even if a later layer removes the visible path. Keep secrets out of the
build context, arguments, environment, layers, and logs; use BuildKit secret or
SSH mounts for temporary access. If a real secret entered an image, revoke it.

### 4. How do bind mounts and named volumes differ?

**Tags:** `storage`

**Answer:** A bind mount exposes an explicit host path and inherits its coupling,
permissions, and security risks. A named volume is managed through Docker's
volume lifecycle and is more portable within that engine environment. Neither is
a backup; define ownership, retention, backup, restore, and deletion separately.

### 5. Why does `localhost` fail between containers?

**Tags:** `networking`, `troubleshooting`

**Answer:** Loopback points to the calling container's own network namespace.
Containers on a shared user-defined network should use the target's service or
container DNS name and listening port. Also verify that the server binds a
non-loopback address; published host ports solve a different ingress path.

### 6. Does Compose `depends_on` guarantee dependency availability?

**Tags:** `compose`, `distributed-systems`

**Answer:** No. It controls creation ordering and can wait for a declared health
condition, but the dependency may fail later and the health check may be shallow.
Clients still require bounded timeouts, appropriate retries with backoff/jitter,
idempotency where effects can repeat, and observable failure handling.

### 7. Why use multi-stage builds?

**Tags:** `build`, `security`

**Answer:** They separate build tooling and intermediate files from the final
runtime filesystem, reducing image size and attack surface. Copy only explicit
artifacts into a minimal, non-root runtime stage. Multi-stage structure does not
by itself make dependencies trusted, builds reproducible, or vulnerabilities absent.

### 8. Is a healthy container necessarily a healthy service?

**Tags:** `operations`

**Answer:** No. A health check proves only its specific signal at one moment and
may miss downstream correctness, capacity, partial failure, or user workflows.
Design checks around a clear decision, expose deeper telemetry separately, and
verify the complete service path rather than making one probe call every dependency.

### 9. Why is the Docker socket sensitive?

**Tags:** `security`, `senior`

**Answer:** Docker API access can normally create privileged containers, mount
host paths, inspect workloads, and control the engine, which commonly provides
host-level power. Do not expose or mount it casually. Use narrowly scoped
brokers or rootless/isolated builders where a workflow needs container operations.

### 10. How do image tags and digests differ?

**Tags:** `registry`, `production`

**Answer:** Tags are convenient mutable names; digests identify exact manifest
content. Pinning a digest makes deployment input reproducible but requires an
explicit process to discover, test, approve, and roll forward to patched content.
Record multi-platform selection and provenance as separate supply-chain evidence.

---

[Previous: Troubleshooting](troubleshooting.md) ·
[Docker module home](README.md) · [Next: Knowledge check](quiz.md)
