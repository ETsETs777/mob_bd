# Customization module

Единый hub настроек: тема, графики, главная, навигация, рынки, портфель, виджет, ассистент.

## Слои

| Слой | Путь | Содержимое |
|------|------|------------|
| Domain | `lib/core/customization/` | Resolvers, sync, presets, bundle, migrator |
| Model | `lib/data/models/user_customization.dart` | JSON schema, Hive `customization_config` |
| State | `lib/providers/customization/` | `customizationProvider`, `resolved*Provider` |
| UI | `lib/features/customization/` | `CustomizationScreen`, panels, live preview |

## Точки входа

- **Settings** → «Вся кастомизация» → `CustomizationScreen`
- **Commit изменений** → `CustomizationSync.commit()` → legacy Hive + auto-sync
- **Backup restore** → `CustomizationSync.applyAfterRestore()`

## Public API (читать/писать конфиг)

```dart
ref.read(customizationProvider);
ref.read(customizationProvider.notifier).update(config);
await CustomizationSync.commit(ref, config);
```

## Resolved providers (для экранов)

- `resolvedChartConfigProvider`
- `resolvedDataDisplayProvider`
- `resolvedAppearanceProvider`
- `resolvedWidgetConfigProvider`

## Документация

- [customization-schema.md](../../docs/customization-schema.md)
