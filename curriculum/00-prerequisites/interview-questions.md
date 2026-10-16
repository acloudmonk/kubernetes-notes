# Interview Questions

**Coverage:** fundamentals · internals · implementation · troubleshooting · security · production

> **Module navigation:** [Prerequisites module home](README.md) · Previous:
> [Troubleshooting scenario](troubleshooting.md) · Next:
> [Knowledge check](quiz.md)

### 1. What happens when Kubernetes terminates a container?

**Tags:** `fundamental`, `production`  
**Answer:** The runtime asks the container's main process to terminate, normally allowing a
grace period before forcing termination. Applications should handle termination,
stop accepting work, complete or abandon it safely, and exit. A common mistake
is assuming a process always receives unlimited shutdown time.

### 2. Why can a service work on localhost but fail from another machine?

**Tags:** `networking`, `troubleshooting`  
**Answer:** It may be bound only to a loopback address, blocked by a firewall, advertised
with the wrong address, or unreachable by route. Verify the listener address,
route, firewall, TCP connection, and then application protocol.

### 3. What is the difference between DNS failure and connection refusal?

**Tags:** `fundamental`  
**Answer:** DNS failure means no usable address was obtained. Connection refusal means an
address was reached but no listener accepted that port, or an intermediary
actively rejected it. They occur at different diagnostic boundaries.

### 4. Why does GitHub sometimes show the wrong commit account?

**Tags:** `git`, `implementation`  
**Answer:** Git stores author and committer names and emails in each commit. Hosting systems
usually map the email to an account; repository ownership does not choose the
author. Verify with `git show --format=fuller` and configure identity locally.

### 5. When are retries dangerous?

**Tags:** `distributed-systems`, `senior`  
**Answer:** Retries amplify overload, repeat non-idempotent effects, and can exceed an
upstream deadline. Retry only suitable transient failures with bounded attempts,
backoff, jitter, idempotency, and a retry budget.

### 6. Why can valid YAML still be rejected by Kubernetes?

**Tags:** `configuration`, `kubernetes`  
**Answer:** YAML parsing only produces data. Kubernetes then validates API version, kind,
schema, field types, admission policy, and authorization. Syntax validity does
not imply API validity.

### 7. How do you troubleshoot an HTTPS failure?

**Tags:** `troubleshooting`, `security`  
**Answer:** Check configuration, DNS, route, TCP, TLS negotiation, certificate chain,
validity and hostname, then HTTP. Never make disabled certificate verification
the permanent fix.

### 8. What makes an operation idempotent?

**Tags:** `distributed-systems`, `architecture`  
**Answer:** Repeating it produces no additional business effect. An idempotency key must be
associated atomically with the operation result so retries can return the prior
outcome instead of repeating the effect.

### 9. Why must shell automation check exit codes?

**Tags:** `shell`, `implementation`

**Answer:** A command can print plausible output and still fail, while a later
command may hide the original nonzero status. Automation should stop or branch
deliberately on failure, preserve diagnostic context, and avoid pipelines whose
exit semantics are misunderstood. Test both success and expected failure paths.

### 10. How do timeout, deadline, and cancellation differ?

**Tags:** `distributed-systems`, `internals`

**Answer:** A timeout bounds how long one operation waits; a deadline is an
absolute budget that can propagate across calls; cancellation communicates that
work is no longer wanted. Stopping the wait does not prove remote work stopped,
so effects need idempotency, reconciliation, and server-side cancellation where
supported.

### 11. How do you recover a Git change without rewriting shared history?

**Tags:** `git`, `production`

**Answer:** Inspect the graph and working state first. Restore or unstage local
paths deliberately, and use `git revert` to create an inverse commit for a change
already shared. Resetting or force-pushing rewrites reachability and can discard
collaborators' work, so it requires explicit coordination and recovery planning.

### 12. What makes a configuration change safe to promote?

**Tags:** `configuration`, `senior`

**Answer:** Define schema and ownership, validate syntax and semantics, review the
diff, test against the target version, protect sensitive values, and specify
verification and rollback. A parser accepting YAML proves only syntax; the
consumer, dependencies, and business behavior must accept the resulting state.

---

[Previous: Troubleshooting scenario](troubleshooting.md) ·
[Prerequisites module home](README.md) · [Next: Knowledge check](quiz.md)
