#!/usr/bin/env bash
# Apply legacy Android/Kotlin toolchain to every v2 app.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOBILEAPP_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

for app in sales_app admin_app monitor_app order_app; do
  app_dir="$MOBILEAPP_ROOT/$app"
  if [[ ! -f "$app_dir/pubspec.yaml" ]]; then
    echo "Skipping missing app: $app"
    continue
  fi
  echo "=== $app ==="
  (cd "$app_dir" && "$SCRIPT_DIR/ensure_android_gradle_compat.sh")
done
