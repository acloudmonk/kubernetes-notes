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
9. Why should automation preserve the first failing exit status?
10. Does a client timeout prove the server stopped processing?
11. Which Git operation safely reverses an already shared commit?
12. What must be validated beyond configuration syntax?

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
9. Otherwise a later successful command can hide the real failure and produce a false pass.
10. No; the outcome may be unknown and the server may still commit an effect.
11. `git revert`, because it adds an inverse commit without rewriting shared history.
12. Schema, target-version compatibility, policy, sensitive-data handling, and actual consumer behavior.

---

[Previous: Interview questions](interview-questions.md) ·
[Prerequisites module home](README.md) · [Next: References](references.md)
