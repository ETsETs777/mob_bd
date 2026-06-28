# Настройки

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Файлы

- `lib/features/settings/settings_screen.dart`
- `lib/features/settings/home_layout_settings.dart`
- `lib/features/settings/profile_backup_widgets.dart`
- `lib/features/admin/admin_panel_screen.dart`

## Разделы настроек

| Секция | Что делает |
|--------|------------|
| Профиль | Имя, аватар |
| Тема | Light / Dark / System, палитры |
| Язык | RU / EN |
| Layout главной | Вкл/выкл секций |
| API keys | CoinGecko, Finnhub, Gemini |
| Уведомления | Утренняя сводка, price alerts |
| Backup | Export/import JSON профиля + портфеля |
| Демо-режим | Mock данные |
| О приложении | Версия, автор **Цымбал Е. В.** |

## Admin panel

**10× tap** на строку версии → `AdminPanelScreen`:

- просмотр кэша
- сброс flags
- dev shortcuts

## Безопасность

- PIN / биометрия через `local_auth`
- Настройки в Hive

## Backup format

`BackupPayload` — JSON с версией схемы для миграций.

Тест: `test/backup_test.dart`
