# EcoPulse — структура проекта

> Автор: Цымбал Е. В. · июнь 2026

Цель: **feature-first** архитектура — каждый модуль изолирован, общий код в `core/` и `shared/`, state рядом с доменом.

## Дерево `lib/`

```
lib/
├── main.dart                 # Точка входа, bootstrap
├── app.dart                  # MaterialApp, тема, локаль
│
├── core/                     # Инфраструктура (без UI экранов)
│   ├── constants/            # API keys, каталоги, конфиг
│   ├── errors/
│   ├── motion/               # Анимации переходов
│   ├── services/             # Hive backup, notifications, widget
│   ├── theme/                # AppTheme, палитра, токены
│   ├── utils/                # formatters, math, analytics
│   └── customization/        # Домен кастомизации (resolvers, sync, presets)
│
├── data/                     # Общий слой данных
│   ├── demo/
│   ├── models/
│   ├── repositories/
│   └── services/             # Dio, cache, home server client
│
├── providers/                # Riverpod state (по доменам)
│   ├── app/                  # locale, theme, demo, security, navigation shell
│   ├── markets/              # stocks, watchlist, news, correlation
│   ├── portfolio/            # paper portfolio, journal, rebalance
│   ├── settings/             # api keys, cloud sync, digest
│   ├── alerts/
│   ├── profile/              # user profile, home server auth
│   ├── messages/
│   ├── learn/
│   ├── customization/        # UserCustomization + resolved providers
│   ├── assistant/
│   └── admin/
│   └── *.dart                # Re-export stubs (import path не меняется)
│
├── features/                 # UI + feature-логика
│   ├── shell/                # MainShell, AppGate
│   ├── home/
│   ├── markets/
│   ├── customization/        # Hub кастомизации (экран + панели)
│   ├── assistant/
│   ├── settings/
│   └── shared/               # Общие виджеты (→ постепенно в lib/shared/)
│
├── shared/                   # (план) UI без привязки к feature
└── l10n/                     # ARB + generated AppLocalizations
```

## Правила для нового кода

| Что добавляете | Куда класть |
|----------------|-------------|
| Новый экран | `lib/features/<module>/` |
| State модуля | `lib/providers/<module>/` + stub `lib/providers/<name>.dart` |
| API + cache | `lib/data/repositories/` + model в `data/models/` |
| Resolver / бизнес-логика кастомизации | `lib/core/customization/` |
| Общий виджет (2+ feature) | `lib/features/shared/widgets/` |
| Строки UI | `lib/l10n/app_ru.arb`, `app_en.arb` → `flutter gen-l10n` |
| Unit-тест | `test/<module>/` (зеркало feature) |

## Импорты

- **Внутри feature**: относительные `../` или `../../`
- **Между слоями**: `package:ecopulse/...` (предпочтительно для тестов)
- **Провайдеры**: старый путь `import '../../providers/watchlist_provider.dart'` продолжает работать через re-export

## Кастомизация (центральный модуль)

```
core/customization/     — domain: resolvers, sync, presets, bundle
providers/customization/  — state: customizationProvider, resolved*Provider
features/customization/ — UI: hub, panels, live preview
data/models/            — user_customization.dart (JSON schema v2)
```

Схема JSON: [customization-schema.md](customization-schema.md)

## Server

```
server/
├── lib/api/          # REST router
├── lib/auth/
├── lib/db/
└── lib/services/
```

## Тесты

```
test/
├── core/             # utils, resolvers
├── features/         # (план) widget/integration по модулям
└── *_test.dart       # unit-тесты top-level
```

Запуск: `flutter test` · CI: analyze + test + web build

## Миграция (roadmap)

1. ✅ `providers/` — подпапки + re-export stubs
2. ⬜ `shared/widgets/` — вынести из `features/shared/`
3. ⬜ `features/customization/` — split на `presentation/` + README
4. ⬜ `features/assistant/domain/` — сервисы из `core/services/assistant/`
5. ⬜ Тесты — зеркалировать `lib/features/`

Скрипты: `tool/organize_providers.ps1`, `tool/add_dartdoc.dart`
