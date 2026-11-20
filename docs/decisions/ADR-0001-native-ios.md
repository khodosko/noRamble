# ADR-0001: Begin with a native iPhone application

- **Date:** 2026-11-19
- **Status:** Accepted
- **Related slice:** [NR-000](../plans/NR-000-project-foundation.md)
- **Pull request:** [#1](https://github.com/khodosko/noRamble/pull/1)

## Context

No Ramble depends on a low-friction daily iPhone ritual, reliable audio recording, notifications, accessibility, and potentially Apple speech capabilities. The team needs a focused initial platform with direct access to these APIs and a strong automated-testing story.

## Decision

Begin with a native iPhone application written in Swift and SwiftUI, using Apple-native frameworks where practical. The internal target/module name is `NoRamble`; the displayed product name is **No Ramble**.

## Benefits

- Direct integration with recording, notifications, lifecycle, accessibility, and privacy controls
- Platform-consistent UI and performance
- Strong Swift type system and first-party testing/tooling
- Fewer cross-platform abstraction constraints while validating the product

## Costs and consequences

- Initial availability is limited to iPhone.
- Swift/SwiftUI and Xcode expertise are required.
- Android or web clients would require separate work and possibly shared service contracts later.
- Apple framework limitations may influence analysis and background behavior.

## Alternatives considered

- **Cross-platform mobile framework:** Broader eventual reach, but adds framework/runtime boundaries before product value is validated and may complicate audio/platform integration.
- **Web application:** Faster universal access, but weaker fit for the desired notification, recording, and native daily ritual.
- **Backend-first service:** Could standardize analysis, but would postpone validating the user experience and create premature privacy/infrastructure commitments.

## Conditions for revisiting

Revisit if validated demand requires another platform, native delivery prevents sustainable development, key analysis capabilities require a shared client architecture, or product evidence shows the daily ritual is better delivered outside an iPhone app. A new ADR must supersede this record rather than editing its history.
