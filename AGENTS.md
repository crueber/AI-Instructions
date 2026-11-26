# AGENTS.md

This repository is the owner's baseline for new repositories and for harnessing existing ones. Read
[REPO-BASELINE.md](REPO-BASELINE.md) before changing anything.

## Ask first

If a change depends on a decision only the owner can make, ask. Do not infer policy from the files.
The questions to ask are in [REPO-BASELINE.md](REPO-BASELINE.md) §5.2.

## Rules

- `make check` must pass.
- Every standardized action is a make target. Do not add a script without a target.
- Do not edit `CODE_OF_CONDUCT.md`, `LICENSE`, or the defaults in `REPO-BASELINE.md` without the
  owner's explicit direction.
- Keep the documents generic. No project-specific details, no secrets, no private hostnames beyond
  the stated defaults.
- Commit subjects are changelog lines: one line, no type prefix, no attribution.

## Verify

```sh
make check
```
