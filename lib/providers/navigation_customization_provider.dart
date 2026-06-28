import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/customization/navigation_customization_resolver.dart';
import 'customization_provider.dart';

final resolvedNavigationProvider = Provider<ResolvedNavigation>((ref) {
  return NavigationCustomizationResolver.resolve(
    ref.watch(customizationProvider.select((c) => c.navigation)),
  );
});
