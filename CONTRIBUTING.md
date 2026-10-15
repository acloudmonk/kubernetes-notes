# Contributing

## Before writing

1. Identify the learner outcome.
2. Check sequence and prerequisites in `ROADMAP.md`.
3. Start modules from `curriculum/_template/README.md`.
4. Record version-sensitive behavior.
5. Prefer specifications and official project documentation.

When publishing or changing a module's status, update its row in both
`ROADMAP.md` and `curriculum/README.md`. Link the module's `README.md` only when
usable learning material exists. Also update the module's previous/next
navigation so learners never reach a dead end or an unpublished path.

Each module defines evidence for **Explain**, **Build**, and **Diagnose**. Every
third module adds a cumulative exercise using at least two earlier modules.
Modules ending a competency stage link to and satisfy the corresponding gate in
`curriculum/ASSESSMENT-GATES.md`.

## Standards

- Explain why before presenting a long command sequence.
- Distinguish specification, common implementation, and opinion.
- Identify defaults that vary by platform or version.
- Pair happy paths with relevant failure behavior.
- Use fictional credentials and domains.
- Include verification and cleanup in every lab.
- Mark destructive or billable steps explicitly.
- State the intended shell for shell-specific commands.
- Use stable Kubernetes APIs unless teaching migration.
- Run containers as non-root where the exercise permits it.
- Avoid floating image tags in reproducible examples.

## Reference and video policy

- Every module should include primary written references and at least two
  curated video resources when suitable material exists.
- Prefer official project channels, recognized conference talks, and university
  courses with clear technical authorship.
- Describe what each video teaches; do not publish an unexplained link list.
- Record the speaker or publisher and year so learners can judge freshness.
- Mark older videos whose concepts remain useful but whose commands or UI may
  have changed.
- Treat videos as explanatory supplements. Current specifications and official
  documentation remain authoritative for version-sensitive behavior.
- Prefer videos with captions and avoid recommendations dominated by product
  promotion or exam dumps.

## Review checklist

- [ ] Objectives and prerequisites are explicit.
- [ ] Concepts agree with implementation.
- [ ] The lab starts from a documented state.
- [ ] Verification and cleanup are present.
- [ ] At least one relevant failure is covered.
- [ ] Questions test reasoning, not only recall.
- [ ] References are authoritative.
- [ ] Version-sensitive claims identify a baseline.
- [ ] No credentials or generated binaries are included.

## Branch and pull-request workflow

All work after the initial Phase 1 scaffold must use a feature branch. Branches
should be short-lived and named for the focused change, preferably with the
`codex/` prefix when created by Codex.

Changes must be pushed to the feature branch and submitted as a pull request
against `main`. Merging into `origin/main` is a manual repository-owner action;
automation and contributors must not merge the pull request themselves.

## Licensing

No license was selected during the initial scaffold. The repository owner
should choose one before accepting external contributions.
