// =============================================================================
// EcoPulse · lib/features/portfolio/add_position_sheet.dart
// Автор: Цымбал Е. В.
// Дата: 10.06.2026
// Бумажный портфель, аллокация, P&L. Файл: add_position_sheet.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/portfolio_math.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/watchlist_provider.dart';
import 'paper_portfolio_screen.dart';

/// Функция [showAddPositionSheet] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
void showAddPositionSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  final watchlist = ref.read(watchlistProvider);
  final crypto = ref.read(cryptoProvider).valueOrNull?.assets ?? const [];
  final stocks = ref.read(stocksProvider).valueOrNull ?? const [];
  final bonds = ref.read(bondsProvider).valueOrNull ?? const [];
  final all = [...crypto, ...stocks, ...bonds];

  final assets = watchlist
      .map((key) => findAssetForKey(key, all))
      .whereType<MarketAsset>()
      .toList();

  showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.portfolioPickAsset,
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
          ),
          if (assets.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Text(l10n.portfolioPickFromWatchlist),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: assets.length,
                itemBuilder: (_, i) {
                  final asset = assets[i];
                  return ListTile(
                    title: Text(asset.symbol),
                    subtitle: Text(asset.name),
                    onTap: () {
                      Navigator.pop(ctx);
                      buyAssetForPortfolio(context, ref, asset);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    ),
  );
}
