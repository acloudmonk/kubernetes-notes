# Learning Guide

## Study cycle

1. Read the objectives and prerequisites.
2. Study concepts and internal mechanics.
3. Reproduce the guided implementation.
4. Complete the lab without copying a solution.
5. Introduce a documented failure and diagnose it.
6. Complete the independent challenge.
7. Answer the interview questions aloud or in writing.
8. Record unclear areas and revisit the evidence.

A useful split is 30% theory, 60% hands-on work, and 10% written explanation.
Use the [learning execution kit](learning/README.md) to turn this cycle into a
study schedule, progress record, evidence summary, gate score, and revision log.

## Evidence of learning

Do not mark a subject complete because a command succeeded. Capture an
explanation in your own words, observable state, the failure signal and root
cause, the corrective action, recovery verification, and an alternative with
its tradeoffs. Never commit secrets or diagnostic bundles with credentials.

Use three evidence categories in every module:

- **Explain:** mechanism, guarantees, limitations, and tradeoffs
- **Build:** reproducible implementation and verification
- **Diagnose:** failure evidence, root cause, correction, and prevention

Every third module includes a cumulative exercise that reuses earlier concepts.
Spaced review is part of the learning path, not optional revision material.

## Lab contract

Every lab documents purpose, prerequisites, versions, estimated time, possible
cost, starting state, tasks, expected evidence, failure cases, and cleanup.
Cloud labs identify billable resources before creating them and offer a local
alternative where it teaches the same objective.

## Troubleshooting method

1. State expected and observed behavior.
2. Bound the affected scope.
3. Check recent changes and events.
4. Follow the request or dependency path one boundary at a time.
5. Form one falsifiable hypothesis.
6. Collect evidence that confirms or rejects it.
7. Apply the smallest safe correction.
8. Verify recovery and document prevention.

Avoid changing unrelated settings simultaneously; that can hide the symptom
without proving its cause.

## Interview responses

Give the direct answer, explain the mechanism, provide an example, discuss
failure modes and tradeoffs, and describe verification. State assumptions and
request missing evidence rather than guessing.

## Using video references

Watch a module's selected videos after reading its mental model and before the
guided lab. Take notes on the mechanism being demonstrated, then verify commands
against the module's current written references. Videos are valuable for visual
and live explanations, but older recordings can contain obsolete defaults,
commands, user interfaces, or security advice.

A useful video note records:

- The component or request flow demonstrated
- One concept that became clearer
- One claim verified against current documentation
- One remaining question to test in the lab

## Safety

- Use dedicated learning namespaces, clusters, and cloud accounts.
- Never use an employer or production cluster for destructive exercises.
- Inspect cleanup commands before running them.
- Use short-lived credentials and ignored local secret files.
- Configure cloud budgets before creating billable resources.
- Stop when lab assumptions do not match the environment.

## Environment progression

Use additional complexity only when it serves the learning objective:

1. Local process and Python exercises
2. Local Docker and Compose
3. Local Kubernetes
4. One managed Kubernetes platform
5. Advanced or multi-cluster comparison after production readiness

Learn one implementation deeply, then compare alternatives through ADRs. Do not
implement every cloud, service mesh, broker, or GitOps controller in parallel.
