<p align="center">
  <strong>EcoPulse</strong><br/>
  <em>Your economy in one pocket — currencies, markets, portfolio & AI</em>
</p>

<p align="center">
  <a href="releases/ecopulse-1.0.58-arm64-v8a.apk">📲 Download APK (arm64)</a>
  ·
  <a href="CHANGELOG.md">Changelog</a>
  ·
  <a href="docs/FULL_IMPROVEMENT.md">Roadmap</a>
  ·
  <a href="docs/README.md">Docs</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.58-blue?style=flat-square" alt="version"/>
  <img src="https://img.shields.io/badge/Flutter-3.12+-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/tests-213_passing-success?style=flat-square" alt="tests"/>
  <img src="https://img.shields.io/badge/languages-RU_EN_DE_IT-informational?style=flat-square" alt="languages"/>
  <img src="https://img.shields.io/badge/platform-Android-green?style=flat-square&logo=android" alt="Android"/>
</p>

---

## Что это

**EcoPulse** — мобильный fintech-дашборд на Flutter: курсы валют, инфляция, крипто и акции MOEX/US, бумажный портфель, облигации ОФЗ, AI-ассистент и глубокая кастомизация интерфейса. Работает офлайн на кэше, с PIN/биометрией и LAN home server.

> Автор: **Цымбал Е. В.** · 2025–2026

---

## Скачать и установить (Android)

| Сборка | Устройства | Файл | Размер |
|--------|------------|------|--------|
| **arm64-v8a** (рекомендуется) | Большинство телефонов с 2018+ | [ecopulse-1.0.58-arm64-v8a.apk](releases/ecopulse-1.0.58-arm64-v8a.apk) | ~30 MB |
| **armeabi-v7a** | Старые 32-bit Android | [ecopulse-1.0.58-armeabi-v7a.apk](releases/ecopulse-1.0.58-armeabi-v7a.apk) | ~29 MB |

1. Скачайте APK на телефон (GitHub, Telegram, USB).
2. Откройте файл → разрешите установку из неизвестных источников.
3. Запустите **EcoPulse**.

SHA256 (arm64): `7f5e3db0ea1838355cd7fa797c0df2e938514870aa3108cd87def1c33f66bce9` — [releases/README.md](releases/README.md)

---

## Возможности v1.0.58

### Экономика и рынки
- **Главная** — USD/RUB, BTC, IMOEX, инфляция, ключевая ставка ЦБ, сырьё, economic radar
- **С прошлого визита** — что изменилось в watchlist и ключевых метриках за ночь
- **Валюты** — MOEX + Frankfurter, графики 30d, конвертер, сравнение пар
- **Рынки** — 100+ crypto, 50 MOEX, 45 US stocks, облигации ОФЗ, yield curve, bond ladder
- **Heatmap секторов MOEX** — tap → фильтр акций по сектору
- **Свечи** — pinch-zoom, pan, volume, lazy-load истории, MA(7/25/99)

### Портфель и финансы
- Бумажный портфель **₽100 000**, несколько счетов (ИИС, USD, crypto)
- Журнал сделок, CSV import/export, rebalance, robo-advisor lite
- Налоговый отчёт (локальная оценка НДФЛ), цели накопления
- Live portfolio ticker (Binance WebSocket для crypto)

### Профиль и безопасность
- **Profile hub** в стиле банковского приложения
- PIN + биометрия, backup/restore JSON, cloud sync
- **Help & support** — FAQ, feedback, GitHub Issues
- Home server (LAN): чаты, Profile ID, sync кастомизации

### Кастомизация
- 7 тем + акцент + фон, presets + marketplace + deep links
- Widget preview, A/B theme preview, per-screen chart profiles
- 4 языка: **Русский · English · Deutsch · Italiano**

### AI и контент
- Gemini + локальный FAQ-ассистент, voice in/out
- Курсы по инвестированию, morning digest push
- Price alerts (фон каждые 15 мин), bond coupon reminders

---

## Скриншоты

| Home | Markets | Portfolio | Customization |
|:----:|:-------:|:---------:|:-------------:|
| *Pulse + radar* | *Crypto + MOEX* | *P&L + allocation* | *Themes + presets* |

> Скриншоты добавьте в `docs/screenshots/` при публикации в Store.

---

## Быстрый старт для разработчиков

```powershell
# Flutter в PATH
$env:Path = "C:\Users\9571\flutter\bin;" + $env:Path

cd C:\Users\9571\Desktop\mob
flutter pub get
flutter run
```

### Сборка release APK

```powershell
flutter build apk --release --split-per-abi
# → build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### API-ключи (опционально)

```powershell
flutter run --dart-define=COINGECKO_KEY=xxx --dart-define=FINNHUB_KEY=xxx --dart-define=GEMINI_KEY=xxx
```

Без ключей работают MOEX, Frankfurter, World Bank и CoinGecko (с лимитом).

| Ключ | Зачем |
|------|--------|
| CoinGecko | Стабильнее crypto API |
| Finnhub | US stocks + news + macro calendar |
| Gemini | Cloud AI-ассистент |
| Supabase | EcoPulse Cloud sync |
| T-Invest | Read-only брокерский портфель |

---

## Источники данных

| Данные | API | Ключ |
|--------|-----|------|
| USD/RUB, MOEX stocks/bonds | [MOEX ISS](https://iss.moex.com/iss/reference/) | — |
| FX majors | [Frankfurter](https://frankfurter.dev/) | — |
| CPI inflation | [World Bank](https://data.worldbank.org/) | — |
| Crypto | [CoinGecko](https://www.coingecko.com/en/api) | рекомендуется |
| US stocks | [Finnhub](https://finnhub.io/) | опционально |
| Key rate RU | CBR | — |

---

## Архитектура

```
lib/
├── core/           # services, customization, utils
├── data/           # models, repositories, API clients
├── features/       # UI screens by domain
├── providers/      # Riverpod (domain folders + stubs)
├── shared/         # cross-feature widgets
└── l10n/           # RU · EN · DE · IT

server/             # optional LAN backend (Dart)
test/               # 213 tests — mirrors lib/
docs/               # architecture, roadmap, release guides
releases/           # versioned APK for direct download
```

Подробнее: [docs/project-structure.md](docs/project-structure.md) · [docs/architecture.md](docs/architecture.md)

---

## Качество и CI

| Check | Status |
|-------|--------|
| `flutter test` | 213 tests |
| `flutter analyze lib` | 0 errors |
| `flutter build web` | OK |
| GitHub Actions | analyze + test + web on push |

---

## Roadmap

Актуальный план: **[docs/FULL_IMPROVEMENT.md](docs/FULL_IMPROVEMENT.md)**

Ближайшее: go_router, feature barrels, MOEX WebSocket live, Play Store release, iOS TestFlight.

---

## Лицензия и контрибьюции

Проект разрабатывается как personal/portfolio fintech app. Issues и PR приветствуются через [GitHub Issues](https://github.com/tsymbal/ecopulse/issues).

---

<p align="center">
  <strong>EcoPulse</strong> — economy pulse in real time<br/>
  <sub>v1.0.58 · Built with Flutter & Riverpod</sub>
</p>
