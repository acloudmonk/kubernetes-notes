# Troubleshooting Helm Releases

> **Module:** [11 — Helm](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
## Evidence order

Separate packaging, rendering, API, controller, and application failures:

1. identify chart digest/version, release, namespace, revision, and effective values;
2. reproduce lint/schema/template errors locally with the same inputs;
3. inspect rendered changes and API server dry-run/admission responses;
4. inspect `helm status`, `helm history`, and the manifest stored for the revision;
5. inspect object conditions, events, managed fields, Pods, Jobs, and logs;
6. verify Service endpoints, storage, dependencies, and application behavior;
7. choose forward fix, rollback, or restore based on side effects and compatibility.

Do not begin by deleting Pods or uninstalling the release; that destroys evidence
and may turn a recoverable failure into data loss.

## Common cases

| Symptom | Likely boundary | Useful evidence | Corrective direction |
|---|---|---|---|
| schema validation error | values contract | merged input path/type | correct the input or intentionally version the schema |
| YAML parse/template error | chart logic | `helm template --debug` near the first failure | repair scope, whitespace, quoting, or type use |
| object already exists / invalid ownership | lifecycle ownership | labels and Helm annotations on the live object | migrate/adopt explicitly or keep it external |
| API rejects render | cluster API/admission | server dry run and admission message | update API shape or satisfy policy; do not bypass blindly |
| release stays pending | interrupted/concurrent action | history, release status, active Jobs, client process | stop competing writers; verify state before recovery |
| upgrade times out | controller/application | rollout conditions, events, probes, logs, dependencies | fix the actual readiness/scheduling/image/storage failure |
| hook blocks or repeats | hook design | hook annotations, weights, Jobs, delete policy | make work idempotent and lifecycle explicit |
| rollback is deployed but app fails | irreversible side effect | schema/data versions and external-system evidence | use compatibility fix or restore; Helm cannot undo data |
| values appear ignored | precedence/type/reuse | `helm get values --all`, command flags | make inputs explicit; remove stale reused values |
| manual fix disappears | ownership conflict/GitOps | managed fields and controller events | change authoritative desired state, not the live object |

## Failed upgrade discipline

A failed revision is evidence. Record the error, rendered delta, events, failing
container state, and whether hooks or migrations produced side effects. Confirm
the target revision and application/data compatibility before rollback. After
recovery, rerun application behavior—not only `helm status`—and preserve a
sanitized incident note.

## Sensitive evidence

Avoid `helm get values --all`, `helm get manifest`, debug output, or Secret
decoding in shared logs when a chart carries sensitive values. This repository
keeps credential values outside Helm, but a third-party chart may not. Redact at
the source and rotate anything exposed; deleting a log is not sufficient.

> **Module:** [11 — Helm](README.md) · Previous: [Independent challenge](independent-challenge.md) · Next: [Interview questions](interview-questions.md)
