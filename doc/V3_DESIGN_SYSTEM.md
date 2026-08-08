# V3 Design System

Branch `version-3` (worktree `ksa-mobileapp-v3/`). V3 = v1 + UI/UX redesign + performance. The v2 Isar work stays parked on `version-2`.

## Brand

One shared design language, one accent per app (`AppBrand` in `packages/core/lib/theme/app_theme.dart`):

| App | Brand | Seed | Rationale |
|---|---|---|---|
| admin_app | `AppBrand.admin` | `#4053B4` indigo | authority / back office |
| sales_app | `AppBrand.sales` | `#0E7490` petrol | field sales |
| order_app | `AppBrand.order` | `#C2410C` burnt orange | customer facing |
| monitor_app | `AppBrand.monitor` | `#6D28D9` violet | analytics / read-only |

Wired in each `app.dart`: `theme: AppTheme.light(AppBrand.x), darkTheme: AppTheme.dark(AppBrand.x)`. All four apps support dark mode (monitor gained it in v3).

## Typography

Bundled in `packages/core/assets/fonts/` (offline-first, no runtime fetching):
- **Manrope** 400–800 — Latin (EN)
- **Noto Sans Bengali** 400–700 — BN fallback
- **Noto Sans Arabic** 400–700 — AR fallback (RTL)

Families are package-namespaced: `packages/core/Manrope`. The theme sets family + fallbacks globally; never set `fontFamily` per-widget.

## Tokens (`packages/core/lib/theme/app_colors.dart`)

- `AppColors.success/warning/pending/danger/offline(context)` + `…Container(context)` — brightness-aware status colors, ≥4.5:1 on their containers in both modes. **Never use `Colors.*` in feature code.**
- `AppSpacing` 4/8/12/16/24/32 · `AppRadii` 10/12/16/24 · `AppDurations` 150/250/350ms.

## Component look (all via ThemeData — don't restyle locally)

Flat surfaces, no shadows: tinted scaffold, white/elevated cards with hairline borders (radius 16), filled inputs (radius 12 — **never add inline `border: OutlineInputBorder()`**), 48dp buttons (radius 12), pill-indicator NavigationBar (height 68), floating snackbars, drag-handle bottom sheets (top radius 24), InkSparkle ripple. Page transitions are the Flutter 3.44 defaults (predictive back on Android, Cupertino on iOS).

## Shared building blocks (`packages/core/lib/widgets/v3_building_blocks.dart`)

- `KpiCard(title, value, icon, subtitle?, caption?, onTap?)` — dashboard stat card, RTL-aware chevron
- `SectionHeader(title, actionLabel?, onAction?)`
- `LoginHero(icon, title, subtitle?)` — brand header on login screens
- `NoticeCard(kind: info|warning|offline|danger|success, …)` — sync/cached/offline notices
- `IconBadge(icon)` — tinted rounded icon square

Plus upgraded `StatusChip` (token-based, dark-safe) and existing `SkeletonDashboard`/`SkeletonListTile` for loading states (prefer skeletons over full-screen spinners).

## Rules

1. Colors only via `Theme.of(context).colorScheme` or `AppColors` tokens.
2. Both themes always — check every screen in light *and* dark.
3. RTL: `EdgeInsetsDirectional`, start/end alignment; test in Arabic.
4. Touch targets ≥48dp; text styles from `textTheme`, not manual sizes.
5. Release rules from `doc/MOBILE_UPGRADE.md` still apply: same applicationIds, same keystore, versionCode must keep increasing (v3 starts at `3.0.0+4`), never rename `ksa_biz_offline.db`. V3 APKs get a `-v3` suffix (`scripts/build_release_apk.sh`).
