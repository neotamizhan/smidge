---
type: Feature
title: Pinned Conversions
description: User-pinned quick conversions, seeded during onboarding and editable afterward.
tags: [pins, onboarding, quick-access]
timestamp: 2026-06-19T00:00:00Z
---

# Pins

Pins are quick-access conversions stored in [AppState](/components/app-state.md)
and persisted via [persistence](/architecture/persistence.md). The `ScrPins`
screen lists them and links into the specialist calculators.

# Onboarding seed

Onboarding collects three initial pins (`ScrPinThree`) along with the default
measurement system. On completion, `AppState.setPins`, `setSystem`, and
`setOnboarded` persist these. Saved pins are reflected after onboarding and can
be edited later.
