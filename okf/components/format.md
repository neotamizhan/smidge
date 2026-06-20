---
type: Component
title: Formatting & Expression Parsing
description: Number formatting (fmt) and expression evaluation (evalExpr) for calculator-mode input.
resource: flutter_app/lib/data/format.dart
tags: [formatting, parsing, expressions]
timestamp: 2026-06-19T00:00:00Z
---

# Format

Number formatting and expression parsing — the final step before display and the
first step when handling calculator input.

# Functions

- `fmt(raw)` — formats a numeric result into a readable display string
  (honors the `decimals` preference from [AppState](/components/app-state.md)).
- `evalExpr(expression)` — parses and evaluates expressions like `3*250+50` for
  [expression mode](/features/general-converter.md).

Every conversion path in [convert](/components/convert.md) ends here before the
value reaches the [screens](/components/screens.md).
