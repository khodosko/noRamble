# Slice plans

Every meaningful engineering or product slice requires a dedicated plan before implementation. A plan is the working agreement for scope, test-first behavior, risks, verification, and completion evidence. Keep it current as evidence changes; do not use it as a second backlog.

Create plans as `docs/plans/NR-NNN-short-title.md` using [the template](SLICE_PLAN_TEMPLATE.md). Link the plan from the matching entry in `TASKS.md`.

Each plan must contain:

- Identifier and title
- Status
- Goal and user value
- Scope and non-goals
- Existing-system observations
- Proposed design
- Files or components expected to change
- Acceptance criteria
- Tests written before implementation
- Failure and edge cases
- Privacy/security and accessibility considerations
- Implementation steps and verification commands
- Risks and rollback strategy
- Documentation updates
- Pull-request link
- Completion evidence

Update the plan before changing scope or accepted behavior. Exceptional changes to existing tests must be justified in the plan before the test is edited.
