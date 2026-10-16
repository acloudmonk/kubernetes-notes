# Independent Challenge — Trace a Layered Failure

> **Module navigation:** [Prerequisites module home](README.md) · Previous:
> [Lab 3 — Configuration failure](labs/03-configuration-failure.md) · Next:
> [Troubleshooting scenario](troubleshooting.md)

Create a local-only dependency and a small caller without copying the guided
commands. Introduce three failures one at a time: an incorrect hostname, an
unused port, and an HTTP response outside the caller's accepted range.

For each failure, provide:

1. expected behavior and effective configuration;
2. process and listener evidence;
3. DNS, TCP, and HTTP evidence in that order;
4. the first failing boundary and one rejected hypothesis;
5. the correction, verification, and exact cleanup; and
6. one reason a blind retry or disabled TLS verification would be unsafe.

Do not use a shared or production endpoint. Acceptance requires three distinct
diagnoses, bounded commands, preserved failure exit codes, and proof that no
listener or environment override remains.

---

[Previous: Lab 3 — Configuration failure](labs/03-configuration-failure.md) ·
[Prerequisites module home](README.md) ·
[Next: Troubleshooting scenario](troubleshooting.md)
