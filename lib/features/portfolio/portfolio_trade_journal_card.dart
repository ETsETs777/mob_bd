// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_trade_journal_card.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Карточка журнала сделок на экране портфеля.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_trade_journal.dart';
import '../../data/models/portfolio_trade.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/portfolio_trade_journal_provider.dart';
import 'portfolio_trade_journal_screen.dart';

/// Карточка последних сделок с переходом к полному журналу.
class PortfolioTradeJournalCard extends ConsumerWidget {
  const PortfolioTradeJournalCard({
    super.key,
    this.showRealizedPnl = true,
  });

  final bool showRealizedPnl;

  static const _previewCount = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final trades = ref.watch(portfolioTradeJournalProvider);

    if (trades.isEmpty) return const SizedBox.shrink();

    final stats = buildTradeJournalStats(trades);
    final preview = trades.take(_previewCount).toList();
    final locale = Localizations.localeOf(context).languageCode;
    final dateFmt = DateFormat('d MMM · HH:mm', locale);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.book, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.portfolioTradeJournalTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.accent,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => openAppPage(
                    context,
                    PortfolioTradeJournalScreen(
                      showRealizedPnl: showRealizedPnl,
                    ),
                  ),
                  child: Text(l10n.portfolioTradeJournalOpenAll),
                ),
              ],
            ),
            const Gap(4),
            Text(
              l10n.portfolioTradeJournalSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            if (showRealizedPnl) ...[
              const Gap(8),
              Text(
                l10n.portfolioTradeJournalRealizedPnl(
                  Formatters.rub(stats.realizedPnlRub),
                ),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: stats.realizedPnlRub >= 0
                      ? palette.positive
                      : palette.negative,
                ),
              ),
            ],
            const Gap(12),
            ...preview.map(
              (t) => _PreviewRow(
                trade: t,
                dateFmt: dateFmt,
                l10n: l10n,
                palette: palette,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.trade,
    required this.dateFmt,
    required this.l10n,
    required this.palette,
  });

  final PortfolioTrade trade;
  final DateFormat dateFmt;
  final AppLocalizations l10n;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.kind == PortfolioTradeKind.buy;
    final kindLabel =
        isBuy ? l10n.portfolioTradeJournalBuy : l10n.portfolioTradeJournalSell;
    final color = isBuy ? palette.positive : palette.negative;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isBuy ? Iconsax.arrow_down : Iconsax.arrow_up,
            size: 14,
            color: color,
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trade.symbol} · $kindLabel',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  dateFmt.format(trade.at),
                  style: TextStyle(
                    fontSize: 11,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Formatters.rub(trade.amountRub),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
