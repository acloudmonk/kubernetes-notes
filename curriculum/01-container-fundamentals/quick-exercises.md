# Quick Exercises

Use a disposable container and spend 5–15 minutes on each.

1. Compare `docker image inspect` with `docker inspect` and identify which
   fields describe reusable content versus runtime configuration.
2. Run two containers from one image and prove their hostname and writable
   layers differ while their image ID is the same.
3. Predict which files survive stop, start, removal, and recreation.
4. Compare a tag with the pulled repo digest. Explain which is mutable.
5. Inspect PID 1 and the configured command inside a running container.
6. Set a memory limit, inspect the effective byte value, and distinguish limit
   from reservation.
7. Identify three options that weaken isolation and the risk introduced.

Record commands, evidence, and cleanup rather than only screenshots.
