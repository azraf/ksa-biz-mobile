#!/usr/bin/env bash
# Sync admin_app/ios/Flutter/Secrets.xcconfig from admin_app/android/secrets.properties.
# Android secrets.properties is the single source of truth for all v1 apps.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOBILEAPP_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SECRETS_FILE="$MOBILEAPP_ROOT/admin_app/android/secrets.properties"
IOS_SECRETS="$MOBILEAPP_ROOT/admin_app/ios/Flutter/Secrets.xcconfig"

if [[ ! -f "$SECRETS_FILE" ]]; then
  return 0 2>/dev/null || exit 0
fi

tmp="$(mktemp)"
{
  echo "// Generated from admin_app/android/secrets.properties — edit secrets.properties only."
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ -z "$line" ]] && continue
    key="${line%%=*}"
    val="${line#*=}"
    key="$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    val="$(echo "$val" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ -z "$key" || -z "$val" ]] && continue
    if [[ ! "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
      continue
    fi
    printf '%s=%s\n' "$key" "$val"
  done < "$SECRETS_FILE"
} > "$tmp"

if [[ ! -f "$IOS_SECRETS" ]] || ! cmp -s "$tmp" "$IOS_SECRETS"; then
  mv "$tmp" "$IOS_SECRETS"
  echo "Synced iOS secrets: admin_app/ios/Flutter/Secrets.xcconfig"
else
  rm -f "$tmp"
fi
