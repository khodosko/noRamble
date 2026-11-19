# Product specification

## Target user

An iPhone user who wants to sound clearer and more concise in everyday or professional conversation, but lacks the motivation to browse courses, exercises, or a broad speaking toolbox.

## User problem

Speaking improvement requires repeated practice and useful feedback, yet existing approaches often impose too much choice, preparation, or commitment. Users need a small next action and feedback they can apply immediately.

## Product thesis

A guided daily speaking ritual with one prompt and one prioritized improvement will create more consistent practice than an open-ended collection of coaching tools.

Core promise: **One prompt. One recording. One improvement. Every day.**

## Core daily loop

1. A notification opens directly to today's prompt.
2. The user records a response; one to two minutes is recommended, not enforced.
3. The app analyzes the attempt.
4. The app shows an overall score, focused feedback, a few observations, and one primary improvement.
5. The user retries the same prompt or finishes.
6. A retry produces a comparison that highlights improvement.
7. The session closes with a clear invitation to return tomorrow.

## Product principles

- Direct the next action; do not make the user browse for it.
- Keep a daily session short and finishable.
- Prefer one actionable improvement over an exhaustive critique.
- Explain scores and feedback in language the user can apply.
- Celebrate progress without turning practice into social performance.
- Collect and retain the least sensitive audio and transcript data practical.
- Make accessibility part of the core experience, not a later layer.

## MVP scope

- Daily prompt selection and notification deep link
- Audio recording and permission/error handling
- Analysis of filler words, pace, pauses/hesitation, conciseness, and structure
- Overall score, concise observations, and one prioritized improvement
- Retry of the same prompt with attempt comparison
- Daily completion, minimal session history, and streak state
- Local persistence for essential state
- Clear privacy controls and disclosure for any remote analysis

## Explicit non-goals

- Large prompt or content library
- Social feed or public profiles
- AI avatar
- Course catalog
- Coaching marketplace
- Complex navigation or an open-ended analytics dashboard
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
