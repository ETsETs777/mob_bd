# Tooling scripts

| Script | Назначение |
|--------|------------|
| `organize_providers.ps1` | Разложить `lib/providers/` по подпапкам + re-export stubs |
| `organize_tests.ps1` | Разложить `test/` по `app/`, `core/`, `features/`, `data/` |
| `add_dartdoc.dart` | Массовое добавление `///` (`--check` для проверки) |
| `add_ecopulse_headers.dart` | Шапки файлов EcoPulse + `docs/file-index.md` |
| `spread_doc_dates.dart` | Распределить даты в dartdoc → `doc_dates.json` |

Запуск Dart-скриптов: `dart run tool/<script>.dart`
