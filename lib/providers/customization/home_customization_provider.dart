import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/home_customization_resolver.dart';
import 'package:ecopulse/providers/customization/customization_provider.dart';

final resolvedHomeLayoutProvider = Provider<ResolvedHomeLayout>((ref) {
  return HomeCustomizationResolver.resolve(
    ref.watch(customizationProvider.select((c) => c.home)),
  );
});
