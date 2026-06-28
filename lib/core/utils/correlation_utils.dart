// =============================================================================
// EcoPulse · lib/core/utils/correlation_utils.dart
// Автор: Цымбал Е. В.
// Дата: 07.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: correlation_utils.
// =============================================================================

import 'dart:math' as math;

import '../../data/models/price_point.dart';
import 'chart_normalize.dart';

/// Дневные доходности по ценам close.
List<double> dailyReturns(List<double> prices) {
  if (prices.length < 2) return [];
  final returns = <double>[];
  for (var i = 1; i < prices.length; i++) {
    final prev = prices[i - 1];
    if (prev == 0) continue;
    returns.add((prices[i] - prev) / prev);
  }
  return returns;
}

/// Коэффициент Пирсона (−1…1).
double? pearsonCorrelation(List<double> a, List<double> b) {
  if (a.length != b.length || a.length < 3) return null;

  final n = a.length;
  final meanA = a.reduce((x, y) => x + y) / n;
  final meanB = b.reduce((x, y) => x + y) / n;

  var num = 0.0;
  var denA = 0.0;
  var denB = 0.0;
  for (var i = 0; i < n; i++) {
    final da = a[i] - meanA;
    final db = b[i] - meanB;
    num += da * db;
    denA += da * da;
    denB += db * db;
  }
  final den = denA * denB;
  if (den == 0) return null;
  return num / math.sqrt(den);
}

/// Изменение за период sparkline (%).
double? changeFromSparkline(List<double> values) {
  if (values.length < 2) return null;
  final first = values.first;
  if (first == 0) return null;
  return ((values.last - first) / first) * 100;
}

/// Класс [CorrelationAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
class CorrelationAsset {
/// Создаёт [CorrelationAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  const CorrelationAsset({required this.id, required this.label, required this.history});

/// Поле [id] класса [CorrelationAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  final String id;
/// Поле [label] класса [CorrelationAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  final String label;
/// Поле [history] класса [CorrelationAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final List<PricePoint> history;
}

/// Класс [CorrelationSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
class CorrelationSnapshot {
/// Создаёт [CorrelationSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  const CorrelationSnapshot({
    required this.assets,
    required this.matrix,
    required this.days,
  });

/// Поле [assets] класса [CorrelationSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  final List<CorrelationAsset> assets;
/// Поле [matrix] класса [CorrelationSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  final Map<String, Map<String, double>> matrix;
/// Поле [days] класса [CorrelationSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final int days;

/// Метод [pair] класса [CorrelationSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  double? pair(String a, String b) => matrix[a]?[b];
}

/// Функция [buildCorrelationSnapshot] — построение данных или UI.
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
CorrelationSnapshot? buildCorrelationSnapshot({
  required List<CorrelationAsset> assets,
  required int days,
}) {
  if (assets.length < 2) return null;

  final aligned = alignPriceSeries(assets.map((a) => a.history).toList());
  if (aligned.length < 2 || aligned.first.length < 5) return null;

  final returns = aligned
      .map((points) => dailyReturns(points.map((p) => p.value).toList()))
      .toList();
  final minLen = returns.map((r) => r.length).reduce((a, b) => a < b ? a : b);
  if (minLen < 3) return null;

  final trimmed = returns.map((r) => r.sublist(r.length - minLen)).toList();
  final ids = assets.map((a) => a.id).toList();

  final matrix = <String, Map<String, double>>{};
  for (var i = 0; i < ids.length; i++) {
    matrix[ids[i]] = {};
    for (var j = 0; j < ids.length; j++) {
      if (i == j) {
        matrix[ids[i]]![ids[j]] = 1;
      } else {
        matrix[ids[i]]![ids[j]] =
            pearsonCorrelation(trimmed[i], trimmed[j]) ?? 0;
      }
    }
  }

  return CorrelationSnapshot(assets: assets, matrix: matrix, days: days);
}
