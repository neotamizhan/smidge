---
type: Component
title: Design System
description: A compact custom design system with hand-drawn widgets and Flutter custom painters instead of a third-party component library.
tags: [design, ui, custom-painter]
timestamp: 2026-06-19T00:00:00Z
---

# Design system

The UI uses a compact custom design system rather than a third-party component
library. Shared widgets and painters keep the hand-drawn style consistent across
[screens](/components/screens.md).

# Modules (`lib/design/`)

| File | Role |
|------|------|
| `colors.dart` | Palette and theme tokens |
| `wobble.dart` | Hand-drawn line/wobble primitives |
| `doodles.dart` | Painted doodle glyphs (category icons) |
| `sk_widgets.dart` | Shared sketch-style widgets |

Dependency direction: `colors → wobble → doodles → sk_widgets → screens`, with
`doodles` also used directly by some screens.

# Brand

The launcher icon is the Smidge ruler-glyph mark, with an adaptive-icon
background of `#F3E9D3` and theme color `#C4593A` (see `pubspec.yaml`).
