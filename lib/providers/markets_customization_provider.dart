import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/customization/markets_customization_resolver.dart';
import 'customization_provider.dart';

final resolvedMarketsProvider = Provider<ResolvedMarkets>((ref) {
  return MarketsCustomizationResolver.resolve(
    ref.watch(customizationProvider.select((c) => c.markets)),
  );
});
