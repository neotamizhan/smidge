---
type: Feature
title: Medical Calculator
description: Educational conversions for glucose, HbA1c, cholesterol, creatinine, and triglycerides with range context.
tags: [medical, glucose, hba1c, specialist, educational]
timestamp: 2026-06-19T00:00:00Z
---

# Medical

A tabbed specialist calculator for common lab values:

- **Glucose** — `mg/dL` ↔ `mmol/L` (`convertGlucose`), with a fasting-range
  indicator (`glucoseRange`).
- **HbA1c**, **cholesterol**, **creatinine**, **triglycerides** — unit
  conversions with range context per analyte.

# Important

Medical ranges are **educational context only** — not a diagnosis or dosing
tool. This boundary is restated at the [application](/index.md) level.

Conversions are rendered through [fmt](/components/format.md) and sit outside the
general [category system](/features/general-converter.md).
