import '../../data/models/user_customization.dart';
import '../../providers/home_layout_provider.dart';

/// Эффективная раскладка главного экрана из [HomeCustomization].
class ResolvedHomeLayout {
  const ResolvedHomeLayout({
    required this.compactHome,
    required this.showSparklines,
    required this.newsCount,
    required this.visibility,
    required this.order,
  });

  final bool compactHome;
  final bool showSparklines;
  final int newsCount;
  final Map<HomeSectionId, bool> visibility;
  final List<HomeSectionId> order;

  Iterable<HomeSectionId> get visibleInOrder =>
      order.where((s) => visibility[s] ?? s.defaultVisible);

  bool isVisible(HomeSectionId section) =>
      visibility[section] ?? section.defaultVisible;
}

/// Резолвер настроек главного экрана.
class HomeCustomizationResolver {
  HomeCustomizationResolver._();

  static const _minNewsCount = 3;
  static const _maxNewsCount = 10;

  static ResolvedHomeLayout resolve(HomeCustomization home) {
    final order = _resolveOrder(home.sectionOrder);
    final visibility = _resolveVisibility(home.sectionVisibility, order);

    return ResolvedHomeLayout(
      compactHome: home.compactHome,
      showSparklines: home.showSparklines,
      newsCount: home.newsCount.clamp(_minNewsCount, _maxNewsCount),
      visibility: visibility,
      order: order,
    );
  }

  static List<HomeSectionId> _resolveOrder(List<String> rawOrder) {
    if (rawOrder.isEmpty) {
      return List<HomeSectionId>.from(HomeSectionId.values);
    }

    final parsed = rawOrder
        .map(HomeSectionId.tryParse)
        .whereType<HomeSectionId>()
        .toList();

    for (final section in HomeSectionId.values) {
      if (!parsed.contains(section)) parsed.add(section);
    }

    return parsed;
  }

  static Map<HomeSectionId, bool> _resolveVisibility(
    Map<String, bool> rawVisibility,
    List<HomeSectionId> order,
  ) {
    return {
      for (final section in order)
        section: rawVisibility[section.name] ?? section.defaultVisible,
    };
  }

  static HomeCustomization updateSectionOrder(
    HomeCustomization home,
    List<String> order,
  ) =>
      home.copyWith(sectionOrder: order);

  static HomeCustomization updateSectionVisible(
    HomeCustomization home,
    HomeSectionId section,
    bool visible,
  ) {
    return home.copyWith(
      sectionVisibility: {
        ...home.sectionVisibility,
        section.name: visible,
      },
    );
  }
}

/// Условный sparkline для MetricCard на главной.
List<double>? homeSparklineData(
  List<double> values, {
  required bool enabled,
}) {
  if (!enabled || values.length < 2) return null;
  return values;
}
