import 'package:flutter/material.dart';

import '../../../core/utils/moving_average.dart';
import '../../../data/models/user_customization.dart';

List<int> enabledMaPeriods(ChartVisualOptions visual) {
  return [
    if (visual.showMa7) 7,
    if (visual.showMa25) 25,
    if (visual.showMa99) 99,
  ];
}

/// Overlay SMA-линий поверх свечного графика.
class ChartMaOverlay extends StatelessWidget {
  const ChartMaOverlay({
    super.key,
    required this.closes,
    required this.visual,
    this.reserveVolumeSpace = false,
  });

  final List<double> closes;
  final ChartVisualOptions visual;
  final bool reserveVolumeSpace;

  @override
  Widget build(BuildContext context) {
    final periods = enabledMaPeriods(visual);
    if (periods.isEmpty || closes.length < 2) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: CustomPaint(
        painter: _MaOverlayPainter(
          closes: closes,
          periods: periods,
          reserveVolumeSpace: reserveVolumeSpace,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _MaOverlayPainter extends CustomPainter {
  _MaOverlayPainter({
    required this.closes,
    required this.periods,
    required this.reserveVolumeSpace,
  });

  final List<double> closes;
  final List<int> periods;
  final bool reserveVolumeSpace;

  @override
  void paint(Canvas canvas, Size size) {
    if (closes.isEmpty || size.width <= 0 || size.height <= 0) return;

    final minY = closes.reduce((a, b) => a < b ? a : b);
    final maxY = closes.reduce((a, b) => a > b ? a : b);
    if ((maxY - minY).abs() <= 0) return;

    final top = 8.0;
    final bottom = reserveVolumeSpace ? size.height * 0.28 : 8.0;
    final chartHeight = size.height - top - bottom;
    final stepX = size.width / (closes.length - 1).clamp(1, closes.length);

    double yFor(double value) {
      final normalized =
          (value - minY * 0.995) / (maxY * 1.005 - minY * 0.995);
      return top + chartHeight * (1 - normalized.clamp(0.0, 1.0));
    }

    for (final period in periods) {
      final ma = simpleMovingAverage(closes, period);
      final paint = Paint()
        ..color = maColorForPeriod(period, fallback: Colors.white70)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final path = Path();
      var started = false;
      for (var i = 0; i < ma.length; i++) {
        final value = ma[i];
        if (value == null) continue;
        final x = i * stepX;
        final y = yFor(value);
        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }
      if (started) canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MaOverlayPainter oldDelegate) {
    return oldDelegate.closes != closes ||
        oldDelegate.periods != periods ||
        oldDelegate.reserveVolumeSpace != reserveVolumeSpace;
  }
}

/// Легенда активных MA под графиком.
class ChartMaLegend extends StatelessWidget {
  const ChartMaLegend({
    super.key,
    required this.visual,
    required this.closes,
  });

  final ChartVisualOptions visual;
  final List<double> closes;

  @override
  Widget build(BuildContext context) {
    final periods = enabledMaPeriods(visual);
    if (periods.isEmpty || closes.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children: periods.map((period) {
          final ma = simpleMovingAverage(closes, period);
          final last = ma.lastWhere((v) => v != null, orElse: () => null);
          final color = maColorForPeriod(period, fallback: Colors.grey);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 16, height: 2, color: color),
              const SizedBox(width: 4),
              Text(
                'MA$period${last != null ? ' · ${last.toStringAsFixed(2)}' : ''}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
