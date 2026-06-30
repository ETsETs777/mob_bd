// =============================================================================
// EcoPulse · lib/features/portfolio/paper_portfolio_screen.dart
// Автор: Цымбал Е. В.
// Дата: 11.06.2026
// Бумажный портфель, аллокация, P&L. Файл: paper_portfolio_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_backtest.dart';
import '../../core/utils/portfolio_export.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/portfolio/live_portfolio_snapshot_provider.dart';
import '../../providers/portfolio_customization_provider.dart';
import 'add_position_sheet.dart';
import 'portfolio_allocation_card.dart';
import 'portfolio_income_card.dart';
import '../calendar/user_calendar_home_card.dart';
import 'portfolio_rebalance_card.dart';
import 'portfolio_robo_advisor_card.dart';
import 'portfolio_real_return_card.dart';
import 'portfolio_scenario_card.dart';
import 'portfolio_trade_journal_card.dart';
import 'portfolio_accounts_bar.dart';
import 'portfolio_savings_goals_card.dart';
import 'broker_portfolio_card.dart';
import 'portfolio_trade_journal_screen.dart';
import 'portfolio_value_ticker.dart';
import 'portfolio_tax_report_card.dart';

/// Класс [PaperPortfolioScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class PaperPortfolioScreen extends ConsumerWidget {
/// Создаёт [PaperPortfolioScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const PaperPortfolioScreen({super.key});

/// Отрисовывает UI [PaperPortfolioScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(portfolioLiveRefreshProvider);

    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final snapshot = ref.watch(livePortfolioSnapshotProvider)?.snapshot ??
        ref.watch(portfolioSnapshotProvider);
    final liveMeta = ref.watch(livePortfolioSnapshotProvider);
    final portfolio = ref.watch(paperPortfolioProvider);
    final activeAccount = ref.watch(activePaperPortfolioAccountProvider);
    final portfolioConfig = ref.watch(resolvedPortfolioProvider);
    final crypto = ref.watch(cryptoProvider).valueOrNull?.assets ?? [];
    final stocks = ref.watch(stocksProvider).valueOrNull ?? [];
    final bonds = ref.watch(bondsProvider).valueOrNull ?? [];
    final ratesList = ref.watch(currencyRatesProvider).valueOrNull;
    var usdRub = 90.0;
    if (ratesList != null) {
      for (final r in ratesList) {
        if (r.isRub && r.code == 'USD') {
          usdRub = r.rate;
          break;
        }
      }
    }
    final backtest = snapshot == null
        ? null
        : backtestPortfolio30d(
            portfolio: portfolio,
            assets: [...crypto, ...stocks, ...bonds],
            usdRubRate: usdRub,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.portfolioTitle} · ${activeAccount.name}'),
        actions: [
          if (portfolioConfig.showJournal)
            IconButton(
              icon: const Icon(Iconsax.book),
              tooltip: l10n.portfolioTradeJournalTitle,
              onPressed: () => openAppPage(
                context,
                PortfolioTradeJournalScreen(
                  showRealizedPnl: portfolioConfig.showRealizedPnl,
                ),
              ),
            ),
          if (snapshot != null && snapshot.positions.isNotEmpty)
            IconButton(
              icon: const Icon(Iconsax.document_download),
              tooltip: l10n.portfolioExportCsv,
              onPressed: () => _exportCsv(context, snapshot, l10n),
            ),
          if (portfolio.positions.isNotEmpty)
            IconButton(
              icon: const Icon(Iconsax.refresh),
              tooltip: l10n.portfolioReset,
              onPressed: () => _confirmReset(context, ref, l10n),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddPositionSheet(context, ref),
        icon: const Icon(Iconsax.add),
        label: Text(l10n.portfolioAdd),
      ),
      body: snapshot == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const PortfolioAccountsBar(),
                const Gap(12),
                const BrokerPortfolioCard(),
                const Gap(12),
                _SummaryCard(
                  snapshot: snapshot,
                  l10n: l10n,
                  isLive: liveMeta?.isLive ?? false,
                  liveUpdatedAt: liveMeta?.liveUpdatedAt,
                ),
                const Gap(12),
                const PortfolioSavingsGoalsCard(),
                const Gap(12),
                PortfolioAllocationCard(snapshot: snapshot),
                const Gap(12),
                const PortfolioRoboAdvisorCard(),
                const Gap(12),
                PortfolioRebalanceCard(snapshot: snapshot),
                const Gap(12),
                const PortfolioIncomeCard(),
                const Gap(12),
                const UserCalendarHomeCard(),
                const Gap(12),
                PortfolioScenarioCard(snapshot: snapshot),
                const Gap(12),
                PortfolioRealReturnCard(snapshot: snapshot),
                if (portfolioConfig.showJournal) ...[
                  const Gap(12),
                  PortfolioTradeJournalCard(
                    showRealizedPnl: portfolioConfig.showRealizedPnl,
                  ),
                ],
                const PortfolioTaxReportCard(),
                if (backtest != null) ...[
                  const Gap(12),
                  _BacktestCard(result: backtest, l10n: l10n),
                ],
                const Gap(16),
                Text(
                  l10n.portfolioPositions,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: palette.accent,
                  ),
                ),
                const Gap(8),
                if (snapshot.positions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        l10n.portfolioEmptyPositions,
                        style: TextStyle(color: palette.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...snapshot.positions.map(
                    (ps) => _PositionTile(
                      snapshot: ps,
                      onRemove: () => ref
                          .read(paperPortfolioProvider.notifier)
                          .removePosition(
                            ps.position.assetKey,
                            sellUnitPrice: ps.currentPrice,
                            proceedsRub: ps.valueRub,
                            pnlRub: ps.pnlRub,
                          ),
                    ),
                  ),
              ],
            ),
    );
  }

/// Приватный метод [_exportCsv] класса [PaperPortfolioScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  Future<void> _exportCsv(
    BuildContext context,
    PortfolioSnapshot snapshot,
    AppLocalizations l10n,
  ) async {
    final csv = portfolioToCsv(snapshot);
    await Share.share(csv, subject: 'EcoPulse Portfolio');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.portfolioExportDone),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

/// Приватный метод [_confirmReset] класса [PaperPortfolioScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  Future<void> _confirmReset(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.portfolioReset),
        content: Text(l10n.portfolioResetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.portfolioReset),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(paperPortfolioProvider.notifier).reset();
    }
  }
}

/// Приватный класс [_BacktestCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class _BacktestCard extends StatelessWidget {
/// Создаёт [_BacktestCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _BacktestCard({required this.result, required this.l10n});

/// Поле [result] класса [_BacktestCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final PortfolioBacktestResult result;
/// Поле [l10n] класса [_BacktestCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final AppLocalizations l10n;

/// Отрисовывает UI [_BacktestCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final change = Formatters.percent(result.changePercent);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.portfolioBacktestTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: palette.accent,
              ),
            ),
            const Gap(8),
            Text(
              l10n.portfolioBacktestResult(
                Formatters.rub(result.pastValueRub),
                Formatters.rub(result.currentValueRub),
                change,
              ),
              style: TextStyle(color: palette.textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_SummaryCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class _SummaryCard extends StatelessWidget {
/// Создаёт [_SummaryCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _SummaryCard({
    required this.snapshot,
    required this.l10n,
    this.isLive = false,
    this.liveUpdatedAt,
  });

/// Поле [snapshot] класса [_SummaryCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final PortfolioSnapshot snapshot;
/// Поле [l10n] класса [_SummaryCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final AppLocalizations l10n;
  final bool isLive;
  final DateTime? liveUpdatedAt;

/// Отрисовывает UI [_SummaryCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final pnlColor =
        snapshot.pnlRub >= 0 ? palette.positive : palette.negative;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.portfolioTotal,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            PortfolioValueTicker(
              totalValueRub: snapshot.totalValueRub,
              isLive: isLive,
              liveUpdatedAt: liveUpdatedAt,
            ),
            const Gap(8),
            Row(
              children: [
                _Metric(
                  label: l10n.portfolioPnl,
                  value: Formatters.percent(snapshot.pnlPercent),
                  color: pnlColor,
                ),
                const Gap(16),
                _Metric(
                  label: l10n.portfolioCash,
                  value: Formatters.rub(snapshot.portfolio.cashRub),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_Metric].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class _Metric extends StatelessWidget {
/// Создаёт [_Metric].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _Metric({
    required this.label,
    required this.value,
    this.color,
  });

/// Поле [label] класса [_Metric].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final String label;
/// Поле [value] класса [_Metric].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final String value;
/// Поле [color] класса [_Metric].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final Color? color;

/// Отрисовывает UI [_Metric].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: palette.textSecondary, fontSize: 11)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color ?? palette.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Приватный класс [_PositionTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class _PositionTile extends StatelessWidget {
/// Создаёт [_PositionTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  const _PositionTile({required this.snapshot, required this.onRemove});

/// Поле [snapshot] класса [_PositionTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final PositionSnapshot snapshot;
/// Поле [onRemove] класса [_PositionTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final VoidCallback onRemove;

/// Отрисовывает UI [_PositionTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final p = snapshot.position;
    final pnlColor =
        snapshot.pnlRub >= 0 ? palette.positive : palette.negative;
    final live = snapshot.liveAsset;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text('${p.symbol} × ${p.quantity.toStringAsFixed(4)}'),
        subtitle: Text(
          '${l10n.portfolioBuy} ${Formatters.price(p.buyPrice, symbol: p.currency == 'RUB' ? '₽' : '\$')}',
          style: TextStyle(color: palette.textSecondary, fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Formatters.rub(snapshot.valueRub),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              Formatters.percent(snapshot.pnlPercent),
              style: TextStyle(color: pnlColor, fontSize: 12),
            ),
          ],
        ),
        onTap: live != null
            ? null
            : null,
        onLongPress: () {
          HapticFeedback.mediumImpact();
          onRemove();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.portfolioRemoved(p.symbol)),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}

/// Функция [buyAssetForPortfolio] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
Future<void> buyAssetForPortfolio(
  BuildContext context,
  WidgetRef ref,
  MarketAsset asset, {
  double quantity = 1,
}) async {
  final rates = ref.read(currencyRatesProvider).valueOrNull ?? const [];
  final usdRub = rates.where((CurrencyRate r) => r.isRub).firstOrNull?.rate;
  if (usdRub == null) return;

  final l10n = AppLocalizations.of(context)!;
  final ok = await ref.read(paperPortfolioProvider.notifier).buy(
        asset: asset,
        quantity: quantity,
        buyPrice: asset.price,
        usdRubRate: usdRub,
      );

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        ok ? l10n.portfolioBought(asset.symbol) : l10n.portfolioInsufficientCash,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Extension [_FirstOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
