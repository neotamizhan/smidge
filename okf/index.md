---
type: Application
title: Smidge
description: A tiny, careful, local-first unit converter. No ads, no chatter — just the answer.
resource: https://github.com/  # repository root
tags: [flutter, dart, unit-converter, offline-first, mobile, web]
timestamp: 2026-06-19T00:00:00Z
---

# Smidge

Smidge is a small, offline-first unit converter focused on fast, readable
conversions. The production implementation is a [Flutter app](/components/index.md);
a React/Babel app kept at the repository root is a design and interaction
[prototype](/architecture/prototype-parity.md).

Everything runs on-device. Conversion tables, specialist calculators,
preferences, onboarding state, and pinned conversions all live locally. There is
no backend service in the current implementation.

# What it does

- Bidirectional conversion with editable "from" and "to" values.
- Inline [calculator mode](/features/general-converter.md) for expressions like `3*250+50`.
- A searchable unit library and unit picker.
- A multi-unit view that converts one input across a whole category at once.
- [Pinned quick conversions](/features/pins.md) for common workflows.
- Specialist calculators for [cooking](/features/cooking.md),
  [medical values](/features/medical.md), [trades](/features/trades.md), and
  [currency](/features/currency.md).
- A hand-drawn [visual system](/architecture/design-system.md) built from
  Flutter custom painters.

# Map

- Architecture — [/architecture/index.md](/architecture/index.md)
- Features — [/features/index.md](/features/index.md)
- Components — [/components/index.md](/components/index.md)

# Boundaries

- Offline-first; no network integration.
- Currency conversion uses static bundled snapshot rates, not live rates.
- Medical context is educational only — not diagnosis or dosing guidance.
- State management is intentionally simple and local to
  [AppState](/components/app-state.md); there is no DI or repository layer.
