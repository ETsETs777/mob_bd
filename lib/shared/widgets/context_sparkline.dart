import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user_customization.dart';
import '../../../providers/chart_customization_provider.dart';
import 'metric_card.dart';

/// Спарклайн с визуальными опциями профиля [ChartContextId.homeSparkline].
class ContextSparkline extends ConsumerWidget {
  const ContextSparkline({
    super.key,
    required this.values,
    this.height = 36,
  });

  final List<double> values;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visual =
        ref.watch(resolvedChartConfigProvider(ChartContextId.homeSparkline)).visual;

    return MiniSparkline(
      values: values,
      height: height,
      strokeWidth: visual.lineWidth,
      showFill: visual.showGradientFill,
    );
  }
}
