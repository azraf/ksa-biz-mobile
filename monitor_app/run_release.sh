#!/usr/bin/env bash
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$(dirname "$APP_DIR")/scripts/build_release_apk.sh" "$(basename "$APP_DIR")" "$@"
