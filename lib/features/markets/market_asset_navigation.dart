import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/app_breakpoints.dart';
import '../../data/models/market_asset.dart';
import '../../providers/markets/tablet_market_selection_provider.dart';
import 'asset_preview_sheet.dart';

/// Открыть актив: preview sheet на телефоне, панель detail на tablet.
void openMarketAsset(
  BuildContext context,
  WidgetRef ref,
  MarketAsset asset,
) {
  if (AppBreakpoints.isTablet(context)) {
    ref.read(tabletSelectedMarketAssetProvider.notifier).state = asset;
    return;
  }
  showAssetPreviewSheet(context, ref, asset);
}
