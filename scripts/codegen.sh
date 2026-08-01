#!/usr/bin/env bash
# Regenerate Isar schemas and other codegen for ksa-mobileapp-v2.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Running build_runner in packages/core..."
cd "$ROOT/packages/core"
dart run build_runner build --delete-conflicting-outputs

echo "Regenerating l10n..."
cd "$ROOT/packages/l10n"
flutter gen-l10n

echo "Done."
