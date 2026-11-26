#!/usr/bin/env bash
# Verifies this repository is still the baseline it claims to be.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

status=0
fail() { echo "FAIL: $*" >&2; status=1; }
need() { [ -s "$1" ] || fail "missing or empty: $1"; }

need README.md
need REPO-BASELINE.md
need AGENTS.md
need CODE_OF_CONDUCT.md
need LICENSE
need Makefile

grep -q "MIT License" LICENSE || fail "LICENSE is not the MIT text"
grep -q "Copyright (c) 2026 Christopher Rueber" LICENSE || fail "LICENSE copyright line changed"

grep -q "^### 5.2 Ask first" REPO-BASELINE.md || fail "REPO-BASELINE.md lacks the ask-first section"
grep -q "^## 6. Makefile" REPO-BASELINE.md || fail "REPO-BASELINE.md lacks the Makefile section"
grep -q "^## 7. Make the baseline self-checking" REPO-BASELINE.md || fail "REPO-BASELINE.md lacks the self-check section"
grep -q "git.packden.us" REPO-BASELINE.md || fail "REPO-BASELINE.md lacks the Forgejo default"
grep -q "github.com/crueber" REPO-BASELINE.md || fail "REPO-BASELINE.md lacks the GitHub default"
grep -q "MIT is the default" REPO-BASELINE.md || fail "REPO-BASELINE.md lacks the MIT default"

for link in REPO-BASELINE.md CODE_OF_CONDUCT.md LICENSE AGENTS.md; do
  grep -q "($link)" README.md || fail "README.md does not link to $link"
done

if [ "$status" -eq 0 ]; then
  echo "check: ok"
fi
exit "$status"
