// =============================================================================
// EcoPulse · lib/core/utils/economic_radar.dart
// Автор: Цымбал Е. В.
// Дата: 08.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: economic_radar.
// =============================================================================

import '../../data/models/commodity_quote.dart';
import '../../data/models/commodity_quote.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/inflation_point.dart';
import '../../data/models/key_rate_point.dart';
import '../../data/models/market_asset.dart';

/// Класс [RadarAxis].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
class RadarAxis {
/// Создаёт [RadarAxis].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  const RadarAxis({required this.label, required this.score});

/// Поле [label] класса [RadarAxis].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  final String label;
/// Поле [score] класса [RadarAxis].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  final double score;
}

/// Класс [EconomicRadarSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
class EconomicRadarSnapshot {
/// Создаёт [EconomicRadarSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  const EconomicRadarSnapshot({
    required this.axes,
    required this.overall,
  });

/// Поле [axes] класса [EconomicRadarSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  final List<RadarAxis> axes;
/// Поле [overall] класса [EconomicRadarSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  final double overall;
}

/// Приватная функция [_clampScore].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
double _clampScore(double value) => value.clamp(0, 100);

/// Оценка «здоровья» по 4 осям (0–100). Чем выше — тем лучше для инвестора.
EconomicRadarSnapshot buildEconomicRadar({
  List<CurrencyRate>? rates,
  KeyRateSnapshot? keyRate,
  List<MarketAsset>? stocks,
  List<InflationPoint>? inflation,
  FearGreedIndex? fearGreed,
}) {
  final axes = <RadarAxis>[];

  // Рынок: IMOEX или SPY
  MarketAsset? market;
  if (stocks != null) {
    market = stocks.where((a) => a.symbol == 'IMOEX').firstOrNull ??
        stocks.where((a) => a.symbol == 'SPY').firstOrNull;
  }
  if (market != null) {
    axes.add(RadarAxis(
      label: 'Рынок',
      score: _clampScore(50 + market.changePercent * 5),
    ));
  }

  // Валюта: стабильность USD/RUB (малый |Δ| = высокий score)
  if (rates != null) {
    final rub = rates.where((r) => r.isRub).firstOrNull;
    if (rub?.changePercent != null) {
      axes.add(RadarAxis(
        label: 'Валюта',
        score: _clampScore(100 - rub!.changePercent!.abs() * 15),
      ));
    }
  }

  // Инфляция РФ: ниже = лучше
  if (inflation != null) {
    final ru = inflation.where((p) => p.countryCode == 'RU').firstOrNull;
    if (ru != null) {
      axes.add(RadarAxis(
        label: 'Инфляция',
        score: _clampScore(100 - ru.value * 4),
      ));
    }
  }

  // Ставка ЦБ: умеренная 15–25% = оптимум
  if (keyRate != null) {
    final r = keyRate.current;
    final dist = (r - 20).abs();
    axes.add(RadarAxis(
      label: 'Ставка',
      score: _clampScore(100 - dist * 4),
    ));
  }

  // Fear & Greed
  if (fearGreed != null) {
    axes.add(RadarAxis(
      label: 'F&G',
      score: fearGreed.value.toDouble(),
    ));
  }

  final overall = axes.isEmpty
      ? 50.0
      : axes.map((a) => a.score).reduce((a, b) => a + b) / axes.length;

  return EconomicRadarSnapshot(axes: axes, overall: overall);
}

/// Extension [_FirstOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
