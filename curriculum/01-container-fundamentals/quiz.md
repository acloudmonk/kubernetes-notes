# Knowledge Check

> **Module navigation:** [Container fundamentals home](README.md) · Previous:
> [Interview questions](interview-questions.md) · Next: [References](references.md)

1. Which part of a Linux container supplies the kernel?
2. Name four namespace types and the views they isolate.
3. What is the difference between CPU throttling and CPU reservation?
4. Why can two containers share image layers but have different files at runtime?
5. What is lost when a container is removed?
6. Why can deleting a secret in a later image layer fail to remove it?
7. What makes a digest more reproducible than a tag?
8. What occurs after the container's main process exits?
9. Why can a shell entrypoint interfere with graceful shutdown?
10. Name three configurations that weaken container isolation.

---

## Answers

1. The host kernel; Docker Desktop supplies a Linux environment on Windows.
2. Examples: PID/processes, network/interfaces and sockets, mount/filesystems,
   UTS/hostname, user/ID mappings, IPC/resources.
3. Throttling caps consumed CPU time; reservation/scheduling is a separate
   guarantee or placement concern.
4. Immutable layers are shared; each container has its own writable layer.
5. Its metadata and writable layer; external volumes have separate lifetimes.
6. Earlier immutable layers still contain the bytes.
7. A digest is content-addressed while a tag can move.
8. The container enters an exited state with the process result.
9. The shell can remain PID 1 and fail to forward signals to its child.
10. Examples: privileged mode, host namespaces, broad capabilities, sensitive
    host mounts, or mounting the engine socket.

---

[Previous: Interview questions](interview-questions.md) ·
[Container fundamentals home](README.md) · [Next: References](references.md)
