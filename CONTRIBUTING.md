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

Every standalone module content page must link back to its module `README.md`.
Ordered pages should also link to the previous and next learning step at both
the top and bottom, so learners can enter directly from search and continue
without returning manually to the table of contents. Validate all relative
links before opening a pull request.

Each module defines evidence for **Explain**, **Build**, and **Diagnose**. Every
third module adds a cumulative exercise using at least two earlier modules.
Modules ending a competency stage link to and satisfy the corresponding gate in
`curriculum/ASSESSMENT-GATES.md`.

## Standards

- Explain why before presenting a long command sequence.
- Distinguish specification, common implementation, and opinion.
- Identify defaults that vary by platform or version.
- Pair happy paths with relevant failure behavior.
- Number every interview question and place an explicit `**Answer:**` directly
  below it. Explain the mechanism and relevant evidence, tradeoffs, failure
  modes, or common mistakes—not only a definition.
- Include at least 12 interview questions and declare coverage of fundamentals,
  internals, implementation, troubleshooting, security, and production. Cover
  each declared area substantively rather than treating the metadata as a label.
- Put every knowledge-check answer in a visible `## Answers` section below a
  separator. Include at least 12 questions, keep question and answer numbering
  identical, and do not collapse or omit the answer key.
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
- [ ] Every interview and knowledge-check question has an explicit answer, and
      `./scripts/Test-AssessmentCompleteness.ps1` passes.
- [ ] References are authoritative.
- [ ] Version-sensitive claims identify a baseline.
- [ ] Every content page has working module-home and sequence navigation.
- [ ] No credentials or generated binaries are included.

## Branch and pull-request workflow

All work after the initial Phase 1 scaffold must use a feature branch. Branches
should be short-lived and named for the focused change, preferably with the
`codex/` prefix when created by Codex.

Changes must be pushed to the feature branch and submitted as a pull request
against `main`. Merging into `origin/main` is a manual repository-owner action;
automation and contributors must not merge the pull request themselves.

## Repository hygiene and secrets

- Commit placeholders in files such as `.env.example`; keep real values only in
  ignored local files, an approved secret manager, or short-lived CI secrets.
- Never commit private keys, kubeconfigs, cloud credential directories,
  Terraform state, access tokens, generated diagnostic bundles, or production
  data. Kubernetes Secret manifests are not safe merely because values are
  base64-encoded.
- Before committing, inspect `git status`, `git diff --cached`, and the exact
  files selected for staging. `.gitignore` reduces accidents but does not stop
  `git add --force` or protect an already tracked file.
- Run `./scripts/Test-RepositoryHygiene.ps1 -IncludeHistory` before opening a
  pull request that adds configuration, automation, or deployment assets. The
  scan reports categories and paths without printing matched values.
- Pull requests and pushes to `main` run a pinned Gitleaks history scan. Treat a
  clean CI result as an additional control, not a substitute for reviewing the
  staged diff.
- If a real credential is committed, revoke or rotate it first. Removing it
  from the latest commit or rewriting history does not make the old credential
  safe.

## Licensing

No license was selected during the initial scaffold. The repository owner
should choose one before accepting external contributions.
