#!/usr/bin/env bash
# Repair Gradle caches after partial deletion (e.g. disk cleanup).
# Fixes: "Could not read workspace metadata ... kotlin-dsl/accessors/.../metadata.bin"
set -euo pipefail

GRADLE_USER_HOME="${GRADLE_USER_HOME:-$HOME/.gradle}"
CACHES_DIR="$GRADLE_USER_HOME/caches"

stop_gradle_daemons() {
  if [[ -f "android/gradlew" ]]; then
    (cd android && ./gradlew --stop >/dev/null 2>&1) || true
  elif command -v gradle >/dev/null 2>&1; then
    gradle --stop >/dev/null 2>&1 || true
  fi
}

repair_kotlin_dsl_cache() {
  local removed=0
  if [[ ! -d "$CACHES_DIR" ]]; then
    return 0
  fi

  while IFS= read -r -d '' accessors_dir; do
    local broken=0
    if compgen -G "$accessors_dir"/*/metadata.bin >/dev/null 2>&1; then
      while IFS= read -r -d '' meta; do
        if [[ ! -s "$meta" ]]; then
          broken=1
          break
        fi
      done < <(find "$accessors_dir" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
    else
      broken=1
    fi

    if [[ "$broken" -eq 1 ]]; then
      rm -rf "$(dirname "$accessors_dir")"
      echo "Gradle repair: removed broken kotlin-dsl cache at $(dirname "$accessors_dir")"
      removed=1
    fi
  done < <(find "$CACHES_DIR" -type d -path '*/kotlin-dsl/accessors' -print0 2>/dev/null)

  # After a full ~/.gradle/caches wipe, version dirs may exist without kotlin-dsl at all.
  # Only touch Gradle version caches (e.g. 8.14), not jars-9 / journal-1 / modules-2.
  for version_dir in "$CACHES_DIR"/*; do
    [[ -d "$version_dir" ]] || continue
    local name
    name="$(basename "$version_dir")"
    [[ "$name" =~ ^[0-9] ]] || continue
    if [[ ! -d "$version_dir/kotlin-dsl" && -n "$(ls -A "$version_dir" 2>/dev/null)" ]]; then
      rm -rf "$version_dir"
      echo "Gradle repair: removed incomplete cache $(basename "$version_dir")"
      removed=1
    fi
  done

  if [[ "$removed" -eq 0 ]]; then
    echo "Gradle repair: global cache looks OK"
  fi
}

repair_project_gradle() {
  if [[ -d "android/.gradle" ]]; then
    rm -rf android/.gradle
    echo "Gradle repair: cleared android/.gradle"
  fi
}

stop_gradle_daemons
repair_kotlin_dsl_cache
repair_project_gradle
