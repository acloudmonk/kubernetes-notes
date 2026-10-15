# Interview Questions

## 1. Is a container a lightweight VM?

**Tags:** `fundamental`, `internals`  
No. A Linux container is a constrained process sharing the host kernel; a VM
runs a guest kernel on virtual hardware. Discuss startup, overhead, compatibility,
and the different security boundary rather than only saying “containers are lighter.”

## 2. What do namespaces and cgroups do?

**Tags:** `internals`  
Namespaces isolate views such as processes, networking, mounts, and identities.
Cgroups organize processes for resource accounting and controls. Neither alone
is a complete container or security boundary.

## 3. What is the difference between an image and a container?

**Tags:** `fundamental`  
An image is immutable configuration and filesystem content. A container is a
runtime instance with process configuration and a writable layer. Many
containers can use the same image content.

## 4. Why pin an image digest?

**Tags:** `security`, `production`  
A tag can be moved to different content; a digest identifies content. Digest
pinning improves reproducibility, but updates must still be deliberately
discovered, tested, and deployed.

## 5. Why is PID 1 important?

**Tags:** `internals`, `production`  
It is the container's main process, determines container lifetime, receives the
stop signal, and must handle orphaned children appropriately. Shell wrappers can
break signal forwarding unless designed correctly.

## 6. What survives a container restart?

**Tags:** `implementation`  
The same container's writable layer and metadata normally survive stop/start.
They do not survive removal. Volumes and external stores have separate lifetimes.

## 7. Does a memory limit reserve memory?

**Tags:** `resources`  
No. A hard limit constrains maximum use; reservation and scheduling semantics
are separate. Inspect actual runtime configuration and OOM evidence.

## 8. Why avoid privileged containers?

**Tags:** `security`  
Privilege can expose devices and capabilities and weaken isolation. Grant the
smallest specific permission required and verify the effective configuration.

## 9. Why might an image run on one machine but not another?

**Tags:** `architecture`, `troubleshooting`  
Check OS and CPU platform, manifest selection, kernel features, runtime policy,
entrypoint, mounts, permissions, and configuration. An image does not contain a
replacement kernel.

## 10. Does Kubernetes require Docker Engine?

**Tags:** `kubernetes`, `internals`  
No. Kubelet uses the Container Runtime Interface with a compatible runtime.
Docker images follow interoperable formats, but Docker Engine is not a required
node runtime.
