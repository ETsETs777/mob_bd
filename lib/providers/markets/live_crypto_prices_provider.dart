import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/binance_live_stream.dart';
import '../../core/utils/live_crypto_utils.dart';
import '../../data/models/crypto_feed.dart';
import '../../data/models/market_asset.dart';
import '../../providers/app/feature_flags_provider.dart';
import '../../providers/app/app_providers.dart';
import '../../providers/portfolio/paper_portfolio_provider.dart';
import '../../providers/watchlist_provider.dart';

class LiveCryptoPricesState {
  const LiveCryptoPricesState({
    this.ticks = const {},
    this.connected = false,
  });

  final Map<String, LiveCryptoTick> ticks;
  final bool connected;

  LiveCryptoPricesState copyWith({
    Map<String, LiveCryptoTick>? ticks,
    bool? connected,
  }) {
    return LiveCryptoPricesState(
      ticks: ticks ?? this.ticks,
      connected: connected ?? this.connected,
    );
  }
}

final liveCryptoPricesProvider =
    NotifierProvider<LiveCryptoPricesNotifier, LiveCryptoPricesState>(
  LiveCryptoPricesNotifier.new,
);

class LiveCryptoPricesNotifier extends Notifier<LiveCryptoPricesState> {
  BinanceLiveStream? _stream;
  StreamSubscription<LiveCryptoTick>? _tickSub;

  @override
  LiveCryptoPricesState build() {
    ref.onDispose(_teardown);

    final enabled =
        ref.watch(featureFlagsProvider)[FeatureFlag.liveCryptoWebSocket] ??
            FeatureFlag.liveCryptoWebSocket.defaultValue;

    if (!enabled) {
      _teardown();
      return const LiveCryptoPricesState();
    }

    ref.listen(cryptoProvider, (_, next) {
      next.whenData((feed) => _syncSymbols(feed.assets));
    }, fireImmediately: true);

    ref.listen(watchlistProvider, (_, __) {
      final feed = ref.read(cryptoProvider).valueOrNull;
      if (feed != null) _syncSymbols(feed.assets);
    });

    ref.listen(paperPortfolioProvider, (_, __) {
      final feed = ref.read(cryptoProvider).valueOrNull;
      if (feed != null) _syncSymbols(feed.assets);
    });

    return const LiveCryptoPricesState();
  }

  Future<void> _syncSymbols(List<MarketAsset> assets) async {
    final watchlistKeys = ref.read(watchlistProvider);
    final symbols = <String>{};

    for (final asset in assets.take(30)) {
      if (asset.type == AssetType.crypto) symbols.add(asset.symbol);
    }

    for (final key in watchlistKeys) {
      if (!key.startsWith('crypto:')) continue;
      final id = key.split(':').last;
      final match = assets.where((a) => a.id == id);
      if (match.isNotEmpty) symbols.add(match.first.symbol);
    }

    for (final pos in ref.read(paperPortfolioProvider).positions) {
      if (pos.type == AssetType.crypto) symbols.add(pos.symbol);
    }

    if (symbols.isEmpty) {
      await _stream?.disconnect();
      state = const LiveCryptoPricesState();
      return;
    }

    _stream ??= BinanceLiveStream();
    await _stream!.connect(symbols.toList());
    _tickSub ??= _stream!.ticks.listen(_onTick);
    state = state.copyWith(connected: _stream!.isConnected);
  }

  void _onTick(LiveCryptoTick tick) {
    final next = Map<String, LiveCryptoTick>.from(state.ticks);
    next[tick.symbol] = tick;
    state = state.copyWith(ticks: next, connected: true);
  }

  void _teardown() {
    _tickSub?.cancel();
    _tickSub = null;
    _stream?.disconnect();
    _stream = null;
  }
}

/// Crypto feed с подмешанными live-ценами Binance.
final cryptoWithLiveProvider = Provider<AsyncValue<CryptoFeed>>((ref) {
  final crypto = ref.watch(cryptoProvider);
  final live = ref.watch(liveCryptoPricesProvider);
  final enabled =
      ref.watch(featureFlagsProvider)[FeatureFlag.liveCryptoWebSocket] ??
          FeatureFlag.liveCryptoWebSocket.defaultValue;

  if (!enabled || live.ticks.isEmpty) return crypto;

  return crypto.whenData(
    (feed) => CryptoFeed(
      assets: applyLiveCryptoPrices(feed.assets, live.ticks),
      loadedPages: feed.loadedPages,
      loadingMore: feed.loadingMore,
    ),
  );
});
