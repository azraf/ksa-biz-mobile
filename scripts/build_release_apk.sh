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
    admin_app) echo "ARM-AdminApp.apk" ;;
    monitor_app) echo "ARM-MonitorApp.apk" ;;
    order_app) echo "ARM-OrderApp.apk" ;;
    sales_app) echo "ARM-SalesApp.apk" ;;
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
    admin_app) names=(ARM-AdminApp.apk) ;;
    monitor_app) names=(ARM-MonitorApp.apk) ;;
    order_app) names=(ARM-OrderApp.apk ARM-SaleOrderApp.apk) ;;
    sales_app) names=(ARM-SalesApp.apk ARM-SalesPersonApp.apk) ;;
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
# shellcheck source=load_maps_api_key.sh
source "$SCRIPT_DIR/load_maps_api_key.sh"

# Drop app name arg if it was a valid app folder name
if [[ $# -ge 1 && "$1" != "." && -f "$MOBILEAPP_ROOT/$1/pubspec.yaml" ]]; then
  shift
fi

VERSION="$(read_pubspec_version)"
BUILD_NUMBER="${VERSION#*+}"
ARM_APK_NAME="$(resolve_arm_apk_name "$APP_NAME")"
APP_BUILTS_DIR="$MOBILEAPP_ROOT/app-builts"
FLUTTER_APK="$(pwd)/build/app/outputs/flutter-apk/app-release.apk"
OUTPUT_APK="$APP_BUILTS_DIR/$ARM_APK_NAME"

echo "Building release APK for $APP_NAME (version $VERSION)..."

"$SCRIPT_DIR/ensure_android_gradle_compat.sh"
flutter pub get
"$SCRIPT_DIR/patch_wakelock_plus.sh"
if [[ "${KSA_WAKELOCK_PATCH_APPLIED:-0}" == "1" ]]; then
  echo "wakelock_plus was patched — running flutter clean to refresh Android plugin build..."
  flutter clean
  flutter pub get
  "$SCRIPT_DIR/patch_wakelock_plus.sh"
fi

BUILD_ARGS=()
if [[ -n "${KSA_GOOGLE_MAPS_API_KEY:-}" ]]; then
  BUILD_ARGS+=(--dart-define=GOOGLE_MAPS_API_KEY="$KSA_GOOGLE_MAPS_API_KEY")
fi

flutter build apk --release "${BUILD_ARGS[@]}" "$@"

if [[ ! -f "$FLUTTER_APK" ]]; then
  echo "Error: expected APK not found at $FLUTTER_APK" >&2
  exit 1
fi

mkdir -p "$APP_BUILTS_DIR"
remove_arm_apk_outputs "$APP_NAME"
cp "$FLUTTER_APK" "$OUTPUT_APK"

cat <<EOF

────────────────────────────────────────────────────────
  Release APK ready

  App:     $APP_NAME
  Version: $VERSION
  Build:   $BUILD_NUMBER (versionCode — increment +N in pubspec.yaml each release)

  Copied to:
    $OUTPUT_APK

  Flutter build output:
    $FLUTTER_APK
────────────────────────────────────────────────────────

EOF
