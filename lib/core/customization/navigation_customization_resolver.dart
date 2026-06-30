import '../../data/models/user_customization.dart';

/// Эффективная конфигурация нижней навигации из [NavigationCustomization].
class ResolvedNavigation {
  const ResolvedNavigation({
    required this.defaultTabIndex,
    required this.orderedVisibleIndices,
    required this.showAssistantFab,
    required this.hideNavLabels,
  });

  static const allTabIndices = [0, 1, 2, 3, 4, 5];

  final int defaultTabIndex;
  final List<int> orderedVisibleIndices;
  final bool showAssistantFab;
  final bool hideNavLabels;

  int get effectiveDefaultIndex {
    if (orderedVisibleIndices.contains(defaultTabIndex)) {
      return defaultTabIndex;
    }
    return orderedVisibleIndices.first;
  }

  int? barIndexForScreen(int screenIndex) {
    final idx = orderedVisibleIndices.indexOf(screenIndex);
    return idx >= 0 ? idx : null;
  }

  int screenIndexForBar(int barIndex) {
    return orderedVisibleIndices[barIndex.clamp(0, orderedVisibleIndices.length - 1)];
  }

  bool isScreenVisible(int screenIndex) =>
      orderedVisibleIndices.contains(screenIndex);
}

/// Резолвер настроек навигации EcoPulse.
class NavigationCustomizationResolver {
  NavigationCustomizationResolver._();

  static ResolvedNavigation resolve(NavigationCustomization navigation) {
    navigation = normalize(navigation);
    final order = _resolveOrder(navigation.tabOrder);
    final visibleSet = navigation.visibleTabIndices.toSet();
    final orderedVisible = order.where(visibleSet.contains).toList();

    if (orderedVisible.isEmpty) {
      orderedVisible.add(0);
    }

    return ResolvedNavigation(
      defaultTabIndex: navigation.defaultTabIndex,
      orderedVisibleIndices: orderedVisible,
      showAssistantFab: navigation.showAssistantFab,
      hideNavLabels: navigation.hideNavLabels,
    );
  }

  static List<int> _resolveOrder(List<int> rawOrder) {
    if (rawOrder.isEmpty) {
      return List<int>.from(ResolvedNavigation.allTabIndices);
    }

    final parsed = rawOrder
        .where((index) => ResolvedNavigation.allTabIndices.contains(index))
        .toList();

    for (final index in ResolvedNavigation.allTabIndices) {
      if (!parsed.contains(index)) parsed.add(index);
    }

    return parsed;
  }

  static NavigationCustomization updateTabOrder(
    NavigationCustomization navigation,
    List<int> order,
  ) =>
      navigation.copyWith(tabOrder: order);

  static NavigationCustomization updateDefaultTabIndex(
    NavigationCustomization navigation,
    int tabIndex,
  ) =>
      navigation.copyWith(defaultTabIndex: tabIndex);

  static NavigationCustomization updateVisibleTabs(
    NavigationCustomization navigation,
    List<int> visible,
  ) {
    final sorted = List<int>.from(visible)..sort();
    var defaultTab = navigation.defaultTabIndex;
    if (!sorted.contains(defaultTab)) {
      defaultTab = sorted.isEmpty ? 0 : sorted.first;
    }
    return navigation.copyWith(
      visibleTabIndices: sorted,
      defaultTabIndex: defaultTab,
    );
  }

  /// Миграция: старые индексы 5 (чаты) и 6 (статьи) → 5 (сообщество).
  static NavigationCustomization normalize(NavigationCustomization navigation) {
    int mapIndex(int index) => index == 6 ? 5 : index;

    List<int> dedupeOrdered(Iterable<int> raw) {
      final seen = <int>{};
      final result = <int>[];
      for (final item in raw) {
        final mapped = mapIndex(item);
        if (ResolvedNavigation.allTabIndices.contains(mapped) && seen.add(mapped)) {
          result.add(mapped);
        }
      }
      return result;
    }

    final visible = dedupeOrdered(navigation.visibleTabIndices)..sort();
    final order = dedupeOrdered(
      navigation.tabOrder.isEmpty
          ? ResolvedNavigation.allTabIndices
          : navigation.tabOrder,
    );
    for (final index in ResolvedNavigation.allTabIndices) {
      if (!order.contains(index)) order.add(index);
    }

    var defaultTab = mapIndex(navigation.defaultTabIndex);
    if (!visible.contains(defaultTab)) {
      defaultTab = visible.isEmpty ? 0 : visible.first;
    }

    return navigation.copyWith(
      defaultTabIndex: defaultTab,
      visibleTabIndices: visible.isEmpty ? [0] : visible,
      tabOrder: order,
    );
  }
}
