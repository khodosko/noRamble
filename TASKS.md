# Task tracker

This file is the authoritative backlog. Do not maintain a competing task list elsewhere.

## Now

### NR-000 — Project foundation

- **Status:** In review
- **Plan:** [NR-000 project foundation](docs/plans/NR-000-project-foundation.md)
- **Acceptance criteria:** Repository and branch initialized; required documentation exists and is internally consistent; the public GitHub repository is verified and connected; the Stitch visual reference is preserved and its behavior differences are explicitly resolved; no application or Xcode project is created.
- **Test status:** Documentation/design-reference slice; archive integrity, safe paths, expected files, HTML rendering, links, and prohibited application-artifact checks verified; no executable application tests apply.
- **Pull request:** [#1 — Establish No Ramble project foundation](https://github.com/khodosko/noRamble/pull/1)

## Next

### NR-001 — Xcode project and CI foundation

- **Status:** Proposed; do not begin before NR-000 review
- **Plan:** To be created at `docs/plans/NR-001-xcode-project-and-ci.md`
- **Acceptance criteria:** Minimal native iPhone project with `NoRamble` module, unit and UI test targets, deterministic CI on pull requests, and no product behavior beyond launchable scaffolding.
- **Test status:** Not started; test-target smoke tests must be written before scaffold behavior is finalized.
- **Pull request:** Not available.

## Later

### NR-010 — Daily prompt domain

- **Status:** Backlog
- **Plan:** Pending
- **Acceptance criteria:** Exactly three curated daily options, one persisted selection per daily session, retry consistency, and daily rollover behavior are specified and covered by unit tests.
- **Test status:** Not started.
- **Pull request:** Not available.

### NR-020 — Audio recording boundary

- **Status:** Backlog
- **Plan:** Pending
- **Acceptance criteria:** Permission, minimal recording-state presentation, two-minute soft-ceiling behavior, lifecycle, interruption, and failure handling are specified behind a testable abstraction.
- **Test status:** Not started.
- **Pull request:** Not available.

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

- None.
