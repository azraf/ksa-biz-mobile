#!/usr/bin/env bash
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$(dirname "$APP_DIR")/scripts/run_android.sh" "$(basename "$APP_DIR")" "$@"
