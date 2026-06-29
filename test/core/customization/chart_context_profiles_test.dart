import 'package:ecopulse/core/customization/chart_context_profiles.dart';
import 'package:ecopulse/core/customization/chart_customization_resolver.dart';
import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/data/models/chart_period.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final charts = CustomizationDefaults.create().charts;

  test('ChartContextProfiles maps period keys', () {
    expect(ChartContextProfiles.periodFromKey('d7'), ChartPeriod.d7);
    expect(ChartContextProfiles.periodFromKey('y1'), ChartPeriod.y1);
    expect(ChartContextProfiles.periodFromKey(null), ChartPeriod.d30);
    expect(ChartContextProfiles.periodFromKey('invalid'), ChartPeriod.d30);
  });

  test('ChartContextProfiles effectiveType respects useGlobalDefaults', () {
    expect(
      ChartContextProfiles.effectiveType(charts, ChartContextId.inflation),
      ChartTypeId.bar,
    );
    expect(
      ChartContextProfiles.effectiveType(charts, ChartContextId.assetDetail),
      charts.defaultType,
    );
  });

  test('ChartContextProfiles periodForContext uses profile override', () {
    final custom = ChartContextProfiles.updateProfile(
      charts,
      ChartContextId.assetDetail,
      const ChartContextProfile(
        useGlobalDefaults: false,
        periodKey: 'd7',
      ),
    );

    expect(
      ChartContextProfiles.periodForContext(custom, ChartContextId.assetDetail),
      ChartPeriod.d7,
    );
  });

  test('ChartCustomizationResolver ignores profile overrides when global', () {
    final custom = CustomizationDefaults.create().copyWith(
      charts: ChartContextProfiles.updateProfile(
        charts,
        ChartContextId.assetDetail,
        const ChartContextProfile(
          useGlobalDefaults: true,
          type: ChartTypeId.bar,
          periodKey: 'd7',
        ),
      ),
    );

    final resolved = ChartCustomizationResolver.resolve(
      custom,
      ChartContextId.assetDetail,
    );

    expect(resolved.type, charts.defaultType);
    expect(resolved.periodKey, charts.defaultPeriodKey);
  });

  test('ChartContextProfiles updateProfile preserves other contexts', () {
    final updated = ChartContextProfiles.updateProfile(
      charts,
      ChartContextId.portfolio,
      const ChartContextProfile(
        useGlobalDefaults: false,
        type: ChartTypeId.donut,
      ),
    );

    expect(
      updated.profileFor(ChartContextId.portfolio).type,
      ChartTypeId.donut,
    );
    expect(
      updated.profileFor(ChartContextId.inflation).type,
      ChartTypeId.bar,
    );
  });

  test('ChartContextProfiles supportsPeriod for relevant contexts', () {
    expect(ChartContextProfiles.supportsPeriod(ChartContextId.assetDetail), isTrue);
    expect(ChartContextProfiles.supportsPeriod(ChartContextId.portfolio), isFalse);
  });
}
