# No Ramble

No Ramble is a native iPhone app for people who want to speak more clearly but do not want to navigate a traditional public-speaking toolbox. Its promise is simple: **one chosen prompt, one recording, one improvement, every day.**

## The problem

Speaking practice is easy to postpone when the next action is unclear or the product demands too much exploration. No Ramble turns improvement into a short, directed daily ritual and gives the user one useful focus for the next attempt.

## Daily loop

1. A daily notification opens three rotating choices from an original bundled prompt library.
2. The user chooses one prompt for that daily session.
3. A focused recording screen keeps the selected prompt visible, shows elapsed time in small numerals, and uses an unmistakable red recording/microphone state without transcript, coaching, or metrics.
4. The user speaks naturally toward a two-minute soft ceiling without an abrupt cutoff at exactly two minutes.
5. After recording ends, the app evaluates delivery, pace, pauses, filler words, conciseness, and structure.
6. The user receives a score, a few observations, and one primary improvement.
7. The user retries the selected prompt and compares attempts, or finishes and continues their streak tomorrow.

## Status

**Recording foundation complete.** [Pull request #6](https://github.com/khodosko/noRamble/pull/6) connects the daily prompt to a focused full-screen recording flow backed by real `AVAudioRecorder` capture. Permission denial, start/stop failure, cancellation, temporary-file cleanup, and the captured seam are explicit and tested. Timing and interruption policy remain the next small slice.

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

### Prerequisites

- Xcode 26.2 with the iOS 26.2 Simulator runtime
- XcodeGen 2.48.0 when regenerating the committed project (`brew install xcodegen`)

### Get and open the project

This workspace is already cloned locally. Open it directly:

```sh
open NoRamble.xcodeproj
```

On another Mac, use Xcode's **Clone Git Repository** action with `https://github.com/khodosko/noRamble.git`, choose a local folder, then open `NoRamble.xcodeproj`. A terminal clone works too:

```sh
git clone https://github.com/khodosko/noRamble.git
cd noRamble
open NoRamble.xcodeproj
```

### Regenerate the project

`project.yml` is the human-reviewable project definition. Regenerate after changing targets or build settings:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodegen generate
```

### Run tests

Relevant unit tests:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild test \
  -project NoRamble.xcodeproj \
  -scheme NoRamble \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.2' \
  -only-testing:NoRambleTests \
  CODE_SIGNING_ALLOWED=NO
```

Complete unit/UI suite with coverage:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild test \
  -project NoRamble.xcodeproj \
  -scheme NoRamble \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.2' \
  -enableCodeCoverage YES \
  CODE_SIGNING_ALLOWED=NO
```

Before contributing:

1. Read `AGENTS.md` and the documents linked above.
2. Select a task from `TASKS.md` and create or update its slice plan.
3. Work on a focused branch using the test-first process in `docs/TESTING.md`.
4. Run relevant tests while iterating and the complete suite before opening a pull request.

This is intentionally a public repository so people can follow the work. Treat every committed file as public: never commit secrets, signing material, API keys, user recordings or transcripts, or developer-specific configuration.
