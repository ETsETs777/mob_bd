import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/customization/appearance_resolver.dart';
import 'customization_provider.dart';

final resolvedAppearanceProvider = Provider<ResolvedAppearance>((ref) {
  return AppearanceResolver.resolve(
    ref.watch(customizationProvider.select((c) => c.appearance)),
  );
});
