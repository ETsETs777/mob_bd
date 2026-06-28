# Design system

> Автор: Цымбал Е. В. · апрель–июнь 2026

EcoPulse использует единую систему отступов, радиусов, типографики и анимаций.

## Файлы

| Файл | Содержимое |
|------|------------|
| `lib/core/theme/app_tokens.dart` | `AppSpacing`, `AppRadii`, `AppBreakpoints` |
| `lib/core/theme/app_typography.dart` | `AppTypography.quote()` — tabular figures |
| `lib/core/theme/app_palette.dart` | Цвета: accent, positive, negative, surface |
| `lib/core/theme/app_theme.dart` | `ThemeData`, Google Fonts |
| `lib/core/motion/app_motion.dart` | Длительности, curves, маршруты |
| `lib/features/shared/widgets/app_card.dart` | Карточка с hover |
| `lib/features/shared/widgets/app_hover.dart` | Hover на web/desktop |
| `lib/features/shared/widgets/app_segmented_control.dart` | Сегментированный переключатель |

## Spacing (`AppSpacing`)

```dart
AppSpacing.xs   // 4
AppSpacing.sm   // 8
AppSpacing.md   // 16  — page, card
AppSpacing.lg   // 24  — section
AppSpacing.xl   // 32
AppSpacing.page // = md, padding экранов
```

## Radii (`AppRadii`)

```dart
AppRadii.card   // 16 — Card, InkWell
AppRadii.sheet  // 20 — bottom sheet
AppRadii.chip   // 10
AppRadii.bar    // 6  — progress bars
```

## Breakpoints

| Константа | px | Использование |
|-----------|-----|---------------|
| `bondAnalyticsSideBySide` | 720 | График + таблица ОФЗ, ladder 2 col |
| `wideContent` | 900 | Широкие layout'ы |

## Типографика

Для **котировок, процентов, сумм** — всегда `AppTypography.quote()`:

```dart
Text(
  '72.45%',
  style: AppTypography.quote(
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
)
```

Включает `FontFeature.tabularFigures()` — цифры не «прыгают» при обновлении.

`MetricCard` поддерживает `numericValue` + `valueFormatter` для анимированного tabular текста.

## AppCard

Единый паттерн вместо `Card` + вложенный `InkWell`:

```dart
AppCard(
  onTap: () => ...,
  child: Column(...),
)
```

- Padding по умолчанию: `AppSpacing.card`
- Hover через `AppHoverSurface` на web
- **Не вкладывать** второй `InkWell` внутрь

## Motion

| API | Назначение |
|-----|------------|
| `AppMotion.duration(context, AppMotion.fast)` | Адаптивная длительность |
| `AppPageRoute` | Fade + slide переход |
| `AppSharedAxisPageRoute` | Shared axis (облигации) |
| `AppTabLayer` | Cross-fade + slide табов |
| `flutter_animate` | Stagger на картоchках главной |

## Hero-анимации

Теги через `watchlistKey(asset)` — формат `type:id`, не голый id:

```dart
Hero(tag: assetHeroTitleTag(asset), child: ...)
```

См. `lib/providers/watchlist_provider.dart`.

## Цвета состояния

- `palette.positive` — рост, низкая инфляция
- `palette.negative` — падение, высокая инфляция
- `palette.accent` — акцент, ссылки, CTA

Палитры настраиваются в Settings (light/dark presets).
