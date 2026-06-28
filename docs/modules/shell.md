# Shell и навигация

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Файлы

- `lib/features/shell/main_shell.dart` — 5 табов
- `lib/features/shell/app_gate.dart` — onboarding / PIN / биометрия
- `lib/features/shell/app_shell_shortcuts.dart` — горячие клавиши

## MainShell

Содержит массив экранов:

1. `HomeScreen`
2. `CurrencyScreen`
3. `InflationScreen`
4. `MarketsScreen`
5. `SettingsScreen`

Индекс таба хранится в `navigationIndexProvider` (Riverpod `StateProvider<int>`).

Все табы **монтируются одновременно** в `Stack` через `AppTabLayer` — состояние scroll сохраняется при переключении.

## AppGate

Проверяет:

- Первый запуск → onboarding
- PIN / биометрия (если включены)
- Затем → `MainShell`

## Горячие клавиши (web/desktop)

| Клавиша | Действие |
|---------|----------|
| `1` | Главная |
| `2` | Валюты |
| `3` | Инфляция |
| `4` | Рынки |
| `5` | Настройки |

## AssistantFab

Плавающая кнопка поверх shell — открывает AI-ассистент (см. [assistant.md](assistant.md)).
