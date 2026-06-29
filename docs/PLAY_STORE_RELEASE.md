# Play Store release guide

## Prerequisites

- Google Play Developer account ($25 one-time)
- Release signing keystore (not debug)
- `docs/PLAY_STORE_LISTING.md` copy and screenshots

## 1. Signing

Create a keystore (once):

```bash
keytool -genkey -v -keystore ecopulse-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias ecopulse
```

Create `android/key.properties` (gitignored):

```properties
storePassword=***
keyPassword=***
keyAlias=ecopulse
storeFile=../ecopulse-release.jks
```

Wire into `android/app/build.gradle.kts` release `signingConfig` (replace debug signing before store upload).

## 2. Build App Bundle

```bash
flutter build appbundle --release \
  --dart-define=FIREBASE_PROJECT_ID=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

Output: `build/app/outputs/bundle/release/app-release.aab`

GitHub Actions (tag `v*`) also builds AAB — see `.github/workflows/release.yml`.

## 3. Play Console

1. **Create app** → default language English, add Russian
2. **Release → Production → Create release** → upload AAB
3. **Store presence** → paste listing from `docs/PLAY_STORE_LISTING.md`
4. **App content** → privacy policy URL, ads (No), target audience
5. **Data safety** → declare local + optional cloud sync per listing doc

## 4. Metadata files (optional Fastlane)

```
store/
  metadata/
    en-US/
      title.txt
      short_description.txt
      full_description.txt
    ru-RU/
      title.txt
      short_description.txt
      full_description.txt
```

Extract first lines from `PLAY_STORE_LISTING.md` into these files when using `fastlane supply`.

## 5. Versioning

- `pubspec.yaml`: `version: x.y.z+build`
- `versionCode` = build number (must increase each upload)
- Tag git: `git tag v1.0.46 && git push origin v1.0.46` for CI release

## 6. Post-release

- Monitor Android vitals (crashes, ANR)
- Reply to store reviews
- Update `CHANGELOG.md` and `FULL_IMPROVEMENT.md`
