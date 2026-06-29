import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/data_display_customization_resolver.dart';
import '../../core/customization/display_formatters.dart';
import 'package:ecopulse/providers/customization/customization_provider.dart';

final resolvedDataDisplayProvider = Provider<ResolvedDataDisplay>((ref) {
  return DataDisplayCustomizationResolver.resolve(
    ref.watch(customizationProvider.select((c) => c.dataDisplay)),
  );
});

final displayFormattersProvider = Provider<DisplayFormatters>((ref) {
  return DisplayFormatters(ref.watch(resolvedDataDisplayProvider));
});
