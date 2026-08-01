#!/usr/bin/env bash
# Ensure Flutter migrator flags are present for AGP 8.11 + kotlin-android plugin.
# Without these, release builds can succeed but the app may fail to start (white screen).
set -euo pipefail

GRADLE_PROPS="android/gradle.properties"
if [[ ! -f "$GRADLE_PROPS" ]]; then
  echo "Note: $GRADLE_PROPS not found — skipping Gradle compat check."
  exit 0
fi

ensure_prop() {
  local key="$1"
  local value="$2"
  if grep -qE "^[[:space:]]*${key}=" "$GRADLE_PROPS"; then
    return 0
  fi
  {
    echo ""
    echo "# Added by ensure_android_gradle_compat.sh (Flutter AGP/Kotlin compat)"
    echo "${key}=${value}"
  } >> "$GRADLE_PROPS"
  echo "Gradle compat: added ${key}=${value} to $GRADLE_PROPS"
}

ensure_prop "android.builtInKotlin" "false"
ensure_prop "android.newDsl" "false"
