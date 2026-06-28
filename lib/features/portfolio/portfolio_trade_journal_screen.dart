// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_trade_journal_screen.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Полный экран журнала сделок бумажного портфеля.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_trade_journal.dart';

/// Экран истории всех сделок портфеля.
class PortfolioTradeJournalScreen extends ConsumerWidget {
  const PortfolioTradeJournalScreen({
    super.key,
    this.showRealizedPnl = true,
  });

  final bool showRealizedPnl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final trades = ref.watch(portfolioTradeJournalProvider);
    final stats = buildTradeJournalStats(trades);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.portfolioTradeJournalTitle),
        actions: [
          if (trades.isNotEmpty)
            IconButton(
              icon: const Icon(Iconsax.document_download),
              tooltip: l10n.portfolioTradeJournalExport,
              onPressed: () {
                Share.share(
                  tradeJournalToCsv(trades),
                  subject: l10n.portfolioTradeJournalTitle,
                );
              },
            ),
        ],
      ),
      body: trades.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.portfolioTradeJournalEmpty,
                  style: TextStyle(color: palette.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StatsBanner(
                  stats: stats,
                  l10n: l10n,
                  palette: palette,
                  showRealizedPnl: showRealizedPnl,
                ),
                const Gap(16),
                ...trades.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TradeTile(
                      trade: t,
                      l10n: l10n,
                      palette: palette,
                      showRealizedPnl: showRealizedPnl,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatsBanner extends StatelessWidget {
  const _StatsBanner({
    required this.stats,
    required this.l10n,
    required this.palette,
    required this.showRealizedPnl,
  });

  final PortfolioTradeJournalStats stats;
  final AppLocalizations l10n;
  final AppPalette palette;
  final bool showRealizedPnl;

  @override
  Widget build(BuildContext context) {
    final pnlColor =
        stats.realizedPnlRub >= 0 ? palette.positive : palette.negative;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.portfolioTradeJournalStats(
                stats.totalTrades,
                stats.buyCount,
                stats.sellCount,
              ),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            if (showRealizedPnl) ...[
              const Gap(8),
              Text(
                l10n.portfolioTradeJournalRealizedPnl(
                  Formatters.rub(stats.realizedPnlRub),
                ),
                style: TextStyle(color: pnlColor, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TradeTile extends StatelessWidget {
  const _TradeTile({
    required this.trade,
    required this.l10n,
    required this.palette,
    required this.showRealizedPnl,
  });

  final PortfolioTrade trade;
  final AppLocalizations l10n;
  final AppPalette palette;
  final bool showRealizedPnl;

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.kind == PortfolioTradeKind.buy;
    final kindColor = isBuy ? palette.positive : palette.negative;
    final kindLabel =
        isBuy ? l10n.portfolioTradeJournalBuy : l10n.portfolioTradeJournalSell;
    final priceSymbol = trade.currency == 'RUB' ? '₽' : '\$';

    return Card(
      child: ListTile(
        leading: Icon(
          isBuy ? Iconsax.arrow_down : Iconsax.arrow_up,
          color: kindColor,
        ),
        title: Text('${trade.symbol} · $kindLabel'),
        subtitle: Text(
          '${Formatters.formatJournalFull(trade.at)}\n'
          '${trade.quantity.toStringAsFixed(4)} × '
          '${Formatters.price(trade.unitPrice, symbol: priceSymbol)}',
          style: TextStyle(color: palette.textSecondary, fontSize: 12),
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Formatters.rub(trade.amountRub),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (showRealizedPnl && trade.pnlRub != null)
              Text(
                Formatters.rub(trade.pnlRub!),
                style: TextStyle(
                  fontSize: 12,
                  color: trade.pnlRub! >= 0
                      ? palette.positive
                      : palette.negative,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
