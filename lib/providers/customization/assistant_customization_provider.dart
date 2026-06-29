import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/assistant_customization_resolver.dart';
import 'package:ecopulse/providers/customization/customization_provider.dart';

final resolvedAssistantProvider = Provider<ResolvedAssistant>((ref) {
  return AssistantCustomizationResolver.resolve(
    ref.watch(customizationProvider.select((c) => c.assistant)),
  );
});
