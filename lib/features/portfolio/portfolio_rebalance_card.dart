// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_rebalance_card.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Карточка ребалансировки: пресеты и подсказки buy/sell.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_rebalance.dart';
import '../../data/models/portfolio_position.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/portfolio_rebalance_provider.dart';
import 'portfolio_allocation_card.dart';

/// Карточка целевой аллокации и подсказок ребалансировки.
class PortfolioRebalanceCard extends ConsumerWidget {
  const PortfolioRebalanceCard({super.key, required this.snapshot});

  final PortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final preset = ref.watch(portfolioRebalancePresetProvider);
    final target = ref.watch(portfolioTargetAllocationProvider);
    final plan = computeRebalancePlan(snapshot: snapshot, target: target);

    if (snapshot.totalValueRub <= 0) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.chart_21, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.portfolioRebalanceTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.accent,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(4),
            Text(
              l10n.portfolioRebalanceSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: RebalancePreset.values.map((p) {
                final selected = preset == p;
                return FilterChip(
                  label: Text(_presetLabel(p, l10n)),
                  selected: selected,
                  onSelected: (_) =>
                      ref.read(portfolioRebalancePresetProvider.notifier).setPreset(p),
                );
              }).toList(),
            ),
            if (preset == RebalancePreset.custom) ...[
              const Gap(12),
              _CustomSliders(
                allocation: target,
                onChanged: (weights) => ref
                    .read(portfolioCustomAllocationProvider.notifier)
                    .setWeights(weights),
                l10n: l10n,
              ),
            ],
            const Gap(16),
            if (plan.needsRebalance)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.portfolioRebalanceDrift(
                    '${plan.maxDriftPercent.toStringAsFixed(1)}%',
                  ),
                  style: TextStyle(fontSize: 12, color: palette.accent),
                ),
              )
            else
              Text(
                l10n.portfolioRebalanceOnTarget,
                style: TextStyle(fontSize: 12, color: palette.positive),
              ),
            const Gap(12),
            ...plan.suggestions.map(
              (s) => _SuggestionRow(suggestion: s, l10n: l10n),
            ),
          ],
        ),
      ),
    );
  }

  String _presetLabel(RebalancePreset preset, AppLocalizations l10n) =>
      switch (preset) {
        RebalancePreset.conservative => l10n.portfolioRebalanceConservative,
        RebalancePreset.balanced => l10n.portfolioRebalancePresetBalanced,
        RebalancePreset.growth => l10n.portfolioRebalanceGrowth,
        RebalancePreset.custom => l10n.portfolioRebalanceCustom,
      };
}

class _CustomSliders extends StatelessWidget {
  const _CustomSliders({
    required this.allocation,
    required this.onChanged,
    required this.l10n,
  });

  final PortfolioTargetAllocation allocation;
  final ValueChanged<Map<String, double>> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Column(
      children: portfolioAssetClasses.map((key) {
        final value = allocation[key];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  PortfolioAllocationCard.labelFor(key, l10n),
                  style: TextStyle(fontSize: 12, color: palette.textSecondary),
                ),
              ),
              Expanded(
                child: Slider(
                  value: value.clamp(0, 100),
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '${value.round()}%',
                  onChanged: (v) {
                    final next = Map<String, double>.from(allocation.weights);
                    next[key] = v;
                    onChanged(next);
                  },
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '${value.round()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.suggestion, required this.l10n});

  final RebalanceSuggestion suggestion;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final label = PortfolioAllocationCard.labelFor(suggestion.assetClass, l10n);

    final (IconData icon, Color color, String actionText) = switch (
      suggestion.action
    ) {
      RebalanceAction.buy when suggestion.assetClass == 'cash' => (
          Iconsax.wallet_add,
          palette.positive,
          l10n.portfolioRebalanceFreeCash(
            Formatters.rub(suggestion.deltaRub.abs()),
          ),
        ),
      RebalanceAction.sell when suggestion.assetClass == 'cash' => (
          Iconsax.send_2,
          palette.accent,
          l10n.portfolioRebalanceInvestCash(
            Formatters.rub(suggestion.deltaRub.abs()),
          ),
        ),
      RebalanceAction.buy => (
          Iconsax.arrow_up,
          palette.positive,
          l10n.portfolioRebalanceBuy(Formatters.rub(suggestion.deltaRub.abs())),
        ),
      RebalanceAction.sell => (
          Iconsax.arrow_down,
          palette.negative,
          l10n.portfolioRebalanceSell(Formatters.rub(suggestion.deltaRub.abs())),
        ),
      RebalanceAction.hold => (
          Iconsax.tick_circle,
          palette.textSecondary,
          l10n.portfolioRebalanceHold,
        ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  l10n.portfolioRebalanceCurrentTarget(
                    suggestion.currentPercent.round(),
                    suggestion.targetPercent.round(),
                  ),
                  style: TextStyle(fontSize: 11, color: palette.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            actionText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
