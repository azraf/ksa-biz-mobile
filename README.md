# KSA Biz – Mobile Apps (Flutter)

This is the sole mobile tree for ongoing development (v3 lineage: modern UI/UX redesign + performance). See `doc/V3_DESIGN_SYSTEM.md` for the design system (per-app brand colors, bundled Manrope/Noto fonts with BN/AR fallbacks, tokens, shared building blocks). Apps version from `3.0.0+4`; release APKs get a `-v3` suffix.

This folder contains four Flutter apps that consume the Laravel API:

- **packages/core** – Shared package: API client, auth, DTOs, theme, **offline sync layer** (SQLite + queue), permissions, contact launcher.
- **admin_app** – Admin mobile app with full CRUD and offline support.
- **monitor_app** – Read-only dashboards for monitor role users.
- **sales_app** – Sales person: van stock, manual orders, orders, dues.
- **order_app** – Customer app (shop, van, importer).

## API URL

**Production default:** `https://ksabiz.makewebsmart.com/api/v1`

| Build | Login screen | URL used |
|-------|--------------|----------|
| **Release** (`flutter build apk --release`) | Email + password only | Fixed production URL |
| **Debug** (`flutter run`) | Includes editable API URL field | Override or default |

For local Laravel during debug:

| Environment | API URL |
|-------------|---------|
| Android emulator | `http://10.0.2.2:8000/api/v1` |
| iOS simulator | `http://127.0.0.1:8000/api/v1` |
| Physical device | `http://<your-pc-lan-ip>:8000/api/v1` |

## API keys (Google Maps and other secrets)

All apps read API keys from **one place**:

| Platform | File |
|----------|------|
| Android + Flutter `--dart-define` | `admin_app/android/secrets.properties` |
| iOS native (Maps SDK) | `admin_app/ios/Flutter/Secrets.xcconfig` (auto-synced from `secrets.properties`) |

Setup:

```bash
cp admin_app/android/secrets.properties.example admin_app/android/secrets.properties
# Edit GOOGLE_MAPS_API_KEY (and any other KEY=value entries)
```

`./run_dev.sh` and `./run_release.sh` load every `KEY=value` from that file as `--dart-define=KEY=value`. Android Gradle uses the same file via `config/android/admin_secrets.gradle.kts`. iOS builds include `admin_app/ios/Flutter/Secrets.xcconfig` from every app’s `Debug.xcconfig` / `Release.xcconfig`.

Do **not** copy secrets into `sales_app`, `monitor_app`, or `order_app` — those folders only reference `admin_app`.

Override at build time with env vars `KSA_<KEY>` (e.g. `KSA_GOOGLE_MAPS_API_KEY`).

## Device permissions (both apps)

Declared in Android `main/AndroidManifest.xml` and iOS `Info.plist`:

| Permission | Purpose |
|------------|---------|
| Internet | API access (must be in `main/` for release APK) |
| Location | Shop GPS capture when adding or visiting a shop |
| Camera | Shop photo, video recording |
| Microphone | Voice/video messages for manual orders |
| Photo library / media read | Pick existing photos and recordings |

**Phone calls** open the system dialer via `tel:` (no `CALL_PHONE` permission). **WhatsApp** opens the host device app via `wa.me` deep links (no WhatsApp API).

Shared helpers in `packages/core`:

- `AppPermissions` – runtime permission requests
- `ContactLauncher` – call, WhatsApp, SMS
- `ContactActionButtons` – reusable call/WhatsApp UI

GPS capture uses `geolocator` in each app with `AppPermissions.requestLocation()`.

### Future apps checklist

When adding `order_app`:

- Depend on `packages/core` (fixed API URL, permissions, contact launcher)
- Include `INTERNET` in Android `main/AndroidManifest.xml` from day one
- Include macOS `com.apple.security.network.client`
- Copy Android `<queries>` for `tel:`, `smsto:`, `wa.me`, WhatsApp packages
- Add all iOS usage-description strings before using location/camera/mic
- Do not expose an editable API URL field in release builds

---

## Release APK (all apps)

From any app folder, one command builds a production APK (fixed API URL, no debug login defaults):

```bash
cd admin_app          # or sales_app, monitor_app, order_app
./run_release.sh
```

The script runs `flutter pub get` and `flutter build apk --release`, then copies the APK to:

`app-builts/ARM-<AppName>.apk` — e.g. `app-builts/ARM-AdminApp.apk`, `ARM-SalesApp.apk`, `ARM-MonitorApp.apk`, `ARM-OrderApp.apk`

If an APK with that name already exists in `app-builts/`, it is removed and replaced with the new build (legacy filenames from older app names are cleaned up too).

Flutter’s default output remains at `build/app/outputs/flutter-apk/app-release.apk`.

Optional: pass extra Flutter build flags, e.g. `./run_release.sh --split-per-abi`.

Rebuild and redeploy APKs after permission or networking changes.

---

## Admin app

### Run

```bash
cd admin_app
./run_dev.sh
```

`./run_dev.sh` launches the **Pixel_API_34** emulator if needed and runs the app on Android (avoids macOS/Xcode prompts). **Hot reload on save** is enabled — edit `.dart` files and press `Cmd+S` to see changes instantly (see [`doc/MACOS_DEV_TESTING.md`](../doc/MACOS_DEV_TESTING.md#hot-reload-see-changes-instantly)).

### Login

| Account | Password | Notes |
|---------|----------|-------|
| `admin@example.com` | `password` | Admin-only; other roles are rejected |

### Offline mode

The admin app supports **offline-first** for:

- **Orders** – create/cancel offline; synced when back online (pending badge on list)
- **Expenses** – create/update offline; synced when back online
- **Reports** – last fetched data cached locally; shown with “cached” indicator when offline

### Build APK (release)

```bash
cd admin_app
./run_release.sh
```

### Features

- Dashboard (KPIs, pending sync, quick links)
- **Catalog** – Products, categories, tags, brands, units, promotions
- **Customers** – Types, vans, importers, shops (GPS + photo capture on shop form)
- **Sales** – Sales persons (call/WhatsApp), orders, manual orders (recordings), invoices
- **Shipping** – Countries, suppliers, containers, purchases
- **Expenses** – Categories, expenses (offline-capable), vehicles
- **Inventory** – Warehouse stock, van stock, load van
- **Reports** – Sales, profit, expenses, expense summary (cached offline)
- **Users** – User list/create/edit with roles

---

## Sales app

### Run

```bash
cd sales_app
./run_dev.sh
```

### Login accounts

| Account | Password | App behavior |
|---------|----------|--------------|
| `salesperson@example.com` | `password` | Auto-linked to dedicated salesperson profile |
| `admin@example.com` | `password` | Pick any salesperson to act as |
| `monitor@example.com` | `password` | Pick any salesperson to act as |

### Build APK (release)

```bash
cd sales_app
./run_release.sh
```

See the root **DEVELOPMENT_PLAN.md** for full API details.

---

## Order app (customer)

### Run

```bash
cd order_app
flutter pub get
flutter run
```

### Login accounts

| Account | Password | App behavior |
|---------|----------|--------------|
| `customer_shop@example.com` | `password` | Shop — catalog, orders, manual requests |
| `customer_van@example.com` | `password` | Van — catalog and orders |
| `customer_importer@example.com` | `password` | Importer — catalog and orders |

### Build APK (release)

```bash
cd order_app
./run_release.sh
```

See `order_app/README.md` for navigation and project structure.

---

## Monitor app

### Run

```bash
cd monitor_app
./run_dev.sh
```

### Login

| Account | Password | Notes |
|---------|----------|-------|
| `monitor@example.com` | `password` | Monitor role only; read-only access |

### Build APK (release)

```bash
cd monitor_app
./run_release.sh
```

### Features (read-only)

- Dashboard (KPIs: sales, profit, expenses, orders)
- Sales – orders list and detail
- Inventory – van stock by sales person
- Expenses – expense list
- Reports – sales, profit, expense, expense summary
