# ADR 0005: Entitlement flags before the store

- **Status:** Accepted
- **Date:** 2026-09-05
- **Supersedes:** none

## Context

Phase 2 needs the full Pro surface (styles, atmospheres, statistics, Pro
screen) so we can test it. Live AdMob and subscriptions need store binaries,
privacy policy, and accounts that do not exist yet.

If screens each invent their own `if (pro)` branches, flipping to real money
later means a rewrite.

## Decision

One `Entitlement` object with at least:

- `isPro`
- `adsAllowed`

Phase 2 / current testing:

```text
isPro = true
adsAllowed = false
```

Screens ask those booleans. `AdSlot` is the only place an ads SDK may load.
Atmosphere and styles ask `soundscapeUnlocked` / `themeUnlocked`.

When Phase 3 connects the store:

- Receipt or RevenueCat customer info sets `isPro`.
- `adsAllowed = !isPro` (and still false on the live screen, which never
  mounts `AdSlot`).

Do not persist a fake “purchased” flag that would fight a later receipt.

## Consequences

- Restore Purchases is a no-op snackbar until Phase 3.
- Free-user QA requires a temporary `Entitlement(isPro: false, adsAllowed:
  true)` build or debug switch — not a second UI codebase.
- The live journey screen still must not read `Entitlement` except through
  atmosphere unlock and the readout/atmosphere toggles already on that
  screen.
