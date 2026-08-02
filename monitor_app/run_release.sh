#!/usr/bin/env bash
# Release APK — pins AGP 8.11.1 / Kotlin 2.2.20 / Gradle 8.14 (see repo info.txt).
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$(dirname "$APP_DIR")/scripts/build_release_apk.sh" "$(basename "$APP_DIR")" "$@"
