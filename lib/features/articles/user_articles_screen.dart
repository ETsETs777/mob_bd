import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/articles_provider.dart';
import '../../providers/home_server_provider.dart';
import '../community/articles_tab.dart';
import 'article_editor_sheet.dart';

/// Отдельная страница статей (deep link / legacy).
class UserArticlesScreen extends ConsumerWidget {
  const UserArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(homeServerProvider).auth;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userArticlesTitle),
        actions: [
          if (auth.isLoggedIn)
            IconButton(
              icon: const Icon(Iconsax.edit),
              tooltip: l10n.userArticlesWrite,
              onPressed: () async {
                final ok = await showArticleEditorSheet(context);
                if (ok == true) {
                  await ref.read(articlesProvider.notifier).refreshAll();
                }
              },
            ),
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: auth.isLoggedIn
                ? () => ref.read(articlesProvider.notifier).refreshAll()
                : null,
          ),
        ],
      ),
      body: const ArticlesTab(),
    );
  }
}
