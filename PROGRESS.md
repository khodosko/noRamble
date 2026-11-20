# Engineering progress

## Current state

NR-000 and NR-001 are merged. The repository has a launchable SwiftUI shell, automated unit/UI test targets, deterministic local commands, and green pull-request CI. No product feature behavior is included yet.

## Next recommended action

Plan NR-010, the daily prompt domain, as the next focused test-first slice. Do not begin unrelated feature work before its plan and tests are reviewed.

## Journal

### 2026-11-19 — NR-000 Project foundation

- **Work completed:** Inspected an empty project directory; initialized Git with `main`; created `chore/project-foundation`; drafted the required documentation system and explicit immutable-test policy; verified and connected the public GitHub repository; established the remote `main`; pushed the foundation branch; opened pull request #1; imported the owner-provided Stitch design package and documented how it informs native implementation.
- **Tests added:** None. This slice contains documentation and repository metadata only.
- **Verification:** Required Markdown files are present; repository-relative Markdown links resolve; no `.swift`, `.xcodeproj`, or `.xcworkspace` artifacts exist; GitHub reports `khodosko/noRamble` is public, unarchived, and writable by the connected owner account. The Stitch ZIP passes integrity and path-safety checks, contains the expected design-system document plus four HTML prototypes, and all four render successfully.
- **Decisions:** Begin with native Swift/SwiftUI; keep architecture boundaries provisional; use strict test-first development; treat valid written tests as locked executable specifications; keep the repository public while excluding secrets and sensitive user data; offer three prompt choices for one daily session; use a two-minute soft recording ceiling without abrupt cutoff; keep recording UI minimal and move all analysis after capture; use streaks without XP.
- **Problems or blockers:** None. The earlier private-repository requirement was explicitly replaced by the owner on 2026-11-19.
- **Immediate next action:** Review and merge pull request #1, then prepare the NR-001 slice plan.

### 2026-11-19 — NR-001 Xcode project and CI foundation

- **Work completed:** Confirmed Xcode 26.2 and iOS 26.2 Simulator availability; created the focused branch and slice plan; installed XcodeGen 2.48.0; generated the project; implemented the minimal accessible SwiftUI shell; added pull-request CI; opened pull request #2.
- **Tests added:** `AppShellContentTests.defaultContent_identifiesNoRambleAndFoundationReadiness`; `AppLaunchUITests.testLaunch_displaysAccessibleAppShell`.
- **Verification:** Red—unit command exited 65 because the `NoRamble` module was absent. Green—relevant unit command exited 0. Complete suite with coverage exited 0 on iPhone 17 Pro / iOS 26.2: 2 passed, 0 failed, 0 skipped; testable app code reports 100% coverage (48/48). Generated project is deterministic and exposes the expected three targets plus shared scheme. Simulator launch and visual QA passed. GitHub Actions passed twice before final bookkeeping; the documentation-evidence run completed in 6m 56s.
- **Decisions:** Provisional minimum deployment target iOS 17.0; commit a generated Xcode project backed by `project.yml`; pin local and CI verification to Xcode 26.2 and iPhone 17 Pro on iOS 26.2.
- **Problems or blockers:** None. The system-wide active developer directory points at Command Line Tools, so repository commands explicitly set `DEVELOPER_DIR` instead of changing global machine configuration.
- **Immediate next action:** Create and review the NR-010 slice plan and its failing domain tests.
