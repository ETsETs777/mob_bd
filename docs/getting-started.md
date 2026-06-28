# Быстрый старт

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Требования

- Flutter SDK **3.12+**
- Dart **3.12+**
- Для Android: SDK + эмулятор или USB-отладка
- Для Web: Chrome

## Установка зависимостей

```powershell
cd C:\Users\9571\Desktop\mob
flutter pub get
```

## Запуск

### Web (удобно для разработки UI)

```powershell
flutter run -d chrome --web-port=9090
# или scripts\EcoPulse.bat web
```

### Android эмулятор

```powershell
flutter emulators
flutter emulators --launch <имя_AVD>
flutter run
```

### Release APK

```powershell
flutter build apk --release
# Результат: build\app\outputs\flutter-apk\app-release.apk
```

## API-ключи (опционально)

Без ключей работают MOEX, Frankfurter, World Bank и CoinGecko с базовым лимитом.

```powershell
flutter run --dart-define=COINGECKO_KEY=xxx --dart-define=FINNHUB_KEY=yyy
```

Ключи также можно ввести в **Настройки → API** или в скрытой admin-панели (10× tap на версию).

## Тесты и анализ

```powershell
flutter test
flutter analyze
```

## Локализация

Строки в `lib/l10n/app_ru.arb` и `app_en.arb`. После правок:

```powershell
flutter gen-l10n
```

## Демо-режим

В настройках можно включить **демо-режим** — приложение показывает mock-данные из `lib/data/demo/demo_fixtures.dart` без сети.
