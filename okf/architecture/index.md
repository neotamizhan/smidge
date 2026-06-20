---
type: Architecture
title: Smidge Architecture
description: Client-only architecture — UI screens call a small state layer, which calls pure conversion helpers and persists locally.
tags: [architecture, flutter, state-management]
timestamp: 2026-06-19T00:00:00Z
---

# Architecture

Smidge is a client-only app. UI [screens](/components/screens.md) call a small
[state layer](/components/app-state.md), the state layer calls pure
[conversion helpers](/components/convert.md), and preferences are persisted
locally. There is no backend in the current repository.

```
User → Flutter app → Screens → AppState → Conversion helpers
                                   └──────→ shared_preferences (persistence)
```

# Runtime targets

The Flutter implementation supports Android, iOS, and web (the platforms
scaffolded under `flutter_app/`). The [prototype](/architecture/prototype-parity.md)
is served as static files from the repository root.

# Sub-concepts

- [State model](/architecture/state-model.md) — what `AppState` holds and how
  updates flow.
- [Persistence](/architecture/persistence.md) — how state is stored on-device.
- [Design system](/architecture/design-system.md) — the custom hand-drawn UI.
- [Prototype parity](/architecture/prototype-parity.md) — the React reference app.

# Startup

`main.dart` initializes Flutter bindings, sets the system UI overlay, builds
`SmidgeApp`, loads [AppState](/components/app-state.md), checks onboarding
status, and routes to either the onboarding flow or the home converter.
