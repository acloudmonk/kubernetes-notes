#!/usr/bin/env bash
set -u

missing=0
for tool in git python3; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '%-10s available\n' "$tool"
  else
    printf '%-10s missing (required)\n' "$tool"
    missing=1
  fi
done

for tool in docker kubectl helm; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '%-10s available\n' "$tool"
  else
    printf '%-10s missing (optional in Phase 2A)\n' "$tool"
  fi
done

exit "$missing"
