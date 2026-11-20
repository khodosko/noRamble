# Instructions for coding agents

These instructions apply to every agent and every change in this repository.

## Before editing

1. Read `README.md`, `PRODUCT.md`, `TASKS.md`, `PROGRESS.md`, and the relevant documents under `docs/`.
2. Run `git status` and preserve all user-authored and unrelated worktree changes.
3. Identify the current task and its slice plan. Create or update the plan before meaningful implementation.
4. Confirm that the current branch is a focused slice branch, never `main`.

## Required working method

- Use strict test-driven development: define behavior, write the test, confirm the expected failure, make the smallest production change, run relevant tests, refactor while green, then run the complete suite.
- Write or update tests before adding or changing production behavior.
- Treat an accepted test as a locked executable specification. Never delete, weaken, skip, or rewrite a test merely to make production code pass.
- Change an existing test only when the requirement intentionally changed, the test is demonstrably invalid or flaky, or an external platform contract changed. Document the evidence and justification in the slice plan and pull request before changing it. Prefer fixing production code whenever a valid test fails.
- Cover meaningful branches, state transitions, failures, parsers, scoring rules, persistence operations, services, and business rules.
- Keep SwiftUI presentation separate from business logic and platform integrations so behavior can be tested directly.
- Run relevant tests after every meaningful change and the complete suite before declaring completion.
- Never bypass a failing test or substitute a successful build for test evidence.
- Avoid unrelated changes and keep the pull request focused.

## Documentation and reporting

- Keep the active slice plan current.
- Update `TASKS.md` and `PROGRESS.md` in the same pull request.
- Update architecture documentation and add an ADR when a durable design decision changes.
- Report exact verification commands and their results. Never claim completion without verification evidence.

## Git, privacy, and safety

- Never work directly on `main`; use a branch and pull request.
- Never push to a remote until its owner, repository name, URL, and visibility are verified against the documented repository policy.
- This repository is intentionally public. Do not change its visibility without explicit owner instruction.
- Never commit secrets, credentials, API keys, signing materials, recordings, transcripts, or developer-local configuration.
- Preserve user changes already present in the worktree.
- Do not force-push shared branches.
- Stop and report the boundary if the configured remote cannot be verified as the intended `khodosko/noRamble` repository.
