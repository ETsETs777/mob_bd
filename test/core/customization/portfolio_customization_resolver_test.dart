import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/portfolio_customization_resolver.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PortfolioCustomizationResolver maps allocation chart types', () {
    expect(
      PortfolioCustomizationResolver.chartTypeFor(AllocationChartType.pie),
      ChartTypeId.pie,
    );
    expect(
      PortfolioCustomizationResolver.chartTypeFor(AllocationChartType.donut),
      ChartTypeId.donut,
    );
    expect(
      PortfolioCustomizationResolver.chartTypeFor(AllocationChartType.bar),
      ChartTypeId.bar,
    );
  });

  test('PortfolioCustomizationResolver resolves portfolio flags', () {
    final portfolio = CustomizationDefaults.create().portfolio.copyWith(
          allocationChartType: AllocationChartType.donut,
          showRealizedPnl: false,
          showJournal: false,
        );

    final resolved = PortfolioCustomizationResolver.resolve(portfolio);

    expect(resolved.allocationChartType, ChartTypeId.donut);
    expect(resolved.showRealizedPnl, isFalse);
    expect(resolved.showJournal, isFalse);
  });

  test('updateAllocationChartType mutates config', () {
    final updated = PortfolioCustomizationResolver.updateAllocationChartType(
      CustomizationDefaults.create().portfolio,
      AllocationChartType.bar,
    );

    expect(updated.allocationChartType, AllocationChartType.bar);
  });
}
