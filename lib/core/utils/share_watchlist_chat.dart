import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/commodity_quote.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/market_asset.dart';
import '../../features/home/economic_brief.dart';
import '../../providers/app_providers.dart';
import '../../providers/markets/commodities_provider.dart';
import '../../providers/markets/watchlist_provider.dart';
import '../../providers/messages/messages_provider.dart';
import '../../providers/profile/home_server_provider.dart';
import '../utils/watchlist_report.dart';

Future<bool> shareWatchlistToSelfChat(WidgetRef ref, {required String locale}) async {
  final messages = ref.read(messagesProvider.notifier);
  if (!ref.read(homeServerProvider).auth.isLoggedIn) return false;

  await messages.ensureSelfThread();
  await messages.refreshThreads();
  final selfThread = ref
      .read(messagesProvider)
      .threads
      .where((t) => t.isSelf)
      .firstOrNull;
  if (selfThread == null) return false;

  final watchlist = ref.read(watchlistProvider);
  final crypto = ref.read(cryptoProvider).valueOrNull?.assets ?? const <MarketAsset>[];
  final stocks = ref.read(stocksProvider).valueOrNull ?? const <MarketAsset>[];
  final rates = ref.read(currencyRatesProvider).valueOrNull;
  final commodities = ref.read(commoditiesProvider).valueOrNull ?? const <CommodityQuote>[];

  final brief = buildEconomicBrief(
    rates: rates,
    keyRate: ref.read(keyRateProvider).valueOrNull,
    crypto: crypto,
    stocks: stocks,
    commodities: commodities,
    fearGreed: ref.read(fearGreedProvider).valueOrNull,
  );

  final text = buildWeeklyReport(
    watchlistKeys: watchlist.toList(),
    allAssets: [...crypto, ...stocks],
    rates: rates,
    crypto: crypto,
    stocks: stocks,
    commodities: commodities,
    briefLines: brief,
    locale: locale,
  );

  return messages.sendMessage(selfThread.id, text);
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
