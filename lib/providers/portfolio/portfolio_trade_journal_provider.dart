// =============================================================================
// EcoPulse · lib/providers/portfolio_trade_journal_provider.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Hive-журнал сделок бумажного портфеля.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';
import '../../data/models/portfolio_trade.dart';
import '../../data/services/cache_service.dart';
import 'paper_portfolio_store_provider.dart';

/// Riverpod-провайдер журнала сделок.
final portfolioTradeJournalProvider =
    NotifierProvider<PortfolioTradeJournalNotifier, List<PortfolioTrade>>(
  PortfolioTradeJournalNotifier.new,
);

/// Сделки активного счёта.
final activeAccountTradeJournalProvider = Provider<List<PortfolioTrade>>((ref) {
  final accountId = ref.watch(paperPortfolioStoreProvider).activeAccountId;
  return ref
      .watch(portfolioTradeJournalProvider)
      .where((t) => t.accountId == accountId)
      .toList();
});

/// Notifier журнала сделок (Hive).
class PortfolioTradeJournalNotifier extends Notifier<List<PortfolioTrade>> {
  static const cacheKey = 'portfolio_trade_journal';
  static const maxEntries = 200;

  @override
  List<PortfolioTrade> build() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => PortfolioTrade.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> logBuy({
    required String accountId,
    required MarketAsset asset,
    required String assetKey,
    required double quantity,
    required double unitPrice,
    required double amountRub,
  }) async {
    await _append(
      PortfolioTrade(
        id: _newId(),
        kind: PortfolioTradeKind.buy,
        symbol: asset.symbol,
        assetKey: assetKey,
        assetType: asset.type.name,
        quantity: quantity,
        unitPrice: unitPrice,
        currency: asset.currency,
        amountRub: amountRub,
        at: DateTime.now(),
        accountId: accountId,
      ),
    );
  }

  Future<void> logSell({
    required String accountId,
    required PortfolioPosition position,
    required double unitPrice,
    required double proceedsRub,
    required double pnlRub,
  }) async {
    await _append(
      PortfolioTrade(
        id: _newId(),
        kind: PortfolioTradeKind.sell,
        symbol: position.symbol,
        assetKey: position.assetKey,
        assetType: position.type.name,
        quantity: position.quantity,
        unitPrice: unitPrice,
        currency: position.currency,
        amountRub: proceedsRub,
        at: DateTime.now(),
        pnlRub: pnlRub,
        accountId: accountId,
      ),
    );
  }

  Future<void> clear() async {
    state = [];
    await _persist();
  }

  Future<void> clearAccount(String accountId) async {
    state = state.where((t) => t.accountId != accountId).toList();
    await _persist();
  }

  /// Импортирует сделки из CSV в журнал активного счёта.
  Future<int> importTrades(List<PortfolioTrade> trades) async {
    if (trades.isEmpty) return 0;

    final existing = {
      for (final t in state) '${t.at.toIso8601String()}|${t.symbol}|${t.kind.name}|${t.quantity}',
    };

    var added = 0;
    for (final trade in trades) {
      final key =
          '${trade.at.toIso8601String()}|${trade.symbol}|${trade.kind.name}|${trade.quantity}';
      if (existing.contains(key)) continue;
      existing.add(key);
      await _append(trade);
      added++;
    }
    return added;
  }

  Future<void> _append(PortfolioTrade trade) async {
    final next = [trade, ...state];
    if (next.length > maxEntries) {
      state = next.sublist(0, maxEntries);
    } else {
      state = next;
    }
    await _persist();
  }

  String _newId() => '${DateTime.now().microsecondsSinceEpoch}';

  Future<void> _persist() async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(state.map((t) => t.toJson()).toList()),
    );
  }
}
