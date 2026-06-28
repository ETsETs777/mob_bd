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
}
