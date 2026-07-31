# ARM Monitor(M)

Read-only Flutter app for **monitor** role users. View dashboards, orders, van stock, expenses, and reports without create/edit actions.

## Run

```bash
cd monitor_app
flutter pub get
flutter run
```

## Login

| Account | Password | Notes |
|---------|----------|-------|
| `monitor@example.com` | `password` | Monitor role required; admin/salesperson accounts are rejected |

## API URL

| Build | Login screen | URL used |
|-------|--------------|----------|
| **Release** | Email + password only | Fixed production URL |
| **Debug** | Includes editable API URL field | Override or default |

Production default: `https://ksabiz.makewebsmart.com/api/v1`

For local Laravel during debug, use the same URLs as other apps (see `../README.md`).

## Build APK (release)

```bash
cd monitor_app
flutter pub get
flutter build apk --release
```

APK output: `monitor_app/build/app/outputs/flutter-apk/app-release.apk`

## Features (read-only)

- **Dashboard** – KPIs: sales, profit, expenses, orders, pending manual orders
- **Sales** – Orders list and order detail
- **Inventory** – Van stock by sales person
- **Expenses** – Expense list with detail sheet
- **Reports** – Sales, profit, expense, and expense summary reports

Uses shared `packages/core` for API client, models, and theme.
