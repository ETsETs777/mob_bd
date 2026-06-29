// =============================================================================
// EcoPulse · lib/providers/paper_portfolio_provider.dart
// Автор: Цымбал Е. В.
// Дата: 23.05.2026
// Riverpod state: провайдеры и notifiers. Файл: paper_portfolio_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/portfolio_math.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/paper_portfolio_account.dart';
import '../../data/models/portfolio_position.dart';
import 'package:ecopulse/providers/app/app_providers.dart';
import 'package:ecopulse/providers/portfolio/paper_portfolio_store_provider.dart';
import 'package:ecopulse/providers/portfolio/portfolio_trade_journal_provider.dart';

export 'paper_portfolio_store_provider.dart';

/// Riverpod-провайдер [paperPortfolioProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
final paperPortfolioProvider =
    NotifierProvider<PaperPortfolioNotifier, PaperPortfolio>(
  PaperPortfolioNotifier.new,
);

/// Riverpod AsyncNotifier [PaperPortfolioNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
class PaperPortfolioNotifier extends Notifier<PaperPortfolio> {
  @override
  PaperPortfolio build() {
    return ref.watch(paperPortfolioStoreProvider).activePortfolio;
  }

  PaperPortfolioStoreNotifier get _store =>
      ref.read(paperPortfolioStoreProvider.notifier);

  String get _activeAccountId =>
      ref.read(paperPortfolioStoreProvider).activeAccountId;

  Future<bool> buy({
    required MarketAsset asset,
    required double quantity,
    required double buyPrice,
    required double usdRubRate,
  }) async {
    if (quantity <= 0) return false;
    final current = state;
    final costRub = asset.currency == 'RUB'
        ? quantity * buyPrice
        : quantity * buyPrice * usdRubRate;
    if (costRub > current.cashRub) return false;

    final key = portfolioAssetKey(asset);
    final existingIdx =
        current.positions.indexWhere((p) => p.assetKey == key);
    final positions = List<PortfolioPosition>.from(current.positions);

    if (existingIdx >= 0) {
      final old = positions[existingIdx];
      final totalQty = old.quantity + quantity;
      final avgPrice =
          (old.costBasis + quantity * buyPrice) / totalQty;
      positions[existingIdx] = old.copyWith(
        quantity: totalQty,
        buyPrice: avgPrice,
        costRub: old.costRub + costRub,
      );
    } else {
      positions.add(
        PortfolioPosition(
          assetKey: key,
          symbol: asset.symbol,
          type: asset.type,
          quantity: quantity,
          buyPrice: buyPrice,
          currency: asset.currency,
          costRub: costRub,
          boughtAt: DateTime.now(),
        ),
      );
    }

    final updated = current.copyWith(
      cashRub: current.cashRub - costRub,
      positions: positions,
    );
    await _store.setActivePortfolio(updated);
    await ref.read(portfolioTradeJournalProvider.notifier).logBuy(
          accountId: _activeAccountId,
          asset: asset,
          assetKey: key,
          quantity: quantity,
          unitPrice: buyPrice,
          amountRub: costRub,
        );
    return true;
  }

  Future<void> removePosition(
    String assetKey, {
    double? sellUnitPrice,
    double? proceedsRub,
    double? pnlRub,
  }) async {
    final current = state;
    final pos =
        current.positions.where((p) => p.assetKey == assetKey).firstOrNull;
    if (pos == null) return;

    final cashBack = proceedsRub ?? pos.costRub;

    final updated = current.copyWith(
      cashRub: current.cashRub + cashBack,
      positions: current.positions.where((p) => p.assetKey != assetKey).toList(),
    );
    await _store.setActivePortfolio(updated);
    await ref.read(portfolioTradeJournalProvider.notifier).logSell(
          accountId: _activeAccountId,
          position: pos,
          unitPrice: sellUnitPrice ?? pos.buyPrice,
          proceedsRub: cashBack,
          pnlRub: pnlRub ?? (cashBack - pos.costRub),
        );
  }

  Future<void> reset() async {
    await _store.resetActiveAccount();
    await ref
        .read(portfolioTradeJournalProvider.notifier)
        .clearAccount(_activeAccountId);
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

/// Riverpod-провайдер [portfolioSnapshotProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
final portfolioSnapshotProvider = Provider<PortfolioSnapshot?>((ref) {
  final portfolio = ref.watch(paperPortfolioProvider);
  if (portfolio.positions.isEmpty &&
      portfolio.cashRub == portfolio.initialCapitalRub) {
    // still show empty portfolio on screen but home card can check positions.isEmpty
  }
  final crypto = ref.watch(cryptoProvider).valueOrNull?.assets ?? const [];
  final stocks = ref.watch(stocksProvider).valueOrNull ?? const [];
  final rates = ref.watch(currencyRatesProvider).valueOrNull ?? const [];
  final usdRub = rates.where((CurrencyRate r) => r.isRub).firstOrNull?.rate;
  if (usdRub == null || usdRub <= 0) return null;

  return buildPortfolioSnapshot(
    portfolio: portfolio,
    allAssets: [
      ...crypto,
      ...stocks,
      ...ref.watch(bondsProvider).valueOrNull ?? const [],
    ],
    usdRubRate: usdRub,
  );
});

extension _FirstOrNullRate on Iterable<CurrencyRate> {
  CurrencyRate? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

/// Снимок портфеля по id счёта (для целей накопления).
final portfolioSnapshotForAccountProvider =
    Provider.family<PortfolioSnapshot?, String>((ref, accountId) {
  final store = ref.watch(paperPortfolioStoreProvider);
  final account = store.accounts.where((a) => a.id == accountId).firstOrNull;
  if (account == null) return null;

  final crypto = ref.watch(cryptoProvider).valueOrNull?.assets ?? const [];
  final stocks = ref.watch(stocksProvider).valueOrNull ?? const [];
  final rates = ref.watch(currencyRatesProvider).valueOrNull ?? const [];
  final usdRub = rates.where((CurrencyRate r) => r.isRub).firstOrNull?.rate;
  if (usdRub == null || usdRub <= 0) return null;

  return buildPortfolioSnapshot(
    portfolio: account.portfolio,
    allAssets: [
      ...crypto,
      ...stocks,
      ...ref.watch(bondsProvider).valueOrNull ?? const [],
    ],
    usdRubRate: usdRub,
  );
});

extension _FirstOrNullAccount on Iterable<PaperPortfolioAccount> {
  PaperPortfolioAccount? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
