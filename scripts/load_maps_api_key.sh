#!/usr/bin/env bash
# Back-compat wrapper — all v1 apps load keys from admin_app via load_admin_secrets.sh.
# Expects MOBILEAPP_ROOT to be set by the caller.

# shellcheck source=load_admin_secrets.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/load_admin_secrets.sh"

# Legacy env var used by some tooling.
if [[ ${#KSA_DART_DEFINE_ARGS[@]} -gt 0 ]]; then
  for arg in "${KSA_DART_DEFINE_ARGS[@]}"; do
    if [[ "$arg" == --dart-define=GOOGLE_MAPS_API_KEY=* ]]; then
      export KSA_GOOGLE_MAPS_API_KEY="${arg#--dart-define=GOOGLE_MAPS_API_KEY=}"
      break
    fi
  done
fi
