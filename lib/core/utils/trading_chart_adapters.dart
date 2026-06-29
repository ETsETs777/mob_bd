import 'package:candlesticks/candlesticks.dart';

import '../../data/models/candle_point.dart';

/// Конвертация EcoPulse → пакет [candlesticks] (newest-first).
class TradingChartAdapters {
  TradingChartAdapters._();

  static List<Candle> toPackageCandles(
    List<CandlePoint> points, {
    bool includeVolume = true,
  }) {
    if (points.isEmpty) return const [];
    return points.reversed.map((p) {
      final volume = includeVolume ? _resolveVolume(p) : 0.0;
      return Candle(
        date: p.date,
        open: p.open,
        high: p.high,
        low: p.low,
        close: p.close,
        volume: volume,
      );
    }).toList();
  }

  static double _resolveVolume(CandlePoint point) {
    if (point.volume > 0) return point.volume;
    final range = (point.high - point.low).abs();
    return range * point.close * 12 + 1;
  }
}
