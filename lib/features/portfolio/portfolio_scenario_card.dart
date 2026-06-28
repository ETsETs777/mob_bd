// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_scenario_card.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// UI сценариев «что если» для бумажного портфеля.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_scenario.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/portfolio_position.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import 'portfolio_allocation_card.dart';

/// Карточка стресс-сценариев для пересчёта стоимости портфеля.
class PortfolioScenarioCard extends ConsumerStatefulWidget {
  const PortfolioScenarioCard({super.key, required this.snapshot});

  final PortfolioSnapshot snapshot;

  @override
  ConsumerState<PortfolioScenarioCard> createState() =>
      _PortfolioScenarioCardState();
}

class _PortfolioScenarioCardState extends ConsumerState<PortfolioScenarioCard> {
  PortfolioScenarioPreset _preset = PortfolioScenarioPreset.usdRubUp10;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);

    if (widget.snapshot.positions.isEmpty) return const SizedBox.shrink();

    final crypto = ref.watch(cryptoProvider).valueOrNull?.assets ?? const [];
    final stocks = ref.watch(stocksProvider).valueOrNull ?? const [];
    final bonds = ref.watch(bondsProvider).valueOrNull ?? const [];
    final rates = ref.watch(currencyRatesProvider).valueOrNull ?? const [];
    final usdRub = rates
        .where((CurrencyRate r) => r.isRub && r.code == 'USD')
        .map((r) => r.rate)
        .firstOrNull;
    if (usdRub == null || usdRub <= 0) return const SizedBox.shrink();

    final shocks = PortfolioScenarioShocks.forPreset(_preset);
    final result = simulatePortfolioScenario(
      baseSnapshot: widget.snapshot,
      allAssets: [...crypto, ...stocks, ...bonds],
      usdRubRate: usdRub,
      shocks: shocks,
    );

    final deltaColor =
        result.deltaRub >= 0 ? palette.positive : palette.negative;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.flash_1, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.portfolioScenarioTitle,
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
              l10n.portfolioScenarioSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PortfolioScenarioPreset.values.map((p) {
                return FilterChip(
                  label: Text(_presetLabel(p, l10n)),
                  selected: _preset == p,
                  onSelected: (_) => setState(() => _preset = p),
                );
              }).toList(),
            ),
            const Gap(16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: deltaColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.portfolioScenarioResult(
                      Formatters.rub(result.baseTotalRub),
                      Formatters.rub(result.scenarioTotalRub),
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      color: palette.textPrimary,
                      height: 1.35,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    l10n.portfolioScenarioDelta(
                      Formatters.rub(result.deltaRub.abs()),
                      Formatters.percent(result.deltaPercent),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: deltaColor,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            ...result.classDeltaRub.entries
                .where((e) => e.value.abs() >= 1)
                .map(
                  (e) => _ClassDeltaRow(
                    label: PortfolioAllocationCard.labelFor(e.key, l10n),
                    deltaRub: e.value,
                    palette: palette,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  String _presetLabel(PortfolioScenarioPreset preset, AppLocalizations l10n) =>
      switch (preset) {
        PortfolioScenarioPreset.usdRubUp10 => l10n.portfolioScenarioUsdUp10,
        PortfolioScenarioPreset.btcDown30 => l10n.portfolioScenarioBtcDown30,
        PortfolioScenarioPreset.imoexDown15 => l10n.portfolioScenarioImoexDown15,
        PortfolioScenarioPreset.keyRateUp2 => l10n.portfolioScenarioKeyRateUp2,
      };
}

class _ClassDeltaRow extends StatelessWidget {
  const _ClassDeltaRow({
    required this.label,
    required this.deltaRub,
    required this.palette,
  });

  final String label;
  final double deltaRub;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final color = deltaRub >= 0 ? palette.positive : palette.negative;
    final sign = deltaRub >= 0 ? '+' : '−';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ),
          Text(
            '$sign${Formatters.rub(deltaRub.abs())}',
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

extension _FirstRate on Iterable<double> {
  double? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
