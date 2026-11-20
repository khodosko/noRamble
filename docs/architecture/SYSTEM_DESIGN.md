# Provisional system design

This document distinguishes **accepted**, **proposed**, and **open** decisions. Proposed boundaries guide planning but are not commitments until tested through a slice or recorded in an ADR.

## Decision status

### Accepted

- The first product is a native iPhone app using Swift and SwiftUI; see [ADR-0001](../decisions/ADR-0001-native-ios.md).
- The internal target/module name is `NoRamble`; the user-facing name is **No Ramble**.
- The app is a directed daily ritual, not an open-ended toolbox.
- The owner-provided Stitch export is the visual reference; its prototype behaviors remain provisional unless accepted by the product specification and a slice plan.
- Each day offers three curated prompts for one daily session; the user's selected prompt remains fixed for retries in that session.
- Recording uses a minimal red recording/microphone presentation, a two-minute soft ceiling without an abrupt `2:00` cutoff, and no visible timer, live transcript, coaching, or metrics.
- Analysis and feedback begin only after recording ends.
- Streaks are the MVP motivational mechanism; XP/points are excluded.
- Business behavior must be testable independently of SwiftUI and concrete Apple services.
- Recordings and transcripts are sensitive; collection, transport, and retention must be minimized.

### Proposed

Use dependency layers that point inward:

`SwiftUI feature UI → application use cases/state → domain models/rules ← infrastructure and platform adapters`

Concrete services implement domain-facing protocols and are composed at the application boundary. Feature slices should add only the abstractions they need.

### Open

- Deployment target and supported devices
- Observation/state-management approach beyond standard SwiftUI facilities
- Local persistence technology
- On-device versus remote speech analysis split
- Scoring calibration and versioning
- Analytics provider and consent model

## Application shell

**Proposed:** A small SwiftUI app shell owns dependency composition, lifecycle routing, notification deep links, and the current daily-session route. Navigation should reflect the directed loop rather than expose a feature catalog. UI state belongs on the main actor; business types should not import SwiftUI.

## Daily prompt domain

**Proposed:** A `DailyPrompt` identity and daily-option policy operate on injected calendar/time-zone values and a prompt source. The policy produces three curated options for a day, persists exactly one selection for the daily session, and keeps retries tied to that selection. It must explicitly handle day rollover, travel, missing/duplicate content, selection restoration, and notification deep links.

**Open:** Prompt sourcing, rotation, localization, content review, and how the three options remain meaningfully distinct.

## Recording abstraction

**Proposed:** A domain-facing recorder exposes permission state and a controlled lifecycle such as idle, preparing, recording, stopping, completed, cancelled, and failed. The AVFoundation implementation remains outside the domain. The recording UI reflects only the recording state with a prominent red indicator/microphone treatment and no visible timer. Interruptions, route changes, app backgrounding, file cleanup, and competing operations require explicit behavior.

**Open:** File format, the warning/grace/stop policy after the two-minute soft ceiling, whether visual metering is necessary for recording confidence, and whether audio is retained after analysis.

## Speech-analysis abstraction

**Proposed:** After recording completes, an analysis client accepts an attempt asset/reference plus locale and returns a versioned, domain-owned analysis result. No transcript, coaching, or analysis result is exposed during capture. The adapter may combine transcription and derived metrics, but platform/network response types do not cross the boundary. Cancellation, partial results, unsupported locale, malformed output, timeout, and service unavailability are modeled.

**Open:** Apple on-device capabilities, any cloud provider, upload/consent flow, offline behavior, and quality thresholds.

## Feedback and scoring

**Proposed:** Store raw/normalized measurements separately from presentation. A versioned scoring policy converts metrics into explainable dimensions and an overall score; a feedback policy selects a few observations and exactly one primary improvement. Results retain the policy version for future comparability.

**Open:** Weights, score scale, baselines, confidence thresholds, tone, and accommodation for language or accessibility needs.

## Retry comparison

**Proposed:** Compare attempts only when prompt and metric versions are compatible. Report understandable changes and prioritize the requested improvement, without implying significance below confidence/tolerance thresholds.

**Open:** Definition of meaningful change and treatment of a clearer but substantially shorter/longer retry.

## Session history and streaks

**Proposed:** A daily session aggregates three prompt options, the selected prompt, attempts, completion state, and local-day identity. History retains the minimum data needed for progress. Streak calculation is a pure policy over completed session dates with injected calendar/time zone. The MVP has no XP or points ledger.

**Open:** Grace periods, travel semantics, retention duration, and whether raw audio/transcripts are ever part of history.

## Notification scheduling

**Proposed:** A scheduler interface accepts desired reminder policy and emits observable scheduling outcomes. The Apple adapter owns authorization and `UNUserNotificationCenter`. Deep links carry stable daily-session intent rather than sensitive content.

**Open:** Default timing, rescheduling rules, customization, and authorization education.

## Local persistence

**Proposed:** Repositories expose domain models and atomic session operations. Schema/data-transfer types remain in infrastructure. Migrations, corrupt data, partial writes, and deletion are tested. Sensitive fields receive data-protection appropriate to their retention need.

**Open:** SwiftData, Core Data, or file-backed storage; sync is not part of the MVP unless later justified.

## Privacy boundaries

**Accepted:** Audio, transcripts, speech characteristics, and feedback are sensitive. No such data enters source control, analytics, ordinary logs, or test fixtures based on real users.

**Proposed:** Delete temporary audio as soon as its defined purpose is complete unless the user explicitly chooses retention. Show clear disclosure before data crosses the device. Make consent and deletion state part of testable application behavior.

## Potential cloud-analysis boundary

**Proposed only:** If on-device quality is insufficient, a remote gateway accepts authenticated, short-lived analysis requests, minimizes metadata, uses encrypted transport, applies explicit retention/deletion rules, and maps provider responses into the same analysis abstraction. Provider credentials must never ship as recoverable app secrets.

No cloud service or provider is selected.

## Analytics event boundary

**Proposed:** Domain/app code emits a small typed event vocabulary through an injected sink. Events measure funnel behavior without raw prompt responses, transcripts, recordings, or free-form feedback text. A no-op sink supports tests and privacy choices.

**Open:** Provider, consent, identifiers, retention, and the smallest event set needed for the 100-user validation.

## Dependency direction and testability

Domain and application code depend on protocols and value types they own. SwiftUI, AVFoundation, Speech, UserNotifications, persistence, analytics, and network clients are outer adapters. Tests replace these seams with controlled implementations and inject time, calendar, identifiers, and cancellation. UI tests cover only critical assembled journeys; rules remain unit-testable.
