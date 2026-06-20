---
type: Data Model
title: Persistence
description: State persists as a JSON blob plus a separate onboarding marker in shared_preferences.
tags: [persistence, shared-preferences, storage]
timestamp: 2026-06-19T00:00:00Z
---

# Persistence

Flutter persistence is a JSON blob plus a separate onboarding marker, both in
`shared_preferences`.

| Key | Contents |
|-----|----------|
| `smidge_state` | Serialized [AppState](/components/app-state.md) JSON (category, units, pins, system, decimals) |
| `smidge_onboarded` | Boolean onboarding-completion marker |

The [prototype](/architecture/prototype-parity.md) uses browser `localStorage`
for the equivalent role.

# Privacy

Smidge stores only local app preferences and onboarding state. No analytics,
accounts, or remote data services are present. See the
[application overview](/index.md) for the full privacy stance.
