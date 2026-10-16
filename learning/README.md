# Learning Execution Kit

This directory turns the published curriculum into a measurable study process.
Content completion is not competency: advance when the required Explain, Build,
and Diagnose evidence passes, not merely when a planned week ends.

## Start here

1. Read the repository [learning guide](../LEARNING-GUIDE.md).
2. Choose the standard or accelerated path in the
   [study plan](STUDY-PLAN.md).
3. Update the [progress tracker](PROGRESS.md) after each study session.
4. Copy the [module evidence template](templates/module-evidence.md) for the
   module you are actively studying.
5. At a competency boundary, copy the
   [gate scorecard](templates/gate-scorecard.md) and assess a changed scenario.
6. Use the [revision log](templates/revision-log.md) for spaced recall.

Begin with [Module 00 — Prerequisites](../curriculum/00-prerequisites/README.md).
Do not study modules out of order until their prerequisites pass or a diagnostic
assessment shows equivalent ability.

## Evidence locations

- Commit only concise, sanitized explanations and scorecards under
  [`evidence`](evidence/README.md).
- Put raw terminal output, generated reports, screenshots, and temporary notes
  under ignored `tmp/learning-evidence/`.
- Keep credentials, kubeconfigs, private keys, `.env` files, Terraform state,
  production data, and unredacted diagnostics outside Git.
- Prefer links to existing repository configuration over duplicated output.

## Status meanings

| Status | Meaning |
|---|---|
| Not started | Prerequisite evidence has not been reviewed |
| In progress | Theory or guided implementation is underway |
| Lab complete | Guided path passed, but challenge or assessment remains |
| Reassess | One or more Explain, Build, or Diagnose dimensions are below 2 |
| Complete | Challenge passed and every required dimension is at least 2 |

Repository module status such as `Verified` describes the learning material.
It does not describe an individual learner's progress.

## Weekly closeout

At the end of each week or study block:

1. summarize the mechanism without notes;
2. reproduce one useful path from a clean starting state;
3. diagnose one deliberate failure before reading the solution;
4. record cleanup and confirm no billable or sensitive resources remain;
5. schedule the next recall date; and
6. update only claims supported by evidence.
