// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_real_return_card.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Карточка сравнения номинальной и реальной доходности портфеля.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_real_return.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/portfolio_position.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';

/// Карточка «номинал vs реальная доходность» с бенчмарками.
class PortfolioRealReturnCard extends ConsumerStatefulWidget {
  const PortfolioRealReturnCard({super.key, required this.snapshot});

  final PortfolioSnapshot snapshot;

  @override
  ConsumerState<PortfolioRealReturnCard> createState() =>
      _PortfolioRealReturnCardState();
}

class _PortfolioRealReturnCardState
    extends ConsumerState<PortfolioRealReturnCard> {
  RealReturnHorizon _horizon = RealReturnHorizon.days30;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);

    if (widget.snapshot.positions.isEmpty) return const SizedBox.shrink();

    final crypto = ref.watch(cryptoProvider).valueOrNull?.assets ?? const [];
    final stocks = ref.watch(stocksProvider).valueOrNull ?? const [];
    final bonds = ref.watch(bondsProvider).valueOrNull ?? const [];
    final inflation = ref.watch(inflationProvider).valueOrNull;
    final keyRate = ref.watch(keyRateProvider).valueOrNull?.current;
    final rates = ref.watch(currencyRatesProvider).valueOrNull ?? const [];

    final usdRub = rates
        .where((CurrencyRate r) => r.isRub && r.code == 'USD')
        .map((r) => r.rate)
        .firstOrNull;
    if (usdRub == null || usdRub <= 0) return const SizedBox.shrink();

    final comparison = buildPortfolioRealReturnComparison(
      snapshot: widget.snapshot,
      assets: [...crypto, ...stocks, ...bonds],
      usdRubRate: usdRub,
      horizon: _horizon,
      inflation: inflation,
      keyRatePercent: keyRate,
    );

    if (comparison == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.chart_2, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.portfolioRealReturnTitle,
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
              l10n.portfolioRealReturnSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: RealReturnHorizon.values.map((h) {
                return FilterChip(
                  label: Text(_horizonLabel(h, l10n)),
                  selected: _horizon == h,
                  onSelected: (_) => setState(() => _horizon = h),
                );
              }).toList(),
            ),
            const Gap(16),
            ...comparison.rows.map(
              (row) => _ReturnRow(
                label: _rowLabel(row.labelKey, l10n),
                percent: row.percent,
                palette: palette,
                bold: row.highlight,
              ),
            ),
            const Gap(12),
            _VerdictBanner(comparison: comparison, l10n: l10n, palette: palette),
          ],
        ),
      ),
    );
  }

  String _horizonLabel(RealReturnHorizon h, AppLocalizations l10n) {
    return switch (h) {
      RealReturnHorizon.days30 => l10n.portfolioRealReturnHorizon30d,
      RealReturnHorizon.allTime => l10n.portfolioRealReturnHorizonAll,
    };
  }

  String _rowLabel(String key, AppLocalizations l10n) {
    return switch (key) {
      'nominal' => l10n.portfolioRealReturnNominal,
      'real' => l10n.portfolioRealReturnReal,
      'inflation' => l10n.portfolioRealReturnInflation,
      'imoex' => l10n.portfolioRealReturnImoex,
      'deposit' => l10n.portfolioRealReturnDeposit,
      _ => key,
    };
  }
}

class _ReturnRow extends StatelessWidget {
  const _ReturnRow({
    required this.label,
    required this.percent,
    required this.palette,
    this.bold = false,
  });

  final String label;
  final double percent;
  final AppPalette palette;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final color = percent >= 0 ? palette.positive : palette.negative;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            Formatters.percent(percent),
            style: TextStyle(
              color: color,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerdictBanner extends StatelessWidget {
  const _VerdictBanner({
    required this.comparison,
    required this.l10n,
    required this.palette,
  });

  final PortfolioRealReturnComparison comparison;
  final AppLocalizations l10n;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final inflationOk = comparison.beatsInflation;
    final inflationColor = inflationOk ? palette.positive : palette.negative;
    final inflationText = inflationOk
        ? l10n.portfolioRealReturnBeatInflation(
            Formatters.percent(comparison.portfolioRealPercent),
          )
        : l10n.portfolioRealReturnLoseInflation(
            Formatters.percent(comparison.portfolioRealPercent),
          );

    final lines = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            inflationOk ? Iconsax.tick_circle : Iconsax.warning_2,
            size: 16,
            color: inflationColor,
          ),
          const Gap(8),
          Expanded(
            child: Text(
              inflationText,
              style: TextStyle(color: inflationColor, fontSize: 12),
            ),
          ),
        ],
      ),
    ];

    final beatsImoex = comparison.beatsImoex;
    if (beatsImoex != null && comparison.imoexPercent != null) {
      final imoexColor = beatsImoex ? palette.positive : palette.negative;
      final delta = comparison.vsImoexPp!;
      lines.add(const Gap(8));
      lines.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Iconsax.chart, size: 16, color: imoexColor),
            const Gap(8),
            Expanded(
              child: Text(
                beatsImoex
                    ? l10n.portfolioRealReturnBeatImoex(Formatters.percent(delta))
                    : l10n.portfolioRealReturnLoseImoex(
                        Formatters.percent(delta.abs()),
                      ),
                style: TextStyle(color: imoexColor, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    final beatsDeposit = comparison.beatsDeposit;
    if (beatsDeposit != null && comparison.depositPercent != null) {
      final depositColor = beatsDeposit ? palette.positive : palette.negative;
      lines.add(const Gap(8));
      lines.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Iconsax.bank, size: 16, color: depositColor),
            const Gap(8),
            Expanded(
              child: Text(
                beatsDeposit
                    ? l10n.portfolioRealReturnBeatDeposit
                    : l10n.portfolioRealReturnLoseDeposit,
                style: TextStyle(color: depositColor, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines,
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
