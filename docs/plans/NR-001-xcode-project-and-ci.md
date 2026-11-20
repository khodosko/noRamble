# NR-001: Xcode project and CI foundation

- **Status:** Complete
- **Task:** [NR-001 in TASKS.md](../../TASKS.md#nr-001--xcode-project-and-ci-foundation)
- **Pull request:** [#2 — Establish tested SwiftUI project foundation](https://github.com/khodosko/noRamble/pull/2)

## Goal

Create the smallest reproducible native iPhone project that launches, exposes unit and UI test targets, and runs the same complete automated suite locally and on every pull request.

## User value

This slice creates a trustworthy delivery loop. Future product behavior can be built in small test-first increments and verified before merge without mixing project setup with the first user feature.

## Scope

- Native SwiftUI application target and `NoRamble` module
- Committed Xcode project generated from a committed `project.yml`
- Minimal launch shell with stable accessibility identifiers
- Unit test target with a meaningful default shell-content test
- UI test target proving the app launches and exposes its initial accessible state
- Deterministic local relevant-test and complete-suite commands
- GitHub Actions workflow running the complete suite for pull requests to `main`
- Xcode `.gitignore`, setup documentation, task/progress/plan updates

## Non-goals

- Daily prompt options or selection
- Audio recording or permissions
- Speech analysis, feedback, retry comparison, persistence, notifications, or streak behavior
- Pixel-complete Stitch screen implementation
- Third-party application dependencies
- App Store signing, distribution, or release automation

## Existing-system observations

- NR-000 merged to `main` as pull request #1.
- No Swift sources, Xcode project, test target, CI workflow, or build command exists.
- Xcode 26.2 (`17C52`) is installed at `/Applications/Xcode.app` with iOS 26.2 Simulator and an iPhone 17 Pro device.
- The active system developer directory points at Command Line Tools, so commands must set `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`.
- Swift from Xcode will be authoritative; the standalone Command Line Tools report Swift 6.0.3.
- XcodeGen is not installed at slice start.
- GitHub's `macos-26` runner supports Xcode 26.2 and the iOS 26.2 simulator.

## Proposed design

Use iOS 17.0 as the provisional minimum deployment target. `project.yml` is the human-reviewable project definition and `NoRamble.xcodeproj` is committed so the project opens immediately in Xcode. XcodeGen is a development-time generator only; the application has no runtime dependencies.

The app shell owns no product flow. A small value type defines its initial title and readiness message, making the initial state directly unit-testable. `AppShellView` renders that state with accessibility identifiers. The UI test launches the assembled application and asserts that both elements are visible.

The shared `NoRamble` scheme gathers coverage and runs both test targets. CI uses the same `xcodebuild test` command as local verification, pinned to Xcode 26.2 and iPhone 17 Pro on iOS 26.2.

## Expected files or components

- `project.yml`
- `NoRamble.xcodeproj/`
- `NoRamble/App/NoRambleApp.swift`
- `NoRamble/AppShell/AppShellContent.swift`
- `NoRamble/AppShell/AppShellView.swift`
- `NoRambleTests/AppShellContentTests.swift`
- `NoRambleUITests/AppLaunchUITests.swift`
- `.github/workflows/ios-ci.yml`
- `.gitignore`
- `README.md`, `TASKS.md`, `PROGRESS.md`, `docs/TESTING.md`, this plan

## Acceptance criteria

- [x] `NoRamble.xcodeproj` opens with application, unit-test, and UI-test targets and a shared `NoRamble` scheme.
- [x] The internal product/module name is `NoRamble`; the displayed name is `No Ramble`.
- [x] The app builds and launches on an iPhone simulator without signing or compiler warnings.
- [x] The launch shell visibly and accessibly identifies the app and its scaffold-ready state.
- [x] A unit test verifies the default shell content.
- [x] A UI test launches the app and verifies the initial accessible elements.
- [x] The relevant unit-test command passes.
- [x] The complete unit/UI suite passes with coverage enabled.
- [x] Pull requests to `main` run the complete suite on GitHub Actions.
- [x] Local setup and exact verification commands are documented.
- [x] No product behavior beyond launch scaffolding is introduced.

## Tests written before implementation

- `AppShellContentTests.defaultContent_identifiesNoRambleAndFoundationReadiness`: initially fails to compile because `AppShellContent` does not exist.
- `AppLaunchUITests.testLaunch_displaysAccessibleAppShell`: initially fails because the application target/shell is absent, then proves the assembled app launches and exposes `app-shell-title` and `app-shell-status`.

The tests are locked after their expected initial failure is observed. Production code must change to satisfy them.

## Failure and edge cases

- Missing Xcode selection: repository commands set `DEVELOPER_DIR` explicitly.
- Missing simulator/runtime: verification reports the exact absent destination rather than silently selecting another platform.
- Project spec and generated project drift: regenerate before verification and review the generated diff.
- UI test launch races: use XCTest existence expectations, never arbitrary sleeps.
- Signing configuration: simulator builds disable signing in command-line verification; distribution signing is out of scope.
- CI runner image changes: pin the runner/Xcode/runtime used by the documented command and update deliberately in a later slice.

## Privacy and security

The shell collects, stores, and transmits no user data. CI receives read-only repository permission, contains no secrets, and runs only committed source/tests. No signing credentials or developer-local configuration enter Git.

## Accessibility

The shell supports Dynamic Type, semantic heading text, sufficient contrast, and stable accessibility identifiers. The UI test verifies accessible discovery of the initial title/status. Broader VoiceOver and layout coverage belongs with real feature UI.

## Implementation steps

1. Add `project.yml` and the unit/UI tests before production Swift sources.
2. Generate the project and run tests, recording the expected failure caused by missing production types/application shell.
3. Add the smallest SwiftUI application and shell content/view that satisfies the tests.
4. Run the relevant unit test, then the complete unit/UI suite with coverage.
5. Add CI using the same pinned complete-suite command.
6. Regenerate the project, verify no drift/warnings, and update documentation/evidence.
7. Push the focused branch, open the pull request, observe CI, and merge only when green.

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

- **Scaffold tests become meaningless:** Assert observable default content and assembled launch accessibility, not implementation details.
- **Generated project obscures changes:** Keep `project.yml` authoritative and commit both spec and generated project.
- **CI differs from local verification:** Pin the same Xcode, simulator OS/device, scheme, and command arguments.
- **Foundation grows into a feature:** Reject prompt, recording, analysis, and streak behavior from this slice.

## Rollback strategy

Revert the focused NR-001 merge. No user data or migrations exist. Removing the generated project, sources, tests, and workflow returns the repository to the documentation-only foundation.

## Documentation updates

- `README.md`: Xcode opening, generation, local test commands, current status
- `TASKS.md`: NR-000 complete and NR-001 state/evidence
- `PROGRESS.md`: red/green commands and results
- `docs/TESTING.md`: exact relevant/full/CI commands
- This plan: completion evidence and pull-request link

## Completion evidence

- **Acceptance criteria:** 11 of 11 satisfied.
- **Red test evidence:** Unit command exited 65: `Unable to find module dependency: 'NoRamble'` before production sources existed.
- **Relevant tests:** Passed, exit 0, on iPhone 17 Pro / iOS 26.2.
- **Complete suite:** Passed with coverage, exit 0: 2 passed, 0 failed, 0 skipped; testable app code 100% (48/48).
- **Warnings:** None; warnings are treated as errors.
- **Project/visual checks:** Regeneration produced an identical project hash; three targets and the shared scheme are discoverable; simulator launch screenshot reviewed successfully.
- **CI:** Passed twice on GitHub Actions using Xcode 26.2 and iPhone 17 Pro / iOS 26.2; the documentation-evidence run completed in 6m 56s.
- **Pull request:** [#2](https://github.com/khodosko/noRamble/pull/2) merged on 2026-11-19.
