# Документация EcoPulse

> **Автор проекта:** Цымбал Е. В.  
> **Версия приложения:** 1.0.44  
> **Период разработки:** апрель–июнь 2026

EcoPulse — Flutter-приложение (Android, iOS, Web): экономический дашборд с валютами, инфляцией, рынками, облигациями и бумажным портфелем.

---

## Оглавление

| Документ | О чём |
|----------|--------|
| [Быстрый старт](getting-started.md) | Установка, запуск, API-ключи, сборка |
| [Архитектура](architecture.md) | Слои, Riverpod, навигация, кэш |
| [Design system](design-system.md) | Токены, типографика, motion, AppCard |
| [Источники данных](data-sources.md) | MOEX, Frankfurter, World Bank, CoinGecko… |
| [Модули](modules/README.md) | Подробно по каждому разделу UI |
| [Соглашения о коде](code-conventions.md) | Шапки файлов, стиль, тесты |
| [Индекс файлов](file-index.md) | Все `.dart` в `lib/` с описанием |

---

## Структура репозитория

```
mob/
├── lib/                  # Исходный код Dart/Flutter
│   ├── main.dart         # Точка входа
│   ├── app.dart          # MaterialApp
│   ├── core/             # Тема, утилиты, сервисы, контент курсов
│   ├── data/             # Модели, репозитории, API, кэш Hive
│   ├── features/         # UI по фичам (home, currency, markets…)
│   ├── l10n/             # Локализация RU/EN
│   └── providers/        # Riverpod-провайдеры
├── test/                 # Unit- и widget-тесты
├── docs/                 # Эта документация
├── tool/                 # Скрипты (шапки файлов)
├── IMPROVEMENT_PLAN.md   # Дорожная карта развития
└── README.md             # Краткий README проекта
```

---

## Как читать код

1. Начните с [`lib/main.dart`](../lib/main.dart) → [`lib/app.dart`](../lib/app.dart) → [`lib/features/shell/app_gate.dart`](../lib/features/shell/app_gate.dart) → [`lib/features/shell/main_shell.dart`](../lib/features/shell/main_shell.dart).
2. Данные идут через [`lib/providers/app_providers.dart`](../lib/providers/app_providers.dart) → репозитории в `lib/data/repositories/`.
3. У каждого `.dart` файла в `lib/` есть **шапка** с автором, датой и назначением (см. [code-conventions.md](code-conventions.md)).

---

## Связанные материалы

- [IMPROVEMENT_PLAN.md](../IMPROVEMENT_PLAN.md) — план фич v1.0 → v2.0
- [README.md](../README.md) — краткое описание для GitHub
