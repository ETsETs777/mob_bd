import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/articles_provider.dart';
import '../../providers/home_server_provider.dart';
import 'article_moderation_list.dart';

/// Экран модерации статей для администратора сервера.
class ArticleModerationScreen extends ConsumerStatefulWidget {
  const ArticleModerationScreen({super.key});

  @override
  ConsumerState<ArticleModerationScreen> createState() =>
      _ArticleModerationScreenState();
}

class _ArticleModerationScreenState
    extends ConsumerState<ArticleModerationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = ref.read(homeServerProvider).auth;
      if (auth.isLoggedIn && auth.isAdmin) {
        ref.read(articlesProvider.notifier).refreshAll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pending = ref.watch(pendingArticlesCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userArticlesModerationTitle),
        actions: [
          if (pending > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Badge(label: Text('$pending')),
              ),
            ),
        ],
      ),
      body: const ArticleModerationList(),
    );
  }
}
