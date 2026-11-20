# NR-021: Recording context refinement

- **Status:** In review
- **Task:** [NR-021 in TASKS.md](../../TASKS.md#nr-021--recording-context-refinement)
- **Pull request:** Pending

## Goal

Bring the implemented prompt-to-recording journey back into alignment with the owner-provided visual references: the selected prompt remains visible during capture, a small elapsed timer shows how long the current rep has been recording, and **Start Daily Rep** uses the large tactile green primary-action treatment.

## Requirement change and locked-test exception

On 2026-11-20, after reviewing NR-020A in Simulator, the owner explicitly replaced the earlier distraction-free rule that hid prompt text and elapsed time. The new accepted behavior is:

- keep the selected prompt visible on the recording screen so the speaker does not forget it;
- show elapsed recording time in small numerals;
- render **Start Daily Rep** as the large bright-green Duolingo-style action shown in the supplied prompt reference.

`RecordingFlowUITests.testSelectedPrompt_canStartStopAndFinishDailyRep` currently asserts that `recording-elapsed-time` does not exist. That assertion is now invalid because the requirement intentionally changed. This slice may replace that one negative assertion with positive prompt/timer assertions before production changes. No unrelated accepted test may be changed.

## Visual contract

Use the existing owner-provided references rather than inventing a new style:

- Primary green: `#58CC02`
- Pressed/depth green: `#46A302`
- White, heavy rounded label typography
- Full-width rounded control with a four-point tactile lower edge
- Recording prompt centered above the large red microphone control
- Elapsed timer below the control in small monospaced numerals

The timer is informational only. It does not introduce a cutoff, progress target, warning, or analysis. NR-020B still owns the two-minute soft ceiling and interruption policy.

## Scope

- Pass the selected `DailyPrompt` into the recording route
- Display the selected prompt title while recording
- Track the successful recording start instant through an injected clock
- Format and update nonnegative elapsed time as `m:ss`
- Restyle **Start Daily Rep** to the reference green/depth/rounded treatment
- Preserve permission, failure, capture, cleanup, and dismissal behavior
- Update product, architecture, design, task, and progress documentation

## Non-goals

- Two-minute soft-limit warnings, automatic stopping, haptics, interruptions, route changes, or background policy
- Live transcript, waveform, coaching, scoring, or metrics
- Changing prompt selection or recording persistence
- Copying web fonts or HTML/CSS into the native app

## Acceptance criteria

- [x] **Start Daily Rep** is a full-width, at least 60-point-high, heavy rounded white-on-`#58CC02` control with `#46A302` tactile depth.
- [x] Starting a rep carries the exact selected prompt into the recording route.
- [x] The active recording screen visibly and accessibly presents that prompt.
- [x] A small monospaced elapsed timer appears during recording and advances from the successful capture start instant.
- [x] Elapsed formatting clamps negative intervals to `0:00` and formats minute/second boundaries deterministically.
- [x] The timer remains informational and does not alter stop/cancel or the future two-minute policy.
- [x] Existing permission, failure, cleanup, prompt-persistence, and accessibility behavior remains green.
- [ ] Relevant and complete suites pass locally and in hosted CI.

## Test-first plan

1. Document the explicit requirement change and invalid locked assertion in this plan.
2. Update the existing assembled UI specification to require a large start action, the selected prompt, and the elapsed timer.
3. Add formatter/start-instant unit specifications.
4. Record the intended red failures before changing production code.
5. Implement the smallest native SwiftUI/application changes.
6. Run focused unit/UI tests, the complete suite with coverage, and deterministic project checks.

## Privacy and accessibility

The prompt and elapsed time are already local session data and are not logged, uploaded, or persisted by this change. The prompt remains a header-level accessible element; the elapsed timer exposes a stable label and identifier without announcing every one-second update. The primary action remains a semantic `Button` with a target larger than 44 points.

## Rollback strategy

Revert the focused NR-021 merge. Audio files, permission state, and prompt persistence require no migration.

## Completion evidence

- Red: focused unit command exited 65 because the elapsed formatter and recording-start state did not exist.
- Green: 37 unit and 3 UI tests pass on iPhone 17 Pro / iOS 26.2; app coverage is 81.22% (1055/1299).
- The assembled UI journey verifies the large start target, exact prompt continuity, small valid `m:ss` timer, stop, captured state, and return.
- XcodeGen regeneration produces a byte-identical `project.pbxproj`; `git diff --check` passes.
- Hosted CI and pull-request evidence remain before merge. A separate computer-control screenshot pass timed out attaching to Simulator; this is reported rather than treated as visual evidence.
