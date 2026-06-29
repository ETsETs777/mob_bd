# Tooling scripts

| Script | Назначение |
|--------|------------|
| `translate_arb.py` | Перевод `.arb` (de, it и др.) через шаблон `app_ru.arb` |
| `add_dartdoc.dart` | Массовое добавление `///` (`--check` для проверки) |
| `add_ecopulse_headers.dart` | Шапки файлов EcoPulse + `docs/file-index.md` |
| `spread_doc_dates.dart` | Распределить даты в dartdoc → `doc_dates.json` |

Запуск Dart-скриптов: `dart run tool/<script>.dart`  
Перевод l10n: `python tool/translate_arb.py`

## Архив (`tool/archive/`)

Одноразовые скрипты миграции структуры (уже применены):

- `reorganize_structure.ps1` — shared, panels, stubs, test moves
- `organize_providers.ps1` — провайдеры по доменам
- `organize_tests.ps1` — тесты по папкам
