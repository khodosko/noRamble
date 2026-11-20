# No Ramble

No Ramble is a native iPhone app for people who want to speak more clearly but do not want to navigate a traditional public-speaking toolbox. Its promise is simple: **one prompt, one recording, one improvement, every day.**

## The problem

Speaking practice is easy to postpone when the next action is unclear or the product demands too much exploration. No Ramble turns improvement into a short, directed daily ritual and gives the user one useful focus for the next attempt.

## Daily loop

1. A daily notification opens today's prompt.
2. The user records a natural response, typically for one to two minutes.
3. The app evaluates delivery, pace, pauses, filler words, conciseness, and structure.
4. The user receives a score, a few observations, and one primary improvement.
5. The user retries and compares attempts, or finishes and returns tomorrow.

## Status

**Project foundation in review.** Product, engineering, testing, architecture, planning, and Git policies are proposed in [pull request #1](https://github.com/khodosko/noRamble/pull/1). No application or Xcode project has been created yet.

## Technology direction

- Native iPhone application
- Swift and SwiftUI
- Apple frameworks where practical
- Internal target/module name: `NoRamble`
- User-facing name: **No Ramble**
- Testable business logic separated from SwiftUI and platform integrations

## Project documents

- [Product specification](PRODUCT.md)
- [Task tracker](TASKS.md)
- [Engineering progress](PROGRESS.md)
- [Agent instructions](AGENTS.md)
- [Engineering standards](docs/ENGINEERING_STANDARDS.md)
- [Testing strategy](docs/TESTING.md)
- [Git workflow](docs/GIT_WORKFLOW.md)
- [Provisional system design](docs/architecture/SYSTEM_DESIGN.md)
- [Design reference](docs/design/README.md)
- [Architecture decisions](docs/decisions/README.md)
- [Slice plans](docs/plans/README.md)

## Development

Development setup and test commands are pending creation of the Xcode project. Until then:

1. Read `AGENTS.md` and the documents linked above.
2. Select a task from `TASKS.md` and create or update its slice plan.
3. Work on a focused branch using the test-first process in `docs/TESTING.md`.
4. Do not add application behavior during the foundation slice.

This is intentionally a public repository so people can follow the work. Treat every committed file as public: never commit secrets, signing material, API keys, user recordings or transcripts, or developer-specific configuration.
