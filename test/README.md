# EcoPulse test suite layout (mirrors lib/)

| Папка | Содержимое |
|-------|------------|
| `app/` | Smoke / formatters widget tests |
| `core/customization/` | Resolvers, presets, sync, model |
| `core/utils/` | Math, formatters, bond, portfolio, moving_average |
| `core/content/` | Course registry |
| `data/` | Models, broker client |
| `features/assistant/` | Intent router, local responder |
| `features/portfolio/` | Allocation, rebalance, journal, tax |
| `features/settings/` | Backup, cloud sync |
| `features/shell/` | Hub navigation widget tests |
| `shared/` | CustomChartView |
| `features/profile/` | Profile hub |
| `support/` | `widget_test_harness.dart` |

Запуск: `flutter test --concurrency=1`

Скрипты миграции: `tool/archive/` (см. `tool/README.md`)
