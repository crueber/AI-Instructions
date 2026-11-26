# AGENTS.md

<!-- Replace this line: what the repository is, the stack, and where the docs live. -->

## Commands

- `make dev`
- `make test`
- `make check`
- `make repo-check`

## Ask first

Ask the owner before you write code. Do not infer product policy from the code. Get answers to these
questions and record them in the repository (README, an ADR, or the plan). If an answer is unknown,
mark it unknown and stop at the point where it matters.

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

## Invariants

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

## Working rules

- Ask the questions above before the first change. Ask again when a request is ambiguous; never infer
  product policy from the code.
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

## Stop conditions

Ask before:

- deleting or migrating data;
- rotating, reading or printing secrets;
- changing auth, permissions or the public contract;
- force-pushing, moving a tag, publishing a release;
- adding a dependency with an unknown or copyleft license;
- disabling or weakening a check.

## Definition of done

- The gate passes locally and in CI.
- A test fails without the change.
- Docs and generated files are current.
- It works on the smallest supported screen or terminal, with the keyboard, offline, and on the
  oldest supported version.
- The recovery path is exercised if data changed.

## Report format

- Commits, with hashes and subjects.
- What changed and why.
- Before and after numbers for every budget touched.
- What was verified, and what was not.
- Open risks.
