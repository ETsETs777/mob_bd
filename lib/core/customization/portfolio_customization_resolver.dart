import '../../data/models/user_customization.dart';

/// Эффективные настройки портфеля из [PortfolioCustomization].
class ResolvedPortfolio {
  const ResolvedPortfolio({
    required this.allocationChartType,
    required this.showRealizedPnl,
    required this.showJournal,
  });

  final ChartTypeId allocationChartType;
  final bool showRealizedPnl;
  final bool showJournal;
}

/// Резолвер настроек портфеля EcoPulse.
class PortfolioCustomizationResolver {
  PortfolioCustomizationResolver._();

  static ResolvedPortfolio resolve(PortfolioCustomization portfolio) {
    return ResolvedPortfolio(
      allocationChartType: chartTypeFor(portfolio.allocationChartType),
      showRealizedPnl: portfolio.showRealizedPnl,
      showJournal: portfolio.showJournal,
    );
  }

  static ChartTypeId chartTypeFor(AllocationChartType type) {
    return switch (type) {
      AllocationChartType.pie => ChartTypeId.pie,
      AllocationChartType.donut => ChartTypeId.donut,
      AllocationChartType.bar => ChartTypeId.bar,
    };
  }

  static PortfolioCustomization updateAllocationChartType(
    PortfolioCustomization portfolio,
    AllocationChartType type,
  ) =>
      portfolio.copyWith(allocationChartType: type);
}
