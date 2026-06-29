# Releases

APK/AAB не хранятся в git. Сборка локально или через GitHub Actions.

## Локально

```powershell
flutter build apk --release --split-per-abi
```

Артефакты: `build/app/outputs/flutter-apk/`

## GitHub Release (v1.0.45+)

1. Обновите `CHANGELOG.md` и версию в `pubspec.yaml`.
2. Закоммитьте и запушьте в `main`.
3. Создайте и запушьте тег:

```powershell
git tag v1.0.45
git push origin v1.0.45
```

Workflow `.github/workflows/release.yml` соберёт arm64 APK и создаст Release с телом из `CHANGELOG.md`.
