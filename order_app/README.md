# Order App (Customer)

Customer-facing Flutter app for **shop**, **van**, and **importer** accounts. Browse the product catalog with customer-type pricing, place orders, submit manual order requests (shops), and manage profile.

Uses shared `packages/core` for API client, auth, models, and theme.

## Run

```bash
cd order_app
flutter pub get
flutter run
```

## Login accounts

| Account | Password | Role |
|---------|----------|------|
| `customer_shop@example.com` | `password` | Shop — catalog, orders, manual requests |
| `customer_van@example.com` | `password` | Van — catalog and orders |
| `customer_importer@example.com` | `password` | Importer — catalog and orders |

## API URL

Same rules as other KSA Biz apps (see `../README.md`):

| Build | Login screen | URL used |
|-------|--------------|----------|
| **Release** | Email + password only | Fixed production URL |
| **Debug** | Includes editable API URL field | Override or default |

Local Laravel (debug):

| Environment | API URL |
|-------------|---------|
| Android emulator | `http://10.0.2.2:8000/api/v1` |
| iOS simulator | `http://127.0.0.1:8000/api/v1` |
| Physical device | `http://<your-pc-lan-ip>:8000/api/v1` |

## Build APK (release)

```bash
cd order_app
./run_release.sh
```

APK output: `../app-builts/ARM-OrderApp.apk`

## Navigation

Persistent bottom navigation (`StatefulShellRoute`):

| Tab | Route | Features |
|-----|-------|----------|
| Catalog | `/catalog` | Product list with customer-type prices from API |
| Orders | `/orders` | Order history, create order with line items |
| Manual Orders | `/manual-orders` | Shop only — list own requests, create with notes |
| Profile | `/profile` | Account info, customer profile, sign out |

## Project structure

```
lib/
  app.dart                 # MaterialApp.router
  main.dart                # ProviderScope + SharedPreferences
  router/app_router.dart   # GoRouter + StatefulShellRoute
  providers/               # Auth, repositories, customer context
  features/                # Login, catalog, orders, manual orders, profile
  widgets/                 # Line items editor, product picker
  repositories/            # Product price by customer type
```
