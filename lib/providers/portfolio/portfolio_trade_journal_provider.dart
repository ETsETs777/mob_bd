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

/// Riverpod-провайдер журнала сделок.
final portfolioTradeJournalProvider =
    NotifierProvider<PortfolioTradeJournalNotifier, List<PortfolioTrade>>(
  PortfolioTradeJournalNotifier.new,
);

/// Notifier журнала сделок (Hive).
class PortfolioTradeJournalNotifier extends Notifier<List<PortfolioTrade>> {
  static const cacheKey = 'portfolio_trade_journal';
  static const maxEntries = 150;

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
      ),
    );
  }

  Future<void> logSell({
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
      ),
    );
  }

  Future<void> clear() async {
    state = [];
    await _persist();
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
