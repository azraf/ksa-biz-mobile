#!/usr/bin/env bash
# Shared Android toolchain prep for run_dev.sh / run_release.sh (see repo info.txt).
#
# Pins: AGP 8.11.1, Kotlin 2.2.20, Gradle 8.14, builtInKotlin=false, newDsl=false
# Usage:
#   prepare_android_toolchain.sh          # dev builds (run_dev.sh)
#   prepare_android_toolchain.sh release  # release builds (run_release.sh)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

use_java17

if [[ "$MODE" == "release" || "${KSA_GRADLE_REPAIR:-0}" == "1" ]]; then
  "$SCRIPT_DIR/repair_gradle_cache.sh"
fi

"$SCRIPT_DIR/ensure_android_gradle_compat.sh"
