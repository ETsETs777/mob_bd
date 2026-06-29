import 'package:ecopulse/core/utils/overnight_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('computeOvernightChanges finds movers after gap', () {
    final previous = OvernightSnapshot(
      savedAt: DateTime.now().subtract(const Duration(hours: 8)),
      points: const [
        OvernightPricePoint(key: 'fx:USD/RUB', label: 'USD/RUB', price: 90),
        OvernightPricePoint(key: 'crypto:BTC', label: 'BTC', price: 60000),
      ],
    );
    final current = const [
      OvernightPricePoint(key: 'fx:USD/RUB', label: 'USD/RUB', price: 95),
      OvernightPricePoint(key: 'crypto:BTC', label: 'BTC', price: 57000),
    ];

    final changes = computeOvernightChanges(
      previous: previous,
      currentPoints: current,
    );

    expect(changes, hasLength(2));
    expect(changes.first.label, 'USD/RUB');
    expect(changes.first.changePercent, closeTo(5.56, 0.1));
  });

  test('computeOvernightChanges skips recent snapshots', () {
    final previous = OvernightSnapshot(
      savedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      points: const [
        OvernightPricePoint(key: 'fx:USD/RUB', label: 'USD/RUB', price: 90),
      ],
    );

    final changes = computeOvernightChanges(
      previous: previous,
      currentPoints: const [
        OvernightPricePoint(key: 'fx:USD/RUB', label: 'USD/RUB', price: 100),
      ],
    );

    expect(changes, isEmpty);
  });
}
