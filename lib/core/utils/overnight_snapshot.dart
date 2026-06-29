import 'dart:convert';

import '../../data/models/currency_rate.dart';
import '../../data/models/market_asset.dart';
import '../../data/services/cache_service.dart';
import '../../providers/markets/watchlist_provider.dart';

const overnightSnapshotCacheKey = 'overnight_price_snapshot_v1';
const minGapForOvernightBrief = Duration(hours: 3);
const maxSnapshotAge = Duration(days: 7);

class OvernightPricePoint {
  const OvernightPricePoint({
    required this.key,
    required this.label,
    required this.price,
  });

  final String key;
  final String label;
  final double price;

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'price': price,
      };

  factory OvernightPricePoint.fromJson(Map<String, dynamic> json) =>
      OvernightPricePoint(
        key: json['key'] as String? ?? '',
        label: json['label'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
      );
}

class OvernightSnapshot {
  const OvernightSnapshot({
    required this.savedAt,
    required this.points,
  });

  final DateTime savedAt;
  final List<OvernightPricePoint> points;

  Map<String, dynamic> toJson() => {
        'savedAt': savedAt.toIso8601String(),
        'points': points.map((p) => p.toJson()).toList(),
      };

  factory OvernightSnapshot.fromJson(Map<String, dynamic> json) =>
      OvernightSnapshot(
        savedAt: DateTime.tryParse(json['savedAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        points: (json['points'] as List<dynamic>? ?? [])
            .map((e) => OvernightPricePoint.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class OvernightChange {
  const OvernightChange({
    required this.label,
    required this.oldPrice,
    required this.newPrice,
    required this.changePercent,
  });

  final String label;
  final double oldPrice;
  final double newPrice;
  final double changePercent;
}

List<OvernightPricePoint> buildOvernightPricePoints({
  required Iterable<String> watchlistKeys,
  required List<MarketAsset> allAssets,
  List<CurrencyRate>? rates,
  List<MarketAsset>? crypto,
}) {
  final points = <OvernightPricePoint>[];

  final usdRub = rates
      ?.where((r) => r.isRub && r.code == 'USD')
      .map((r) => r.rate)
      .firstOrNull;
  if (usdRub != null && usdRub > 0) {
    points.add(
      OvernightPricePoint(
        key: 'fx:USD/RUB',
        label: 'USD/RUB',
        price: usdRub,
      ),
    );
  }

  final btc = crypto?.where((a) => a.symbol.toUpperCase() == 'BTC').firstOrNull;
  if (btc != null && btc.price > 0) {
    points.add(
      OvernightPricePoint(
        key: 'crypto:BTC',
        label: 'BTC',
        price: btc.price,
      ),
    );
  }

  for (final key in watchlistKeys) {
    final asset = allAssets
        .where((a) => watchlistKey(a) == key)
        .firstOrNull;
    if (asset == null || asset.price <= 0) continue;
    points.add(
      OvernightPricePoint(
        key: key,
        label: asset.symbol,
        price: asset.price,
      ),
    );
  }

  return points;
}

Future<void> saveOvernightSnapshot(CacheService cache, OvernightSnapshot snapshot) {
  return cache.putString(
    overnightSnapshotCacheKey,
    jsonEncode(snapshot.toJson()),
  );
}

OvernightSnapshot? loadOvernightSnapshot(CacheService cache) {
  final raw = cache.getString(overnightSnapshotCacheKey);
  if (raw == null || raw.isEmpty) return null;
  try {
    return OvernightSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    return null;
  }
}

List<OvernightChange> computeOvernightChanges({
  required OvernightSnapshot previous,
  required List<OvernightPricePoint> currentPoints,
  DateTime? now,
}) {
  final clock = now ?? DateTime.now();
  final age = clock.difference(previous.savedAt);
  if (age < minGapForOvernightBrief || age > maxSnapshotAge) {
    return const [];
  }

  final currentByKey = {for (final p in currentPoints) p.key: p};
  final changes = <OvernightChange>[];

  for (final old in previous.points) {
    final current = currentByKey[old.key];
    if (current == null || old.price <= 0 || current.price <= 0) continue;
    final pct = ((current.price - old.price) / old.price) * 100;
    if (pct.abs() < 0.05) continue;
    changes.add(
      OvernightChange(
        label: current.label,
        oldPrice: old.price,
        newPrice: current.price,
        changePercent: pct,
      ),
    );
  }

  changes.sort((a, b) => b.changePercent.abs().compareTo(a.changePercent.abs()));
  return changes.take(6).toList();
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
