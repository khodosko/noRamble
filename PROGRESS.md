# Engineering progress

## Current state

NR-000, NR-001, NR-010, NR-011, and NR-020A are merged. NR-021 is in progress to align the reviewed recording journey with the supplied prompt and recording references.

## Next recommended action

Write the changed NR-021 UI contract and elapsed-time specifications red, then implement the tactile green start action plus selected-prompt and small-timer recording context. NR-020B remains next.

## Journal

### 2026-11-20 — NR-021 Recording context refinement

- **Requirement change:** After reviewing NR-020A in Simulator, the owner explicitly requested the selected prompt and a small elapsed timer during recording and called out the start action's deviation from the large green supplied reference.
- **Test-policy impact:** The locked NR-020A UI assertion that elapsed time must be absent is now invalid. NR-021 documents the changed requirement before replacing only that assertion with positive prompt/timer coverage; unrelated tests remain locked.
- **Immediate next action:** Commit this plan, write the revised UI and timer specifications, and record their intended red state before production edits.

### 2026-11-20 — NR-020A Recording screen foundation

- **Work completed:** Safely inspected and preserved the owner-provided `recordScreen.zip`; adapted its close action, red status, large circular control, whitespace, and borders into native SwiftUI while honoring the newer no-prompt/no-timer requirement; connected a selected prompt to **Start Daily Rep**; added explicit permission, preparing, recording, denied, captured, and failure states; implemented real mono AAC `.m4a` capture with `AVAudioApplication`, `AVAudioSession`, and `AVAudioRecorder`; kept files temporary and deleted them on cancel or captured-route dismissal.
- **Tests added:** Ten `RecordingViewModel` permission/lifecycle/failure/idempotency tests and one assembled UI journey covering selection, start, distraction-free recording state, stop, captured state, and return to the picker. All were written and observed failing before production implementation and are now locked.
- **Verification:** Red—the relevant unit command exited 65 because the new recording boundary types did not exist. Green—36 unit and 3 UI tests pass with 0 failures on iPhone 17 Pro / iOS 26.2. App coverage is 79.44% (935/1177); test bundles report 99.28% and 100%. The built app contains the microphone purpose string, XcodeGen regeneration is byte-identical, and the native UI journey verifies the prompt screen and visible timer are absent during recording. GitHub Actions run [44763858902](https://github.com/khodosko/noRamble/actions/runs/44763858902) passed the complete suite in 6m48s. A separate manual computer-control visual pass could not attach to Simulator because that automation service timed out; no unverified screenshot review is claimed.
- **Decisions:** Split recording into NR-020A foundation and NR-020B timing/interruption policy. The later recording HTML is visual reference only: its prompt, visible timer, 60-second ready state, and stop-square behavior are intentionally excluded. The captured artifact stays in a UUID-named temporary file and is not uploaded, logged, or retained after leaving this seam.
- **Problems or blockers:** None for NR-020A. Timing, haptic warning/grace behavior, interruptions, route changes, and background transitions are deliberately deferred to NR-020B.
- **Immediate next action:** Plan NR-020B's timing and interruption behavior test-first.

### 2026-11-20 — NR-011 Prompt library and daily rotation

- **Work completed:** Researched official Toastmasters guidance and examples; replaced the three weak workplace prompts with 30 newly written prompts across story, opinion, reflection, imagination, decision, and connection themes; added deterministic local-day rotation; kept retired identifiers available only for same-day restoration; updated the visible ritual label to **Daily Rep** and accepted **Start Daily Rep** for the recording slice.
- **Tests added:** Catalog size, uniqueness, category breadth, and legacy separation; exactly-three rotation, same-day and cross-instance stability, next-day change, full ten-day catalog coverage, and pre-epoch behavior; same-day legacy-selection visibility.
- **Verification:** Red—unit command exited 65 because `DailyPromptRotation`, `DailyPromptCatalog.legacy`, and `DailyPromptCatalog.all` did not exist. Green—26 unit and 2 UI tests pass with 0 failures on iPhone 17 Pro / iOS 26.2. App coverage is 97.86% (503/514); session policy, view model, and app composition are 100%. Simulator visual review confirmed all three longer cards remain readable and scrollable without clipping. GitHub Actions run [44694752680](https://github.com/khodosko/noRamble/actions/runs/44694752680) passed the complete suite in 4m55s.
- **Decisions:** Prompt wording is original rather than copied from published question sets; the bundled library stays offline and non-browsable; stable FNV-1a ordering avoids process-randomized hashing; adding future unselected prompts may alter a day's set, but a persisted same-day choice remains visible.
- **Problems or blockers:** None. The owner explicitly replaced the fixed three-item catalog requirement. The invalid exact-catalog test was replaced with library-quality and rotation tests; two fixtures that named retired prompt IDs now select injected/visible prompts without weakening their save-failure or selection-lock assertions.
- **Immediate next action:** Plan NR-020's audio-recording boundary and its failing lifecycle tests.

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
