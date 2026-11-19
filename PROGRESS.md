# Engineering progress

## Current state

The repository foundation is in progress on `chore/project-foundation`. Product, engineering, testing, Git, architecture, ADR, and planning documents have been created. No application code or Xcode project exists.

## Next recommended action

Connect the verified public GitHub repository, commit/push the foundation, and open its pull request. Do not begin NR-001 until the foundation is reviewed.

## Journal

### 2026-11-19 — NR-000 Project foundation

- **Work completed:** Inspected an empty project directory; initialized Git with `main`; created `chore/project-foundation`; drafted the required documentation system and explicit immutable-test policy.
- **Tests added:** None. This slice contains documentation and repository metadata only.
- **Verification:** All required Markdown files are present; repository-relative Markdown links resolve; no `.swift`, `.xcodeproj`, or `.xcworkspace` artifacts exist; the current branch is `chore/project-foundation`; Git reports only the expected untracked foundation documents. GitHub reports `khodosko/noRamble` is public, empty, unarchived, and writable by the connected owner account.
- **Decisions:** Begin with native Swift/SwiftUI; keep architecture boundaries provisional; use strict test-first development; treat valid written tests as locked executable specifications; keep the repository public so development is visible, while excluding secrets and sensitive user data.
- **Problems or blockers:** None. The earlier private-repository requirement was explicitly replaced by the owner on 2026-11-19.
- **Immediate next action:** Add the verified remote, establish the empty `main` baseline, commit/push the foundation branch, and open the pull request.
