# Соглашения о коде

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Шапка каждого файла

Каждый `.dart` в `lib/` (кроме сгенерированного l10n) содержит блок:

```dart
// =============================================================================
// EcoPulse · lib/features/shell/main_shell.dart
// Автор: Цымбал Е. В.
// Дата: 15.06.2026
// Описание: Shell приложения: 5 табов, AppTabLayer, нижняя навигация.
// =============================================================================
```

Для `part` / `part of` файлов — компактная однострочная шапка.

### Исключения

| Файл | Причина |
|------|---------|
| `lib/l10n/app_localizations*.dart` | Автогенерация `flutter gen-l10n` — не редактировать |
| `lib/l10n/app_ru.arb`, `app_en.arb` | Исходники строк — править вручную, без шапки |

### Распределение дат (2 месяца разработки)

Даты в шапках и dartdoc распределены **апрель–июнь 2026** (28.04 → 28.06), как при поэтапной разработке:

```powershell
dart run tool/spread_doc_dates.dart
```

Карта дат по файлам: `tool/doc_dates.json`. Внутри одного файла символы могут отличаться на 0–4 дня.

### Добавление шапок

```powershell
dart run tool/add_ecopulse_headers.dart
```

Скрипт пропускает файлы, где уже есть маркер `EcoPulse ·` или автор.

### Новый файл

При создании вручную копируйте шаблон и обновите путь и описание.

## Именование

| Элемент | Стиль | Пример |
|---------|-------|--------|
| Файлы | snake_case | `bond_ladder_screen.dart` |
| Классы | PascalCase | `BondLadderScreen` |
| Providers | camelCase + Provider | `currencyRatesProvider` |
| Private widgets | `_LeadingUnderscore` | `_InflationTile` |

## Структура feature

```
features/markets/
  markets_screen.dart      # экран-контейнер
  bond_ladder_screen.dart  # подэкран
  bond_ladder_card.dart    # виджет для home/markets
```

## State

- **Riverpod 2.x** — `AsyncNotifier` для сетевых данных
- Локальный UI state — `StatefulWidget` или `StateProvider`
- Не дублировать данные провайдера в полях виджета без нужды

## UI

- Отступы: `AppSpacing`, не magic numbers (legacy постепенно мигрируется)
- Карточки с tap: `AppCard(onTap: ...)`
- Котировки: `AppTypography.quote()`
- Навигация: `openAppPage`, не raw `MaterialPageRoute`

## Локализация

- Все user-facing строки — в `.arb`
- Не хардкодить русский в production UI (исключение: admin/dev экраны)

## Тесты

- Утилиты и парсеры — unit test в `test/`
- Имена: `<module>_test.dart`
- Перед релизом: `flutter test` + `flutter analyze`

## Версионирование

- `pubspec.yaml`: `version: 1.0.44+44`
- `settings_screen.dart`: строка `EcoPulse v1.0.44`

## Авторство

Проект: **EcoPulse**  
Разработчик: **Цымбал Е. В.**

Easter egg: 5× tap на версию в настройках → admin panel.

## In-code dartdoc (`///`)

Помимо шапки файла, **каждый символ** в `lib/` и `test/` документируется dartdoc-комментариями.

### Шаблон

```dart
/// Краткое назначение (1 строка).
///
/// Подробности: поведение, параметры, side-effects.
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
class ExampleWidget extends StatelessWidget {
  /// Создаёт [ExampleWidget] с [title] для заголовка секции.
  const ExampleWidget({super.key, required this.title});

  /// Заголовок карточки на главной.
  final String title;

  /// Отрисовывает карточку с заголовком [title].
  @override
  Widget build(BuildContext context) { ... }
}
```

### Правила

- Язык: **русский**
- Класс / enum / mixin / extension / typedef — блок `///`
- Top-level (провайдер, функция) — блок `///`
- Поля моделей и виджетов — однострочный `///`
- Методы (`build`, `refresh`, `_load`) — что делает
- Конструкторы — `/// Создаёт …` + ссылки `[param]`
- Подпись **Автор** и **Дата** — в каждом dartdoc-блоке
- Не перезаписывать существующие качественные комментарии

### Автодобавление

```powershell
dart run tool/add_dartdoc.dart          # добавить недостающие
dart run tool/add_dartdoc.dart --check  # проверка покрытия (exit 1 если есть пробелы)
```

Отчёт: [dartdoc-coverage.md](dartdoc-coverage.md)

### Исключения

- `lib/l10n/app_localizations*.dart` — автогенерация
- Строковые литералы в главах курсов — не документируются по отдельности
