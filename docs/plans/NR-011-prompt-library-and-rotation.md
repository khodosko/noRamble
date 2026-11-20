# NR-011: Prompt library and daily rotation

- **Status:** Complete and merged 2026-11-20
- **Task:** [NR-011 in TASKS.md](../../TASKS.md#nr-011--prompt-library-and-daily-rotation)
- **Pull request:** [#4 — Rotate a better daily prompt library](https://github.com/khodosko/noRamble/pull/4)

## Goal

Replace the weak three-item starter catalog with an original, engaging Table Topics–style prompt library and deterministically rotate exactly three choices per local day without breaking the selected-prompt invariant.

## User value

The daily choices should make someone want to speak. A broader mix of stories, opinions, decisions, imagination, and personal reflection keeps the ritual fresh while the user still sees only three choices at a time.

## Scope

- Research the official Toastmasters Table Topics format and representative themes
- Write at least 30 original prompts across at least five meaningful categories
- Keep the prompt library bundled and offline; do not create a browsable library UI
- Deterministically select exactly three distinct prompts for an injected local day
- Keep the same three prompts stable throughout that local day and rotate on the next day
- Exercise every bundled prompt during a bounded rotation cycle
- Restore a same-day selection even when it came from the retired NR-010 starter catalog
- Adopt **Start Daily Rep** as the accepted label for the recording action in NR-020
- Preserve selection persistence, accessibility, and the current three-card UI contract

## Non-goals

- Audio recording, microphone permission, navigation to a recording screen, or a button with no functional destination
- Downloading, scraping, or remotely updating prompts at runtime
- Copying or presenting an official Toastmasters question collection
- Claiming affiliation with or endorsement by Toastmasters International
- User browsing, filtering, favoriting, editing, or choosing prompt categories
- Localization or content-management tooling

## Existing-system observations

- NR-010 exposes `DailyPromptCatalog.curated` as exactly three fixed prompts and passes that same array to selection policy and UI state.
- A same-day selected identifier is stored in `UserDefaults` and must remain restorable after an app update.
- The UI and locked UI test require exactly three accessible prompt buttons.
- Official Toastmasters guidance defines Table Topics as quick organization around an impromptu question with a clear, succinct one-to-two-minute response.
- Official magazine examples cover personal stories, opinions, relationships, values, imagination, and reflection rather than only workplace status updates.
- The product remains a directed ritual, so a larger internal library must not become a content browser.

Research references:

- [Toastmasters — Table Topics Speaker](https://toastmasters.org/membership/club-meeting-roles/table-topics-speaker)
- [Toastmasters Magazine — Table Topics Workout](https://www.toastmasters.org/magazine/articles/table-topics-workout)
- [Toastmasters Magazine — Get to Know Your Members Through Table Topics](https://www.toastmasters.org/magazine/magazine-issues/2026/april/get-to-know-your-members-through-table-topics)
- [Toastmasters Magazine — Table Topics](https://www.toastmasters.org/magazine/magazine-issues/2026/may/table-topics)

## Proposed design

`DailyPromptCatalog.curated` becomes a bundled library of at least 30 original prompts. The three NR-010 items move to a separate legacy collection used only to restore already-persisted same-day choices; they never enter future rotation.

`DailyPromptRotation` creates a stable, platform-independent ordering using a fixed FNV-1a hash of prompt identifiers. It divides that ordering into cyclic groups of three based on the injected calendar’s local-day distance from a fixed epoch. This yields exactly three stable daily options, changes the set on consecutive days, and surfaces the complete library within a bounded cycle without Swift’s randomized `Hasher` or wall-clock dependencies.

`DailyPromptSession` receives the combined current plus legacy catalog for identifier validation/restoration. `DailyPromptViewModel` receives the rotation separately, recalculates options on load/appearance, and normally exposes only today’s three. If a saved same-day legacy selection is restored, it is inserted into the visible set while retaining exactly three cards, so the lock remains understandable until rollover.

The library is inspired by the impromptu-speaking structure and theme breadth documented by Toastmasters, but every shipped prompt and coaching line is newly written for No Ramble.

## Expected files or components

- `NoRamble/DailyPrompt/Domain/DailyPrompt.swift`
- `NoRamble/DailyPrompt/Domain/DailyPromptRotation.swift`
- `NoRamble/DailyPrompt/Application/DailyPromptViewModel.swift`
- `NoRamble/App/NoRambleApp.swift`
- `NoRambleTests/DailyPrompt/DailyPromptCatalogTests.swift`
- `NoRambleTests/DailyPrompt/DailyPromptRotationTests.swift`
- `NoRambleTests/DailyPrompt/DailyPromptViewModelTests.swift`
- `NoRamble.xcodeproj` regenerated from `project.yml`
- `PRODUCT.md`, `README.md`, `TASKS.md`, `PROGRESS.md`, `docs/architecture/SYSTEM_DESIGN.md`, this plan

## Acceptance criteria

- [x] The current library contains at least 30 original, distinct, nonempty prompts across at least five categories.
- [x] The three disliked NR-010 starter prompts are excluded from future rotation.
- [x] Any injected local day produces exactly three distinct library prompts.
- [x] Different instants in the same injected local day produce the same ordered options.
- [x] Consecutive local days produce a different option set.
- [x] Every current prompt appears within one bounded rotation cycle.
- [x] Rotation is stable across independent instances and does not use Swift’s randomized `Hasher`.
- [x] A same-day selection is restored and remains visible even if it belongs to the retired catalog.
- [x] The assembled app and UI test still expose exactly three accessible prompt cards.
- [x] Existing selection, persistence, launch, and error-handling behavior remains green.
- [x] Product documentation accepts **Start Daily Rep** as the next recording action label without adding a nonfunctional button.

## Tests written before implementation

- `DailyPromptCatalogTests.curatedLibrary_containsAtLeastThirtyDistinctOriginalPromptsAcrossCategories`
- `DailyPromptCatalogTests.legacyPrompts_areExcludedFromCuratedRotationLibrary`
- `DailyPromptRotationTests.options_forDay_containsExactlyThreeDistinctLibraryPrompts`
- `DailyPromptRotationTests.options_sameLocalDay_isStableAcrossTimesAndInstances`
- `DailyPromptRotationTests.options_consecutiveLocalDays_changeSet`
- `DailyPromptRotationTests.options_overCompleteCycle_surfaceEntireLibrary`
- `DailyPromptViewModelTests.loadSelection_legacySameDayChoice_preservesItWithinThreeVisibleOptions`
- Existing complete UI journey continues to assert exactly three prompt buttons.

### Intentional changes to accepted tests

The owner explicitly replaced NR-010’s fixed three-item content requirement with a larger rotating library on 2026-11-20. Therefore `DailyPromptCatalogTests.testCurated_containsExactlyThreeDistinctPrompts` is no longer a valid catalog assertion and will be replaced by library size, uniqueness, category breadth, and legacy-exclusion assertions. The UI test’s exactly-three-visible-options assertion remains unchanged.

Existing session and view-model fixtures may switch from the three-item `curated` array to the combined catalog or explicitly selected small fixtures where needed. Those are mechanical fixture updates required by the new catalog/rotation boundary; no selection, locking, persistence, failure, or rollover expectation will be deleted or weakened.

The accepted UI journey previously addressed the retired starter prompts by the fixed identifiers `work-update` and `priority-case`. Those identifiers are intentionally absent from future rotation, so the journey will mechanically select the first and second of the still-asserted three visible prompt buttons. Its behavioral contract remains unchanged: exactly three options appear, tapping one marks it selected, and the alternative becomes disabled. The view-model save-failure fixture likewise selects the first prompt exposed by its injected catalog instead of naming the retired `work-update` fixture; its error assertion is unchanged.

All new tests become locked after their intended red failures are observed.

## Failure and edge cases

- A library with fewer than three items is a programmer error and fails fast at construction.
- Rotation handles negative day distances with positive modulo arithmetic.
- Adding prompts later may change unselected daily options, but a persisted same-day selection is preserved in the visible set.
- A stored identifier missing from both current and legacy catalogs retains the existing unavailable-content recovery behavior.
- Travel semantics remain the injected current-calendar rule accepted in NR-010.

## Privacy and security

The prompt library is static app content. Rotation is entirely on-device and stores no new user data. No browsing history, prompt response, recording, transcript, identifier, network request, or analytics event is added. Research sources contain no runtime dependency.

## Accessibility

The UI continues to render three full-card buttons with Dynamic Type, scrolling, selected value/trait, labels, hints, and disabled alternatives. Longer prompt wording must remain concise enough for narrow iPhones and large text; the existing UI test protects count and selection state.

## Implementation steps

1. Record research and the requirement-driven test change on a focused branch.
2. Add rotation, library-quality, and legacy-restoration tests; update only the invalid catalog test and necessary fixtures; record red evidence.
3. Add the original prompt library and deterministic rotation policy.
4. Separate the session’s validation catalog from the view model’s three rotating options and preserve legacy selections.
5. Regenerate the project and run relevant unit tests.
6. Run the complete unit/UI suite with coverage and visually inspect at least two injected daily sets through deterministic test evidence.
7. Update task, product, architecture, research attribution, and completion evidence.
8. Push, open a focused pull request, require green hosted CI, and squash-merge.

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

- **Prompts feel generic again:** require category breadth and review the full library as product content, not filler test data.
- **Rotation changes unpredictably across launches:** use a documented stable hash and deterministic local-day index.
- **A catalog update breaks today’s choice:** validate sessions against current plus legacy entries and keep the restored selection visible.
- **Research creates an affiliation/copyright problem:** ship original wording, cite inspiration in engineering documentation, and make no endorsement claim.
- **This slice drifts into recording:** record the accepted label but leave functional navigation to NR-020.

## Rollback strategy

Revert the focused NR-011 merge. NR-010’s persisted selection schema does not change; the previous fixed catalog can read its own identifiers without migration.

## Documentation updates

- `PRODUCT.md`
- `README.md`
- `TASKS.md`
- `PROGRESS.md`
- `docs/architecture/SYSTEM_DESIGN.md`
- This plan

## Completion evidence

- Test-first red: the relevant unit command exited 65 because `DailyPromptRotation`, `DailyPromptCatalog.legacy`, and `DailyPromptCatalog.all` were intentionally absent.
- Relevant green: 26 unit tests passed with 0 failures on iPhone 17 Pro / iOS 26.2.
- Complete green: 26 unit and 2 UI tests passed with 0 failures under the shared scheme with coverage enabled.
- Coverage: 97.86% app coverage (503/514); `DailyPromptSession`, `DailyPromptViewModel`, and `NoRambleApp` are 100%. The rotation gaps are defensive construction/calendar/hash-collision branches; the SwiftUI gap is a non-rendered result-builder branch.
- Visual QA: simulator inspection confirmed the new copy renders as three readable, scrollable cards without clipping and displays **Daily Rep**.
- XcodeGen regeneration completed successfully and includes the new production and test sources.
- Pull request: [#4 — Rotate a better daily prompt library](https://github.com/khodosko/noRamble/pull/4).
- Hosted CI: GitHub Actions run [44694752680](https://github.com/khodosko/noRamble/actions/runs/44694752680) passed the complete unit/UI suite in 4m55s.
- Final hosted CI: GitHub Actions run [44695445826](https://github.com/khodosko/noRamble/actions/runs/44695445826) passed against the merge candidate in 6m32s.
- Squash merge: `196eb56c86fa979db07e57c84fd81686a0817cf3` on 2026-11-20.
