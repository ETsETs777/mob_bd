# Главная

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Файлы

- `lib/features/home/home_screen.dart` — сборка секций
- `lib/features/home/economic_radar_card.dart` — радар 0–100
- `lib/features/home/news_feed_card.dart` — новости Finnhub
- `lib/features/home/bond_home_card.dart` — превью ОФЗ
- `lib/features/portfolio/portfolio_home_card.dart` — P&L портфеля
- `lib/features/learn/course_home_card.dart` — прогресс курса

## Как работает

1. `home_layout_provider` определяет **какие секции видны** (настройки layout).
2. Каждая секция — отдельный виджет с `AsyncValue.when` или статикой.
3. Pull-to-refresh вызывает `markRefreshed` + refresh нужных провайдеров.

## Economic Radar

`buildEconomicRadar()` в `core/utils/economic_radar.dart` считает score по осям:

- Валюты (USD/RUB trend)
- Ключевая ставка
- Рынки (IMOEX, fear/greed)
- Инфляция

Tap → `TimelineScreen` (лента macro-событий).

## Новости

Требует `FINNHUB_KEY`. Без ключа — hint с иконкой ключа.

## Demo badge

При `demoModeProvider` — badge «Demo» на AppBar.

## Easter egg

5× tap на подпись разработчика → переход в admin panel.
