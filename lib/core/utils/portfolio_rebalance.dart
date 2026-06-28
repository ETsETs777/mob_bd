// =============================================================================
// EcoPulse · lib/core/utils/portfolio_rebalance.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Целевая аллокация и подсказки ребалансировки бумажного портфеля.
// =============================================================================

import '../../data/models/portfolio_position.dart';
import 'portfolio_math.dart';

/// Классы активов для целевой аллокации.
const portfolioAssetClasses = ['cash', 'crypto', 'stocks', 'bonds'];

/// Пресеты целевого распределения (%).
enum RebalancePreset {
  conservative,
  balanced,
  growth,
  custom,
}

/// Целевые доли по классам активов (сумма = 100).
class PortfolioTargetAllocation {
  const PortfolioTargetAllocation(this.weights);

  final Map<String, double> weights;

  double operator [](String key) => weights[key] ?? 0;

  static PortfolioTargetAllocation forPreset(RebalancePreset preset) =>
      switch (preset) {
        RebalancePreset.conservative => const PortfolioTargetAllocation({
            'cash': 20,
            'bonds': 50,
            'stocks': 25,
            'crypto': 5,
          }),
        RebalancePreset.balanced => const PortfolioTargetAllocation({
            'cash': 10,
            'bonds': 30,
            'stocks': 50,
            'crypto': 10,
          }),
        RebalancePreset.growth => const PortfolioTargetAllocation({
            'cash': 5,
            'bonds': 15,
            'stocks': 60,
            'crypto': 20,
          }),
        RebalancePreset.custom => const PortfolioTargetAllocation({
            'cash': 10,
            'bonds': 30,
            'stocks': 50,
            'crypto': 10,
          }),
      };

  /// Нормализует произвольные веса к сумме 100%.
  static PortfolioTargetAllocation normalize(Map<String, double> raw) {
    var sum = 0.0;
    for (final key in portfolioAssetClasses) {
      sum += raw[key]?.clamp(0, 100) ?? 0;
    }
    if (sum <= 0) return forPreset(RebalancePreset.balanced);
    return PortfolioTargetAllocation({
      for (final key in portfolioAssetClasses)
        key: ((raw[key]?.clamp(0, 100) ?? 0) / sum) * 100,
    });
  }

  Map<String, double> toJson() => Map.from(weights);

  factory PortfolioTargetAllocation.fromJson(Map<String, dynamic> json) {
    final raw = <String, double>{};
    for (final key in portfolioAssetClasses) {
      final v = json[key];
      if (v is num) raw[key] = v.toDouble();
    }
    return normalize(raw);
  }
}

/// Действие ребалансировки по классу активов.
enum RebalanceAction { buy, sell, hold }

/// Подсказка: текущая vs целевая доля и сумма сделки в ₽.
class RebalanceSuggestion {
  const RebalanceSuggestion({
    required this.assetClass,
    required this.currentValueRub,
    required this.currentPercent,
    required this.targetPercent,
    required this.deltaRub,
    required this.action,
  });

  final String assetClass;
  final double currentValueRub;
  final double currentPercent;
  final double targetPercent;
  final double deltaRub;
  final RebalanceAction action;
}

/// Результат расчёта ребалансировки.
class RebalancePlan {
  const RebalancePlan({
    required this.totalValueRub,
    required this.suggestions,
    required this.maxDriftPercent,
  });

  final double totalValueRub;
  final List<RebalanceSuggestion> suggestions;
  final double maxDriftPercent;

  bool get needsRebalance =>
      suggestions.any((s) => s.action != RebalanceAction.hold);
}

/// Считает подсказки «купить / продать» по классам активов.
RebalancePlan computeRebalancePlan({
  required PortfolioSnapshot snapshot,
  required PortfolioTargetAllocation target,
  double minDeltaPercent = 2,
  double minDeltaRub = 500,
}) {
  final total = snapshot.totalValueRub;
  if (total <= 0) {
    return const RebalancePlan(
      totalValueRub: 0,
      suggestions: [],
      maxDriftPercent: 0,
    );
  }

  final slices = buildPortfolioAllocation(snapshot);
  final currentByClass = {
    for (final key in portfolioAssetClasses) key: 0.0,
  };
  for (final slice in slices) {
    currentByClass[slice.key] = slice.valueRub;
  }

  final suggestions = <RebalanceSuggestion>[];
  var maxDrift = 0.0;

  for (final key in portfolioAssetClasses) {
    final currentValue = currentByClass[key] ?? 0;
    final currentPct = (currentValue / total) * 100;
    final targetPct = target[key];
    final drift = (currentPct - targetPct).abs();
    if (drift > maxDrift) maxDrift = drift;

    final targetValue = total * targetPct / 100;
    final delta = targetValue - currentValue;

    RebalanceAction action;
    if (delta.abs() < minDeltaRub && drift < minDeltaPercent) {
      action = RebalanceAction.hold;
    } else if (delta > 0) {
      action = RebalanceAction.buy;
    } else if (delta < 0) {
      action = RebalanceAction.sell;
    } else {
      action = RebalanceAction.hold;
    }

    suggestions.add(
      RebalanceSuggestion(
        assetClass: key,
        currentValueRub: currentValue,
        currentPercent: currentPct,
        targetPercent: targetPct,
        deltaRub: delta,
        action: action,
      ),
    );
  }

  return RebalancePlan(
    totalValueRub: total,
    suggestions: suggestions,
    maxDriftPercent: maxDrift,
  );
}
