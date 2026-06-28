# Портфель

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Файлы

- `lib/features/portfolio/paper_portfolio_screen.dart`
- `lib/providers/paper_portfolio_provider.dart`
- `lib/core/utils/portfolio_math.dart`
- `lib/features/portfolio/portfolio_allocation_pie.dart`

## Бумажный портфель

- Стартовый капитал **100 000 ₽**
- Позиции: акции, крипто, облигации
- P&L в RUB с учётом текущих котировок из провайдеров

## Добавление позиции

- Из `AssetPreviewSheet` → «Купить»
- `AddPositionSheet` — количество, цена

## Аллокация

`buildPortfolioAllocation()` — группировка по классам активов.

UI:

- `PortfolioAllocationPie` — полный pie на экране портфеля
- `PortfolioAllocationMini` — мини-pie на главной

## Экспорт

CSV через `portfolioToCsv` + `share_plus`.

## Backup

Позиции входят в JSON backup (`BackupService`).

## Тесты

- `test/portfolio_math_test.dart`
- `test/portfolio_allocation_test.dart`
- `test/portfolio_export_test.dart`
