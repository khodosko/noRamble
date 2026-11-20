# Testing strategy

## Policy

Testing is the development method, not a final quality gate. For each behavior: write the test, observe the expected failure, implement the smallest change, keep the suite green while refactoring, then run all tests.

Once a test has been accepted, treat it as immutable executable specification. If it fails, fix production code. Do not loosen assertions, delete coverage, skip the test, or replace it with a different expectation to accommodate an implementation. A test change is exceptional and requires evidence that the requirement changed, the test is invalid/flaky, or an external contract changed; record this in the slice plan and pull request before editing the test.

## Test layers

### Unit tests

Default layer for prompt selection, session state, scoring, feedback prioritization, retry comparison, validation, error mapping, and persistence decisions. They must be fast, isolated, and deterministic.

### Integration tests

Exercise concrete boundaries such as local persistence, serialization, migrations, notification request construction, and analysis adapters. Use controlled stores and fixtures; never depend on a developer's personal data or a live production service.

### UI tests

Cover critical journeys: first activation, recording permission outcomes, recording/finishing, analysis success/failure, retry comparison, and daily completion. Keep business-rule permutations in unit tests rather than duplicating them through the UI.

## Test doubles and dependency injection

Inject meaningful sources of nondeterminism and side effects. Use focused fakes, spies, stubs, or in-memory implementations for clocks, calendars, time zones, identifiers, recorders, transcription/analysis clients, notification schedulers, analytics, persistence, and network transport. A test double should expose only behavior the consumer needs.

## Determinism requirements

- **Time:** Supply an instant, calendar, locale, and time zone; test day boundaries and clock changes explicitly.
- **Notifications:** Assert requested content, trigger, replacement, denial, and scheduling errors without relying on the system daemon.
- **Recording:** Drive permission, lifecycle, interruption, route change, cancellation, and file failures through a controllable recorder.
- **Transcription/analysis:** Use versioned fixtures for success, malformed responses, partial results, latency, cancellation, and service errors.
- **Network:** Stub transport at the request/response boundary. Do not call live services in unit or standard CI tests.
- Never use arbitrary sleeps. Coordinate on observable events or controlled clocks.

## Failure-path coverage

Every meaningful failure, cancellation, permission denial, empty or boundary input, unavailable dependency, and invalid state transition must have an assertion about observable behavior and recovery. Ensure sensitive data is not exposed in error descriptions or logs.

## Naming and organization

- Mirror production modules and features in test groups.
- Name tests by behavior and condition, for example: `finishingAttempt_withoutAudio_returnsRecordingMissing`.
- Keep arrange/act/assert phases readable.
- Prefer one behavioral reason to fail per test while allowing multiple assertions that describe the same outcome.
- Store reusable fixtures centrally and version external-contract fixtures.

## Running tests

Exact schemes, destinations, and commands are pending NR-001. The project must document:

- A fast relevant-test command for local iteration
- A complete-suite command matching CI
- Any required simulator runtime
- Coverage reporting and artifact locations

CI must build and run the automated suite on every pull request once the Xcode project exists.

## Coverage and exceptions

Target complete coverage of testable production logic. Coverage percentage is a diagnostic, not a reason to write meaningless tests. Generated code, operating-system entry points, or purely declarative wiring may be excluded only when the slice plan and pull request name the exact exception and explain why behavior cannot reasonably be exercised. Undocumented gaps are prohibited.

## Flaky tests

A flaky test is a defect. Preserve failure evidence, isolate the cause, and fix determinism promptly. Do not add retries, sleeps, broad tolerances, or permanent quarantine as a substitute. If temporary quarantine is unavoidable, create a tracked blocker with an owner and removal condition; do not claim the slice complete.
