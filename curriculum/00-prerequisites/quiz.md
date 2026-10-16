# Knowledge Check

> **Module navigation:** [Prerequisites module home](README.md) · Previous:
> [Interview questions](interview-questions.md) · Next: [References](references.md)

Answer every question before reading the answer section.

1. Why is `SIGTERM` preferable to `SIGKILL` for normal shutdown?
2. What does binding a server to `127.0.0.1` imply?
3. Which layer has failed when DNS resolves but TCP is refused?
4. Why is disabling TLS verification unsafe?
5. How do working tree, index, and commit differ?
6. Why might an unquoted YAML value be interpreted unexpectedly?
7. Why can unlimited retries worsen an outage?
8. What state is required for reliable idempotency?

---

## Answers

1. It permits cleanup and graceful completion; `SIGKILL` cannot be handled.
2. Only callers in the same network namespace/host can reach that listener.
3. Resolution succeeded; investigate route, firewall, listener, and port.
4. It removes peer authentication and permits interception.
5. They are current files, proposed snapshot, and stored snapshot respectively.
6. YAML parsers assign scalar types and special syntax has structural meaning.
7. They add load and resource consumption to an already failing dependency.
8. A stable key stored atomically with the original operation result.

---

[Previous: Interview questions](interview-questions.md) ·
[Prerequisites module home](README.md) · [Next: References](references.md)
