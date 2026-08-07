#!/usr/bin/env bash
# Dev run — pins AGP 8.11.1 / Kotlin 2.2.20 / Gradle 8.14 (see repo info.txt).
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$(dirname "$APP_DIR")/scripts/run_android.sh" "$(basename "$APP_DIR")" "$@"
