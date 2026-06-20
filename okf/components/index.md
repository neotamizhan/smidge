---
type: Component
title: Flutter App Components
description: Entrypoint, state, data, design, and screens — data modules kept pure for testability.
resource: flutter_app/
tags: [flutter, dart, modules]
timestamp: 2026-06-19T00:00:00Z
---

# Flutter app

The primary implementation lives in `flutter_app/`. Code is split into
entrypoint, state, data, design, and screens. Data modules are deliberately pure
(or nearly so) so conversion behavior is easy to test.

# Requirements

- Flutter `>= 3.10.0`, Dart `>= 3.0.0 < 4.0.0`
- Dependencies: `shared_preferences`, `google_fonts`

```sh
cd flutter_app && flutter pub get
flutter run            # or: flutter run -d chrome
flutter analyze
flutter test
```

# Module map

| Concept | File |
|---------|------|
| Entrypoint | `lib/main.dart` |
| [AppState](/components/app-state.md) | `lib/state/app_state.dart` |
| [Units](/components/units.md) | `lib/data/units.dart` |
| [Convert](/components/convert.md) | `lib/data/convert.dart` |
| [Format](/components/format.md) | `lib/data/format.dart` |
| [Screens](/components/screens.md) | `lib/screens/*` |
| [Design system](/architecture/design-system.md) | `lib/design/*` |

Dependency direction: screens depend on state, data, and design; state depends
on data and persistence; `convert` depends on `units`.
