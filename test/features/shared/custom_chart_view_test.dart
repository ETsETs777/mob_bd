import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/data/models/candle_point.dart';
import 'package:ecopulse/data/models/chart_render_input.dart';
import 'package:ecopulse/data/models/price_point.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:ecopulse/features/shared/widgets/custom_chart_view.dart';
import '../../support/widget_test_harness.dart';

List<PricePoint> _samplePoints() {
  final now = DateTime.now();
  return List.generate(
    20,
    (i) => PricePoint(
      date: now.subtract(Duration(days: 19 - i)),
      value: 100 + i * 1.5,
    ),
  );
}

List<CandlePoint> _sampleCandles() {
  final now = DateTime.now();
  return List.generate(20, (i) {
    final base = 100 + i * 1.5;
    return CandlePoint(
      date: now.subtract(Duration(days: 19 - i)),
      open: base - 0.5,
      high: base + 1.2,
      low: base - 1.0,
      close: base,
      volume: 1000 + i * 10,
    );
  });
}

void main() {
  setUp(() async {
    await initWidgetTestEnvironment();
  });

  testWidgets('CustomChartView renders line and candlestick charts', (tester) async {
    await pumpWidgetForTest(
      tester,
      CustomChartView(
        contextId: ChartContextId.assetDetail,
        input: ChartRenderInput(
          points: _samplePoints(),
          currencySymbol: '₽',
        ),
        height: 200,
      ),
    );
    expect(find.byType(CustomChartView), findsOneWidget);
    await tester.pumpWidget(wrapForWidgetTest(const SizedBox.shrink()));
    await tester.pump();

    await pumpWidgetForTest(
      tester,
      CustomChartView(
        contextId: ChartContextId.assetDetail,
        overrideType: ChartTypeId.candlestick,
        input: ChartRenderInput(
          points: _samplePoints(),
          candles: _sampleCandles(),
          currencySymbol: '₽',
        ),
        height: 200,
      ),
    );
    expect(find.byType(CustomChartView), findsOneWidget);

    await flushTestTimers(tester);
  });
}
