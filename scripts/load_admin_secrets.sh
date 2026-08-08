#!/usr/bin/env bash
# Load API keys from admin_app/android/secrets.properties for all v1 apps.
# Expects MOBILEAPP_ROOT to be set by the caller.
# Exports KSA_DART_DEFINE_ARGS as an array variable for flutter --dart-define flags.
# Does not override keys already set in the environment (KSA_<KEY>).

if [[ -z "${MOBILEAPP_ROOT:-}" ]]; then
  echo "Error: MOBILEAPP_ROOT is required." >&2
  return 1 2>/dev/null || exit 1
fi

# shellcheck source=sync_admin_secrets.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/sync_admin_secrets.sh"

SECRETS_FILE="$MOBILEAPP_ROOT/admin_app/android/secrets.properties"
KSA_DART_DEFINE_ARGS=()

if [[ ! -f "$SECRETS_FILE" ]]; then
  echo "Note: API secrets not set ($SECRETS_FILE missing). Maps and other keyed features use fallback UI."
  return 0 2>/dev/null || exit 0
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%#*}"
  line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  [[ -z "$line" ]] && continue
  key="${line%%=*}"
  val="${line#*=}"
  key="$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  val="$(echo "$val" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  [[ -z "$key" || -z "$val" ]] && continue
  if [[ "$val" == "your_google_maps_api_key_here" ]]; then
    continue
  fi

  env_key="KSA_${key}"
  existing="$(printenv "$env_key" 2>/dev/null || true)"
  if [[ -n "$existing" ]]; then
    val="$existing"
    echo "API key $key: using $env_key from environment."
  fi

  KSA_DART_DEFINE_ARGS+=(--dart-define="$key=$val")
done < "$SECRETS_FILE"

if [[ ${#KSA_DART_DEFINE_ARGS[@]} -gt 0 ]]; then
  echo "API secrets: loaded from admin_app/android/secrets.properties (${#KSA_DART_DEFINE_ARGS[@]} dart-define flag(s))."
fi
