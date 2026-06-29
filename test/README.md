# EcoPulse test suite layout (mirrors lib/).

| Папка | Содержимое |
|-------|------------|
| `app/` | Smoke / formatters widget tests |
| `core/customization/` | Resolvers, presets, sync, model |
| `core/utils/` | Math, formatters, bond, portfolio utils |
| `core/content/` | Course registry |
| `data/models/` | JSON / model roundtrips |
| `features/assistant/` | Intent router, local responder |
| `features/portfolio/` | Allocation, rebalance, journal |
| `features/settings/` | Backup, cloud sync |

Запуск: `flutter test` (рекурсивно по всем подпапкам).

Скрипт сортировки: `tool/organize_tests.ps1`
