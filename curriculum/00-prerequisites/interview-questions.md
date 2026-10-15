# Interview Questions

> **Module navigation:** [Prerequisites module home](README.md) · Previous:
> [Troubleshooting scenario](troubleshooting.md) · Next:
> [Knowledge check](quiz.md)

## 1. What happens when Kubernetes terminates a container?

**Tags:** `fundamental`, `production`  
The runtime asks the container's main process to terminate, normally allowing a
grace period before forcing termination. Applications should handle termination,
stop accepting work, complete or abandon it safely, and exit. A common mistake
is assuming a process always receives unlimited shutdown time.

## 2. Why can a service work on localhost but fail from another machine?

**Tags:** `networking`, `troubleshooting`  
It may be bound only to a loopback address, blocked by a firewall, advertised
with the wrong address, or unreachable by route. Verify the listener address,
route, firewall, TCP connection, and then application protocol.

## 3. What is the difference between DNS failure and connection refusal?

**Tags:** `fundamental`  
DNS failure means no usable address was obtained. Connection refusal means an
address was reached but no listener accepted that port, or an intermediary
actively rejected it. They occur at different diagnostic boundaries.

## 4. Why does GitHub sometimes show the wrong commit account?

**Tags:** `git`, `implementation`  
Git stores author and committer names and emails in each commit. Hosting systems
usually map the email to an account; repository ownership does not choose the
author. Verify with `git show --format=fuller` and configure identity locally.

## 5. When are retries dangerous?

**Tags:** `distributed-systems`, `senior`  
Retries amplify overload, repeat non-idempotent effects, and can exceed an
upstream deadline. Retry only suitable transient failures with bounded attempts,
backoff, jitter, idempotency, and a retry budget.

## 6. Why can valid YAML still be rejected by Kubernetes?

**Tags:** `configuration`, `kubernetes`  
YAML parsing only produces data. Kubernetes then validates API version, kind,
schema, field types, admission policy, and authorization. Syntax validity does
not imply API validity.

## 7. How do you troubleshoot an HTTPS failure?

**Tags:** `troubleshooting`, `security`  
Check configuration, DNS, route, TCP, TLS negotiation, certificate chain,
validity and hostname, then HTTP. Never make disabled certificate verification
the permanent fix.

## 8. What makes an operation idempotent?

**Tags:** `distributed-systems`, `architecture`  
Repeating it produces no additional business effect. An idempotency key must be
associated atomically with the operation result so retries can return the prior
outcome instead of repeating the effect.

---

[Previous: Troubleshooting scenario](troubleshooting.md) ·
[Prerequisites module home](README.md) · [Next: Knowledge check](quiz.md)
