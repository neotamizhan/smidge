---
type: Data Model
title: State Model
description: AppState is a ChangeNotifier holding the active conversion, input expression, focused side, pins, and preferences.
tags: [state, change-notifier, data-model]
timestamp: 2026-06-19T00:00:00Z
---

# State model

[AppState](/components/app-state.md) is a `ChangeNotifier`. Mutating methods
update memory, call `notifyListeners`, and persist — screens never write to
local storage directly.

# Fields

| Field | Type | Meaning |
|-------|------|---------|
| `category` | String | Active conversion category id |
| `fromUnit` / `toUnit` | String | Selected units |
| `expression` | String | Current input expression |
| `exprMode` | bool | Whether calculator/expression mode is active |
| `inputSide` | InputSide | Which side (`from`/`to`) is focused |
| `pins` | List | User's pinned conversions |
| `system` | String | Preferred measurement system |
| `decimals` | int | Decimal precision setting |

# Related concepts

`AppState` references [UnitCategory and Unit](/components/units.md) — a category
owns a map of units, and each unit carries a `name`, `sym`, and base-unit
`factor`. Computed `fromDisplay` / `toDisplay` strings drive the UI.

# Update flow

```
User taps key/swap/category/unit
  → Screen calls an AppState action
  → AppState evaluates/converts via helpers when needed
  → AppState mutates fields, notifyListeners, persists JSON
  → Screen rebuilds with new display
```
