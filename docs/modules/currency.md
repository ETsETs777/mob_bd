# Валюты

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Файлы

- `lib/features/currency/currency_screen.dart`
- `lib/data/repositories/currency_repository.dart`
- `lib/providers/app_providers.dart` → `currencyRatesProvider`

## Экран

### Секции

1. **Курсы** — группы Major / Europe / Asia / EM / MOEX (`groupCurrencyRates`)
2. **MetricCard** — пара, значение, % изменения, sparkline 30d
3. **Сравнение** — overlay график выбранных пар
4. **Конвертер** — amount, from/to, комиссия %, результат с tabular figures
5. **История конвертаций** — локально в Hive

### Layout

- Узкий: один `ListView`
- Широкий landscape ≥720px: две колонки (курсы | конвертер+график)

## Источники

- Frankfurter — кросс-курсы к EUR
- MOEX ISS — USD/RUB и RUB-пары

## Провайдеры конвертера

| Provider | Назначение |
|----------|------------|
| `converterAmountProvider` | Сумма |
| `converterFromProvider` | Из валюты |
| `converterToProvider` | В валюту |
| `converterFeeProvider` | Комиссия % |

## Quick convert

Парсинг строк вида `100 usd in rub` — `core/utils/quick_convert.dart`, тесты в `test/quick_convert_test.dart`.
