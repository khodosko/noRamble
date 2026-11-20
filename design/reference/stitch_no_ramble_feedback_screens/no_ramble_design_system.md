---
name: "No Ramble Design System"
description: "Precision speech-coaching design system balancing high-energy metric rings, editorial coaching critique, and audio-waveform timelines."
---

## Overview

No Ramble is a speech-coaching app designed to train people to eliminate fluff, structure their thoughts, and lead with their bottom line immediately. The interface communicates cheerful, encouraging momentum—combining bright Duolingo-style surfaces, tactile 3D button depth, playful streak motivation, and clear visual feedback across activity rings, coach markup, and audio telemetry.

## Colors

The system uses a light, playful, high-energy palette inspired by Duolingo: Feather Green (`#58CC02`) for wins and primary actions, Fox Orange (`#FF9600`) for streaks and coaching tips, Macaw Blue (`#1CB0F6`) for pacing and audio waveforms, and Cardinal Coral (`#FF4B4B`) for ramble zones, grounded in crisp white and soft snow-gray surfaces (`#FFFFFF` / `#F7F7F7`) with warm charcoal ink (`#3C3C3C`).

- **Primary:** Vibrant Feather Green (`#58CC02`) for primary goals, suggested openings, and "Try again" CTAs.
- **Accent:** Playful Fox Orange (`#FF9600`) for daily streak flames, coaching tips, and coach markup notes.
- **Surface:** Crisp white cards (`#FFFFFF`) on light snow-gray grounds (`#F7F7F7`) with tactile 2px borders (`#E5E5E5`).

```yaml
colors:
  fitness-green: "#58CC02"
  fitness-green-dark: "#46A302"
  fitness-green-text: "#2B6A00"
  fitness-green-bg: "#F3FCEB"
  fitness-pink: "#FF4B4B"
  fitness-cyan: "#1CB0F6"
  coach-amber: "#FF9600"
  coach-highlight: "#FFF3CC"
  coach-ink: "#FFFFFF"
  coach-ink-dark: "#FFFFFF"
  telemetry-dark: "#FFFFFF"
  telemetry-button: "#EEF2F6"
  telemetry-bg: "#F7F9FC"
  alert-red: "#FF4B4B"
  alert-red-text: "#C81E1E"
  timeline-wave: "#1CB0F6"
  timeline-wave-text: "#0B77AD"
  timeline-wave-bg: "#EEF9FF"
  waveform-muted: "#CBD5E1"
  streak-orange: "#FF9600"
  streak-bg: "#FFF4E0"
  streak-text: "#9A4800"
  ink-dark: "#1A1A1A"
  light:
    primary: "#58CC02"
    on-primary: "#1A3300"
    surface: "#F7F7F7"
    on-surface: "#3C3C3C"
    surface-container: "#FFFFFF"
    surface-container-high: "#EFEFEF"
    outline: "#6E6E73"
  dark:
    primary: "#58CC02"
    on-primary: "#1A3300"
    surface: "#131F24"
    on-surface: "#FFFFFF"
    surface-container: "#1F2F36"
    surface-container-high: "#2A3E47"
    outline: "#A1A1A6"
```

## Typography

Headline and stat metrics rely on **Afacad Flux** for dynamic, technical presence. Body content and coach transcript notes utilize **Instrument Sans** for neutral clarity and high legibility. Precision timestamps and audio timecodes use **Source Code Pro**.

```yaml
typography:
  display-lg:
    fontFamily: "Afacad Flux"
    fontSize: 48px
    fontWeight: 800
    lineHeight: 52px
    letterSpacing: -1px
  display-lg-mobile:
    fontFamily: "Afacad Flux"
    fontSize: 32px
    fontWeight: 800
    lineHeight: 38px
    letterSpacing: -0.5px
  headline-lg:
    fontFamily: "Afacad Flux"
    fontSize: 36px
    fontWeight: 700
    lineHeight: 42px
    letterSpacing: -0.5px
  headline-lg-mobile:
    fontFamily: "Afacad Flux"
    fontSize: 28px
    fontWeight: 700
    lineHeight: 34px
    letterSpacing: -0.3px
  headline-md:
    fontFamily: "Afacad Flux"
    fontSize: 24px
    fontWeight: 700
    lineHeight: 30px
    letterSpacing: -0.2px
  headline-sm:
    fontFamily: "Afacad Flux"
    fontSize: 18px
    fontWeight: 600
    lineHeight: 24px
  body-lg:
    fontFamily: "Instrument Sans"
    fontSize: 17px
    fontWeight: 400
    lineHeight: 24px
  body-md:
    fontFamily: "Instrument Sans"
    fontSize: 15px
    fontWeight: 400
    lineHeight: 22px
  body-sm:
    fontFamily: "Instrument Sans"
    fontSize: 13px
    fontWeight: 400
    lineHeight: 18px
  label-lg:
    fontFamily: "Instrument Sans"
    fontSize: 16px
    fontWeight: 600
    lineHeight: 20px
  label-md:
    fontFamily: "Instrument Sans"
    fontSize: 14px
    fontWeight: 600
    lineHeight: 18px
  label-sm:
    fontFamily: "Instrument Sans"
    fontSize: 12px
    fontWeight: 600
    lineHeight: 16px
  code-md:
    fontFamily: "Source Code Pro"
    fontSize: 14px
    fontWeight: 500
    lineHeight: 20px
```

## Layout & Spacing

Mobile-first iOS architecture targeting 390px viewport width. Content utilizes a 4px/8px modular spacing scale with 20px screen margins.

```yaml
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 20px
  xl: 24px
  xxl: 32px
  section: 40px
```

## Elevation & Depth

Surfaces rely on crisp white layered cards (`#FFFFFF`) on soft snow-gray grounds (`#F7F7F7`), framed by playful 2px borders (`#E5E5E5`) and tactile bottom-lip depth on primary buttons.

## Shapes

Organic iOS squircle and pill geometry.

```yaml
rounded:
  sm: 8px
  md: 12px
  lg: 18px
  xl: 24px
  full: 9999px
```

## Motion & Micro-interaction

Micro-interactions are snappy and immediate.

```yaml
motion:
  tap:
    duration: 100ms
    delay: 0ms
    timingFunction: ease-out
  sheet:
    duration: 250ms
    delay: 0ms
    timingFunction: cubic-bezier(0.16, 1, 0.3, 1)
```

## Voice & Content Strategy

The coaching tone is direct, supportive, and actionable. Pinpoint the hesitation, state the exact second the point landed, and supply the revised sentence immediately.
