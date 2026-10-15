# Images and Filesystems

> **Module navigation:** [Container fundamentals home](README.md) · Previous:
> [Isolation and resource control](02-isolation-and-resources.md) · Next:
> [Lifecycle, PID 1, and security](04-lifecycle-pid1-security.md)

## Image content

An image packages configuration and immutable filesystem layers. Layers store
changes, not a full independent copy for every image. Content addressing allows
registries and hosts to verify and reuse identical content.

```powershell
docker image inspect <image>
docker image history --no-trunc <image>
docker manifest inspect <image>
```

History is useful but not a complete software inventory. It may omit detail,
and secrets copied in an earlier layer remain recoverable even if a later layer
deletes them.

## Writable container layer

At runtime, the engine places a writable layer above the image layers. A
copy-on-write mechanism records container changes without modifying the image.
Stopping and restarting the same container retains that layer. Removing the
container removes it unless data lives in a volume or external system.

This is why application state should not depend on the container layer.

## Registry references

A full image reference can include registry, repository path, tag, and digest.
Tags can move; digests do not. Production deployments should use controlled,
immutable references and a documented update process.

Multi-platform image indexes point to different manifests for combinations such
as `linux/amd64` and `linux/arm64`. The runtime selects a compatible manifest.

## Image trust

An image is executable supply-chain content. Prefer maintained sources, pin
dependencies, minimize unnecessary packages, scan contents, retain provenance,
and rebuild when the base image changes. “Small” and “secure” are related but
not equivalent.

---

[Previous: Isolation and resource control](02-isolation-and-resources.md) ·
[Container fundamentals home](README.md) ·
[Next: Lifecycle, PID 1, and security](04-lifecycle-pid1-security.md)
