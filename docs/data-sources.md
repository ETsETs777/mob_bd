# Источники данных

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Сводная таблица

| Данные | API | Ключ | Репозиторий |
|--------|-----|------|-------------|
| EUR, GBP, JPY… | [Frankfurter](https://frankfurter.dev/) | — | `CurrencyRepository` |
| USD/RUB, MOEX акции/облигации | [MOEX ISS](https://iss.moex.com/) | — | `CurrencyRepository`, `MarketRepository` |
| Инфляция CPI | [World Bank](https://data.worldbank.org/) | — | `InflationRepository` |
| Ключевая ставка ЦБ | cbr.ru | — | `CbrRepository` |
| Криптовалюты | [CoinGecko](https://www.coingecko.com/en/api) | Demo key | `MarketRepository` |
| US акции, новости | [Finnhub](https://finnhub.io/) | Free key | `MarketRepository` |
| AI-ассистент | Google Gemini | API key | `GeminiClient` |

## Передача ключей

```powershell
flutter run --dart-define=COINGECKO_KEY=... --dart-define=FINNHUB_KEY=... --dart-define=GEMINI_KEY=...
```

Или через UI: **Настройки → API keys** (сохраняется в Hive через `ApiKeysStore`).

## Кэширование

Каждый репозиторий:

1. Проверяет `force` и TTL кэша
2. При успехе — пишет JSON в Hive
3. При ошибке — читает последний кэш

Ключи кэша — в методах `CacheService` / константах репозитория.

## MOEX ISS

Используется для:

- Котировки акций (SBER, GAZP, IMOEX…)
- Облигации ОФЗ (доходность, погашение, купоны)
- USD/RUB на MOEX

Парсинг: `lib/data/services/moex_parser.dart` (свечи, секции, колонки).

## CoinGecko

- Топ монет с market cap
- Sparkline 7d
- Lazy load: первые 50, кнопка «Ещё» до 150

## Finnhub

- US акции (если ключ задан)
- General news на главной
- Macro calendar (события)

Без ключа — секции скрыты или показывают hint.

## World Bank

Инфляция по странам — индикатор `FP.CPI.TOTL.ZG`, последний доступный год.

## Демо-режим

`lib/data/demo/demo_fixtures.dart` — статические данные для всех провайдеров при `demoModeProvider == true`.

## Offline

При отсутствии сети UI показывает закэшированные значения и баннер «данные могут быть устаревшими».
