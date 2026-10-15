# References

> **Module navigation:** [Container fundamentals home](README.md) · Previous:
> [Knowledge check](quiz.md) · Next: [Module 02 — Docker](../02-docker/README.md)

- [Docker overview](https://docs.docker.com/get-started/docker-overview/) — engine,
  image, container, and lifecycle concepts.
- [Docker: What is a container?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-container/) — container mental model.
- [Docker: What is an image?](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-an-image/) — image and layer model.
- [Docker resource constraints](https://docs.docker.com/engine/containers/resource_constraints/) — CPU and memory controls.
- [Docker start/stop behavior](https://docs.docker.com/reference/cli/docker/container/stop/) — stop signal and timeout.
- [Docker security](https://docs.docker.com/engine/security/) — daemon and container security model.
- [Open Container Initiative](https://opencontainers.org/) — image, runtime, and distribution specifications.
- [OCI Image Specification](https://specs.opencontainers.org/image-spec/) — image manifests, configuration, and layers.
- [OCI Runtime Specification](https://specs.opencontainers.org/runtime-spec/) — runtime bundle and lifecycle.
- [Linux namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html) — namespace types and behavior.
- [Linux cgroup v2](https://docs.kernel.org/admin-guide/cgroup-v2.html) — kernel resource-control model.

## Videos

- [Containers From Scratch](https://www.youtube.com/watch?v=8fi7uSYlOdc) — Liz
  Rice at GOTO, 2018. Builds a container from Linux primitives to make
  namespaces, root filesystems, and cgroups concrete. The mechanisms remain
  relevant; verify individual commands against current kernel documentation.
- [Docker 101: Introduction to Docker and Containers](https://www.youtube.com/watch?v=kwsJIH5TGIg)
  — Docker, 2018. Provides a visual introduction to containers, images, and
  virtual-machine differences. Docker Desktop screens and some commands may
  differ from current releases.
- [The Container Security Checklist](https://community.cncf.io/e/m848je/)
  — CNCF webinar with Liz Rice, 2021. Connects shared-kernel isolation,
  privileges, image risks, and operational security decisions.

---

[Previous: Knowledge check](quiz.md) · [Container fundamentals home](README.md) ·
[Next: Module 02 — Docker](../02-docker/README.md)
