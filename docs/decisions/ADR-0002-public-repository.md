# ADR-0002: Keep the source repository public

- **Date:** 2026-11-19
- **Status:** Accepted
- **Related slice:** [NR-000](../plans/NR-000-project-foundation.md)
- **Pull request:** Pending

## Context

The foundation brief initially required a private repository. After creating `khodosko/noRamble`, the owner explicitly chose public visibility so other people can see the project's development. Public source changes the exposure of code, history, pull requests, CI logs, and artifacts, but it does not change the privacy obligations for future app users.

## Decision

Keep `khodosko/noRamble` public. Treat all repository content and collaboration surfaces as publicly readable. Never commit or publish credentials, signing material, API keys, developer-local configuration, user recordings, transcripts, personal feedback, or other sensitive user data. Repository visibility may change later only through explicit owner instruction.

## Benefits

- People can follow development and review the project's methods.
- Public discussion and contributions remain possible.
- The documentation and test-first process are visible and auditable.

## Costs and consequences

- Accidental secret or sensitive-data commits have immediate public exposure and cannot be made safe merely by deleting the latest revision.
- Branches, pull requests, CI logs, issues, and artifacts require the same data hygiene as the default branch.
- Security-sensitive implementation details are visible, so the application must rely on sound secret management and server-side controls rather than obscurity.

## Alternatives considered

- **Private repository:** Reduces casual visibility but conflicts with the owner's current collaboration preference and still would not justify committing secrets or user data.
- **Develop privately and mirror publicly:** Adds synchronization and review complexity without current evidence that it is needed.

## Conditions for revisiting

Revisit if the owner wants private development, contribution management becomes burdensome, contractual obligations require restricted source, or the repository begins to contain work that cannot safely be developed in public. A superseding ADR must document the new policy.
