# Product specification

## Target user

An iPhone user who wants to sound clearer and more concise in everyday or professional conversation, but lacks the motivation to browse courses, exercises, or a broad speaking toolbox.

## User problem

Speaking improvement requires repeated practice and useful feedback, yet existing approaches often impose too much choice, preparation, or commitment. Users need a small next action and feedback they can apply immediately.

## Product thesis

A guided daily speaking ritual with three curated choices, one selected prompt, and one prioritized improvement will create more consistent practice than an open-ended collection of coaching tools.

Core promise: **One chosen prompt. One recording. One improvement. Every day.**

## Core daily loop

1. A notification opens today's three prompt choices.
2. The user selects one prompt for the daily session. The limited choice prevents a blank-mind blocker without becoming a content browser.
3. The app presents a minimal recording state: a prominent red recording indicator and microphone treatment, with no visible timer, live transcript, coaching, metrics, or analysis.
4. The user records naturally. Two minutes is the soft ceiling; the app must not cut speech off abruptly at exactly `2:00`.
5. After recording ends, the app analyzes the attempt.
6. The app shows an overall score, focused feedback, a few observations, and one primary improvement.
7. The user retries the same selected prompt or finishes.
8. A retry produces a comparison that highlights improvement.
9. The session closes with a clear invitation to return tomorrow and updates the streak.

## Product principles

- Direct the next action; offer only three curated prompt choices rather than a browsable content library.
- Keep a daily session short and finishable.
- Prefer one actionable improvement over an exhaustive critique.
- Explain scores and feedback in language the user can apply.
- Celebrate progress without turning practice into social performance.
- Collect and retain the least sensitive audio and transcript data practical.
- Make accessibility part of the core experience, not a later layer.

## MVP scope

- Three curated daily prompt choices, one selected prompt per daily session, and notification deep linking
- Minimal audio-recording screen with a prominent red recording/microphone state, a two-minute soft ceiling, and permission/error handling
- Analysis of filler words, pace, pauses/hesitation, conciseness, and structure
- Overall score, concise observations, and one prioritized improvement
- Retry of the same prompt with attempt comparison
- Post-recording analysis only; no live transcript or coaching during capture
- Daily completion, minimal session history, and streak state without XP
- Local persistence for essential state
- Clear privacy controls and disclosure for any remote analysis

## Explicit non-goals

- Large prompt or content library
- Social feed or public profiles
- AI avatar
- Course catalog
- Coaching marketplace
- Complex navigation or an open-ended analytics dashboard
- Live transcription, coaching, metrics, or feedback while recording
- XP, points, or a second gamification currency beyond streaks
- Android, web, or iPad-specific experiences in the initial product

## Activation event

A new user completes a first recording and views their first actionable improvement.

## Retention hypothesis

Users will return when the ritual takes only a few minutes, the app removes choice, and each session produces feedback that is specific enough to use on an immediate retry.

## Monetization hypothesis

Validate repeated value before choosing a model. A possible direction is a subscription that preserves a useful free daily experience and adds deeper history or analysis. No paywall design is accepted yet.

## Initial success metric

Reach **100 real users** who complete at least one session, then evaluate activation, repeat sessions, qualitative usefulness, and privacy trust before optimizing growth.

## Open product questions

- Which prompt categories produce repeat practice without requiring a content library?
- What analysis can run on-device with acceptable quality and latency?
- When is cloud processing justified, and what explicit consent and deletion controls are required?
- How should the overall score be calibrated and explained?
- What is the minimum history that helps users see progress without adding navigation complexity?
- What reminder timing and customization support a ritual without becoming intrusive?
- What evidence threshold should define a meaningful improvement between retries?
- What free experience is sufficient to establish value before monetization?
- What warning, grace period, or gentle stop behavior should occur after the two-minute soft ceiling without cutting the user off mid-thought?
