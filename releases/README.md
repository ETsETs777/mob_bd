# Releases

Готовые APK для установки без сборки. Версионированные файлы `ecopulse-*.apk` **хранятся в git** для прямой загрузки.

## v1.0.58 (2026-06-29)

| Файл | ABI | Размер | Назначение |
|------|-----|--------|------------|
| [ecopulse-1.0.58-arm64-v8a.apk](ecopulse-1.0.58-arm64-v8a.apk) | arm64-v8a | ~31.5 MB | Современные телефоны (2018+) |
| [ecopulse-1.0.58-armeabi-v7a.apk](ecopulse-1.0.58-armeabi-v7a.apk) | armeabi-v7a | ~29.8 MB | Старые 32-bit устройства |

### SHA256

```text
ecopulse-1.0.58-arm64-v8a.apk     63e146d68dbcebf0389a2a5e4c8610988315eb1f72c45c33fdf4e5c093c5e8db
ecopulse-1.0.58-armeabi-v7a.apk   65fc98c7309f8c0d755007eb568f4fcd3aaacda5092467bff896fe4871ff0ba4
```

Проверка локально:

```powershell
Get-FileHash releases\ecopulse-1.0.58-arm64-v8a.apk -Algorithm SHA256
```

## Сборка из исходников

```powershell
flutter build apk --release --split-per-abi
```

Артефакты: `build/app/outputs/flutter-apk/`

## GitHub Release (тег)

```powershell
git tag v1.0.58
git push origin v1.0.58
```

Workflow `.github/workflows/release.yml` соберёт APK/AAB и создаст GitHub Release с notes из `CHANGELOG.md`.
