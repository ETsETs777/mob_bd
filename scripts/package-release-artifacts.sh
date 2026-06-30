#!/usr/bin/env bash
# Package EcoPulse web + admin panel zips for GitHub Release.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-$(grep '^version:' "$ROOT/pubspec.yaml" | awk '{print $2}' | cut -d'+' -f1)}"
DIST="$ROOT/dist"

mkdir -p "$DIST"

if [[ -d "$ROOT/build/web" ]]; then
  (cd "$ROOT/build/web" && zip -r "$DIST/ecopulse-web-${VERSION}.zip" .)
  echo "Created ecopulse-web-${VERSION}.zip"
fi

if [[ -d "$ROOT/server/web_admin" ]]; then
  (cd "$ROOT/server/web_admin" && zip -r "$DIST/ecopulse-admin-web-${VERSION}.zip" .)
  echo "Created ecopulse-admin-web-${VERSION}.zip"
fi

if [[ -d "$ROOT/build/app/outputs/flutter-apk" ]]; then
  for apk in "$ROOT/build/app/outputs/flutter-apk"/*-release.apk; do
    [[ -f "$apk" ]] || continue
    abi="$(basename "$apk" | sed 's/app-//;s/-release.apk//')"
    cp "$apk" "$DIST/ecopulse-${VERSION}-${abi}.apk"
    echo "Copied ecopulse-${VERSION}-${abi}.apk"
  done
fi

if [[ -f "$ROOT/build/app/outputs/bundle/release/app-release.aab" ]]; then
  cp "$ROOT/build/app/outputs/bundle/release/app-release.aab" \
    "$DIST/ecopulse-${VERSION}.aab"
  echo "Copied ecopulse-${VERSION}.aab"
fi

ls -la "$DIST"
