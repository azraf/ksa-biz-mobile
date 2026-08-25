#!/usr/bin/env bash
# Shared Android toolchain prep for run_dev.sh / run_release.sh (see repo info.txt).
#
# Pins: AGP 8.11.1, Kotlin 2.2.20, Gradle 8.14, builtInKotlin=false, newDsl=false
# Usage:
#   source prepare_android_toolchain.sh dev      # dev builds (run_dev.sh)
#   source prepare_android_toolchain.sh release  # release builds (run_release.sh)
#
# Must be SOURCED, not executed: it exports JAVA_HOME and puts flutter on PATH,
# and a subprocess would throw both away.
set -euo pipefail

# Not SCRIPT_DIR — this file is sourced, and that name belongs to the caller.
TOOLCHAIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-dev}"

use_java17() {
  if command -v /usr/libexec/java_home >/dev/null 2>&1; then
    local jdk17
    jdk17="$(/usr/libexec/java_home -v 17 2>/dev/null || true)"
    if [[ -n "$jdk17" ]]; then
      export JAVA_HOME="$jdk17"
      export PATH="$JAVA_HOME/bin:$PATH"
      echo "Using JAVA_HOME=$JAVA_HOME for Gradle"
    fi
  fi
}

# Flutter is not on the PATH of a plain login shell here, so resolve it the
# same way we resolve the JDK rather than failing 60 lines later inside a
# build step.
use_flutter() {
  local candidate
  local candidates=(
    "${KSA_FLUTTER_BIN:-}"
    "$HOME/flutter/bin"
    "$HOME/development/flutter/bin"
    "/opt/homebrew/share/flutter/bin"
    "/usr/local/share/flutter/bin"
  )

  if command -v flutter >/dev/null 2>&1; then
    return
  fi

  for candidate in "${candidates[@]}"; do
    if [[ -n "$candidate" && -x "$candidate/flutter" ]]; then
      export PATH="$candidate:$PATH"
      echo "Using flutter from $candidate"
      return
    fi
  done

  echo "Error: flutter not found on PATH." >&2
  echo "  Add it to PATH, or set KSA_FLUTTER_BIN to its bin directory:" >&2
  echo "  KSA_FLUTTER_BIN=\$HOME/flutter/bin ./run_release.sh" >&2
  exit 1
}

use_java17
use_flutter

if [[ "$MODE" == "release" || "${KSA_GRADLE_REPAIR:-0}" == "1" ]]; then
  "$TOOLCHAIN_DIR/repair_gradle_cache.sh"
fi

"$TOOLCHAIN_DIR/ensure_android_gradle_compat.sh"
