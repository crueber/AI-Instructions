# AI Instructions

The owner's baseline for a new repository, and the harness for an existing one.

- [REPO-BASELINE.md](REPO-BASELINE.md) is the instruction: files, both forge workflows, repository
  settings, the agent rules, the make entry point, the self-check, and the greenfield and retrofit
  orders.
- [templates/](templates/) holds the files to copy into a new repository: the agent file, the license,
  the code of conduct, the make entry point, the self-check script, and both CI workflows.

## Defaults

- License: MIT. The text is [templates/LICENSE](templates/LICENSE).
- Code of conduct: [templates/CODE_OF_CONDUCT.md](templates/CODE_OF_CONDUCT.md), Christopher Rueber's
  standard.
- Development forge: use `tea` to reach it.
- Public release: use `gh` to reach it.
- Entry point: `make`. Every standardized action is a target; scripts are implementation details.
- Ask first: [templates/AGENTS.md](templates/AGENTS.md) tells the agent to ask the questions in its
  "Ask first" section before writing code.

## Use it

1. Read [REPO-BASELINE.md](REPO-BASELINE.md).
2. Copy the contents of `templates/` into the new repository root, including the dotfiles.
3. Replace every `TODO` and `<!-- Replace ... -->` placeholder.
4. Complete the project-specific files the baseline lists: README, CONTRIBUTING, SECURITY, docs/.
5. Run `make check`.

## This repository

This repository is the source of the templates and has no build of its own. The templates' Makefile
is the entry point once they are copied.
