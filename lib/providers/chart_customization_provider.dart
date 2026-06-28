import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/customization/chart_customization_resolver.dart';
import '../data/models/chart_render_input.dart';
import '../data/models/user_customization.dart';
import 'customization_provider.dart';

final resolvedChartConfigProvider =
    Provider.family<ResolvedChartConfig, ChartContextId>((ref, contextId) {
  return ChartCustomizationResolver.resolve(
    ref.watch(customizationProvider),
    contextId,
  );
});

final resolvedChartForRenderProvider = Provider.family<
    ResolvedChartConfig,
    ({
      ChartContextId contextId,
      ChartRenderInput input,
      ChartTypeId? overrideType,
    })>((ref, params) {
  return ChartCustomizationResolver.resolveForRender(
    config: ref.watch(customizationProvider),
    context: params.contextId,
    input: params.input,
    overrideType: params.overrideType,
  );
});
