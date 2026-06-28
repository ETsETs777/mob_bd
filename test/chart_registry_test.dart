import 'package:ecopulse/core/customization/chart_customization_resolver.dart';
import 'package:ecopulse/core/customization/chart_registry.dart';
import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/data/models/candle_point.dart';
import 'package:ecopulse/data/models/chart_render_input.dart';
import 'package:ecopulse/data/models/price_point.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final config = CustomizationDefaults.create();
  final samplePoints = [
    PricePoint(date: DateTime(2026, 1, 1), value: 90),
    PricePoint(date: DateTime(2026, 1, 2), value: 91),
  ];

  test('ChartRegistry lists types per context', () {
    final currencyTypes = ChartRegistry.typesForContext(ChartContextId.currency);
    expect(currencyTypes, contains(ChartTypeId.line));
    expect(currencyTypes, contains(ChartTypeId.normalizedOverlay));
    expect(currencyTypes, isNot(contains(ChartTypeId.yieldCurve)));
  });

  test('ChartRegistry resolves compatible type for candles', () {
    final input = ChartRenderInput(
      points: samplePoints,
      candles: const [],
    );

    final resolved = ChartRegistry.resolveCompatible(
      preferred: ChartTypeId.candlestick,
      context: ChartContextId.assetDetail,
      input: input.copyWith(
        candles: [
          for (var i = 0; i < 3; i++)
            CandlePoint(
              date: DateTime(2026, 1, i + 1),
              open: 90.0 + i,
              high: 92.0 + i,
              low: 89.0 + i,
              close: 91.0 + i,
            ),
        ],
      ),
    );

    expect(resolved, ChartTypeId.candlestick);
  });

  test('ChartRegistry falls back when bar data missing', () {
    final resolved = ChartRegistry.resolveCompatible(
      preferred: ChartTypeId.bar,
      context: ChartContextId.currency,
      input: ChartRenderInput(points: samplePoints),
    );

    expect(resolved, ChartTypeId.line);
  });

  test('ChartCustomizationResolver uses context profile overrides', () {
    final custom = config.copyWith(
      charts: config.charts.copyWith(
        contextProfiles: {
          ...config.charts.contextProfiles,
          ChartContextId.inflation: const ChartContextProfile(
            useGlobalDefaults: false,
            type: ChartTypeId.bar,
          ),
        },
      ),
    );

    final resolved = ChartCustomizationResolver.resolve(
      custom,
      ChartContextId.inflation,
    );

    expect(resolved.type, ChartTypeId.bar);
  });

  test('ChartCustomizationResolver prefers candles when enabled', () {
    final resolved = ChartCustomizationResolver.resolveForRender(
      config: config,
      context: ChartContextId.assetDetail,
      input: ChartRenderInput(
        points: samplePoints,
        candles: [
          for (var i = 0; i < 3; i++)
            CandlePoint(
              date: DateTime(2026, 1, i + 1),
              open: 90.0 + i,
              high: 92.0 + i,
              low: 89.0 + i,
              close: 91.0 + i,
            ),
        ],
      ),
    );

    expect(resolved.type, ChartTypeId.candlestick);
  });

  test('heightPx maps presets', () {
    expect(
      ChartCustomizationResolver.heightPx(ChartHeightPreset.compact),
      180,
    );
    expect(
      ChartCustomizationResolver.heightPx(ChartHeightPreset.tall),
      300,
    );
  });
}
