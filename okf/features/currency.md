---
type: Feature
title: Currency Converter
description: Static currency conversion using bundled USD-relative snapshot rates (not live).
tags: [currency, static-rates, specialist]
timestamp: 2026-06-19T00:00:00Z
---

# Currency

Converts between currencies using static, bundled USD-relative snapshot rates:

```
result = amount / fromRate * toRate
```

# Limitation

Rates are a bundled snapshot, **not** live exchange rates — see the
[application boundaries](/index.md). Output is rendered by
[fmt](/components/format.md).
