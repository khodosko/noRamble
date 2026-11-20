# Design reference

## Status and intent

The owner-provided Stitch export is the accepted **visual direction** for No Ramble. It should guide native SwiftUI layout, color, typography, spacing, shapes, motion, and feedback presentation. It is not production web code, a final product specification, or permission to add behavior outside an approved slice.

The source archive and extracted files live under [`design/reference`](../../design/reference/). The original archive is retained so future imports can be compared against an exact source.

## Provenance

- **Archive:** `design/reference/stitch_no_ramble_feedback_screens.zip`
- **SHA-256:** `a6c9421ddeddd51f7ee1a892d488c288367ce63db98e1cbb1ee6481cd78446c2`
- **Imported:** 2026-11-19
- **Archive integrity:** Verified with `unzip -t`
- **Path safety:** No absolute paths, traversal segments, or backslash-based paths
- **Secrets scan:** No credentials, keys, tokens, or passwords found

## Included references

- [`no_ramble_design_system.md`](../../design/reference/stitch_no_ramble_feedback_screens/no_ramble_design_system.md): palette, type scale, spacing, radii, motion, and voice
- [`daily_prompts_no_ramble/code.html`](../../design/reference/stitch_no_ramble_feedback_screens/daily_prompts_no_ramble/code.html): prompt selection
- [`live_recording_no_ramble/code.html`](../../design/reference/stitch_no_ramble_feedback_screens/live_recording_no_ramble/code.html): recording, timer, waveform, transcript, and coaching nudge
- [`direction_2_editorial_markup_coach_transcript/code.html`](../../design/reference/stitch_no_ramble_feedback_screens/direction_2_editorial_markup_coach_transcript/code.html): transcript markup, concise feedback, and retry action
- [`streak_extended_no_ramble/code.html`](../../design/reference/stitch_no_ramble_feedback_screens/streak_extended_no_ramble/code.html): completion, streak, progress comparison, and winning opener

All four HTML screens were rendered successfully at the target 390-point mobile width.

## Visual language to carry into SwiftUI

- Feather Green `#58CC02` for success and primary actions
- Fox Orange `#FF9600` for streaks and coaching emphasis
- Macaw Blue `#1CB0F6` for audio/pacing information
- Cardinal Coral `#FF4B4B` for ramble or warning states
- Snow-gray `#F7F7F7` background with white cards, warm charcoal text, and crisp two-point borders
- Four/eight-point spacing rhythm with 20-point screen margins
- Rounded cards and pills, tactile button depth, short 100 ms taps, and 250 ms sheet motion
- Direct, supportive coaching copy that identifies the exact delay and supplies a better opening immediately

The export uses Afacad Flux, Instrument Sans, Source Code Pro, and Material Symbols from external Google resources. Before native implementation, confirm font licensing/bundling and Dynamic Type behavior. Prefer SF Symbols for native icons where a close semantic match exists.

## Behavioral differences requiring product decisions

| Stitch reference | Current durable product direction | Required resolution |
|---|---|---|
| User picks one of three prompts | App chooses one daily prompt and directs the next action | Decide before the daily-prompt slice |
| Per-prompt 45/60-second limits | Recommend one to two minutes and allow natural completion | Decide before recording UX is specified |
| Live transcript and coaching nudge | Analyze after recording | Decide whether live analysis belongs in MVP |
| XP plus streak celebration | Minimal history and streaks; XP is unspecified | Validate motivational value before adding XP |

Until these decisions are made, reproduce the visual system without treating the prototype's sample behavior as accepted requirements.

## Native implementation guidance

- Translate semantic colors into an asset catalog with light/dark variants rather than copying Tailwind class names into Swift.
- Model typography through Dynamic Type-aware SwiftUI styles; never lock accessibility text to the prototype's pixel sizes.
- Build reusable native cards, pills, buttons, metric labels, and transcript annotations from the shared tokens.
- Replace browser-only scripts with tested state and domain behavior.
- Preserve VoiceOver meaning, focus order, contrast, reduced-motion behavior, and minimum tap targets.
- Test each screen at supported Dynamic Type sizes and narrow/large iPhone widths rather than assuming a fixed 390-point canvas.

## Export sufficiency

This ZIP is enough to begin faithful native planning and implementation. A Stitch project/share link or versioned screenshots would be useful for future design revisions and pixel-level review, but another export format is not required now. Native SwiftUI should be implemented from approved slice behavior and this visual reference, not mechanically converted from the HTML.
