// =============================================================================
// EcoPulse · test/economic_radar_test.dart
// Автор: Цымбал Е. В.
// Дата: 24.06.2026
// Unit/widget тест: economic_radar_test.
// =============================================================================

import 'package:ecopulse/core/utils/economic_radar.dart';
import 'package:ecopulse/data/models/key_rate_point.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
void main() {
  test('buildEconomicRadar computes overall from axes', () {
    final snapshot = buildEconomicRadar(
      stocks: [
        const MarketAsset(
          id: 'imoex',
          symbol: 'IMOEX',
          name: 'IMOEX',
          price: 3200,
          changePercent: 2,
          type: AssetType.stockRu,
        ),
      ],
      keyRate: KeyRateSnapshot(
        current: 21,
        history: const [],
        updatedAt: DateTime.now(),
      ),
    );

    expect(snapshot.axes, isNotEmpty);
    expect(snapshot.overall, greaterThan(0));
    expect(snapshot.overall, lessThanOrEqualTo(100));
  });
}
