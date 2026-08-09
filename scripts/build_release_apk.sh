#!/usr/bin/env bash
# Build a production (release) APK for a Flutter app in ksa-mobileapp.
#
# Usage (from any app folder):
#   ../scripts/build_release_apk.sh
#   ../scripts/build_release_apk.sh sales_app
#   ./run_release.sh
#
# Extra args are passed to flutter build apk, e.g.:
#   ./run_release.sh --split-per-abi

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOBILEAPP_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

resolve_app_dir() {
  if [[ $# -ge 1 && -f "$MOBILEAPP_ROOT/$1/pubspec.yaml" ]]; then
    cd "$MOBILEAPP_ROOT/$1"
    return
  fi
  if [[ -f "$(pwd)/pubspec.yaml" ]]; then
    return
  fi
  echo "Error: run from an app folder or pass app name (admin_app, monitor_app, sales_app, order_app)." >&2
  exit 1
}

read_pubspec_version() {
  local pubspec="pubspec.yaml"
  if [[ ! -f "$pubspec" ]]; then
    echo "unknown"
    return
  fi
  awk -F': ' '/^version:/{print $2; exit}' "$pubspec" | tr -d '[:space:]'
}

resolve_arm_apk_name() {
  case "$1" in
    admin_app) echo "ARM-AdminApp-v3.apk" ;;
    monitor_app) echo "ARM-MonitorApp-v3.apk" ;;
    order_app) echo "ARM-OrderApp-v3.apk" ;;
    sales_app) echo "ARM-SalesApp-v3.apk" ;;
    *)
      echo "Error: unknown app '$1' for ARM APK naming." >&2
      exit 1
  esac
}

# Remove current and legacy APK filenames so each release replaces the previous build.
remove_arm_apk_outputs() {
  local app="$1"
  local names=()

  case "$app" in
    admin_app) names=(ARM-AdminApp-v3.apk ARM-AdminApp-v3-arm32.apk) ;;
    monitor_app) names=(ARM-MonitorApp-v3.apk ARM-MonitorApp-v3-arm32.apk) ;;
    order_app) names=(ARM-OrderApp-v3.apk ARM-OrderApp-v3-arm32.apk ARM-SaleOrderApp-v3.apk) ;;
    sales_app) names=(ARM-SalesApp-v3.apk ARM-SalesApp-v3-arm32.apk ARM-SalesPersonApp-v3.apk) ;;
    *) return 0 ;;
  esac

  for name in "${names[@]}"; do
    if [[ -f "$APP_BUILTS_DIR/$name" ]]; then
      rm -f "$APP_BUILTS_DIR/$name"
      echo "Removed previous build: $APP_BUILTS_DIR/$name"
    fi
  done
}

resolve_app_dir "${1:-}"
APP_NAME="$(basename "$(pwd)")"
# shellcheck source=load_admin_secrets.sh
source "$SCRIPT_DIR/load_admin_secrets.sh"

# Drop app name arg if it was a valid app folder name
if [[ $# -ge 1 && "$1" != "." && -f "$MOBILEAPP_ROOT/$1/pubspec.yaml" ]]; then
  shift
fi

VERSION="$(read_pubspec_version)"
BUILD_NUMBER="${VERSION#*+}"
ARM_APK_NAME="$(resolve_arm_apk_name "$APP_NAME")"
APP_BUILTS_DIR="$MOBILEAPP_ROOT/app-builts"
FLUTTER_APK_DIR="$(pwd)/build/app/outputs/flutter-apk"
FLUTTER_APK_ARM64="$FLUTTER_APK_DIR/app-arm64-v8a-release.apk"
FLUTTER_APK_ARM32="$FLUTTER_APK_DIR/app-armeabi-v7a-release.apk"
OUTPUT_APK="$APP_BUILTS_DIR/$ARM_APK_NAME"
OUTPUT_APK_ARM32="$APP_BUILTS_DIR/${ARM_APK_NAME%.apk}-arm32.apk"
SYMBOLS_DIR="$APP_BUILTS_DIR/symbols/$APP_NAME-$VERSION"

echo "Building release APK for $APP_NAME (version $VERSION)..."

"$SCRIPT_DIR/prepare_android_toolchain.sh" release
flutter pub get
"$SCRIPT_DIR/patch_wakelock_plus.sh"
if [[ "${KSA_WAKELOCK_PATCH_APPLIED:-0}" == "1" ]]; then
  echo "wakelock_plus was patched — running flutter clean to refresh Android plugin build..."
  flutter clean
  flutter pub get
  "$SCRIPT_DIR/patch_wakelock_plus.sh"
fi

BUILD_ARGS=("${KSA_DART_DEFINE_ARGS[@]:-}")

# App key + build number feed the in-app update banner (AppUpdateNotice).
APP_KEY="${APP_NAME%_app}"

mkdir -p "$SYMBOLS_DIR"
flutter build apk --release --split-per-abi \
  --target-platform android-arm,android-arm64 \
  --split-debug-info="$SYMBOLS_DIR" \
  --dart-define=KSA_BUILD_NUMBER="$BUILD_NUMBER" \
  --dart-define=KSA_APP_KEY="$APP_KEY" \
  "${BUILD_ARGS[@]}" "$@"

if [[ ! -f "$FLUTTER_APK_ARM64" || ! -f "$FLUTTER_APK_ARM32" ]]; then
  echo "Error: expected split APKs not found in $FLUTTER_APK_DIR" >&2
  exit 1
fi

mkdir -p "$APP_BUILTS_DIR"
remove_arm_apk_outputs "$APP_NAME"
cp "$FLUTTER_APK_ARM64" "$OUTPUT_APK"
cp "$FLUTTER_APK_ARM32" "$OUTPUT_APK_ARM32"

cat <<EOF

────────────────────────────────────────────────────────
  Release APKs ready (split per ABI)

  App:     $APP_NAME
  Version: $VERSION
  Build:   $BUILD_NUMBER (versionCode — increment +N in pubspec.yaml each release)

  Copied to:
    $OUTPUT_APK          (arm64 — modern phones, primary download)
    $OUTPUT_APK_ARM32    (arm32 — older phones only)

  Crash symbols (keep for this release):
    $SYMBOLS_DIR
────────────────────────────────────────────────────────

EOF
