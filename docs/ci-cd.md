# CI/CD

GitHub Actions pipelines for EcoPulse mobile app, Flutter web, and Home Server admin panel.

## Workflows

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| [`.github/workflows/flutter_ci.yml`](../.github/workflows/flutter_ci.yml) | Push/PR → `main`/`master` | Flutter analyze, test, integration test, web build; server analyze + test; CI artifacts |
| [`.github/workflows/release.yml`](../.github/workflows/release.yml) | Git tag `v*` (e.g. `v1.0.58`) | Full test suite → web + APK + AAB + admin zip → GitHub Release |

## CI (every push / PR)

```
Flutter job                    Server job
├── pub get                    ├── dart pub get
├── gen-l10n                   ├── dart analyze
├── flutter analyze            └── dart test
├── flutter test
├── integration_test
├── flutter build web
└── artifact: ecopulse-web     └── artifact: ecopulse-admin-web
```

On **push** to main, artifacts are kept 7 days:

- `ecopulse-web` — `build/web/` (Flutter web app)
- `ecopulse-admin-web` — `server/web_admin/` (static admin panel)

## Release (git tag)

1. Bump `version:` in [`pubspec.yaml`](../pubspec.yaml) and add a section to [`CHANGELOG.md`](../CHANGELOG.md).
2. Commit and tag (tag must match pubspec version):

```powershell
git tag v1.0.58
git push origin v1.0.58
```

3. Workflow runs:

```
test (Flutter + server)
  → build web
  → build APK (split per ABI) + AAB
  → package dist/
  → GitHub Release
```

### Release assets

| File | Description |
|------|-------------|
| `ecopulse-{version}-arm64-v8a.apk` | Android 64-bit (most phones) |
| `ecopulse-{version}-armeabi-v7a.apk` | Android 32-bit |
| `ecopulse-{version}-x86_64.apk` | Emulators / x86 devices |
| `ecopulse-{version}.aab` | Google Play upload |
| `ecopulse-web-{version}.zip` | Flutter web build |
| `ecopulse-admin-web-{version}.zip` | Admin panel static files for Home Server |

Release notes are extracted from the matching `CHANGELOG.md` section via [`scripts/extract-changelog-section.sh`](../scripts/extract-changelog-section.sh).

### Deploy admin panel

Unpack on the Home Server host next to the Dart server:

```bash
unzip ecopulse-admin-web-1.0.58.zip -d /opt/ecopulse/server/web_admin/
# restart server — static files served at /admin/
```

The server resolves `server/web_admin/` automatically ([`admin_static.dart`](../server/lib/api/admin_static.dart)).

## Local packaging

Same scripts as CI:

```bash
flutter build web --release
flutter build apk --release --split-per-abi
flutter build appbundle --release
bash scripts/package-release-artifacts.sh
```

Output: `dist/`

## Signing (Play Store)

Release APK/AAB from CI use **debug signing** unless you configure `android/key.properties` in a private fork or add secrets to the workflow. For store uploads, build locally with a release keystore — see [`docs/PLAY_STORE_RELEASE.md`](PLAY_STORE_RELEASE.md).
