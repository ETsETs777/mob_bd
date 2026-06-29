import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/customization_defaults.dart';
import '../../core/customization/customization_legacy_adapter.dart';
import '../../data/models/user_customization.dart';
import '../../core/customization/customization_sync.dart';
import '../../data/services/cache_service.dart';

/// Секции кастомизации для частичного сброса.
enum CustomizationSection {
  charts,
  appearance,
  home,
  navigation,
  markets,
  portfolio,
  widgets,
  dataDisplay,
  assistant,
}

final customizationProvider =
    NotifierProvider<CustomizationNotifier, UserCustomization>(
  CustomizationNotifier.new,
);

class CustomizationNotifier extends Notifier<UserCustomization> {
  static const cacheKey = 'customization_config';

  @override
  UserCustomization build() {
    final cache = CacheService.instance;
    final raw = cache.getString(cacheKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        return UserCustomization.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } catch (_) {
        // fall through to legacy import
      }
    }
    final imported = CustomizationLegacyAdapter.importFromCache(cache);
    Future.microtask(() => _persist(imported));
    return imported;
  }

  Future<void> update(UserCustomization config) async {
    final next = config.copyWith(
      meta: config.meta.copyWith(
        schemaVersion: UserCustomization.currentSchemaVersion,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    state = next;
    await _persist(next);
  }

  /// Обновить конфиг и синхронизировать legacy-провайдеры (из UI).
  Future<void> commitWithLegacy(
    WidgetRef ref,
    UserCustomization config,
  ) async {
    await update(config);
    await CustomizationSync.applyLegacy(ref, state);
  }

  Future<void> updateCharts(ChartCustomization charts) async {
    await update(state.copyWith(charts: charts));
  }

  Future<void> updateAppearance(AppearanceCustomization appearance) async {
    await update(state.copyWith(appearance: appearance));
  }

  Future<void> updateHome(HomeCustomization home) async {
    await update(state.copyWith(home: home));
  }

  Future<void> updateNavigation(NavigationCustomization navigation) async {
    await update(state.copyWith(navigation: navigation));
  }

  Future<void> updateMarkets(MarketsCustomization markets) async {
    await update(state.copyWith(markets: markets));
  }

  Future<void> updatePortfolio(PortfolioCustomization portfolio) async {
    await update(state.copyWith(portfolio: portfolio));
  }

  Future<void> updateWidgets(WidgetCustomization widgets) async {
    await update(state.copyWith(widgets: widgets));
  }

  Future<void> updateDataDisplay(DataDisplayCustomization dataDisplay) async {
    await update(state.copyWith(dataDisplay: dataDisplay));
  }

  Future<void> updateAssistant(AssistantCustomization assistant) async {
    await update(state.copyWith(assistant: assistant));
  }

  Future<void> resetSection(CustomizationSection section) async {
    final defaults = CustomizationDefaults.create();
    final next = switch (section) {
      CustomizationSection.charts => state.copyWith(charts: defaults.charts),
      CustomizationSection.appearance =>
        state.copyWith(appearance: defaults.appearance),
      CustomizationSection.home => state.copyWith(home: defaults.home),
      CustomizationSection.navigation =>
        state.copyWith(navigation: defaults.navigation),
      CustomizationSection.markets => state.copyWith(markets: defaults.markets),
      CustomizationSection.portfolio =>
        state.copyWith(portfolio: defaults.portfolio),
      CustomizationSection.widgets => state.copyWith(widgets: defaults.widgets),
      CustomizationSection.dataDisplay =>
        state.copyWith(dataDisplay: defaults.dataDisplay),
      CustomizationSection.assistant =>
        state.copyWith(assistant: defaults.assistant),
    };
    await update(next);
  }

  Future<void> resetAll() async {
    await update(CustomizationDefaults.create());
  }

  Future<void> loadFromJson(Map<String, dynamic> json) async {
    await update(UserCustomization.fromJson(json));
  }

  Future<void> _persist(UserCustomization config) async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(config.toJson()),
    );
  }
}
