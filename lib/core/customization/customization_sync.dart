import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_accent.dart';
import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/user_customization.dart';
import '../../providers/accent_provider.dart';
import '../../providers/app_providers.dart';
import '../../providers/background_provider.dart';
import '../../providers/base_currency_provider.dart';
import '../../providers/compact_home_provider.dart';
import '../../providers/customization_provider.dart';
import '../../providers/default_tab_provider.dart';
import '../../providers/feature_flags_provider.dart';
import '../../providers/home_layout_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/widget_config_provider.dart';
import '../../core/customization/data_display_customization_resolver.dart';
import '../../core/customization/widget_customization_resolver.dart';
import '../../core/customization/markets_customization_resolver.dart';
import '../../core/customization/navigation_customization_resolver.dart';
import '../../core/utils/market_list_utils.dart';
import '../../providers/stock_market_provider.dart';
import '../../data/services/cache_service.dart';
import '../../providers/watchlist_provider.dart';
import 'chart_context_profiles.dart';
import 'customization_legacy_adapter.dart';
import 'customization_preset.dart';
import 'customization_presets.dart';

/// Синхронизация [UserCustomization] с legacy-провайдерами и Hive-ключами.
class CustomizationSync {
  CustomizationSync._();

  static Future<void> applyLegacy(WidgetRef ref, UserCustomization config) async {
    final cache = CacheService.instance;
    final appearance = config.appearance;

    await ref.read(themeModeProvider.notifier).setMode(
          AppThemeModeX.fromString(appearance.themeModeKey),
        );
    await ref.read(accentColorProvider.notifier).setAccent(
          AppAccentColor.fromKey(appearance.accentKey),
        );
    await ref.read(backgroundPresetProvider.notifier).setPreset(
          AppBackgroundPresetX.fromString(appearance.backgroundKey),
        );

    await ref.read(compactHomeProvider.notifier).setEnabled(config.home.compactHome);

    for (final section in HomeSectionId.values) {
      final visible =
          config.home.sectionVisibility[section.name] ?? section.defaultVisible;
      await ref.read(homeLayoutProvider.notifier).setVisible(section, visible);
    }
    if (config.home.sectionOrder.isNotEmpty) {
      await cache.putString(
        'home_sec_order_v1',
        config.home.sectionOrder.join(','),
      );
      ref.invalidate(homeLayoutProvider);
    }

    await cache.putString('default_tab', config.navigation.defaultTabIndex.toString());
    _syncNavigation(ref, config.navigation);

    _syncDataDisplay(ref, config.dataDisplay);

    _syncMarkets(ref, config.markets);

    await ref.read(featureFlagsProvider.notifier).setFlag(
          FeatureFlag.stocksGrouped,
          config.markets.groupStocksBySector,
        );
    await ref.read(featureFlagsProvider.notifier).setFlag(
          FeatureFlag.sectorHeatmap,
          config.markets.showSectorHeatmap,
        );

    await cache.putString(
      'flag_stocks_grouped',
      config.markets.groupStocksBySector ? '1' : '0',
    );

    _syncWidgets(ref, config.widgets);

    _syncChartPeriod(ref, config.charts);

    ref.invalidate(defaultTabProvider);
  }

  static Future<void> _syncDataDisplay(
    WidgetRef ref,
    DataDisplayCustomization dataDisplay,
  ) async {
    final resolved = DataDisplayCustomizationResolver.resolve(dataDisplay);
    await ref.read(baseCurrencyProvider.notifier).setCurrency(resolved.baseCurrency);
    await ref.read(localeProvider.notifier).setLocale(resolved.appLocale);
  }

  static Future<void> _syncWidgets(
    WidgetRef ref,
    WidgetCustomization widgets,
  ) async {
    final config = WidgetCustomizationResolver.resolve(widgets);
    await ref.read(widgetConfigProvider.notifier).setLayout(config.layout);
    await ref.read(widgetConfigProvider.notifier).setSlot1(config.slot1);
    await ref.read(widgetConfigProvider.notifier).setSlot2(config.slot2);
    await ref.read(widgetConfigProvider.notifier).setSlot3(config.slot3);
    await ref.read(widgetConfigProvider.notifier).setSlot4(config.slot4);
  }

  static void _syncChartPeriod(WidgetRef ref, ChartCustomization charts) {
    ref.read(chartPeriodProvider.notifier).state =
        ChartContextProfiles.periodForContext(charts, ChartContextId.assetDetail);
  }

  static void _syncMarkets(WidgetRef ref, MarketsCustomization markets) {
    final resolved = MarketsCustomizationResolver.resolve(markets);
    ref.read(stockMarketRegionProvider.notifier).state =
        resolved.defaultStockRegion;
    ref.read(stocksGroupedListProvider.notifier).state =
        resolved.groupStocksBySector;
  }

  static void _syncNavigation(WidgetRef ref, NavigationCustomization navigation) {
    final resolved = NavigationCustomizationResolver.resolve(navigation);
    final current = ref.read(navigationIndexProvider);
    if (!resolved.isScreenVisible(current)) {
      ref.read(navigationIndexProvider.notifier).state =
          resolved.effectiveDefaultIndex;
    }
  }

  static Future<void> commit(
    WidgetRef ref,
    UserCustomization config,
  ) async {
    await ref.read(customizationProvider.notifier).update(config);
    await applyLegacy(ref, config);
  }

  /// Применить пресет целиком: конфиг, legacy-провайдеры и вкладка по умолчанию.
  static Future<void> commitPreset(
    WidgetRef ref,
    CustomizationPreset preset,
  ) async {
    final config = CustomizationPresets.withActivePreset(
      ref.read(customizationProvider),
      preset,
    );
    await commit(ref, config);
    final nav = NavigationCustomizationResolver.resolve(config.navigation);
    ref.read(navigationIndexProvider.notifier).state = nav.effectiveDefaultIndex;
  }

  static Future<void> resetSection(
    WidgetRef ref,
    CustomizationSection section,
  ) async {
    await ref.read(customizationProvider.notifier).resetSection(section);
    await applyLegacy(ref, ref.read(customizationProvider));
  }

  static Future<void> resetAll(WidgetRef ref) async {
    await ref.read(customizationProvider.notifier).resetAll();
    await applyLegacy(ref, ref.read(customizationProvider));
  }

  /// После backup/cloud restore: импорт legacy при отсутствии JSON и sync провайдеров.
  static Future<void> applyAfterRestore(WidgetRef ref) async {
    final cache = CacheService.instance;
    final raw = cache.getString(CustomizationNotifier.cacheKey);
    if (raw == null || raw.isEmpty) {
      final imported = CustomizationLegacyAdapter.importFromCache(cache);
      await ref.read(customizationProvider.notifier).update(imported);
    }
    await applyLegacy(ref, ref.read(customizationProvider));
  }
}
