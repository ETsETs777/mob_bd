# Tooling scripts

| Script | Назначение |
|--------|------------|
| `organize_providers.ps1` | Разложить `lib/providers/` по подпапкам + re-export stubs |
| `fix_provider_imports.ps1` | Поправить глубину `../data`, `../core` после move |
| `fix_provider_cross_imports.ps1` | Cross-imports → `package:ecopulse/providers/...` |
| `add_dartdoc.dart` | Массовое добавление `///` |
| `add_ecopulse_headers.dart` | Шапки файлов EcoPulse |

**Не запускайте** `restructure_lib.ps1` — экспериментальный полный move (устарел).
