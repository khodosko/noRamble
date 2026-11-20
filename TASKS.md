# Task tracker

This file is the authoritative backlog. Do not maintain a competing task list elsewhere.

## Now

- NR-011 — Prompt library and daily rotation

### NR-011 — Prompt library and daily rotation

- **Status:** In progress
- **Plan:** [NR-011 prompt library and daily rotation](docs/plans/NR-011-prompt-library-and-rotation.md)
- **Acceptance criteria:** A broad original Table Topics–style library deterministically rotates exactly three choices per local day, preserves existing same-day selections, and keeps the three-card accessible UI contract.
- **Test status:** Test changes and new red specifications pending.
- **Pull request:** Not available.

## Next

### NR-020 — Audio recording boundary

- **Status:** Backlog
- **Plan:** Pending
- **Acceptance criteria:** Permission, minimal recording-state presentation, two-minute soft-ceiling behavior, lifecycle, interruption, and failure handling are specified behind a testable abstraction.
- **Test status:** Not started.
- **Pull request:** Not available.

## Later

### NR-030 — Speech-analysis boundary

- **Status:** Backlog
- **Plan:** Pending
- **Acceptance criteria:** Post-recording-only analysis contract, privacy boundary, deterministic fixtures, and error behavior are defined and tested; no analysis is exposed during capture.
- **Test status:** Not started.
- **Pull request:** Not available.

### NR-040 — Feedback and scoring

- **Status:** Backlog
- **Plan:** Pending
- **Acceptance criteria:** Explainable scoring and improvement-selection rules are specified and tested against representative inputs and edge cases.
- **Test status:** Not started.
- **Pull request:** Not available.

### NR-050 — Retry comparison

- **Status:** Backlog
- **Plan:** Pending
- **Acceptance criteria:** Comparable attempts produce stable, useful improvement summaries with tested handling of incomplete or incomparable data.
- **Test status:** Not started.
- **Pull request:** Not available.

## Blocked

- None.

## Completed

### NR-010 — Daily prompt domain

- **Status:** Complete
- **Plan:** [NR-010 daily prompt domain](docs/plans/NR-010-daily-prompt-domain.md)
- **Acceptance criteria:** Exactly three curated daily options, one persisted selection per local day, retry consistency, daily rollover behavior, accessible presentation, and failure handling are covered by unit, persistence, and UI tests.
- **Test status:** Red state recorded (missing `DailyPromptCatalog`, exit 65); 19 unit and 2 UI tests pass locally with 98.16% app coverage and 100% coverage of session policy, application state, and concrete persistence.
- **Pull request:** [#3 — Add tested daily prompt selection](https://github.com/khodosko/noRamble/pull/3) — merged 2026-11-19.

### NR-001 — Xcode project and CI foundation

- **Status:** Complete
- **Plan:** [NR-001 Xcode project and CI foundation](docs/plans/NR-001-xcode-project-and-ci.md)
- **Acceptance criteria:** Minimal native iPhone project with `NoRamble` module, unit and UI test targets, deterministic CI on pull requests, and no product behavior beyond launchable scaffolding.
- **Test status:** Red state recorded (missing `NoRamble` module, exit 65); relevant unit test and complete two-test unit/UI suite pass locally with 100% testable app-code coverage; GitHub Actions passes.
- **Pull request:** [#2 — Establish tested SwiftUI project foundation](https://github.com/khodosko/noRamble/pull/2) — merged 2026-11-19.

### NR-000 — Project foundation

- **Status:** Complete
- **Plan:** [NR-000 project foundation](docs/plans/NR-000-project-foundation.md)
- **Acceptance criteria:** Repository and documentation foundation established; public GitHub repository connected; Stitch visual reference preserved and behavior differences resolved; no application or Xcode project created.
- **Test status:** Documentation/design-reference verification passed; no executable application tests applied.
- **Pull request:** [#1 — Establish No Ramble project foundation](https://github.com/khodosko/noRamble/pull/1) — merged 2026-11-19.
