#!/usr/bin/env bash
# Legacy Android/Kotlin toolchain for Flutter release builds (see repo info.txt).
#
# - android.builtInKotlin=false / android.newDsl=false
# - AGP 8.11.1, Kotlin 2.2.20, Gradle 8.14
# - app module uses kotlin-android + kotlinOptions (not kotlin { compilerOptions })
set -euo pipefail

GRADLE_PROPS="android/gradle.properties"
SETTINGS="android/settings.gradle.kts"
WRAPPER="android/gradle/wrapper/gradle-wrapper.properties"
APP_BUILD="android/app/build.gradle.kts"

TARGET_AGP="8.11.1"
TARGET_KOTLIN="2.2.20"
TARGET_GRADLE="gradle-8.14-all.zip"

sed_inplace() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

ensure_prop() {
  local key="$1"
  local value="$2"
  if grep -qE "^[[:space:]]*${key}=" "$GRADLE_PROPS"; then
    if ! grep -qE "^[[:space:]]*${key}=${value}[[:space:]]*$" "$GRADLE_PROPS"; then
      sed_inplace "s/^[[:space:]]*${key}=.*/${key}=${value}/" "$GRADLE_PROPS"
      echo "Gradle compat: corrected ${key}=${value} in $GRADLE_PROPS"
    fi
    return 0
  fi
  {
    echo ""
    echo "# Added by ensure_android_gradle_compat.sh (Flutter AGP/Kotlin compat)"
    echo "${key}=${value}"
  } >> "$GRADLE_PROPS"
  echo "Gradle compat: added ${key}=${value} to $GRADLE_PROPS"
}

pin_settings() {
  if [[ ! -f "$SETTINGS" ]]; then
    return 0
  fi

  local changed=0
  if ! grep -q "id(\"com.android.application\") version \"${TARGET_AGP}\"" "$SETTINGS"; then
    sed_inplace "s/id(\"com.android.application\") version \"[^\"]*\"/id(\"com.android.application\") version \"${TARGET_AGP}\"/" "$SETTINGS"
    changed=1
  fi
  if ! grep -q "id(\"org.jetbrains.kotlin.android\") version \"${TARGET_KOTLIN}\"" "$SETTINGS"; then
    sed_inplace "s/id(\"org.jetbrains.kotlin.android\") version \"[^\"]*\"/id(\"org.jetbrains.kotlin.android\") version \"${TARGET_KOTLIN}\"/" "$SETTINGS"
    changed=1
  fi

  if [[ "$changed" -eq 1 ]]; then
    echo "Gradle compat: pinned AGP ${TARGET_AGP} + Kotlin ${TARGET_KOTLIN} in $SETTINGS"
  fi
}

pin_wrapper() {
  if [[ ! -f "$WRAPPER" ]]; then
    return 0
  fi

  local target_url="distributionUrl=https\\://services.gradle.org/distributions/${TARGET_GRADLE}"
  if grep -qF "$target_url" "$WRAPPER"; then
    return 0
  fi

  sed_inplace "s|distributionUrl=.*|${target_url}|" "$WRAPPER"
  echo "Gradle compat: pinned Gradle ${TARGET_GRADLE} in $WRAPPER"
}

ensure_legacy_kotlin_app_build() {
  if [[ ! -f "$APP_BUILD" ]]; then
    return 0
  fi

  if grep -q 'id("kotlin-android")' "$APP_BUILD"; then
    if grep -qE 'kotlin[[:space:]]*\{|compilerOptions' "$APP_BUILD"; then
      echo "Error: $APP_BUILD mixes kotlin-android with new kotlin { compilerOptions } DSL." >&2
      echo "Use kotlinOptions { jvmTarget = ... } like sales_app/android/app/build.gradle.kts" >&2
      exit 1
    fi
    return 0
  fi

  if grep -qE 'kotlin[[:space:]]*\{|compilerOptions' "$APP_BUILD"; then
    echo "Error: $APP_BUILD uses new Kotlin DSL." >&2
    echo "Switch to kotlin-android plugin + kotlinOptions (see sales_app/android/app/build.gradle.kts)." >&2
    exit 1
  fi

  echo "Error: $APP_BUILD is missing id(\"kotlin-android\") plugin." >&2
  exit 1
}

ensure_gradle_wrapper() {
  local wrapper_jar="android/gradle/wrapper/gradle-wrapper.jar"
  if [[ -f "$wrapper_jar" && -x "android/gradlew" ]]; then
    return 0
  fi

  local template_root
  template_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/sales_app/android"
  if [[ ! -f "$template_root/gradle/wrapper/gradle-wrapper.jar" ]]; then
    echo "Note: sales_app Gradle wrapper missing — run flutter build once from sales_app." >&2
    return 0
  fi

  mkdir -p android/gradle/wrapper
  cp "$template_root/gradle/wrapper/gradle-wrapper.jar" "$wrapper_jar"
  cp "$template_root/gradlew" "$template_root/gradlew.bat" android/
  chmod +x android/gradlew
  echo "Gradle compat: restored gradlew + wrapper jar from sales_app"
}

if [[ ! -f "$GRADLE_PROPS" ]]; then
  echo "Note: $GRADLE_PROPS not found — skipping Gradle compat check."
  exit 0
fi

ensure_prop "android.builtInKotlin" "false"
ensure_prop "android.newDsl" "false"
pin_settings
pin_wrapper
ensure_gradle_wrapper
ensure_legacy_kotlin_app_build
