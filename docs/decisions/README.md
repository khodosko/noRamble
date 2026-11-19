# Architecture decision records

Architecture decision records (ADRs) capture durable decisions whose context and tradeoffs should survive the implementation that introduced them. They complement, rather than duplicate, the current system design.

## When to create one

Create or supersede an ADR when a slice chooses a technology, cross-feature boundary, data/privacy policy, major dependency, or difficult-to-reverse engineering direction. Do not create ADRs for routine local implementation details.

## Naming

Use the next four-digit sequence and a short lowercase kebab-case subject:

`ADR-0002-example-subject.md`

Never renumber accepted records. If a decision changes, add a new ADR and mark the old record superseded with a link.

## Required sections

- Title, date, and status (`Proposed`, `Accepted`, `Superseded`, or `Rejected`)
- Context
- Decision
- Benefits
- Costs and consequences
- Alternatives considered
- Conditions for revisiting
- Related slice/PR links
