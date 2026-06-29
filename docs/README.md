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
| [Домашний сервер](home-server.md) | LAN-бэкенд: профиль, чаты, тест на ПК |
| [Архитектура](architecture.md) | Слои, Riverpod, навигация, кэш |
| [Design system](design-system.md) | Токены, типографика, motion, AppCard |
| [Источники данных](data-sources.md) | MOEX, Frankfurter, World Bank, CoinGecko… |
| [Модули](modules/README.md) | Подробно по каждому разделу UI |
| [Соглашения о коде](code-conventions.md) | Шапки файлов, стиль, тесты |
| [Индекс файлов](file-index.md) | Все `.dart` в `lib/` с описанием |
| [План развития](IMPROVEMENT_PLAN.md) | Дорожная карта v1.0 → v2.0 |
| [Полный план улучшений](FULL_IMPROVEMENT.md) | Актуальный свод: сделано / P0–P3 / фазы |
| [Roadmap v2](ROADMAP_V2.md) | Аккаунт, админка, backend |
| [UI-библиотеки](DESIGN_LIBRARIES.md) | Пакеты и визуальный план |

---

## Структура репозитория

```
mob/
├── lib/                  # Исходный код Dart/Flutter
├── server/               # Home Server (SQLite, JWT, чаты)
├── test/                 # Unit- и widget-тесты
├── docs/                 # Эта документация
├── scripts/              # EcoPulse.bat, run-server.ps1
├── releases/             # APK для установки
├── tool/                 # Скрипты (шапки файлов)
└── README.md             # Краткий README проекта
```

---

## Как читать код

1. Начните с [`lib/main.dart`](../lib/main.dart) → [`lib/app.dart`](../lib/app.dart) → [`lib/features/shell/app_gate.dart`](../lib/features/shell/app_gate.dart) → [`lib/features/shell/main_shell.dart`](../lib/features/shell/main_shell.dart).
2. Данные идут через [`lib/providers/app_providers.dart`](../lib/providers/app_providers.dart) → репозитории в `lib/data/repositories/`.
3. У каждого `.dart` файла в `lib/` есть **шапка** с автором, датой и назначением (см. [code-conventions.md](code-conventions.md)).

---

## Связанные материалы

- [IMPROVEMENT_PLAN.md](IMPROVEMENT_PLAN.md) — план фич v1.0 → v2.0
- [README.md](../README.md) — краткое описание для GitHub
