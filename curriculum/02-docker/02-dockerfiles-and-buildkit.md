# Dockerfiles and BuildKit

## Build context

The final argument to `docker build` selects the build context. Files in that
context can be sent to the builder unless excluded by `.dockerignore`. Keep the
context narrow and exclude Git metadata, virtual environments, caches, outputs,
credentials, and local configuration.

## Instruction responsibilities

- `FROM` selects a base or previous stage.
- `WORKDIR` establishes an explicit directory.
- `COPY` transfers intentional build-context content.
- `RUN` executes during build and creates a layer.
- `USER` selects runtime identity.
- `ENV` persists runtime environment; `ARG` is build-scoped but not secret.
- `ENTRYPOINT` defines the executable; `CMD` supplies overridable defaults.

Use JSON/exec form for the main process so signals reach it directly. Shell form
is appropriate only when shell behavior is deliberately required.

## Cache strategy

BuildKit reuses a step when the instruction and relevant inputs match. Copy
dependency metadata and install dependencies before copying frequently changing
application code. Do not combine unrelated volatile inputs early in the file.

```dockerfile
# syntax=docker/dockerfile:1.7
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt
```

Cache mounts improve performance without copying the cache into the image.
Secret mounts expose a value to a build step without persisting it in build
arguments, environment, or a layer. Still verify resulting layers and logs.

## Multi-stage builds

A builder stage can contain compilers and dependency tooling while the runtime
stage receives only required artifacts. This reduces attack surface and size,
but does not automatically make dependencies trusted or images reproducible.

## Reproducibility

- Pin base images and application dependencies according to maintenance policy.
- Record digests used for releases.
- Build for the intended OS and architecture.
- Generate an SBOM and scan the final image.
- Rebuild regularly; an old “clean” scan does not remain current.
- Never bake credentials into `ARG`, `ENV`, copied files, or history.
