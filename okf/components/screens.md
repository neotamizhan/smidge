---
type: Component
title: Screens
description: Flutter screens, navigated with Navigator.push / MaterialPageRoute; the home screen is the hub.
resource: flutter_app/lib/screens/
tags: [screens, navigation, ui]
timestamp: 2026-06-19T00:00:00Z
---

# Screens

The app navigates with `Navigator.push` and `MaterialPageRoute` directly. The
home screen is the hub for the library, pins, unit pickers, multi-unit view, and
the specialist calculators.

# Map

| Screen | Role |
|--------|------|
| `ScrSplash` | Startup splash while state loads |
| `ScrWelcome`, `ScrPickCats`, `ScrPref`, `ScrPinThree` | Onboarding flow |
| `ScrHome` | [General converter](/features/general-converter.md) hub |
| `ScrLibrary` | Searchable unit library |
| `ScrUnitPicker` | From/to unit selection |
| `ScrMulti` | Multi-unit view across a category |
| `ScrPins` | [Pinned conversions](/features/pins.md) |
| `ScrCooking`, `ScrMedical`, `ScrTrades`, `ScrCurrency` | Specialist calculators |

# Onboarding flow

`Splash → Welcome → PickCats → Pref → PinThree`, then persists system, pins, and
completion via [AppState](/components/app-state.md) and routes to `ScrHome`.
Category interest is collected during onboarding but is not stored as an active
filter.

Screens read from [AppState](/components/app-state.md) and render with the
[design system](/architecture/design-system.md).
