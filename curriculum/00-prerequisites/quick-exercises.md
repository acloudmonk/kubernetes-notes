# Quick Exercises

> **Module navigation:** [Prerequisites module home](README.md) · Previous:
> [Distributed-system foundations](04-distributed-systems.md) · Next:
> [Core labs](labs/README.md)

Spend 5–15 minutes on each exercise.

1. Start `python -m http.server 8080 --bind 127.0.0.1`. Identify its PID and
   listening socket without looking at the terminal that started it.
2. Explain why another machine cannot reach a listener bound to `127.0.0.1`.
3. Compare the DNS result for a known name with the address used by `curl -v`.
4. Run `git status`, `git diff`, and `git diff --staged` in a disposable repo and
   explain why their output differs.
5. Predict the data types in a YAML document before parsing or validating it.
6. Given a 2-second caller budget and two dependencies, propose timeout and
   retry limits without exceeding the caller budget.
7. Describe a duplicate-order scenario and the state needed to make it
   idempotent.

Record commands, observations, and explanations. Clean up the HTTP server.

---

[Previous: Distributed-system foundations](04-distributed-systems.md) ·
[Prerequisites module home](README.md) · [Next: Core labs](labs/README.md)
