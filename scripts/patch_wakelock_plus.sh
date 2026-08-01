#!/usr/bin/env bash
# wakelock_plus <=1.7.0: Pigeon Kotlin output omits `package`, and plugin sources
# import message types from the default package. Both break Android release builds.
set -euo pipefail

PUB_CACHE="${PUB_CACHE:-$HOME/.pub-cache}"
PACKAGE_LINE='package dev.fluttercommunity.plus.wakelock'
PLUGIN_DIR='android/src/main/kotlin/dev/fluttercommunity/plus/wakelock'
PATCHED=0

patch_generated_messages() {
  local gen_file="$1"
  if grep -q "^${PACKAGE_LINE}$" "$gen_file"; then
    return 0
  fi

  local tmp
  tmp="$(mktemp)"
  awk -v pkg="$PACKAGE_LINE" '
    { print }
    /@file:Suppress/ && !done {
      print ""
      print pkg
      done = 1
    }
  ' "$gen_file" > "$tmp"
  mv "$tmp" "$gen_file"
  PATCHED=1
  echo "Patched wakelock_plus Kotlin package in: $gen_file"
}

patch_invalid_imports() {
  local kotlin_file="$1"
  if ! grep -qE '^import (IsEnabledMessage|ToggleMessage|WakelockPlusApi)$' "$kotlin_file"; then
    return 0
  fi

  local tmp
  tmp="$(mktemp)"
  grep -v -E '^import (IsEnabledMessage|ToggleMessage|WakelockPlusApi)$' "$kotlin_file" > "$tmp"
  mv "$tmp" "$kotlin_file"
  PATCHED=1
  echo "Removed invalid default-package imports in: $kotlin_file"
}

for plugin_root in "$PUB_CACHE"/hosted/pub.dev/wakelock_plus-*; do
  [[ -d "$plugin_root" ]] || continue
  plugin_kotlin_dir="$plugin_root/$PLUGIN_DIR"
  gen_file="$plugin_kotlin_dir/WakelockPlusMessages.g.kt"
  [[ -f "$gen_file" ]] && patch_generated_messages "$gen_file"
  if [[ -d "$plugin_kotlin_dir" ]]; then
    for kotlin_file in "$plugin_kotlin_dir"/*.kt; do
      [[ -f "$kotlin_file" ]] || continue
      [[ "$kotlin_file" == "$gen_file" ]] && continue
      patch_invalid_imports "$kotlin_file"
    done
  fi
done

if [[ "$PATCHED" -eq 0 ]]; then
  echo "wakelock_plus Kotlin patch: nothing to do."
else
  export KSA_WAKELOCK_PATCH_APPLIED=1
fi
