# Knowledge Check

> **Module navigation:** [Docker module home](README.md) · Previous:
> [Interview questions](interview-questions.md) · Next:
> [References and videos](references.md)

Answer every question before reading the answer section.

1. What does the final argument to `docker build` select?
2. Why copy dependency metadata before application source?
3. When should exec-form process configuration be preferred?
4. Does `EXPOSE 8080` publish a host port?
5. Where does `localhost` point inside a container?
6. Which storage type survives container removal by default?
7. Why is a volume not a backup?
8. What does health-based `depends_on` guarantee?
9. Why is an environment variable not a complete secret solution?
10. What evidence distinguishes unhealthy from exited?

---

## Answers

1. The build context available to the builder.
2. Source changes then preserve the dependency-install cache layer.
3. When the executable should receive signals without an implicit shell.
4. No; it documents intent. Publishing creates forwarding.
5. The same container's network namespace.
6. A deliberately retained volume or external/bind-mounted data.
7. It proves no independent, application-consistent, restorable copy exists.
8. Startup waits for reported health, not future availability.
9. It can leak through inspection, process state, logs, and tooling.
10. State, exit code, OOM flag, health log, timestamps, and application logs.

---

[Previous: Interview questions](interview-questions.md) ·
[Docker module home](README.md) ·
[Next: References and videos](references.md)
