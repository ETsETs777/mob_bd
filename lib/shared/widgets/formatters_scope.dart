import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../../providers/data_display_customization_provider.dart';

/// Подключает [DisplayFormatters] к статическим [Formatters] для всего дерева.
class FormattersScope extends ConsumerWidget {
  const FormattersScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Formatters.bind(ref.watch(displayFormattersProvider));
    return child;
  }
}
