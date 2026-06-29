import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/market_asset.dart';

/// Выбранный актив для master-detail на tablet (Markets).
final tabletSelectedMarketAssetProvider =
    StateProvider<MarketAsset?>((ref) => null);
