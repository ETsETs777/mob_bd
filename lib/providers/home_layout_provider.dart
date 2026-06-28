// =============================================================================
// EcoPulse · lib/providers/home_layout_provider.dart
// Автор: Цымбал Е. В.
// Дата: 22.05.2026
// Riverpod state: провайдеры и notifiers. Файл: home_layout_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/cache_service.dart';
import 'app_providers.dart';

/// Enum [HomeSectionId] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
enum HomeSectionId {
/// Значение enum [learn].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  learn('home_sec_learn', true),
/// Значение enum [portfolio].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  portfolio('home_sec_portfolio', true),
/// Значение enum [news].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  news('home_sec_news', true),
/// Значение enum [radar].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  radar('home_sec_radar', true),
/// Значение enum [indices].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  indices('home_sec_indices', true),
/// Значение enum [fearGreed].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  fearGreed('home_sec_fng', true),
/// Значение enum [currencies].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  currencies('home_sec_currencies', true),
/// Значение enum [keyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  keyRate('home_sec_keyrate', true),
/// Значение enum [inflation].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  inflation('home_sec_inflation', true),
/// Значение enum [commodities].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  commodities('home_sec_commodities', true),
/// Значение enum [markets].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  markets('home_sec_markets', true),
/// Значение enum [bonds].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  bonds('home_sec_bonds', true),
/// Значение enum [watchlist].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  watchlist('home_sec_watchlist', true),
/// Значение enum [correlation].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  correlation('home_sec_correlation', true);

  const HomeSectionId(this.storageKey, this.defaultVisible);

  final String storageKey;
  final bool defaultVisible;

  static HomeSectionId? tryParse(String name) {
    for (final id in HomeSectionId.values) {
      if (id.name == name) return id;
    }
    return null;
  }
}

/// Класс [HomeLayoutConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
class HomeLayoutConfig {
/// Создаёт [HomeLayoutConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  const HomeLayoutConfig({
    required this.visibility,
    required this.order,
  });

/// Поле [visibility] класса [HomeLayoutConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  final Map<HomeSectionId, bool> visibility;
/// Поле [order] класса [HomeLayoutConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  final List<HomeSectionId> order;

/// Getter [visibleInOrder] класса [HomeLayoutConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Iterable<HomeSectionId> get visibleInOrder =>
      order.where((s) => visibility[s] ?? s.defaultVisible);
}

/// Riverpod-провайдер [homeLayoutProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
final homeLayoutProvider =
    NotifierProvider<HomeLayoutNotifier, HomeLayoutConfig>(
  HomeLayoutNotifier.new,
);

/// Riverpod AsyncNotifier [HomeLayoutNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
class HomeLayoutNotifier extends Notifier<HomeLayoutConfig> {
/// Поле [_orderKey] класса [HomeLayoutNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  static const _orderKey = 'home_sec_order_v1';

/// Отрисовывает UI [HomeLayoutNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  @override
  HomeLayoutConfig build() {
    final cache = ref.watch(cacheServiceProvider);
    return HomeLayoutConfig(
      visibility: {
        for (final section in HomeSectionId.values)
          section: _readSection(cache, section),
      },
      order: _readOrder(cache),
    );
  }

/// Приватный метод [_readSection] класса [HomeLayoutNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  bool _readSection(CacheService cache, HomeSectionId section) {
    final raw = cache.getString(section.storageKey);
    if (raw == null) return section.defaultVisible;
    return raw == '1';
  }

/// Приватный метод [_readOrder] класса [HomeLayoutNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  List<HomeSectionId> _readOrder(CacheService cache) {
    final raw = cache.getString(_orderKey);
    if (raw == null || raw.isEmpty) {
      return List<HomeSectionId>.from(HomeSectionId.values);
    }
    final parsed = raw
        .split(',')
        .map(HomeSectionId.tryParse)
        .whereType<HomeSectionId>()
        .toList();
    for (final section in HomeSectionId.values) {
      if (!parsed.contains(section)) parsed.add(section);
    }
    return parsed;
  }

/// Метод [setVisible] класса [HomeLayoutNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  Future<void> setVisible(HomeSectionId section, bool visible) async {
    await ref.read(cacheServiceProvider).putString(
          section.storageKey,
          visible ? '1' : '0',
        );
    state = HomeLayoutConfig(
      visibility: {...state.visibility, section: visible},
      order: state.order,
    );
  }

/// Метод [reorder] класса [HomeLayoutNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> reorder(int oldIndex, int newIndex) async {
    final order = List<HomeSectionId>.from(state.order);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = order.removeAt(oldIndex);
    order.insert(newIndex, item);
    await ref.read(cacheServiceProvider).putString(
          _orderKey,
          order.map((s) => s.name).join(','),
        );
    state = HomeLayoutConfig(visibility: state.visibility, order: order);
  }

/// Метод [isVisible] класса [HomeLayoutNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  bool isVisible(HomeSectionId section) =>
      state.visibility[section] ?? section.defaultVisible;

/// Getter [visibleOrder] класса [HomeLayoutNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  List<HomeSectionId> get visibleOrder => state.visibleInOrder.toList();
}

/// Extension [HomeLayoutX].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
extension HomeLayoutX on WidgetRef {
  bool showHomeSection(HomeSectionId id) =>
      read(homeLayoutProvider.notifier).isVisible(id);
}
