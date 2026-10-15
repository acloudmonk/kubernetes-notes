# Container and Runtime Model

> **Module navigation:** [Container fundamentals home](README.md) · Previous:
> Module home · Next: [Isolation and resource control](02-isolation-and-resources.md)

## Container versus virtual machine

A virtual machine presents virtual hardware and runs its own kernel. A Linux
container is one or more ordinary host-kernel processes whose views and
resources are constrained. The image supplies user-space files; it does not
supply a separate Linux kernel.

Consequences:

- Containers normally start faster and use less overhead than VMs.
- Kernel isolation is shared, so a kernel vulnerability can cross an important
  security boundary.
- A Linux image requires a Linux kernel even when Docker Desktop runs on
  Windows; Docker Desktop supplies that kernel through a managed VM/WSL layer.

## Control flow

```text
docker CLI
    → Docker API / dockerd
        → containerd
            → OCI runtime
                → isolated host process
```

The exact implementation can vary. Kubernetes uses the Container Runtime
Interface to communicate with a CRI implementation; it does not require the
Docker CLI or Docker Engine on a node.

## OCI specifications

The Open Container Initiative maintains complementary standards:

- **Image Specification:** content-addressed image configuration and layers.
- **Runtime Specification:** the bundle, configuration, execution environment,
  and lifecycle used to create a container.
- **Distribution Specification:** registry APIs for moving content.

An image index can select platform-specific manifests. A manifest identifies a
configuration object and ordered filesystem layers for one platform. A tag is
a mutable human-readable reference; a digest identifies content.

## Lifecycle

Creating a container records configuration and prepares a writable layer.
Starting it creates the configured process. Stopping it terminates the process
but retains container metadata and writable state. Removing it deletes that
container state. An image remains independently reusable.

---

[Container fundamentals home](README.md) · Next:
[Isolation and resource control](02-isolation-and-resources.md)
