---
type: Data Model
title: Units
description: Static unit-category tables — each category owns a map of units with a base-unit factor.
resource: flutter_app/lib/data/units.dart
tags: [units, data, categories]
timestamp: 2026-06-19T00:00:00Z
---

# Units

Static tables defining the general conversion categories used by the
[general converter](/features/general-converter.md).

# Shapes

`UnitCategory`: `id`, `name`, `icon` (DoodleKind), `color`, `defaultFrom`,
`defaultTo`, `special` (flag for specialist handling), and a `units` map.

`Unit`: `name`, `sym` (symbol), `factor` (relative to the category's base unit).

# Categories

Length, mass, volume, area, speed, time, data, pressure, energy (linear via
factor) plus temperature (special-cased). Categories flagged `special` route to
the specialist calculators in [features](/features/index.md) instead of the
linear path in [convert](/components/convert.md).
