#!/usr/bin/env bash
# Extract the CHANGELOG section for [VERSION] into release_notes.md
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-$(grep '^version:' "$ROOT/pubspec.yaml" | awk '{print $2}' | cut -d'+' -f1)}"
OUT="${2:-$ROOT/release_notes.md}"

awk -v ver="$VERSION" '
  $0 ~ "^## \\[" ver "\\]" { capture=1; print; next }
  capture && /^## \[/ { exit }
  capture { print }
' "$ROOT/CHANGELOG.md" > "$OUT"

if [[ ! -s "$OUT" ]]; then
  echo "## EcoPulse $VERSION" > "$OUT"
  echo "" >> "$OUT"
  echo "See [CHANGELOG.md](CHANGELOG.md) for details." >> "$OUT"
fi

cat "$OUT"
