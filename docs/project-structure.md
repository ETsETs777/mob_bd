# EcoPulse — структура проекта

> Версия layout: 1.0.58+ · июнь 2026

## `lib/`

```
lib/
├── main.dart              # bootstrap (Hive, FCM, Supabase)
├── app.dart               # MaterialApp, theme, locale
│
├── core/                  # domain, services, utils (без UI-экранов)
│   ├── broker/
│   ├── cloud/
│   ├── constants/
│   ├── content/
│   ├── customization/
│   ├── motion/
│   ├── pro/
│   ├── services/
│   ├── theme/
│   └── utils/
│
├── data/                  # models, repositories, API clients
│   ├── models/
│   ├── repositories/
│   └── services/
│
├── providers/             # Riverpod (подпапки по доменам + stubs в корне)
│   ├── app/
│   ├── markets/
│   ├── portfolio/
│   ├── customization/
│   └── …
│
├── shared/                # общие виджеты и actions (не feature)
│   ├── app_actions.dart
│   ├── shared.dart        # barrel export
│   └── widgets/
│
├── features/              # экраны и feature-specific UI
│   ├── shell/             # AppGate, MainShell
│   ├── home/
│   ├── markets/
│   ├── portfolio/
│   ├── settings/
│   │   ├── panels/        # cloud, widget, layout, backup …
│   │   └── widgets/
│   ├── customization/
│   └── …
│
└── l10n/                  # app_ru.arb (template), app_en.arb, app_de.arb, app_it.arb
```

## `test/` (зеркало `lib/`)

```
test/
├── app/
├── core/          # customization/, utils/, content/
├── data/
├── features/      # portfolio/, settings/, shell/, assistant/, …
├── shared/        # CustomChartView
└── support/       # widget_test_harness.dart
```

## Правила

| Что | Куда |
|-----|------|
| Новый экран | `lib/features/<feature>/` |
| Общий виджет (2+ features) | `lib/shared/widgets/` |
| Riverpod state | `lib/providers/<domain>/` + stub `lib/providers/<name>.dart` |
| API / модели | `lib/data/` |
| Бизнес-логика без UI | `lib/core/` |
| Unit-тест | `test/` с тем же путём относительно домена |

## Обратная совместимость

- `lib/features/shared/` — re-export stubs → `lib/shared/`
- `lib/features/settings/*.dart` (panels) — stubs → `settings/panels/`
- `lib/providers/*.dart` — re-export stubs → `providers/<domain>/`

## Скрипты

- `tool/translate_arb.py` — перевод l10n
- `tool/archive/` — одноразовые миграции структуры (reorganize, organize_*)
