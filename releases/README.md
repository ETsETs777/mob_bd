# Releases

Готовые APK для установки без сборки. Версионированные файлы `ecopulse-*.apk` **хранятся в git** для прямой загрузки.

## v1.0.58 (2026-06-29)

| Файл | ABI | Размер | Назначение |
|------|-----|--------|------------|
| [ecopulse-1.0.58-arm64-v8a.apk](ecopulse-1.0.58-arm64-v8a.apk) | arm64-v8a | ~30 MB | Современные телефоны (2018+) |
| [ecopulse-1.0.58-armeabi-v7a.apk](ecopulse-1.0.58-armeabi-v7a.apk) | armeabi-v7a | ~29 MB | Старые 32-bit устройства |

### SHA256

```text
ecopulse-1.0.58-arm64-v8a.apk     7f5e3db0ea1838355cd7fa797c0df2e938514870aa3108cd87def1c33f66bce9
ecopulse-1.0.58-armeabi-v7a.apk   a90ee83e8d211e0673cc31ea287f810c7ae486df2b3aeafc47390306f97385fa
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
