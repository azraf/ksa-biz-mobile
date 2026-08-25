#!/usr/bin/env bash
# Launch Pixel_API_34 (if needed) and run the current Flutter app on Android.
#
# Usage (from any app folder):
#   ../scripts/run_android.sh
#   ../scripts/run_android.sh sales_app
#   ./run_dev.sh
#
# Extra args are passed to flutter run, e.g.:
#   ./run_dev.sh --dart-define=FOO=bar

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOBILEAPP_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
AVD_ID="${KSA_AVD:-Pixel_API_34}"
MAP_HERD_HOSTS="${KSA_MAP_HERD_HOSTS:-1}"
HERD_HOST="${KSA_HERD_HOST:-ksa-biz.test}"

resolve_app_dir() {
  if [[ $# -ge 1 && -f "$MOBILEAPP_ROOT/$1/pubspec.yaml" ]]; then
    cd "$MOBILEAPP_ROOT/$1"
    return
  fi
  if [[ -f "$(pwd)/pubspec.yaml" ]]; then
    return
  fi
  echo "Error: run from an app folder or pass app name (admin_app, monitor_app, order_app, sales_app)." >&2
  exit 1
}

android_device_id() {
  adb devices 2>/dev/null | awk '/^emulator-/{print $1; exit}'
}

emulator_booted() {
  [[ "$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" == "1" ]]
}

wait_for_emulator() {
  local timeout="${1:-180}"
  local elapsed=0

  echo "Waiting for emulator to boot..."
  adb wait-for-device >/dev/null 2>&1 || true

  until emulator_booted; do
    sleep 2
    elapsed=$((elapsed + 2))
    if [[ $elapsed -ge $timeout ]]; then
      echo "Timed out waiting for emulator boot (${timeout}s)." >&2
      exit 1
    fi
  done

  echo "Emulator ready."
}

launch_emulator() {
  if [[ -n "$(android_device_id)" ]]; then
    echo "Android emulator already running: $(android_device_id)"
    wait_for_emulator 30
    return
  fi

  echo "Starting Android emulator: $AVD_ID"
  if command -v flutter >/dev/null 2>&1; then
    flutter emulators --launch "$AVD_ID" >/dev/null &
  else
    emulator -avd "$AVD_ID" >/dev/null &
  fi

  wait_for_emulator
}

map_herd_hosts() {
  if [[ "$MAP_HERD_HOSTS" != "1" ]]; then
    return
  fi

  if ! adb root >/dev/null 2>&1; then
    echo "Note: could not adb root — skip Herd hosts mapping for $HERD_HOST."
    return
  fi

  adb remount >/dev/null 2>&1 || true

  if adb shell "grep -q '$HERD_HOST' /etc/hosts" 2>/dev/null; then
    echo "Herd host already mapped: $HERD_HOST"
    return
  fi

  if adb shell "echo '10.0.2.2 $HERD_HOST' >> /etc/hosts" 2>/dev/null; then
    echo "Mapped $HERD_HOST -> 10.0.2.2 on emulator."
  else
    echo "Note: could not map $HERD_HOST in emulator /etc/hosts."
  fi
}

resolve_app_dir "${1:-}"
APP_NAME="$(basename "$(pwd)")"
# shellcheck source=load_admin_secrets.sh
source "$SCRIPT_DIR/load_admin_secrets.sh"
echo "Running $APP_NAME on Android ($AVD_ID)..."

launch_emulator
map_herd_hosts

DEVICE_ID="$(android_device_id)"
if [[ -z "$DEVICE_ID" ]]; then
  echo "Error: no Android emulator detected after launch." >&2
  exit 1
fi

# Sourced: it exports JAVA_HOME and puts flutter on PATH for the steps below.
# shellcheck source=prepare_android_toolchain.sh
source "$SCRIPT_DIR/prepare_android_toolchain.sh" dev
flutter pub get
"$SCRIPT_DIR/patch_wakelock_plus.sh"

EXTRA_ARGS=("${KSA_DART_DEFINE_ARGS[@]:-}")

# Drop app name arg if it was a valid app folder name
if [[ $# -ge 1 && "$1" != "." && -f "$MOBILEAPP_ROOT/$1/pubspec.yaml" ]]; then
  shift
fi

if [[ "${KSA_LAUNCH_ONLY:-0}" == "1" ]]; then
  echo "Emulator ready: $DEVICE_ID"
  exit 0
fi

cat <<'EOF'

────────────────────────────────────────────────────────
  Debug session — hot reload is enabled

  • Save any .dart file in Cursor → app updates automatically
  • Or focus this terminal and press:
      r   hot reload   (fast — keeps app state)
      R   hot restart  (full reset — use after code-gen / init changes)
      q   quit

  Shared widgets & API code: packages/core/lib/ (reloads the same way)
────────────────────────────────────────────────────────

EOF

exec flutter run -d "$DEVICE_ID" "${EXTRA_ARGS[@]}" "$@"
