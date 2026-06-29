# Releases

APK/AAB собираются локально и не хранятся в git.

```powershell
flutter build apk --release --split-per-abi
```

Артефакты: `build/app/outputs/flutter-apk/`

Для публикации — GitHub Releases или другой канал дистрибуции.
