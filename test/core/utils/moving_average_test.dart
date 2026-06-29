import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/moving_average.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:ecopulse/shared/widgets/chart_ma_overlay.dart';

void main() {
  group('simpleMovingAverage', () {
    test('returns null until period is filled', () {
      final ma = simpleMovingAverage([1, 2, 3, 4, 5], 3);
      expect(ma[0], isNull);
      expect(ma[1], isNull);
      expect(ma[2], closeTo(2.0, 0.001));
      expect(ma[3], closeTo(3.0, 0.001));
      expect(ma[4], closeTo(4.0, 0.001));
    });

    test('handles empty input', () {
      expect(simpleMovingAverage([], 7), isEmpty);
    });
  });

  group('enabledMaPeriods', () {
    test('respects visual toggles', () {
      const visual = ChartVisualOptions(showMa7: true, showMa99: true);
      expect(enabledMaPeriods(visual), [7, 99]);
    });
  });
}
