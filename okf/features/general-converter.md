---
type: Feature
title: General Converter
description: Home-screen bidirectional conversion with inline expression evaluation, across all standard categories.
tags: [conversion, calculator, home]
timestamp: 2026-06-19T00:00:00Z
---

# General converter

The home screen (`ScrHome`) is the hub. The user enters a value on the keypad;
[AppState](/components/app-state.md) evaluates any expression, then
[convert](/components/convert.md) produces the result, which
[fmt](/components/format.md) renders for both sides.

# Categories

Length, mass, volume, area, speed, time, data, pressure, energy. These are
static tables in [units](/components/units.md) and convert through a base-unit
factor:

```
result = value * fromUnit.factor / toUnit.factor
```

Temperature is special-cased with custom formulas (`convertTemp`) rather than a
linear factor.

# Expression mode

`exprMode` allows inline calculator input like `3*250+50`. The expression is
parsed by `evalExpr` in [format](/components/format.md) before conversion.

# Hub navigation

From the home screen the user can reach pins, the library, the from/to unit
pickers, the multi-unit view, and the specialist calculators listed in
[features](/features/index.md).
