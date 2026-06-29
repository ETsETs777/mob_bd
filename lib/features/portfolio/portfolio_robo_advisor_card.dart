// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_robo_advisor_card.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_rebalance.dart';
import '../../core/utils/portfolio_robo_advisor.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/portfolio/portfolio_robo_advisor_provider.dart';
import '../../providers/portfolio_rebalance_provider.dart';
import 'portfolio_allocation_card.dart';

/// Карточка robo-advisor lite: рекомендация аллокации и приоритетные действия.
class PortfolioRoboAdvisorCard extends ConsumerWidget {
  const PortfolioRoboAdvisorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final advice = ref.watch(portfolioRoboAdvisorProvider);
    final currentPreset = ref.watch(portfolioRebalancePresetProvider);

    if (advice == null) return const SizedBox.shrink();

    final presetLabel = _presetLabel(advice.recommendedPreset, l10n);
    final matches = advice.presetMatches(currentPreset);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.cpu, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.portfolioRoboTitle,
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
              l10n.portfolioRoboSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: palette.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: palette.accent.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.portfolioRoboRecommended(presetLabel),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    l10n.portfolioRoboRiskScore(advice.riskScore),
                    style: TextStyle(fontSize: 12, color: palette.textSecondary),
                  ),
                ],
              ),
            ),
            const Gap(12),
            ...advice.rationaleKeys.map(
              (key) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.lamp_on, size: 14, color: palette.accent),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        _rationaleText(key, l10n),
                        style: TextStyle(fontSize: 12, color: palette.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (advice.topActions.isNotEmpty) ...[
              const Gap(12),
              Text(
                l10n.portfolioRoboActionsHeader,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                  fontSize: 13,
                ),
              ),
              const Gap(8),
              ...advice.topActions.map(
                (s) => _ActionRow(suggestion: s, l10n: l10n, palette: palette),
              ),
            ] else if (advice.plan.needsRebalance == false) ...[
              const Gap(8),
              Text(
                l10n.portfolioRebalanceOnTarget,
                style: TextStyle(fontSize: 12, color: palette.positive),
              ),
            ],
            if (!matches) ...[
              const Gap(12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => ref
                      .read(portfolioRebalancePresetProvider.notifier)
                      .setPreset(advice.recommendedPreset),
                  icon: const Icon(Iconsax.tick_circle, size: 18),
                  label: Text(l10n.portfolioRoboApplyPreset(presetLabel)),
                ),
              ),
            ],
            const Gap(12),
            Text(
              l10n.portfolioRoboDisclaimer,
              style: TextStyle(fontSize: 11, color: palette.textSecondary),
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

  String _rationaleText(RoboRationaleKey key, AppLocalizations l10n) =>
      switch (key) {
        RoboRationaleKey.accountIis => l10n.portfolioRoboReasonIis,
        RoboRationaleKey.accountCrypto => l10n.portfolioRoboReasonCrypto,
        RoboRationaleKey.accountUsd => l10n.portfolioRoboReasonUsd,
        RoboRationaleKey.goalShortTerm => l10n.portfolioRoboReasonShortGoal,
        RoboRationaleKey.goalLongTerm => l10n.portfolioRoboReasonLongGoal,
        RoboRationaleKey.fearGreedHigh => l10n.portfolioRoboReasonFngHigh,
        RoboRationaleKey.fearGreedLow => l10n.portfolioRoboReasonFngLow,
        RoboRationaleKey.emptyPortfolio => l10n.portfolioRoboReasonEmpty,
        RoboRationaleKey.highCash => l10n.portfolioRoboReasonHighCash,
        RoboRationaleKey.highCrypto => l10n.portfolioRoboReasonHighCrypto,
        RoboRationaleKey.defaultBalanced => l10n.portfolioRoboReasonDefault,
      };
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.suggestion,
    required this.l10n,
    required this.palette,
  });

  final RebalanceSuggestion suggestion;
  final AppLocalizations l10n;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final label =
        PortfolioAllocationCard.labelFor(suggestion.assetClass, l10n);
    final (IconData icon, Color color, String actionText) = switch (
      suggestion.action
    ) {
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const Gap(8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: palette.textPrimary),
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
