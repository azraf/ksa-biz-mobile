#!/usr/bin/env bash
# Load KSA_GOOGLE_MAPS_API_KEY from admin_app/android/secrets.properties for map-enabled apps.
# Expects MOBILEAPP_ROOT and APP_NAME to be set by the caller.
# Skips order_app. Does not override an already-exported KSA_GOOGLE_MAPS_API_KEY.

if [[ "${APP_NAME:-}" == "order_app" ]]; then
  return 0 2>/dev/null || exit 0
fi

if [[ -n "${KSA_GOOGLE_MAPS_API_KEY:-}" ]]; then
  echo "Google Maps API key: using KSA_GOOGLE_MAPS_API_KEY from environment."
  return 0 2>/dev/null || exit 0
fi

SECRETS_FILE="${MOBILEAPP_ROOT:?}/admin_app/android/secrets.properties"
if [[ ! -f "$SECRETS_FILE" ]]; then
  echo "Note: Google Maps API key not set ($SECRETS_FILE missing). Embedded maps use fallback UI."
  return 0 2>/dev/null || exit 0
fi

KEY="$(grep -E '^[[:space:]]*GOOGLE_MAPS_API_KEY=' "$SECRETS_FILE" | head -1 | cut -d= -f2- | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
if [[ -z "$KEY" || "$KEY" == "your_google_maps_api_key_here" ]]; then
  echo "Note: GOOGLE_MAPS_API_KEY is empty in $SECRETS_FILE. Embedded maps use fallback UI."
  return 0 2>/dev/null || exit 0
fi

export KSA_GOOGLE_MAPS_API_KEY="$KEY"
echo "Google Maps API key: loaded from admin_app/android/secrets.properties"
