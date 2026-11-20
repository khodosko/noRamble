# Engineering standards

## Test-driven development

Every production behavior begins with observable acceptance criteria and a failing automated test. Confirm that the test fails for the intended reason, make the smallest production change that passes it, refactor while green, run relevant tests after meaningful changes, and run the complete suite before completion.

An accepted test is a locked executable specification. A valid failing test requires a production-code fix. Never delete, skip, weaken, or rewrite a test just to obtain a green suite. An existing test may change only when a requirement intentionally changes, the test is proven invalid or flaky, or an external contract changes. The slice plan and pull request must record the evidence, reason, and behavioral impact before the test changes.

No production behavior may be added without meaningful automated coverage. A successful build is not test evidence.

## Testing expectations

- Unit-test business rules, state transitions, transformations, errors, and boundary decisions.
- Integration-test persistence and adapters at their real seams.
- UI-test the most important user journeys without duplicating all unit coverage.
- Inject clocks, calendars, notification schedulers, recorders, transcription/analysis clients, persistence stores, identifiers, and network clients.
- Cover failure and cancellation paths, not just successful input.
- Target complete coverage of testable production logic. Document justified exceptions in the slice plan and pull request.
- Do not use arbitrary sleeps, live services, wall-clock assumptions, or order-dependent state.

Detailed rules live in [TESTING.md](TESTING.md).

## Code review

Pull requests must be focused, explain user value and design, link the slice plan, identify risks and privacy effects, and include exact test evidence. Reviewers should assess behavior, tests, failure handling, accessibility, privacy, architecture boundaries, and documentation together. All checks must pass before merge.

## Swift and SwiftUI design

- Prefer small, explicit types and value semantics.
- Model domain states so invalid combinations are hard to represent.
- Keep view bodies declarative and move behavior into testable models or use cases.
- Use protocols at meaningful platform or infrastructure seams, not around every type.
- Prefer dependency injection over service locators and global mutable state.
- Keep public APIs minimal and name types by domain responsibility.
- Treat compiler warnings as problems to resolve or explicitly explain.

## Dependency boundaries

- **UI:** Renders state, gathers intent, and owns accessibility presentation.
- **Business logic:** Defines prompts, sessions, attempts, feedback, scoring, and retry comparison without importing UI or concrete platform services.
- **Infrastructure:** Implements persistence, analytics, and any remote clients behind domain-facing interfaces.
- **Platform integrations:** Isolate audio recording, speech services, notifications, and lifecycle APIs behind adapters.

Dependencies point inward toward stable domain concepts. Concrete adapters must not leak framework-specific types into business logic.

## Error handling

- Represent expected failures explicitly and preserve useful causes.
- Give the UI actionable, non-technical recovery states.
- Never silently discard recording, persistence, consent, or analysis failures.
- Avoid logging sensitive audio, transcripts, tokens, or personal feedback.
- Test every meaningful error mapping and retry/cancellation rule.

## Concurrency and state management

- Make actor and thread ownership explicit.
- Keep UI-observable state isolated to the main actor.
- Prefer structured concurrency; propagate cancellation and avoid unscoped tasks.
- Protect session and persistence invariants from overlapping operations.
- Make async tests deterministic through controlled dependencies rather than timing.

## Accessibility

- Support VoiceOver labels, hints, traits, and a logical focus order.
- Support Dynamic Type without clipping essential information.
- Do not encode status or score using color alone.
- Provide accessible recording-state and progress announcements.
- Respect reduced motion and adequate contrast.
- Include accessibility acceptance criteria and suitable automated/manual evidence in each UI slice.

## Privacy and security

- Minimize collection and retention of recordings, transcripts, and analysis data.
- Prefer on-device processing where it meets product quality.
- Require clear disclosure and consent before remote processing.
- Define deletion and retention behavior before persisting sensitive content.
- Use platform-protected storage where appropriate and transport encryption for remote boundaries.
- Never put secrets or user data in source control, fixtures, analytics, logs, screenshots, or crash metadata.

## Definition of done

A slice is done only when its plan is current, acceptance criteria are met, tests were written first and are meaningful, relevant and complete suites pass, warnings and failures are resolved, documentation/task/progress records are current, durable decisions are recorded, the focused pull request contains verification evidence, and CI passes.
