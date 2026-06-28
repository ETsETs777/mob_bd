# Инфляция

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Файлы

- `lib/features/inflation/inflation_screen.dart`
- `lib/data/repositories/inflation_repository.dart`
- `lib/core/utils/inflation_math.dart` — purchasing power
- `lib/core/utils/inflation_chart_utils.dart` — выравнивание лет

## Вкладки экрана

1. **Страны** — список CPI по странам World Bank
2. **Ставка vs инфляция** — overlay ключевой ставки ЦБ и инфляции РФ
3. **Калькуляторы** — вклад, ипотека, сценарии

## Плитка страны (`_InflationTile`)

- `AppCard` с hover
- Trailing: % инфляции (tabular)
- Subtitle: purchasing power — «1000₽ в 2010 → X₽ сегодня»

## Детальный экран

`InflationDetailScreen` — bar chart истории + список по годам.

Навигация через `openAppPage`.

## Дедупликация

`_dedupeHistoryByYear` — убирает дубли лет в dropdown (fix v1.0.40).

## Данные

World Bank indicator `FP.CPI.TOTL.ZG` — годовая инфляция %.
