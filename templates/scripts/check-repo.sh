#!/usr/bin/env bash
# Verifies the repository still has the baseline files and sane workflows.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

status=0
fail() { echo "FAIL: $*" >&2; status=1; }
need() { [ -s "$1" ] || fail "missing or empty: $1"; }

for f in README.md AGENTS.md CONTRIBUTING.md SECURITY.md LICENSE CODE_OF_CONDUCT.md Makefile; do
  need "$f"
done

grep -q "MIT License" LICENSE || fail "LICENSE is not the MIT text"

for f in .github/workflows/*.yml .forgejo/workflows/*.yml; do
  [ -e "$f" ] || continue
  grep -q "^jobs:" "$f" || fail "$f has no jobs:"
  for key in runs-on timeout-minutes steps; do
    grep -q "^[[:space:]]*$key:" "$f" || fail "$f has no $key:"
  done
done

if [ "$status" -eq 0 ]; then
  echo "repo-check: ok"
fi
exit "$status"
