# Рынки и облигации

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Файлы

- `lib/features/markets/markets_screen.dart` — хаб
- `lib/features/markets/market_asset_row.dart` — строка актива
- `lib/core/utils/bond_analytics.dart` — расчёты ОФЗ

## Вкладки Markets

| Tab | Содержимое |
|-----|------------|
| Акции | MOEX + US (Finnhub) |
| Крипто | CoinGecko, lazy load |
| Облигации | ОФЗ + corporate catalog |
| Watchlist | из `watchlist_provider` |

Tap на актив → `AssetPreviewSheet` → детали / добавить в портфель.

## Аналитика облигаций

### Кривая доходности ОФЗ

- `OfzYieldCurveScreen` / `OfzYieldCurveChart`
- Crosshair при hover/touch
- Zoom: scroll, pinch, double-tap reset
- ≥720px: chart + `BondYieldCurveTable` side-by-side

### Bond Ladder

- `BondLadderScreen` — группировка по годам погашения
- Accordion по годам, анимация bar grow
- Wide: 2 колонки

### Bond Calendar

- Купоны и погашения
- `BondCalendarSidebar` на широких экранах
- `BondCouponReminderService` — локальные push

## Hero-переходы

`openBondAnalyticsPage` + `BondAnalyticsHeroTitle` — shared axis + Hero tag `type:id`.

## Deep links

`bond_analytics_deep_link.dart` — открытие ladder/calendar/yield из assistant actions.

## Ключевые функции (`bond_analytics.dart`)

| Функция | Назначение |
|---------|------------|
| `buildOfzYieldCurve` | Точки кривой YTM × maturity |
| `buildBondLadderByYear` | Ladder buckets |
| `buildBondCalendarEvents` | События купон/ maturity |
| `portfolioCouponIncomeEstimate` | Оценка купонного дохода |

Тесты: `test/bond_analytics_test.dart`
