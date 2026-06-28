// =============================================================================
// EcoPulse · lib/providers/paper_portfolio_provider.dart
// Автор: Цымбал Е. В.
// Дата: 23.05.2026
// Riverpod state: провайдеры и notifiers. Файл: paper_portfolio_provider.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/portfolio_math.dart';
import '../data/models/currency_rate.dart';
import '../data/models/market_asset.dart';
import '../data/models/portfolio_position.dart';
import '../data/services/cache_service.dart';
import 'app_providers.dart';
import 'portfolio_trade_journal_provider.dart';

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
/// Поле [cacheKey] класса [PaperPortfolioNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  static const cacheKey = 'paper_portfolio';

/// Отрисовывает UI [PaperPortfolioNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  @override
  PaperPortfolio build() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return const PaperPortfolio();
    try {
      return PaperPortfolio.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const PaperPortfolio();
    }
  }

/// Метод [buy] класса [PaperPortfolioNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  Future<bool> buy({
    required MarketAsset asset,
    required double quantity,
    required double buyPrice,
    required double usdRubRate,
  }) async {
    if (quantity <= 0) return false;
    final costRub = asset.currency == 'RUB'
        ? quantity * buyPrice
        : quantity * buyPrice * usdRubRate;
    if (costRub > state.cashRub) return false;

    final key = portfolioAssetKey(asset);
    final existingIdx =
        state.positions.indexWhere((p) => p.assetKey == key);
    final positions = List<PortfolioPosition>.from(state.positions);

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

    state = state.copyWith(
      cashRub: state.cashRub - costRub,
      positions: positions,
    );
    await _persist();
    await ref.read(portfolioTradeJournalProvider.notifier).logBuy(
          asset: asset,
          assetKey: key,
          quantity: quantity,
          unitPrice: buyPrice,
          amountRub: costRub,
        );
    return true;
  }

/// Метод [removePosition] класса [PaperPortfolioNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  Future<void> removePosition(
    String assetKey, {
    double? sellUnitPrice,
    double? proceedsRub,
    double? pnlRub,
  }) async {
    final pos = state.positions
        .where((p) => p.assetKey == assetKey)
        .firstOrNull;
    if (pos == null) return;

    final cashBack = proceedsRub ?? pos.costRub;

    state = state.copyWith(
      cashRub: state.cashRub + cashBack,
      positions: state.positions.where((p) => p.assetKey != assetKey).toList(),
    );
    await _persist();
    await ref.read(portfolioTradeJournalProvider.notifier).logSell(
          position: pos,
          unitPrice: sellUnitPrice ?? pos.buyPrice,
          proceedsRub: cashBack,
          pnlRub: pnlRub ?? (cashBack - pos.costRub),
        );
  }

/// Метод [reset] класса [PaperPortfolioNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> reset() async {
    state = const PaperPortfolio();
    await _persist();
    await ref.read(portfolioTradeJournalProvider.notifier).clear();
  }

/// Приватный метод [_persist] класса [PaperPortfolioNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  Future<void> _persist() async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(state.toJson()),
    );
  }
}

/// Extension [_FirstOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
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
  if (portfolio.positions.isEmpty && portfolio.cashRub == portfolio.initialCapitalRub) {
    // still show empty portfolio on screen but home card can check positions.isEmpty
  }
  final crypto = ref.watch(cryptoProvider).valueOrNull?.assets ?? const [];
  final stocks = ref.watch(stocksProvider).valueOrNull ?? const [];
  final rates = ref.watch(currencyRatesProvider).valueOrNull ?? const [];
  final usdRub = rates.where((CurrencyRate r) => r.isRub).firstOrNull?.rate;
  if (usdRub == null || usdRub <= 0) return null;

  return buildPortfolioSnapshot(
    portfolio: portfolio,
    allAssets: [...crypto, ...stocks, ...ref.watch(bondsProvider).valueOrNull ?? const []],
    usdRubRate: usdRub,
  );
});
