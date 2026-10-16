# Troubleshooting Scenario

> **Module navigation:** [Prerequisites module home](README.md) · Previous:
> [Independent challenge](independent-challenge.md) · Next:
> [Interview questions](interview-questions.md)

An application reports: `dependency unavailable`. Its configuration uses
`http://catalog:8080`, and repeated retries produce the same message.

## Evidence to request

1. The effective configuration as seen by the process
2. Name-resolution results for `catalog`
3. The resolved addresses and network context
4. TCP connectivity to port 8080
5. HTTP response and dependency logs
6. Recent configuration or deployment changes

Stop here and form hypotheses before reading the diagnosis.

---

## Example diagnosis

If this process runs on the host while `catalog` is only a Docker Compose or
Kubernetes service name, the name exists only inside that network context. The
failure is configuration/name scope, not an application retry problem.

Correct the endpoint for the caller's actual network context or run the caller
inside the intended network. Verify DNS, TCP, then HTTP. Prevent recurrence by
documenting environment-specific endpoints and testing effective configuration.

---

[Previous: Independent challenge](independent-challenge.md) ·
[Prerequisites module home](README.md) ·
[Next: Interview questions](interview-questions.md)
