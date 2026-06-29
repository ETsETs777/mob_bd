import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/overnight_snapshot.dart';
import '../../data/models/market_asset.dart';
import '../app_providers.dart';
import '../markets/watchlist_provider.dart';

class OvernightBrief {
  const OvernightBrief({
    required this.savedAt,
    required this.changes,
  });

  final DateTime savedAt;
  final List<OvernightChange> changes;

  bool get hasChanges => changes.isNotEmpty;
}

final overnightBriefProvider = Provider<OvernightBrief?>((ref) {
  final cache = ref.watch(cacheServiceProvider);
  final previous = loadOvernightSnapshot(cache);
  if (previous == null) return null;

  final watchlist = ref.watch(watchlistProvider);
  final rates = ref.watch(currencyRatesProvider).valueOrNull;
  final crypto = ref.watch(cryptoProvider).valueOrNull?.assets;
  final stocks = ref.watch(stocksProvider).valueOrNull ?? const <MarketAsset>[];
  final cryptoList = crypto ?? const <MarketAsset>[];
  final allAssets = [...cryptoList, ...stocks];

  final current = buildOvernightPricePoints(
    watchlistKeys: watchlist,
    allAssets: allAssets,
    rates: rates,
    crypto: cryptoList,
  );

  final changes = computeOvernightChanges(
    previous: previous,
    currentPoints: current,
  );

  if (changes.isEmpty) return null;
  return OvernightBrief(savedAt: previous.savedAt, changes: changes);
});

Future<void> persistOvernightSnapshot(WidgetRef ref) async {
  final cache = ref.read(cacheServiceProvider);
  final watchlist = ref.read(watchlistProvider);
  final rates = ref.read(currencyRatesProvider).valueOrNull;
  final crypto = ref.read(cryptoProvider).valueOrNull?.assets;
  final stocks = ref.read(stocksProvider).valueOrNull ?? const <MarketAsset>[];
  final cryptoList = crypto ?? const <MarketAsset>[];
  final allAssets = [...cryptoList, ...stocks];

  final points = buildOvernightPricePoints(
    watchlistKeys: watchlist,
    allAssets: allAssets,
    rates: rates,
    crypto: cryptoList,
  );
  if (points.isEmpty) return;

  await saveOvernightSnapshot(
    cache,
    OvernightSnapshot(savedAt: DateTime.now(), points: points),
  );
}
