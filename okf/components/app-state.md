---
type: Component
title: AppState
description: The single ChangeNotifier that owns conversion state and orchestrates conversion + persistence.
resource: flutter_app/lib/state/app_state.dart
tags: [state, change-notifier]
timestamp: 2026-06-19T00:00:00Z
---

# AppState

A single `ChangeNotifier` that owns the app's conversion state and is the only
writer to local storage. See the [state model](/architecture/state-model.md) for
the field list and [persistence](/architecture/persistence.md) for storage keys.

# Key methods

- `load()` / `persist()` — read and write the JSON state blob.
- `onKey(String k)` — handle keypad input (drives expression/calculator mode).
- `swap()` — swap from/to units.
- `setSide(InputSide)`, `setCategory(String)`, `setUnit(InputSide, String)`.
- `toggleExpr()`, `setSystem(String)`, `setPins(List)`.
- `fromDisplay` / `toDisplay` — computed display strings.

# Collaborators

Calls into [convert](/components/convert.md) and [format](/components/format.md);
reads [units](/components/units.md); persists via `shared_preferences`. Consumed
by all [screens](/components/screens.md).
