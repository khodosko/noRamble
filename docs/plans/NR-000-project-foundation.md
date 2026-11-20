# NR-000: Project foundation

- **Status:** Complete
- **Task:** [NR-000 in TASKS.md](../../TASKS.md#nr-000--project-foundation)
- **Pull request:** [#1 — Establish No Ramble project foundation](https://github.com/khodosko/noRamble/pull/1)

## Goal

Establish the durable product definition, engineering policy, documentation system, Git workflow, architecture direction, and planning process that all future No Ramble work must follow.

## User value

A disciplined foundation reduces privacy, quality, and product-scope failures before sensitive recording and analysis behavior is built. It makes future changes reviewable and ensures working software is driven by meaningful tests.

## Scope

- Inspect the initial directory and Git/GitHub state.
- Initialize Git with `main` and create `chore/project-foundation`.
- Create all documentation named in the foundation brief.
- Record the native-iOS decision and provisional system boundaries.
- Make the locked-test policy explicit across agent, testing, engineering, and review guidance.
- Verify and connect the canonical GitHub remote with the owner-selected visibility.
- Preserve the owner-provided Stitch visual reference and document its role, dependencies, and resolved behavioral differences.

## Non-goals

- Application source code or product behavior
- Xcode project, targets, schemes, dependencies, or CI implementation
- Unverified or incorrectly owned remote
- Final technology choices for persistence, analysis, analytics, or cloud services
- Native implementation of the Stitch screens
- Beginning NR-001 before foundation review

## Existing-system observations

- The project directory was empty on 2026-11-19.
- It was not a Git repository and had no remote, tests, application source, or Xcode project.
- Git was initialized locally with `main`, followed by `chore/project-foundation`.
- The Codex GitHub connection identifies the authenticated user as `khodosko`.
- The available GitHub connector can inspect and modify existing repositories but does not create repositories.
- GitHub CLI (`gh`) is installed and authenticated as `khodosko` for HTTPS Git operations.
- The owner created `khodosko/noRamble` as an empty public repository and explicitly replaced the initial private-only requirement on 2026-11-19.
- The connected GitHub account has admin and push access to the repository.
- The Stitch export contains a design-system Markdown file and four working HTML prototypes for daily prompts, live recording, editorial transcript feedback, and streak completion.
- The HTML depends on Tailwind CDN, Google Fonts, and Material Symbols; it is a visual reference rather than native or production code.
- The owner resolved the prototype behavior differences: three prompt choices for one daily session, a two-minute soft ceiling without abrupt cutoff, minimal recording-only UI with no visible timer, post-recording analysis, and streaks without XP.

## Proposed design

Keep durable product truth in `PRODUCT.md`, authoritative work state in `TASKS.md`, chronological evidence in `PROGRESS.md`, engineering policies under `docs/`, decisions in numbered ADRs, and one plan per meaningful slice. Link rather than duplicate details. `AGENTS.md` summarizes mandatory operating rules and points to deeper policies.

## Expected files or components

- `README.md`, `AGENTS.md`, `PRODUCT.md`, `TASKS.md`, `PROGRESS.md`
- `docs/ENGINEERING_STANDARDS.md`, `docs/TESTING.md`, `docs/GIT_WORKFLOW.md`
- `docs/architecture/SYSTEM_DESIGN.md`
- `docs/decisions/README.md`, `docs/decisions/ADR-0001-native-ios.md`
- `docs/plans/README.md`, `docs/plans/SLICE_PLAN_TEMPLATE.md`, this plan
- `docs/design/README.md` and `design/reference/stitch_no_ramble_feedback_screens/`
- `design/reference/stitch_no_ramble_feedback_screens.zip` for source provenance
- Local Git metadata and branch only

## Acceptance criteria

- [x] Initial directory and Git state inspected.
- [x] Git initialized with `main`; work occurs on `chore/project-foundation`.
- [x] Every required document exists with one clear responsibility and useful cross-links.
- [x] Product loop, MVP scope, non-goals, success metric, hypotheses, and open questions are recorded.
- [x] TDD, complete testable-logic coverage, and test-integrity rules are explicit.
- [x] Existing tests are locked by default and may change only with documented evidence of necessity.
- [x] Git workflow records the owner-selected public visibility, branches, pull requests, checks, and test evidence.
- [x] System design distinguishes accepted, proposed, and open decisions.
- [x] ADR-0001 records the native iPhone decision and revisit conditions.
- [x] No application source or Xcode project is created.
- [x] The public `khodosko/noRamble` repository exists and its owner, URL, visibility, empty state, and access are verified.
- [x] The Stitch ZIP is preserved and extracted; integrity, safe paths, expected contents, and rendering are verified.
- [x] The visual reference is separated from production code and its behavioral conflicts are resolved in `PRODUCT.md`, system design, and design guidance.
- [x] Documentation verification results are recorded in `PROGRESS.md` and this plan.

## Tests written before implementation

No production behavior exists in this documentation/design-reference slice, so executable application tests would be meaningless. Verification checks assert required file presence, Markdown link validity, absence of Swift/Xcode artifacts, current branch, remote state, ZIP integrity and safe paths, expected design contents, and successful browser rendering. Future slices must follow red/green TDD.

No pre-existing tests exist. The test-integrity policy added here prohibits changing future valid tests simply to make code pass.

## Failure and edge cases

- Existing non-empty directory or user changes: inspect and preserve; not encountered.
- Existing repository/remote: verify identity and visibility before use; the owner-created public repository was encountered and verified.
- Repository creation unavailable: complete safe local work and report the exact boundary.
- Contradictory documentation: make one document authoritative and cross-link it.
- Accidental application/Xcode creation: detect during verification and remove before completion.
- Ambiguous or incorrectly owned remote: do not push until identity and documented visibility are verified.
- Generated HTML mistaken for product behavior: keep it under `design/reference`, follow the documented resolutions, and require slice-level acceptance criteria before translating it to SwiftUI.

## Privacy and security

This slice handles no user audio or transcripts. Because the repository is public, documentation prohibits secrets and sensitive user data in Git, branches, pull requests, logs, analytics, fixtures, and CI artifacts. No credentials will be stored or displayed. No remote will be used until its identity and visibility are verified.

## Accessibility

No UI is created. Engineering and system-design documents establish VoiceOver, Dynamic Type, focus, contrast, reduced-motion, and recording-state expectations for later slices.

## Implementation steps

1. Inspect the directory, Git state, remotes, and available GitHub authentication.
2. Initialize local Git and create the foundation branch.
3. Draft documents with explicit ownership and cross-links.
4. Review product, testing, Git, architecture, and planning documents for contradictions.
5. Run structural/link/prohibited-artifact checks and inspect Git diff/status.
6. Verify the canonical repository identity, access, and owner-selected visibility.
7. Import and inspect the Stitch design package, record its provenance and implementation guidance, and verify its four screens render.
8. Update completion evidence and present NR-001 for review without beginning it.

## Verification commands

```sh
git branch --show-current
git status --short --branch
find . -type f -not -path './.git/*' | sort
find . -type f \( -name '*.swift' -o -name '*.xcodeproj' -o -name '*.xcworkspace' \)
# Run a local Markdown-link checker against repository-relative links.
git remote -v
unzip -t design/reference/stitch_no_ramble_feedback_screens.zip
shasum -a 256 design/reference/stitch_no_ramble_feedback_screens.zip
```

## Risks

- **Policy duplication drifts:** Assign one clear responsibility per document and cross-link details.
- **Over-design before evidence:** Label unvalidated architecture as proposed or open.
- **Test policy is bypassed under delivery pressure:** Repeat the locked-test rule in agent, testing, engineering, and PR review policy.
- **Repository identity or visibility differs from policy:** Do not push until the owner, URL, access, and documented visibility agree.
- **Design export drifts from product policy:** Product decisions override prototype behavior; treat the export as visual reference and carry the documented resolutions into slice acceptance criteria.

## Rollback strategy

Before a remote or commit exists, documentation files and local Git metadata can be removed without affecting application or user data. After review, revert the focused foundation commit through Git rather than rewriting shared history. Visibility changes require explicit owner instruction and are not a rollback mechanism.

## Documentation updates

This slice creates the complete initial documentation set. Final verification results must be appended to this plan and `PROGRESS.md`; `TASKS.md` changes to complete only after review/PR/CI conditions are satisfied or explicitly scoped for the pre-project foundation.

## Completion evidence

- **Files:** All required foundation documents are present, including ADR-0002 and the owner-provided Stitch source package with a design-reference guide.
- **Tests:** No executable application tests apply. Repository-relative Markdown links resolve; artifact checks found no Swift source, Xcode project, or Xcode workspace; the Stitch archive passes integrity/path-safety checks and all four HTML prototypes render.
- **Git:** `main` contains the repository bootstrap commit. `chore/project-foundation` is connected to its remote tracking branch and contains the documentation changes.
- **CI:** Deferred until NR-001 because no Xcode project or known test command exists.
- **GitHub:** `khodosko/noRamble` is verified as public, unarchived, and writable by the connected owner account. Public visibility is an explicit owner decision recorded in ADR-0002.
- **Pull request:** [#1](https://github.com/khodosko/noRamble/pull/1) is open for review.
