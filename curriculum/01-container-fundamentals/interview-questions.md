# Interview Questions

> **Module navigation:** [Container fundamentals home](README.md) · Previous:
> [Troubleshooting scenario](troubleshooting.md) · Next:
> [Knowledge check](quiz.md)

### 1. Is a container a lightweight VM?

**Tags:** `fundamental`, `internals`

**Answer:** No. A Linux container is a constrained process that shares the host
kernel; a VM runs a guest kernel on virtual hardware. Containers usually start
faster and use fewer resources, but kernel compatibility and isolation differ.
Treating the two as equivalent hides their different security and failure boundaries.

### 2. What do namespaces and cgroups do?

**Tags:** `internals`

**Answer:** Namespaces isolate views such as processes, networking, mounts, and
identities. Cgroups organize processes for accounting and controls such as CPU,
memory, and process counts. Neither alone is a complete container or security
boundary; runtimes combine them with filesystems, capabilities, seccomp, and policy.

### 3. What is the difference between an image and a container?

**Tags:** `fundamental`

**Answer:** An image is immutable configuration and filesystem content. A
container is a runtime instance with a process configuration and writable layer.
Many containers can share the same image layers while retaining separate runtime
state, namespaces, and writable changes.

### 4. Why pin an image digest?

**Tags:** `security`, `production`

**Answer:** A tag can be moved to different content; a digest identifies exact
content. Pinning improves reproducibility and auditability, but does not prove the
content is trusted or vulnerability-free. Updates still need discovery, review,
testing, promotion, and a rollback process.

### 5. Why is PID 1 important in a container?

**Tags:** `internals`, `production`

**Answer:** PID 1 is the container's main process, determines container lifetime,
receives the stop signal, and has special orphan-reaping and signal behavior.
Shell wrappers can prevent signals reaching the application unless they use
`exec` or forward and reap correctly. Verify graceful termination under load.

### 6. What survives a container restart?

**Tags:** `implementation`

**Answer:** Stopping and starting the same container normally preserves its
metadata and writable layer. Removing and recreating it loses that writable
state. Named volumes, bind mounts, and external stores have separate lifecycles,
so “restart” and “replacement” must be distinguished when reasoning about data.

### 7. Does a memory limit reserve memory?

**Tags:** `resources`

**Answer:** No. A hard memory limit constrains maximum use and can cause an OOM
kill; reservation, placement, and guarantees are separate mechanisms. Inspect
the actual cgroup/runtime configuration, working set, pressure, and termination
evidence instead of interpreting the limit as preallocated capacity.

### 8. Why should privileged containers be avoided?

**Tags:** `security`

**Answer:** Privileged mode exposes broad capabilities and devices and can
substantially weaken isolation from the host. Grant the smallest specific
capability, device, or mount required and verify the effective configuration.
Even an unprivileged container still needs patched code, runtime, and kernel.

### 9. Why might an image run on one machine but not another?

**Tags:** `architecture`, `troubleshooting`

**Answer:** Check OS and CPU platform, manifest selection, required kernel
features, runtime and security policy, entrypoint, mounts, permissions, and
configuration. An image supplies userspace, not a replacement kernel. Compare
the selected digest and observable runtime error before rebuilding it.

### 10. Does Kubernetes require Docker Engine?

**Tags:** `kubernetes`, `internals`

**Answer:** No. Kubelet uses the Container Runtime Interface with a compatible
runtime such as containerd or CRI-O. OCI-compatible images remain portable
across runtimes, but Docker Engine is not the node contract and Docker-specific
local behavior should not be assumed in Kubernetes.

---

[Previous: Troubleshooting scenario](troubleshooting.md) ·
[Container fundamentals home](README.md) · [Next: Knowledge check](quiz.md)
