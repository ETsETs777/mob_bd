// =============================================================================
// EcoPulse · lib/core/customization/preset_marketplace_catalog.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Каталог featured пресетов для marketplace.
// =============================================================================

import 'customization_presets.dart';

/// Метаданные пресета в marketplace.
class PresetMarketplaceEntry {
  const PresetMarketplaceEntry({
    required this.presetId,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.tagsRu,
    required this.tagsEn,
  });

  final String presetId;
  final String descriptionRu;
  final String descriptionEn;
  final List<String> tagsRu;
  final List<String> tagsEn;

  String description({required bool isRu}) =>
      isRu ? descriptionRu : descriptionEn;

  List<String> tags({required bool isRu}) => isRu ? tagsRu : tagsEn;
}

/// Featured пресеты marketplace (встроенные профили).
class PresetMarketplaceCatalog {
  PresetMarketplaceCatalog._();

  static const entries = [
    PresetMarketplaceEntry(
      presetId: CustomizationPresets.classicId,
      descriptionRu: 'Сбалансированный профиль EcoPulse по умолчанию',
      descriptionEn: 'Balanced default EcoPulse profile',
      tagsRu: ['Универсальный', 'Графики'],
      tagsEn: ['Universal', 'Charts'],
    ),
    PresetMarketplaceEntry(
      presetId: CustomizationPresets.traderId,
      descriptionRu: 'Компактный UI, свечи, акцент на рынки',
      descriptionEn: 'Compact UI, candles, markets-first layout',
      tagsRu: ['Трейдинг', 'Свечи'],
      tagsEn: ['Trading', 'Candles'],
    ),
    PresetMarketplaceEntry(
      presetId: CustomizationPresets.minimalId,
      descriptionRu: 'Светлая тема, минимум карточек и анимаций',
      descriptionEn: 'Light theme, fewer cards and motion',
      tagsRu: ['Минимализм', 'Светлая'],
      tagsEn: ['Minimal', 'Light'],
    ),
    PresetMarketplaceEntry(
      presetId: CustomizationPresets.analystId,
      descriptionRu: 'Просторный UI, bar-графики, точные числа',
      descriptionEn: 'Spacious UI, bar charts, precise numbers',
      tagsRu: ['Аналитика', 'Данные'],
      tagsEn: ['Analytics', 'Data'],
    ),
    PresetMarketplaceEntry(
      presetId: CustomizationPresets.oledId,
      descriptionRu: 'Чистый чёрный OLED и графитовый фон',
      descriptionEn: 'Pure black OLED with graphite background',
      tagsRu: ['OLED', 'Тёмная'],
      tagsEn: ['OLED', 'Dark'],
    ),
  ];

  static PresetMarketplaceEntry? forPreset(String id) {
    for (final entry in entries) {
      if (entry.presetId == id) return entry;
    }
    return null;
  }
}
