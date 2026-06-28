// =============================================================================
// EcoPulse · lib/providers/portfolio_rebalance_provider.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Пресет и целевая аллокация для ребалансировки портфеля.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/portfolio_rebalance.dart';
import 'app_providers.dart';

final portfolioRebalancePresetProvider =
    NotifierProvider<PortfolioRebalancePresetNotifier, RebalancePreset>(
  PortfolioRebalancePresetNotifier.new,
);

final portfolioTargetAllocationProvider =
    Provider<PortfolioTargetAllocation>((ref) {
  final preset = ref.watch(portfolioRebalancePresetProvider);
  if (preset != RebalancePreset.custom) {
    return PortfolioTargetAllocation.forPreset(preset);
  }
  return ref.watch(portfolioCustomAllocationProvider);
});

final portfolioCustomAllocationProvider =
    NotifierProvider<PortfolioCustomAllocationNotifier, PortfolioTargetAllocation>(
  PortfolioCustomAllocationNotifier.new,
);

class PortfolioRebalancePresetNotifier extends Notifier<RebalancePreset> {
  static const _key = 'portfolio_rebalance_preset';

  @override
  RebalancePreset build() {
    final raw = ref.watch(cacheServiceProvider).getString(_key);
    return RebalancePreset.values.firstWhere(
      (p) => p.name == raw,
      orElse: () => RebalancePreset.balanced,
    );
  }

  Future<void> setPreset(RebalancePreset preset) async {
    await ref.read(cacheServiceProvider).putString(_key, preset.name);
    state = preset;
  }
}

class PortfolioCustomAllocationNotifier extends Notifier<PortfolioTargetAllocation> {
  static const _key = 'portfolio_rebalance_custom_v1';

  @override
  PortfolioTargetAllocation build() {
    final raw = ref.watch(cacheServiceProvider).getString(_key);
    if (raw == null || raw.isEmpty) {
      return PortfolioTargetAllocation.forPreset(RebalancePreset.balanced);
    }
    try {
      return PortfolioTargetAllocation.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return PortfolioTargetAllocation.forPreset(RebalancePreset.balanced);
    }
  }

  Future<void> setWeights(Map<String, double> weights) async {
    final normalized = PortfolioTargetAllocation.normalize(weights);
    await ref.read(cacheServiceProvider).putString(
          _key,
          jsonEncode(normalized.toJson()),
        );
    state = normalized;
  }
}
