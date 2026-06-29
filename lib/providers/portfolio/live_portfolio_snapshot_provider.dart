import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/live_crypto_utils.dart';
import '../../core/utils/portfolio_math.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';
import '../../providers/app/app_providers.dart';
import '../../providers/markets/live_crypto_prices_provider.dart';
import 'paper_portfolio_provider.dart';

/// Снимок портфеля с live-ценами (crypto WebSocket + периодический refresh).
class PortfolioLiveSnapshot {
  const PortfolioLiveSnapshot({
    required this.snapshot,
    required this.isLive,
    this.liveUpdatedAt,
  });

  final PortfolioSnapshot snapshot;
  final bool isLive;
  final DateTime? liveUpdatedAt;
}

/// Портфель с подмешанными live crypto-тиками Binance.
final livePortfolioSnapshotProvider = Provider<PortfolioLiveSnapshot?>((ref) {
  final portfolio = ref.watch(paperPortfolioProvider);
  final live = ref.watch(liveCryptoPricesProvider);

  final crypto = ref.watch(cryptoProvider).valueOrNull?.assets ?? const [];
  final stocks = ref.watch(stocksProvider).valueOrNull ?? const [];
  final bonds = ref.watch(bondsProvider).valueOrNull ?? const [];
  final rates = ref.watch(currencyRatesProvider).valueOrNull ?? const [];
  final usdRub = rates.where((CurrencyRate r) => r.isRub).firstOrNull?.rate;
  if (usdRub == null || usdRub <= 0) return null;

  var assets = <MarketAsset>[...crypto, ...stocks, ...bonds];
  if (live.ticks.isNotEmpty) {
    assets = applyLiveCryptoPrices(assets, live.ticks);
  }

  final snapshot = buildPortfolioSnapshot(
    portfolio: portfolio,
    allAssets: assets,
    usdRubRate: usdRub,
  );

  final hasCrypto = portfolio.positions.any((p) => p.type == AssetType.crypto);
  final cryptoLive = hasCrypto &&
      live.connected &&
      portfolio.positions.any(
        (p) => p.type == AssetType.crypto && live.ticks.containsKey(p.symbol),
      );

  DateTime? updatedAt;
  for (final pos in portfolio.positions) {
    if (pos.type != AssetType.crypto) continue;
    final tick = live.ticks[pos.symbol];
    if (tick == null) continue;
    if (updatedAt == null || tick.updatedAt.isAfter(updatedAt)) {
      updatedAt = tick.updatedAt;
    }
  }

  return PortfolioLiveSnapshot(
    snapshot: snapshot,
    isLive: cryptoLive || (hasCrypto && live.connected),
    liveUpdatedAt: updatedAt,
  );
});

/// Периодически обновляет котировки, пока экран портфеля открыт.
final portfolioLiveRefreshProvider = Provider.autoDispose<void>((ref) {
  final timer = Timer.periodic(const Duration(seconds: 45), (_) {
    ref.invalidate(stocksProvider);
    ref.invalidate(bondsProvider);
    ref.invalidate(cryptoProvider);
  });
  ref.onDispose(timer.cancel);
});

extension _FirstOrNullRate on Iterable<CurrencyRate> {
  CurrencyRate? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
