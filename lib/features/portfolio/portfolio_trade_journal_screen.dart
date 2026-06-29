// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_trade_journal_screen.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Полный экран журнала сделок бумажного портфеля.
// =============================================================================

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_trade_import.dart';
import '../../core/utils/portfolio_trade_journal.dart';
import '../../data/models/portfolio_trade.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/portfolio/paper_portfolio_store_provider.dart';
import '../../providers/portfolio_trade_journal_provider.dart';

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
    final trades = ref.watch(activeAccountTradeJournalProvider);
    final stats = buildTradeJournalStats(trades);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.portfolioTradeJournalTitle),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.document_upload),
            tooltip: l10n.portfolioTradeJournalImport,
            onPressed: () => _importCsv(context, ref, l10n),
          ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.portfolioTradeJournalEmpty,
                      style: TextStyle(color: palette.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(16),
                    OutlinedButton.icon(
                      onPressed: () => _importCsv(context, ref, l10n),
                      icon: const Icon(Iconsax.document_upload),
                      label: Text(l10n.portfolioTradeJournalImport),
                    ),
                  ],
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

Future<void> _importCsv(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) async {
  try {
    String? csv;

    if (kIsWeb) {
      csv = await _promptPasteCsv(context, l10n);
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'txt'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.bytes != null) {
        csv = utf8.decode(file.bytes!);
      }
    }

    if (csv == null || csv.trim().isEmpty) return;

    final accountId = ref.read(paperPortfolioStoreProvider).activeAccountId;
    final parsed = parseTradeJournalCsv(csv, accountId: accountId);
    if (parsed.trades.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.portfolioTradeJournalImportEmpty),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final added = await ref
        .read(portfolioTradeJournalProvider.notifier)
        .importTrades(parsed.trades);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.portfolioTradeJournalImportDone(added, parsed.skippedRows),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.portfolioTradeJournalImportError(e.toString())),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

Future<String?> _promptPasteCsv(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final controller = TextEditingController();
  final value = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.portfolioTradeJournalImport),
      content: TextField(
        controller: controller,
        maxLines: 8,
        decoration: InputDecoration(
          hintText: l10n.portfolioTradeJournalImportHint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, controller.text),
          child: Text(l10n.portfolioTradeJournalImport),
        ),
      ],
    ),
  );
  controller.dispose();
  return value;
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
