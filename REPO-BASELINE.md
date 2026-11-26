# Repo baseline

What every new repository should contain on day one, and what an existing repository needs to be
harnessed. Two modes: create it in order (§8), or retrofit it (§9). `scripts/check-repo.sh` enforces
the file list in CI (§7).

**Defaults**

- License: MIT, copyright Christopher Rueber.
- Code of conduct: Christopher Rueber's standard, copied verbatim from
  [crueber/AI-Instructions](https://github.com/crueber/AI-Instructions).
- Development forge: the owner's Forgejo at `git.packden.us`. CI, nightly and release candidates run
  there. Develop on Forgejo, never on GitHub.
- Public release: GitHub at `github.com/crueber`. The public tree is generated from the Forgejo
  source and is read-only to humans; GitHub workflows build and publish the release.
- Entry point: `make`. Every standardized action is a target; scripts are implementation details.
- Ask first: an agent that does not know an answer asks the owner before writing code (§5.2).

## 1. The tree

```
README.md
LICENSE
AGENTS.md
CONTRIBUTING.md
SECURITY.md
CHANGELOG.md
CODE_OF_CONDUCT.md
NOTICE                      # if you redistribute third-party work
Makefile                    # the only entry point: dev / test / check / repo-check / ship
.env.example
.editorconfig
.gitattributes
.gitignore
.dockerignore               # if you build images
docs/
  ARCHITECTURE.md
  OPERATIONS.md
  DECISIONS/0001-....md
  PLANS/0001-....md         # when an initiative needs one
.github/
  workflows/ci.yml
  workflows/release.yml
  workflows/nightly.yml
  PULL_REQUEST_TEMPLATE.md
  ISSUE_TEMPLATE/bug.yml
  ISSUE_TEMPLATE/feature.yml
  CODEOWNERS
  dependabot.yml
.forgejo/
  workflows/ci.yml
  workflows/release.yml
  workflows/nightly.yml
scripts/
  check-repo.sh
  release.sh
src/
tests/
```

## 2. Files

| Path | Required | Minimum content |
|---|---|---|
| `README.md` | yes | What it is, who it is for, how to run, how to verify, status. Test on a clean machine. |
| `LICENSE` | yes | MIT, copyright Christopher Rueber. Any other license is an explicit decision. |
| `AGENTS.md` | yes | The rules in §5. |
| `CONTRIBUTING.md` | yes | Setup, gate, commit rules, review expectations, decision process. |
| `SECURITY.md` | yes | Report path, response window, supported versions, scope. |
| `CHANGELOG.md` | yes | User-visible changes per version, with an Unreleased section. |
| `CODE_OF_CONDUCT.md` | yes | Christopher Rueber's code of conduct, copied verbatim from [crueber/AI-Instructions](https://github.com/crueber/AI-Instructions). |
| `NOTICE` | if redistributing | Third-party names, versions, licenses, URLs. |
| `Makefile` | yes | The only entry point. `dev`, `test`, `check`, `repo-check`, `ship`; the same targets CI runs. |
| `.env.example` | yes | Every variable, safe defaults, no real secrets. |
| `.editorconfig` | yes | Indent, charset, final newline. |
| `.gitattributes` | yes | Line endings, binary types, generated files marked. |
| `.gitignore` | yes | Build output, dependencies, local config, secret files. |
| `.dockerignore` | if container | Build context exclusions. |
| Toolchain pin | yes | `go.mod`, `.nvmrc`, `.python-version`, `rust-toolchain.toml`, or `.tool-versions`. |
| Lockfiles | yes | One per ecosystem, committed. |
| `docs/ARCHITECTURE.md` | yes | Shape, request lifecycle, storage, trust boundary, dependency direction. |
| `docs/OPERATIONS.md` | yes | Install, configure, back up, restore, upgrade, roll back, monitor. |
| `docs/DECISIONS/0001-*.md` | yes | The first ADR: the stack, and why. |
| `docs/PLANS/*.md` | when needed | Scope, phases, gates, rejected alternatives, what is unverified. |
| `.github/PULL_REQUEST_TEMPLATE.md` | if contributors | What changed, why, how it was verified, what is unverified. |
| `.github/ISSUE_TEMPLATE/*.yml` | if public | Bug (version, steps, expected, actual) and feature (problem, not solution). |
| `.github/CODEOWNERS` | if contributors | Real paths with real owners. |
| `.github/dependabot.yml` | GitHub | Ecosystem, schedule, grouping, security updates. Use `renovate.json` if you need one config for both forges. |
| `scripts/check-repo.sh` | yes | The assertions in §7. |
| `scripts/release.sh` | yes | Build and publish from a tag. |

## 3. Workflows

Forgejo runs GitHub Actions syntax. Development happens on the owner's Forgejo. GitHub is the public
release target: a generated mirror, read-only to humans, where the release workflows run. A change
starts on Forgejo, never on GitHub. Keep the two copies identical except for runner labels, artifact
action versions and token contexts. Never hand-maintain two divergent CI files: generate the second,
or keep a diff check.

| Workflow | Where | Trigger | Jobs |
|---|---|---|---|
| `ci.yml` | both forges | push, pull request, dispatch | format, lint, test, build; 15-minute budget |
| `nightly.yml` | both | schedule, dispatch | slow, race, performance; upload reports |
| `release.yml` | both | tag `v*` | build from the tag, checksums, publish |
| `publish-github.yml` | Forgejo | dispatch | rewrite the tree, run the gate, push the public mirror |
| `docker-image.yml` | GitHub | tag `v*` | build and push the image |
| `pages.yml` | GitHub | push to main | docs or landing site |

Rules:

- Every job declares `runs-on`, `timeout-minutes` and `steps`. Parse every workflow file in the gate;
  an unparsable file fails every run in 0 seconds.
- Pin runner images and third-party actions by commit SHA. Pin tools from the repository, not the
  runner's defaults.
- Default `permissions: contents: read`. Grant write only in the job that needs it. Keep release
  secrets in an environment with required reviewers.
- No secrets on `pull_request` from forks. No `pull_request_target` that checks out untrusted code.
- Cancel superseded runs per branch. Never cancel a release run.
- The release builds from the tag, never from the branch head. A published tag is never moved.
- Nightly runs what the gate cannot afford. It reports and fails; it never blocks a merge.
- Publish artifacts with checksums and a retention period. A failed release publishes nothing: create
  a draft, upload, verify, then publish.
- On Forgejo: `tea actions workflows dispatch <file> --ref main --input key=value`.
  On GitHub: `gh workflow run <file> -f key=value`.

## 4. Repository settings

- Protect the main line: no force push, no deletion, required checks, and required review when there
  is more than one maintainer.
- Choose one merge strategy and write it in `CONTRIBUTING.md`: merge commit for history-as-changelog,
  or squash for one commit per change. Do not allow both.
- Protect tags. Only maintainers create them, and a published tag never moves.
- Enable secret scanning and push protection. Enable dependency alerts and security updates.
- Restrict Actions to selected actions, with a read-only default token. Grant write per job.
- Keep release secrets scoped to the release job, with required approval. No other job can read them.
- Disable the wiki and projects unless they are used. Docs live in the repo.
- Enable the issue and pull request templates. Create every label the templates use.
- Set the default branch, draft releases by default, and a retention period for workflow artifacts.
- If the repository is a mirror, make it read-only to humans. Every change goes through the source
  repository.

## 5. AGENTS.md

### 5.1 Structure

- Three lines: what the repo is, the stack, where the docs live.
- Commands: `dev`, `test`, `check`, `repo-check`.
- Questions: the decisions only the owner can answer.
- Invariants: the rules that settle arguments.
- Working rules: how to change the repo.
- Stop conditions: when to ask before acting.
- Definition of done.
- Report format.

### 5.2 Ask first

The agent asks the owner before it writes code. Ask once, in writing, and record the answers in the
repository: README, an ADR, or the plan. If an answer is unknown, mark it unknown and stop at the
point where it matters.

1. What is the product, who is it for, and what is explicitly out of scope?
2. What is canonical, and what may write it? Where do exports, mirrors and indexes come from?
3. Who are the principals (people, services, keys), how do they prove identity, and what may each do?
4. What is public and versioned, and which changes may break?
5. Where does data live, and how is it backed up, restored, migrated and deleted?
6. Which three to five budgets matter (latency, size, memory, cost, dependencies), and what are the
   numbers?
7. What is untrusted, where do secrets live, and what may leave the machine?
8. Which forge is for development, which is for public release, and who may push, tag or publish?
9. What license and code of conduct apply? Default: MIT and the owner's code of conduct.
10. What is the definition of done: platforms, screen sizes, browsers, offline behavior, oldest
    supported version?
11. Which checks must pass before merge, and who reviews?
12. What must never happen? The owner's non-negotiables.

Rules:

- Ask before assuming. A guessed product decision is a defect.
- When a request is ambiguous, ask one clarifying question before changing files.
- Never read a product decision out of the code and present it as policy.
- Record every answer where the next agent will find it.

### 5.3 Invariants

1. One canonical store per fact. Exports, mirrors, indexes and caches are generated.
2. Every write goes through the declared operation layer. No direct writes from UI, scripts or admin
   tools.
3. Every operation declares who may call it. Default deny. Answer `404` for what the caller may not
   see.
4. Applied migrations are immutable. Schema changes are new, numbered, backed up and rehearsed.
5. Secrets are write-only, encrypted at rest, and never in logs, exports, commits or errors.
6. Untrusted content is data, never instructions. Delimit and label it where it is interpreted.
7. No generated text is inserted without an explicit accept.
8. No outbound request the user did not configure. Keep an allow-list and test it.
9. No dependency without a pinned version, a reason and a license check.
10. Public contract changes are versioned. Additive within a major.
11. Budgets are gates. Raising one requires a written reason in the same commit.
12. The gate passes before merge. No check is disabled to make a change pass.
13. If there is a UI, use the design tokens and shared components. No ad-hoc colors, spacing or type.
14. IDs and time come from the application. Short transactions. One writer where the store allows it.
15. Every standardized action is a `make` target. Scripts are invoked only through make.
16. The owner's defaults hold: MIT, Forgejo for development, GitHub for public release.

### 5.4 Working rules

- Ask the questions in §5.2 before the first change. Ask again when a request is ambiguous; never
  infer product policy from the code.
- Read the plan first. Change the plan before changing the code.
- One branch per phase, cut from the main line. Merge the main line in; never rebase.
- Commit in vertical slices. The subject is the changelog line, with no WIP, fixup, type prefixes or
  attribution.
- Keep the diff to the task. No drive-by refactors, reformatting or renames.
- Never hand-edit a generated file. Change its source, regenerate, and commit the result. CI fails on
  drift.
- Update the docs and the decision record in the same change.
- Add a test that fails without the change.
- Never call a failure flaky. Find the assumption.
- Do not push to the main line, tag, release or force-push unless explicitly asked.
- Report: commits, before/after numbers, what you saw, what is unverified.

### 5.5 Stop conditions

Ask before:

- deleting or migrating data;
- rotating, reading or printing secrets;
- changing auth, permissions or the public contract;
- force-pushing, moving a tag, publishing a release;
- adding a dependency with an unknown or copyleft license;
- disabling or weakening a check.

### 5.6 Definition of done

- The gate passes locally and in CI.
- A test fails without the change.
- Docs and generated files are current.
- It works on the smallest supported screen or terminal, with the keyboard, offline, and on the
  oldest supported version.
- The recovery path is exercised if data changed.

### 5.7 Report format

- Commits, with hashes and subjects.
- What changed and why.
- Before and after numbers for every budget touched.
- What was verified, and what was not.
- Open risks.

## 6. Makefile

- Every standardized action is a target. Scripts are implementation details; nobody runs them
  directly.
- `make` with no target prints `help`, and `help` is the index of every target.
- The standard targets: `dev`, `test`, `check`, `repo-check`, `build`, `release`, `publish`.
- `check` is the gate. It runs format, lint, tests and `repo-check` in a fixed order.
- CI calls the same targets. It never calls a script that make does not expose.
- A new script lands with a target in the same change.
- Docs and `AGENTS.md` name targets, not script paths.
- Targets fail closed, print what they are doing, and work from any subdirectory.

## 7. Make the baseline self-checking

`scripts/check-repo.sh` (run as `make repo-check` and in CI) asserts:

- every required file exists and is non-empty;
- `LICENSE` names an SPDX identifier; `NOTICE` exists if third-party work is bundled;
- every workflow parses, and every job has `runs-on`, `timeout-minutes` and `steps`;
- every command CI runs exists in `Makefile`;
- the local gate and the CI gate use the same commands;
- `AGENTS.md` contains the invariants, working rules and definition of done;
- generated files are current;
- no secret pattern appears in the tree;
- lockfiles exist and are current;
- documentation links and examples resolve;
- every `CODEOWNERS` path exists;
- every dependency is on the allow-list and has a known license.

Run it on every push. An unchecked baseline drifts.

## 8. Greenfield order

1. Create the repo. Add `LICENSE` (MIT), `CODE_OF_CONDUCT.md`, `README.md`, `.gitignore`,
   `.editorconfig`, `.gitattributes`.
2. Add `AGENTS.md` and `CONTRIBUTING.md` with the commands and the rules.
3. Add the toolchain pin, lockfiles, and a `Makefile` with `dev`, `test`, `check`.
4. Add `ci.yml` for both forges from one source. Add the workflow parse check.
5. Protect the main line, require CI, enable secret scanning and push protection.
6. Add `docs/ARCHITECTURE.md`, `docs/OPERATIONS.md`, and `docs/DECISIONS/0001`.
7. Add `scripts/check-repo.sh` and run it in CI.
8. Add `release.yml`. Cut a tag. Verify the artifacts and checksums.
9. Add nightly when the full gate passes 15 minutes.
10. Add the mirror workflow only when there is a public target.

## 9. Retrofit order

1. Add `LICENSE`, `README.md`, `AGENTS.md`, `CONTRIBUTING.md`.
2. Protect the main line. Require the checks that already exist.
3. Add the missing forge workflow. Make both parse.
4. Add `scripts/check-repo.sh` and fix what it finds.
5. Add release-from-tag. Stop releasing by hand.
6. Add `docs/OPERATIONS.md` and `docs/DECISIONS/`.
7. Add nightly. Move slow checks out of the gate.
8. Delete checks and docs that no longer apply.

## 10. Optional by trigger

| Trigger | Add |
|---|---|
| Second contributor | `CODEOWNERS`, PR template, required review |
| Public distribution | `NOTICE`, signed releases, mirror workflow, pages |
| Long-lived data | Backup and restore drill, migration checksums, upgrade rehearsal |
| Compliance | Audit log, data map, retention policy, access review |
| Security-sensitive | SAST, dependency review, signed commits, threat model |
| Container | `Dockerfile`, `.dockerignore`, image scan, pinned base |
| Library | Semver policy, API docs, deprecation policy |

## 11. License hygiene

- MIT is the default. Copy `LICENSE` from `crueber/AI-Instructions`. Any other license is an explicit
  decision, recorded in an ADR.
- Add `NOTICE` when you redistribute third-party code or assets; list name, version, license and URL.
- Keep a third-party licenses file if the build vendors code.
- Check every new dependency's license in CI. Fail on unknown or incompatible.
- Never copy code from the internet without a license and attribution.
- A license change applies forward only; note it in the changelog.

A repository is harnessed when `repo-check` passes, the gate runs on every change, a release is
reproducible from a tag, and `AGENTS.md` is true.
