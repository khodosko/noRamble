# Engineering progress

## Current state

NR-000, NR-001, and NR-010 are merged. NR-011 is complete locally: 30 original prompts rotate through three deterministic daily choices while preserving the three-card and same-day lock contracts. Recording has not started.

## Next recommended action

Plan NR-020's testable audio-recording boundary, including permission, lifecycle, interruption, failure, and the two-minute soft-ceiling behavior behind the accepted **Start Daily Rep** action.

## Journal

### 2026-11-20 — NR-011 Prompt library and daily rotation

- **Work completed:** Researched official Toastmasters guidance and examples; replaced the three weak workplace prompts with 30 newly written prompts across story, opinion, reflection, imagination, decision, and connection themes; added deterministic local-day rotation; kept retired identifiers available only for same-day restoration; updated the visible ritual label to **Daily Rep** and accepted **Start Daily Rep** for the recording slice.
- **Tests added:** Catalog size, uniqueness, category breadth, and legacy separation; exactly-three rotation, same-day and cross-instance stability, next-day change, full ten-day catalog coverage, and pre-epoch behavior; same-day legacy-selection visibility.
- **Verification:** Red—unit command exited 65 because `DailyPromptRotation`, `DailyPromptCatalog.legacy`, and `DailyPromptCatalog.all` did not exist. Green—26 unit and 2 UI tests pass with 0 failures on iPhone 17 Pro / iOS 26.2. App coverage is 97.86% (503/514); session policy, view model, and app composition are 100%. Simulator visual review confirmed all three longer cards remain readable and scrollable without clipping.
- **Decisions:** Prompt wording is original rather than copied from published question sets; the bundled library stays offline and non-browsable; stable FNV-1a ordering avoids process-randomized hashing; adding future unselected prompts may alter a day's set, but a persisted same-day choice remains visible.
- **Problems or blockers:** None. The owner explicitly replaced the fixed three-item catalog requirement. The invalid exact-catalog test was replaced with library-quality and rotation tests; two fixtures that named retired prompt IDs now select injected/visible prompts without weakening their save-failure or selection-lock assertions.
- **Immediate next action:** Merge [pull request #4](https://github.com/khodosko/noRamble/pull/4) after hosted CI passes, then plan NR-020.

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

### 2026-11-19 — NR-010 Daily prompt domain

- **Work completed:** Added three curated starter prompts; modeled local-day identity and the immutable same-day choice; added a domain-owned store boundary and namespaced `UserDefaults` adapter; composed a main-actor view model; replaced the empty shell body with an accessible, scrollable native prompt picker while preserving the locked NR-001 launch contract; opened pull request #3.
- **Tests added:** Catalog cardinality/content; selection persistence and restoration; idempotent same-choice retries; different-choice locking; unknown and retired identifiers; injected time-zone rollover; store round-trip, clearing, and corrupt data; view-model restoration, lock, unavailable/save/load recovery, and disabled-intent guards; end-to-end accessible picker selection.
- **Verification:** Red—relevant unit command exited 65 because `DailyPromptCatalog` did not exist. Green—19 unit and 2 UI tests pass with 0 failures on iPhone 17 Pro / iOS 26.2. App coverage is 98.16% (427/435); the session policy, view model, concrete store, app composition, and shell are 100%. Uncovered lines are a non-rendered SwiftUI error-result-builder branch and the defensive impossible-calendar precondition. XcodeGen regeneration is byte-identical. Manual simulator launch and visual review passed.
- **Decisions:** The local day is derived from an injected calendar and its time zone; the first persisted choice is fixed for that day and is idempotent when selected again; only a prompt identifier and date components enter `UserDefaults`; this scoped preference adapter does not decide future history/attempt persistence.
- **Problems or blockers:** None. Two test-fixture corrections were required and documented before editing: invalid Swift default-parameter helper syntax, and an outdated assumption that Vancouver would be UTC−8 on 2026-11-20. Neither changed behavioral assertions.
- **Immediate next action:** Plan NR-020 without adding recording behavior to NR-010.
