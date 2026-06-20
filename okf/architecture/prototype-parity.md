---
type: Component
title: React/Babel Prototype
description: A root-level React prototype that mirrors the Flutter app's product model for fast iteration.
resource: index.html
tags: [prototype, react, reference]
timestamp: 2026-06-19T00:00:00Z
---

# Prototype parity

The repository root holds a React/Babel app (loaded from CDN scripts in
`index.html`) that mirrors the Flutter app's interaction model and conversion
data. It is a design/interaction reference — the [Flutter app](/components/index.md)
is the production target.

# Files

| File | Role |
|------|------|
| `index.html` | Entry; loads design, data, screens, app |
| `app.js` | React state + reducer actions, `localStorage` |
| `screens.js` | Screen components |
| `data.js` | Static conversion data helpers |
| `design.js` | Visual system |

# Running it

```sh
python3 -m http.server 8000   # then open http://localhost:8000
```

The prototype keeps a similar conceptual architecture (React state, reducer
actions, static data helpers, browser `localStorage`) to the Flutter
[state model](/architecture/state-model.md).
