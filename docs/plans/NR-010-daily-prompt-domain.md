# NR-010: Daily prompt domain

- **Status:** In progress
- **Task:** [NR-010 in TASKS.md](../../TASKS.md#nr-010--daily-prompt-domain)
- **Pull request:** Pending

## Goal

Give the user exactly three curated daily speaking prompts, persist the first choice for the local day, keep retries tied to that prompt, and permit a new choice after local-day rollover.

## User value

The first real product behavior removes the blank-page problem without becoming a content browser. Once a prompt is chosen, the user cannot silently switch topics between attempts, so later retry comparisons remain meaningful.

## Scope

- A small domain model for a prompt, local-day identity, and saved daily selection
- Exactly three distinct curated starter prompts based on the accepted Stitch visual reference
- A testable selection policy with injected calendar/time-zone inputs
- Idempotent restoration of the selected prompt for same-day retries
- Rejection of a different same-day selection and of unknown prompt identifiers
- A `UserDefaults` adapter for the small, non-sensitive selection record
- A native SwiftUI prompt picker that shows and persists the locked daily choice
- Deterministic unit, persistence-integration, and critical UI-journey tests

## Non-goals

- Prompt rotation, networking, localization, content-management tooling, or notification deep links
- Recording, microphone permission, timers, analysis, feedback, retry comparison, completion, or streak behavior
- Persisting recordings, transcripts, attempts, or any sensitive speech data
- A final decision for broader session/history persistence

## Existing-system observations

- NR-001 provides a launchable SwiftUI shell, one locked unit test, one locked UI test, and green pull-request CI.
- The current shell has no product behavior or persistence.
- The accepted design reference shows three single-select prompt cards and supplies starter copy, but its 45/60-second labels conflict with the accepted two-minute soft-ceiling behavior and will not be carried forward.
- The system design requires injected calendar/time-zone behavior and keeps business logic independent of SwiftUI and concrete Apple services.

## Proposed design

`DailyPrompt` and `LocalDay` are small value types. `DailyPromptCatalog` owns the three starter choices. `DailyPromptSession` applies the selection invariant against a domain-owned `DailyPromptSelectionStore` protocol: a same-day selection is restored, selecting it again is idempotent, choosing a different prompt is rejected, and a different local day permits a new selection. Dates become `LocalDay` values using the injected `Calendar`, including its time zone, so tests never depend on the wall clock.

`UserDefaultsDailyPromptSelectionStore` encodes only the local-day components and stable prompt identifier. This is a scoped adapter for a tiny preference-like record and does not choose the storage technology for future attempts or history.

A main-actor observable view model composes the domain policy for SwiftUI. The picker exposes three accessible buttons, clearly marks the chosen card, disables alternatives after selection, and restores the choice on launch. A launch-only UI-test reset argument clears this one test record to keep UI tests deterministic.

## Expected files or components

- `NoRamble/DailyPrompt/` domain, application state, persistence adapter, and SwiftUI prompt UI
- `NoRamble/AppShell/AppShellView.swift`
- `NoRamble/App/NoRambleApp.swift`
- `NoRambleTests/DailyPrompt/`
- `NoRambleUITests/DailyPromptSelectionUITests.swift`
- `NoRamble.xcodeproj` regenerated from `project.yml`
- `README.md`, `TASKS.md`, `PROGRESS.md`, `docs/architecture/SYSTEM_DESIGN.md`, this plan

## Acceptance criteria

- [ ] The launch screen visibly presents exactly three curated prompt choices.
- [ ] The three prompts have distinct stable identifiers and meaningful title/guidance copy.
- [ ] Selecting a known prompt persists its identifier for the injected local day.
- [ ] Reloading or retrying on that local day restores the same prompt.
- [ ] Selecting the same prompt again is idempotent.
- [ ] Selecting a different prompt on the same local day is rejected without replacing the original.
- [ ] An unknown prompt identifier is rejected without persistence.
- [ ] On the next injected local day, no prompt is initially selected and a new choice can be persisted.
- [ ] Concrete local persistence round-trips a valid selection and reports corrupt data.
- [ ] The picker exposes an accessible heading, three buttons, selected state, and locked alternatives.
- [ ] Existing locked NR-001 tests remain unchanged and pass.

## Tests written before implementation

- `DailyPromptCatalogTests.curated_containsExactlyThreeDistinctPrompts`
- `DailyPromptSessionTests.select_knownPrompt_persistsAndRestoresForSameDayRetry`
- `DailyPromptSessionTests.select_samePromptAgain_isIdempotent`
- `DailyPromptSessionTests.select_differentPromptOnSameDay_keepsOriginalAndThrowsLocked`
- `DailyPromptSessionTests.select_unknownPrompt_doesNotPersistAndThrowsUnknownPrompt`
- `DailyPromptSessionTests.selection_onNextLocalDay_startsEmptyAndAllowsNewChoice`
- `DailyPromptSessionTests.localDay_usesInjectedCalendarTimeZone`
- `UserDefaultsDailyPromptSelectionStoreTests.savedSelection_roundTrips`
- `UserDefaultsDailyPromptSelectionStoreTests.corruptSelection_throwsWithoutInventingState`
- `DailyPromptViewModelTests.selection_updatesObservableStateAndLocksAlternatives`
- `DailyPromptSelectionUITests.selectingPrompt_marksItSelectedAndLocksOtherChoices`

These new tests become locked after their intended initial failure is recorded. Existing tests require no changes.

## Failure and edge cases

- Unknown prompt identifiers fail explicitly and do not write state.
- A different same-day choice returns a typed locked-selection error and preserves the original.
- A saved identifier missing from the current catalog returns a typed unavailable-prompt error rather than silently selecting something else.
- Corrupt persisted data is reported to the application model; the UI shows a non-technical recovery message without inventing a selection.
- Local-day calculation uses the injected calendar and time zone. Travel semantics beyond that deterministic rule remain open.

## Privacy and security

The adapter stores only a prompt identifier plus year/month/day. It stores no response, recording, transcript, account identifier, analytics, or secret and performs no network access. UI tests use synthetic prompt state only.

## Accessibility

The screen uses Dynamic Type styles and scrolls when content grows. Prompt cards are full-width buttons with stable accessibility identifiers, selected traits/values, useful labels and hints, and at least standard control height. Selection is conveyed by text/icon/VoiceOver state as well as color. Locked alternatives become disabled after selection.

## Implementation steps

1. Add the plan and mark NR-010 active on a focused feature branch.
2. Add all domain, persistence, view-model, and UI tests before production behavior; regenerate the project and record the intended red failure.
3. Add the smallest domain models and selection policy that satisfy relevant unit tests.
4. Add and test the concrete local store.
5. Add the observable application state and accessible SwiftUI picker that satisfy the UI journey without adding recording behavior.
6. Run relevant tests after each step, then the complete suite with coverage.
7. Update documentation/evidence, push, open the focused pull request, require green CI, and squash-merge.

## Verification commands

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodegen generate

DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild test \
  -project NoRamble.xcodeproj \
  -scheme NoRamble \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.2' \
  -only-testing:NoRambleTests \
  CODE_SIGNING_ALLOWED=NO

DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild test \
  -project NoRamble.xcodeproj \
  -scheme NoRamble \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.2' \
  -enableCodeCoverage YES \
  CODE_SIGNING_ALLOWED=NO
```

## Risks

- **A daily choice can be accidentally changed:** the domain rejects replacement and the UI locks alternatives after the first persisted choice.
- **Wall-clock tests become flaky:** all day calculations receive a date and calendar explicitly.
- **A tiny adapter becomes an accidental architecture commitment:** documentation limits `UserDefaults` to this preference-like record and leaves broader persistence open.
- **The slice drifts into recording:** the picker stops after selection; microphone behavior remains NR-020.

## Rollback strategy

Revert the focused NR-010 merge. The only stored state is one namespaced `UserDefaults` data value; older scaffold code ignores it, and the adapter provides a removal operation for deterministic recovery.

## Documentation updates

- `README.md`
- `TASKS.md`
- `PROGRESS.md`
- `docs/architecture/SYSTEM_DESIGN.md`
- This plan

## Completion evidence

Pending implementation, local verification, pull request, and CI.
