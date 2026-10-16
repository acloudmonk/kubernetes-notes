# Independent Challenge — Observability Practitioner

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Lab 2 — Correlate and diagnose](labs/02-correlate-diagnose.md) · Next: [Troubleshooting](troubleshooting.md)

## Scenario

CloudCart users report intermittent slow or failed order creation. You own the
service during a 45-minute incident exercise. Another person may choose one
reversible fault: PostgreSQL Service selection, RabbitMQ reachability, API
resource pressure, one broken scrape annotation, Collector export failure, or
an invalid Grafana query. You must not be told which fault was selected.

## Deliverables

1. A diagram of metric, log, and trace paths with trust/storage boundaries.
2. A user-centered availability or latency SLI, objective, window, exclusions,
   error-budget calculation, and fast/slow burn alert proposal.
3. A version-controlled dashboard change with audience, question, and action
   documented for each panel.
4. An incident timeline showing symptom, bounded scope, hypotheses, supporting
   and contradicting evidence, root cause, mitigation, and recovery proof.
5. One metric → exemplar → trace → log correlation path, or a precise account
   of why sampling/pipeline behavior prevents it and how to correct that gap.
6. Extend one order trace across the API → outbox relay → RabbitMQ → worker
   boundary. Persist only approved W3C trace context beside the outbox event,
   inject it into message headers, extract it at the consumer, and justify
   parent/child spans versus span links for the asynchronous work. Prove the
   resulting trace shape and correlated relay/worker logs without changing the
   `order.accepted.v1` business payload contract.
7. A review that finds and fixes one high-cardinality, sensitive-data, or noisy
   alert design without committing real sensitive data.
8. A production-gap table covering auth, tenancy, TLS, durability, sampling,
   retention, capacity, upgrades, backup/restore, and pipeline monitoring.

## Constraints

- Verify `kind-cloudcart-observability` before mutation.
- Preserve the fault and restoration commands in your notes.
- Do not delete persistent data, disable security controls, expose Services,
  paste credentials, or use a guessed restore value.
- Query raw backend APIs when Grafana results are ambiguous.
- Restore baseline and rerun the automated observability test.

## Gate 4 scoring

Use the [competency rubric](../ASSESSMENT-GATES.md). Passing requires at least 2
in Explain, Build, and Diagnose and at least 7/9 overall. A copied dashboard or
script without a defended SLI and evidence chain does not pass.

> **Module:** [13 — Grafana and observability](README.md) · Previous: [Lab 2 — Correlate and diagnose](labs/02-correlate-diagnose.md) · Next: [Troubleshooting](troubleshooting.md)
