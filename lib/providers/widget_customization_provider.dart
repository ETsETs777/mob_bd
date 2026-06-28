import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/customization/widget_customization_resolver.dart';
import 'customization_provider.dart';
import 'widget_config_provider.dart';

final resolvedWidgetConfigProvider = Provider<WidgetConfig>((ref) {
  return WidgetCustomizationResolver.resolve(
    ref.watch(customizationProvider.select((c) => c.widgets)),
  );
});
