# AI Instructions

The owner's baseline for a new repository, and the harness for an existing one.

Read [REPO-BASELINE.md](REPO-BASELINE.md). It lists the files, the Forgejo and GitHub workflows, the
repository settings, the [AGENTS.md](AGENTS.md) rules, the Makefile rule, the self-check, and the
greenfield and retrofit orders.

## Defaults

- License: [MIT](LICENSE), copyright Christopher Rueber.
- Code of conduct: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md), the owner's standard.
- Development forge: Forgejo at `git.packden.us`.
- Public release: GitHub at `github.com/crueber`.
- Entry point: `make`. Every standardized action is a target; scripts are implementation details.
- Ask first: an agent that does not know an answer asks the owner. The questions are in
  [REPO-BASELINE.md](REPO-BASELINE.md) §5.2.

## Use it

- New repository: follow §8 of [REPO-BASELINE.md](REPO-BASELINE.md).
- Existing repository: follow §9.
- Copy [LICENSE](LICENSE) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) verbatim.
- Write `AGENTS.md` from §5.
- Add the Makefile targets from §6.
- Run `make check`.

## This repository

`make help` lists the targets. `make check` verifies the baseline documents are present and the
defaults are intact.
