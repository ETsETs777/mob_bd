import '../../data/models/user_customization.dart';
import '../../data/services/cache_service.dart';
import '../../providers/home_layout_provider.dart';
import 'customization_defaults.dart';

/// Импорт legacy-ключей Hive в [UserCustomization] при первом запуске.
class CustomizationLegacyAdapter {
  CustomizationLegacyAdapter._();

  static UserCustomization importFromCache(CacheService cache) {
    return importFromStrings(cache.getString);
  }

  /// Тестируемый импорт из map ключ → значение (legacy Hive).
  static UserCustomization importFromStrings(
    String? Function(String key) read,
  ) {
    final base = CustomizationDefaults.create();
    final appearance = base.appearance.copyWith(
      themeModeKey: read('theme_mode') ?? base.appearance.themeModeKey,
      accentKey: read('accent_color') ?? base.appearance.accentKey,
      backgroundKey: read('background_preset') ?? base.appearance.backgroundKey,
    );

    final home = base.home.copyWith(
      compactHome: read('compact_home') == 'true',
      sectionVisibility: _readSectionVisibility(read),
      sectionOrder: _readSectionOrder(read),
    );

    final navigation = base.navigation.copyWith(
      defaultTabIndex:
          int.tryParse(read('default_tab') ?? '') ??
              base.navigation.defaultTabIndex,
    );

    final dataDisplay = base.dataDisplay.copyWith(
      baseCurrency: read('base_currency') ?? base.dataDisplay.baseCurrency,
      localeCode: _readLocale(read) ?? base.dataDisplay.localeCode,
    );

    final markets = base.markets.copyWith(
      groupStocksBySector:
          _readBoolFlag(read('flag_stocks_grouped'), defaultValue: false),
      showSectorHeatmap:
          _readBoolFlag(read('flag_sector_heatmap'), defaultValue: true),
    );

    final widgets = base.widgets.copyWith(
      layout: read('widget_layout') ?? base.widgets.layout,
      slots: [
        read('widget_slot1') ?? base.widgets.slots[0],
        read('widget_slot2') ?? base.widgets.slots[1],
        read('widget_slot3') ?? base.widgets.slots[2],
        read('widget_slot4') ?? base.widgets.slots[3],
      ],
    );

    return base.copyWith(
      appearance: appearance,
      home: home,
      navigation: navigation,
      markets: markets,
      widgets: widgets,
      dataDisplay: dataDisplay,
      meta: base.meta.copyWith(updatedAt: DateTime.now().toUtc()),
    );
  }

  static Map<String, bool> _readSectionVisibility(
    String? Function(String key) read,
  ) {
    final map = <String, bool>{};
    for (final section in HomeSectionId.values) {
      final raw = read(section.storageKey);
      map[section.name] = raw == null ? section.defaultVisible : raw == '1';
    }
    return map;
  }

  static List<String> _readSectionOrder(String? Function(String key) read) {
    const orderKey = 'home_sec_order_v1';
    final raw = read(orderKey);
    if (raw == null || raw.isEmpty) {
      return HomeSectionId.values.map((s) => s.name).toList();
    }
    final parsed = raw
        .split(',')
        .map(HomeSectionId.tryParse)
        .whereType<HomeSectionId>()
        .map((s) => s.name)
        .toList();
    for (final section in HomeSectionId.values) {
      if (!parsed.contains(section.name)) parsed.add(section.name);
    }
    return parsed;
  }

  static bool _readBoolFlag(String? raw, {required bool defaultValue}) {
    if (raw == null) return defaultValue;
    return raw == '1' || raw == 'true';
  }

  static String? _readLocale(String? Function(String key) read) {
    final raw = read('app_locale');
    if (raw == null || raw.isEmpty) return null;
    return raw == 'en' ? 'en' : 'ru';
  }
}
