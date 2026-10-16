# Independent Challenge — Defend a Container Boundary

> **Module navigation:** [Container fundamentals home](README.md) · Previous:
> [Guided lab](lab/README.md) · Next: [Troubleshooting](troubleshooting.md)

Run a version-pinned container that stays alive, has explicit CPU and memory
limits, uses a non-root numeric user, and handles its configured stop signal.
Do not copy the guided command unchanged.

Produce evidence for:

1. image ID, platform, manifest/config relationship, and layer history;
2. host runtime flow and the container's PID 1;
3. namespace and cgroup isolation plus one thing they do not isolate;
4. read-only image content versus the writable container layer;
5. effective user, capabilities, limits, and termination result; and
6. removal/recreation behavior and precise cleanup.

Inject one incorrect command or permission setting, diagnose it from exit state
and logs, then correct it. Acceptance requires a non-root final process, bounded
resources, graceful exit, no surviving challenge container, and an explanation
of why the result is not equivalent to a virtual-machine security boundary.

---

[Previous: Guided lab](lab/README.md) ·
[Container fundamentals home](README.md) ·
[Next: Troubleshooting](troubleshooting.md)
