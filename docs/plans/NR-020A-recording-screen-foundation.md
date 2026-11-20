# NR-020A: Recording screen foundation

- **Status:** In review
- **Task:** [NR-020A in TASKS.md](../../TASKS.md#nr-020a--recording-screen-foundation)
- **Pull request:** [#6 — Add tested recording screen foundation](https://github.com/khodosko/noRamble/pull/6)

## Goal

Deliver the first thin recording vertical slice: after choosing today's prompt, the user can tap **Start Daily Rep**, grant microphone permission, record real audio through a minimal full-screen native interface, stop or cancel, and reach a captured-recording seam for later analysis.

## User value

The prompt picker becomes a functional speaking exercise rather than a selection-only prototype. The recording state stays unmistakable and distraction-free while permission denial and capture failures have clear recovery paths.

## Slice boundary

This is intentionally the first half of the broader audio boundary. It includes permission, start, stop, cancel, failure mapping, temporary-file ownership, navigation, and the minimal recording screen. NR-020B will add the injected two-minute soft-limit scheduler, interruption/route/background behavior, and the final warning/grace policy before speech analysis begins.

## Scope

- Preserve the owner-provided `recordScreen.zip` HTML as a visual reference with provenance
- Show a functional **Start Daily Rep** action only after a prompt is selected
- Present a full-screen recording route and begin capture through a domain-facing service
- Request microphone permission with the iOS 17+ `AVAudioApplication` API
- Record AAC audio to an app-owned temporary `.m4a` file with `AVAudioRecorder`
- Stop capture into a typed artifact and show a small captured-state seam
- Cancel capture, delete its temporary file, deactivate the audio session, and return to the prompt screen
- Map denied permission, recorder startup failure, and stop failure into understandable states
- Provide deterministic unit tests with a fake recording service and a UI-test-only simulated service
- Add `NSMicrophoneUsageDescription`
- Preserve the current prompt selection and accessibility contracts

## Non-goals

- Speech transcription, analysis, scoring, feedback, retry comparison, history, upload, or cloud processing
- A visible timer, prompt text, transcript, waveform, metrics, or coaching while recording
- Automatic cutoff at 60 or 120 seconds
- Soft-limit scheduling, haptics, warning/grace behavior, audio interruptions, route changes, or background transitions; these remain NR-020B
- Keeping recordings after the in-memory captured route is dismissed
- Porting the HTML, Tailwind, Google Fonts, or Material Symbols into production

## Design reference and resolved conflicts

The owner supplied `/Users/daniil/workplace/recordScreen.zip` on 2026-11-20. It contains one safe, valid `code.html` export. The native screen carries forward its close action, centered red status, large tactile circular control, generous whitespace, two-point borders, and coral `#FF4B4B` recording color.

The prototype also renders the chosen prompt, a visible elapsed timer, a `60s` ready state, and a stop-square glyph. Those are not production requirements. The previously accepted product behavior is more recent and remains authoritative: while capture is active, show only an unmistakable red recording/microphone state with no prompt, visible timer, transcript, coaching, or metrics. The big red control uses a microphone symbol and stops when tapped.

## Apple platform evidence

- [`AVAudioApplication.requestRecordPermission`](https://developer.apple.com/documentation/avfaudio/avaudioapplication/requestrecordpermission%28completionhandler%3A%29) is the iOS 17+ permission API and requires a microphone purpose string.
- [`AVAudioRecorder`](https://developer.apple.com/documentation/avfaudio/avaudiorecorder) records input to a file after the audio session is configured for recording.
- [Handling audio interruptions](https://developer.apple.com/documentation/avfaudio/handling-audio-interruptions) requires explicit lifecycle handling; that work is reserved for NR-020B so it is not implied complete here.

## Proposed design

`AudioRecordingService` is a main-actor protocol owned by the feature. It exposes permission, request, start, stop, and cancel operations without leaking AVFoundation types. `AudioRecordingArtifact` identifies the temporary file returned after stop.

`SystemAudioRecordingService` adapts `AVAudioApplication`, `AVAudioSession`, and `AVAudioRecorder`. It creates one UUID-named temporary `.m4a`, uses mono AAC settings suitable for speech, refuses conflicting starts/stops, deletes on cancel, and deactivates the session after capture.

`RecordingViewModel` owns explicit preparing, recording, permission-denied, captured, and failed presentation states. `RecordingView` renders those states with native SwiftUI and no time-derived UI. The app shell presents it as a full-screen cover. A debug-only simulated service gives UI tests deterministic granted-permission capture without invoking the simulator microphone dialog.

## Expected files or components

- `design/reference/record_screen_2026-11-20/code.html`
- `docs/design/README.md`
- `NoRamble/Recording/Domain/AudioRecording.swift`
- `NoRamble/Recording/Application/RecordingViewModel.swift`
- `NoRamble/Recording/Infrastructure/SystemAudioRecordingService.swift`
- `NoRamble/Recording/UI/RecordingView.swift`
- `NoRamble/DailyPrompt/UI/DailyPromptPickerView.swift`
- `NoRamble/AppShell/AppShellView.swift`
- `NoRamble/App/NoRambleApp.swift`
- `NoRambleTests/Recording/RecordingViewModelTests.swift`
- `NoRambleUITests/RecordingFlowUITests.swift`
- `project.yml` and regenerated `NoRamble.xcodeproj`
- `PRODUCT.md`, `TASKS.md`, `PROGRESS.md`, and architecture/testing documents as required

## Acceptance criteria

- [x] A selected daily prompt reveals one **Start Daily Rep** action; no action appears before selection.
- [x] Starting with granted permission calls the recording service once and presents the active recording state.
- [x] Undetermined permission is requested once; a grant starts capture and a denial does not.
- [x] Already-denied permission presents recovery guidance without calling start.
- [x] The active screen shows a close action, red recording status, and one large microphone control with no prompt, visible timer, transcript, metric, or coaching content.
- [x] Tapping the large control stops once and presents a captured artifact state.
- [x] Closing while active cancels once, deletes the temporary recording through the service, and dismisses.
- [x] Startup and stop failures produce stable user-facing recovery states.
- [x] The system adapter records AAC to a unique temporary `.m4a`, deactivates the session after stop/cancel, and never logs audio paths or contents.
- [x] The app declares a clear microphone purpose string.
- [x] Existing prompt, persistence, launch, and accessibility tests remain green without weakening.
- [ ] Relevant and complete suites pass locally and in hosted CI; native simulator visual QA passes.

## Tests to write before implementation

- `RecordingViewModelTests.begin_grantedPermission_startsRecording`
- `RecordingViewModelTests.begin_undeterminedThenGranted_requestsAndStarts`
- `RecordingViewModelTests.begin_undeterminedThenDenied_doesNotStart`
- `RecordingViewModelTests.begin_deniedPermission_doesNotRequestOrStart`
- `RecordingViewModelTests.begin_startFailure_exposesFailureState`
- `RecordingViewModelTests.stop_activeRecording_returnsCapturedArtifact`
- `RecordingViewModelTests.stop_failure_exposesFailureState`
- `RecordingViewModelTests.cancel_activeRecording_cancelsAndRequestsDismissal`
- `RecordingViewModelTests.repeatedBeginAndStop_doNotDuplicateServiceCalls`
- `RecordingFlowUITests.selectedPrompt_canStartStopAndFinishDailyRep`

All new tests become locked after their intended red failures are observed. No accepted test is expected to change in this slice.

## Failure and edge cases

- Permission may be undetermined, denied, granted, or a future unknown value.
- Permission callbacks may return after the view is dismissed; cancellation must prevent a later start.
- `AVAudioSession` activation, recorder creation, preparation, recording start, and session deactivation can fail.
- Stop without an active recording and duplicate taps must not create duplicate artifacts or service calls.
- If stop fails, the service must still relinquish the audio session and remove an unusable file.
- The temporary directory may be unavailable or unwritable.

## Privacy and security

Microphone access begins only after the explicit **Start Daily Rep** action and system permission. Audio remains in a UUID-named temporary local file, is never logged or uploaded, and is deleted on cancel or when the captured route is dismissed. No transcript, analytics event, account identifier, or network request is added.

## Accessibility

The recording screen uses semantic native controls, at least 44-point targets, Dynamic Type, sufficient coral/foreground contrast, a clear `Recording` status, and VoiceOver labels/hints for close, stop, retry, and done. Motion is decorative and omitted when Reduce Motion is enabled. No meaning depends only on animation.

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

## Rollback strategy

Revert the focused NR-020A merge. Prompt persistence is unchanged. Temporary recordings from an interrupted run remain only in the operating system temporary directory and are eligible for system cleanup; no persistent schema or remote data requires migration.

## Completion evidence

- Red: focused unit build exited 65 because the recording boundary and model did not exist.
- Green: 36 unit and 3 UI tests pass on iPhone 17 Pro / iOS 26.2; app coverage is 79.44% (935/1177).
- The assembled recording UI test verifies selection-to-capture-to-dismiss and asserts that neither a visible elapsed-time element nor the underlying prompt screen is exposed during capture.
- The built `Info.plist` contains the expected `NSMicrophoneUsageDescription` value.
- XcodeGen regeneration produces a byte-identical `project.pbxproj`; `git diff --check` passes.
- Hosted CI, pull-request evidence, and the final simulator visual check remain before merge. A separate computer-control attempt could not attach to Simulator because its service timed out; this is reported rather than treated as passed.
