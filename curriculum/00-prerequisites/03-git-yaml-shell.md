# Git, YAML, and Shell Fundamentals

## Git state

The working tree contains checked-out files, the index contains the proposed
next snapshot, and a commit stores an immutable snapshot plus metadata and
parents. A branch is a movable name pointing to a commit. `origin/main` is a
local remote-tracking reference updated by fetch; it is not the remote itself.

```powershell
git status --short --branch
git diff
git diff --staged
git log --oneline --decorate --graph --all
git fetch origin
```

`fetch` downloads remote objects and updates remote-tracking references. `pull`
performs a fetch and then integrates changes, so inspect before integrating when
the history matters.

## YAML

YAML represents mappings, sequences, and scalars; indentation expresses
structure. Tabs are unsafe for indentation. Quote values when type inference or
special characters could change meaning. Kubernetes validates its resource
schema after YAML parsing, so syntactically valid YAML can still be invalid for
the API.

```yaml
service:
  name: catalog
  ports:
    - name: http
      port: 8080
  enabled: true
```

Do not confuse a block scalar with nested structure:

```yaml
script: |
  echo "This entire block is one string"
```

## Shell boundaries

PowerShell, Bash, and POSIX shell syntax differ. Quoting controls whether the
shell expands variables, wildcards, or command substitutions before the target
program sees them. Documentation must label the intended shell.

Environment variables are inherited by child processes and are visible to the
process environment. They are configuration transport, not a secret store.
