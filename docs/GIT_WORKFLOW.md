# Git workflow

## Repository rules

- The canonical GitHub repository is the intentionally public `khodosko/noRamble` repository. Do not change visibility without explicit owner instruction.
- `main` is the protected primary branch.
- No feature or meaningful engineering slice is implemented directly on `main`.
- Verify the remote owner, repository name, URL, and documented visibility before any push.
- Never commit secrets, credentials, signing materials, API keys, recordings, transcripts, `.env` data, or developer-local configuration.
- Assume every commit, branch, pull request, issue, action log, and artifact is publicly readable.
- Do not force-push shared branches.

## Branch names

Use a type and concise slice name, for example:

- `chore/project-foundation`
- `feature/daily-prompt`
- `feature/audio-recording`
- `feature/speech-analysis`
- `feature/retry-comparison`
- `test/recording-error-coverage`
- `fix/notification-rollover`

## Commits

Keep commits coherent and reviewable. Use imperative messages that describe intent. Do not mix formatting or unrelated cleanup with behavioral changes. A commit should leave the branch in a useful, verifiable state when practical.

Test-first history is evidence, but a pull request's documented red/green commands are the durable record. Do not amend history to conceal a test-first violation.

## Pull requests

Every meaningful slice is merged through a focused pull request. The pull request must link the task and slice plan; explain user value, design, risk, privacy, accessibility, and rollback; enumerate changed behavior; and show exact verification commands and results. Documentation changes belong in the same pull request as the behavior they describe.

All checks and required reviews must pass. Prefer squash merge unless a later recorded decision selects another strategy. Delete merged feature branches when safe.

## CI and `main` protection

Once NR-001 establishes known Xcode commands, CI must build and run the complete automated suite for every pull request. Configure `main` to require pull requests, required checks, resolved review conversations, and protection from force pushes and deletion. Repository visibility changes require explicit owner instruction and a documentation update.

## Test integrity during review

A valid failing test is fixed in production code. Existing tests must not be deleted, skipped, weakened, or rewritten merely to make CI pass. Any exceptional test change must be called out prominently with evidence and the matching requirement or external-contract change; reviewers must verify that coverage and intent are preserved.

## Emergency fixes

Use a focused `fix/` branch and pull request. Accelerated review may be appropriate, but remote verification, meaningful tests, required checks, documentation, public-repository data safety, and test integrity still apply. Follow with an ADR or cleanup slice if the emergency solution creates a temporary design compromise.

## Pull-request checklist

- [ ] Task and current slice plan are linked.
- [ ] Scope is focused and unrelated work is excluded.
- [ ] Acceptance criteria are satisfied.
- [ ] Tests were written or updated before production behavior.
- [ ] Every existing-test change is exceptional, justified, and preserves intent.
- [ ] Relevant tests pass; commands and results are included.
- [ ] The complete suite passes; command and result are included.
- [ ] CI passes with no unexplained warning or failure.
- [ ] Failure paths, privacy, security, and accessibility were reviewed.
- [ ] `TASKS.md`, `PROGRESS.md`, and relevant architecture docs are updated.
- [ ] No secrets, user recordings/transcripts, or local configuration are committed.
- [ ] Rollback or recovery is described.
- [ ] Remote identity and documented visibility were verified before push.
