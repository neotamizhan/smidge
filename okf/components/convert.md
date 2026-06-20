---
type: Component
title: Conversion Helpers
description: Pure conversion functions — linear base-factor conversion, temperature, and specialist helpers.
resource: flutter_app/lib/data/convert.dart
tags: [conversion, pure-functions]
timestamp: 2026-06-19T00:00:00Z
---

# Conversion helpers

Pure functions that turn an input value into a converted number. Kept free of UI
and storage so behavior is easy to test.

# Functions

| Function | Used by |
|----------|---------|
| `convert(value, from, to, category)` | [General converter](/features/general-converter.md), linear: `value * from.factor / to.factor` |
| `convertTemp` | Temperature (custom formulas) |
| `cookingConvert` | [Cooking](/features/cooking.md) |
| `convertGlucose`, `glucoseRange` | [Medical](/features/medical.md) |
| `mmToFtInFrac` | [Trades](/features/trades.md) |
| currency ratio | [Currency](/features/currency.md), `amount / fromRate * toRate` |

Depends on [units](/components/units.md). Results are formatted by
[format](/components/format.md).
