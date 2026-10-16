# Sanitized Learning Evidence

This directory is reserved for concise evidence summaries created from the
[module template](../templates/module-evidence.md) and
[gate scorecard](../templates/gate-scorecard.md). It intentionally contains no
runtime output.

Before committing an evidence file:

1. link repository configuration instead of copying generated manifests;
2. reduce terminal output to the claim it supports;
3. remove credentials, tokens, keys, kubeconfigs, `.env` values, state,
   production data, internal addresses, and personal information;
4. record versions, limitations, cleanup, and the next reassessment; and
5. run `./scripts/Test-RepositoryHygiene.ps1 -IncludeHistory`.

Keep raw notes and generated artifacts under ignored
`tmp/learning-evidence/`. Ignoring a file prevents accidental normal staging;
it does not make sensitive data safe to share or exempt it from local handling
requirements.
