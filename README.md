# EcoPulse

Мобильный экономический дашборд на Flutter: валюты, инфляция, криптовалюты и акции с графиками в реальном времени.

> **План развития:** см. [docs/IMPROVEMENT_PLAN.md](docs/IMPROVEMENT_PLAN.md) — полная дорожная карта улучшений от v1.0 до v2.0+  
> **Документация:** см. [docs/README.md](docs/README.md) — архитектура, модули, design system (автор: Цымбал Е. В., апрель–июнь 2026)

## Возможности

- **Главная** — сводка USD/RUB, USD/EUR, Bitcoin, инфляция РФ/США, индекс IMOEX
- **Валюты** — курсы Frankfurter + MOEX, графики за 30 дней, конвертер с swap
- **Инфляция** — CPI по странам (World Bank), bar chart, детали по стране
- **Рынки** — топ-20 крипто (CoinGecko), акции MOEX (SBER, GAZP, IMOEX…), опционально US-акции (Finnhub)

## Источники данных

| Данные | API | Ключ |
|--------|-----|------|
| EUR, CNY, GBP, JPY | [Frankfurter](https://frankfurter.dev/) | Не нужен |
| USD/RUB, акции РФ | [MOEX ISS](https://iss.moex.com/iss/reference/) | Не нужен |
| Инфляция | [World Bank](https://data.worldbank.org/) | Не нужен |
| Криптовалюты | [CoinGecko](https://www.coingecko.com/en/api) | Рекомендуется (бесплатный Demo) |
| Акции США | [Finnhub](https://finnhub.io/) | Опционально (бесплатный) |

## Требования

- Flutter SDK 3.12+
- Android SDK + эмулятор или телефон с USB-отладкой
- Интернет на устройстве

## Быстрый старт

```powershell
# Добавить Flutter в PATH (если ещё не добавлен)
$env:Path = "C:\Users\9571\flutter\bin;" + $env:Path

cd C:\Users\9571\Desktop\mob
flutter pub get
```

### Запуск на эмуляторе Android Studio

> **Если эмулятор не запускается** с ошибкой `hardware acceleration` / `hypervisor driver`:
> 1. Android Studio → SDK Manager → SDK Tools → **Android Emulator Hypervisor Driver (installer)** ✓
> 2. Запустите от администратора:  
>    `C:\Users\9571\AppData\Local\Android\Sdk\extras\google\Android_Emulator_Hypervisor_Driver\silent_install.bat`
> 3. **Перезагрузите ПК**
> 4. Или включите в Windows: «Компоненты Windows» → **Windows Hypervisor Platform**
>
> Альтернатива: запустите AVD из **Android Studio → Device Manager → Play** (▶)

```powershell
# Список эмуляторов
flutter emulators

# Запуск эмулятора (пример)
flutter emulators --launch Pixel_10_Pro_XL

# Дождаться загрузки, затем:
flutter devices
flutter run
```

### Запуск на физическом телефоне

1. Включите **USB-отладку** на Android (Настройки → Для разработчиков)
2. Подключите USB-кабель
3. `adb devices` — телефон должен появиться в списке
4. `flutter run --release`

### Сборка APK

```powershell
flutter build apk --release
# APK: build\app\outputs\flutter-apk\app-release.apk

# Меньший размер (~15 MB):
flutter build apk --split-per-abi
# Используйте: app-arm64-v8a-release.apk
```

## Установка APK на телефон

1. Скопируйте `app-release.apk` на телефон (Telegram, USB, Google Drive)
2. Откройте файл на Android
3. Разрешите установку из неизвестных источников, если система спросит
4. Запустите **EcoPulse**

## API-ключи (опционально)

```powershell
flutter run --dart-define=COINGECKO_KEY=your_key --dart-define=FINNHUB_KEY=your_key
flutter build apk --release --dart-define=COINGECKO_KEY=your_key --dart-define=FINNHUB_KEY=your_key
```

Без ключей приложение работает: MOEX + Frankfurter + World Bank + CoinGecko (с пониженным лимитом).

## Структура проекта

```
lib/          # код Flutter-приложения
server/       # LAN-бэкенд (профиль, чаты)
docs/         # документация и планы
scripts/      # run-server.ps1, EcoPulse.bat
releases/     # готовые APK
test/         # тесты
```

Подробнее: [docs/architecture.md](docs/architecture.md) · [docs/file-index.md](docs/file-index.md)

## Offline mode

При отсутствии сети показываются последние закэшированные данные (Hive) с баннером «Offline mode».

## Что нового в v1.0.1

- Прогрессивная загрузка секций на главной
- Время последнего обновления
- Кнопка «О приложении» с статусом API
- Swap валют в конвертере
- Исправлен конвертер (TextEditingController)
- [docs/IMPROVEMENT_PLAN.md](docs/IMPROVEMENT_PLAN.md) — план развития
