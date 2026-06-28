import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/customization/portfolio_customization_resolver.dart';
import 'customization_provider.dart';

final resolvedPortfolioProvider = Provider<ResolvedPortfolio>((ref) {
  return PortfolioCustomizationResolver.resolve(
    ref.watch(customizationProvider.select((c) => c.portfolio)),
  );
});
