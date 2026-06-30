import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../articles/article_moderation_list.dart';

/// Модерация статей в admin panel.
class ArticleModerationPanel extends ConsumerWidget {
  const ArticleModerationPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ArticleModerationList(compact: true);
  }
}
