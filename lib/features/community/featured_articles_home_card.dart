import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/constants/article_categories.dart';
import '../../core/motion/app_motion.dart';
import '../../core/navigation/shell_navigation_intent.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app/app_providers.dart';
import '../../providers/articles_provider.dart';
import '../../providers/home_server_provider.dart';
import '../articles/article_detail_screen.dart';

/// Карточка избранных статей Community на главном экране.
class FeaturedArticlesHomeCard extends ConsumerWidget {
  const FeaturedArticlesHomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final auth = ref.watch(homeServerProvider).auth;
    if (!auth.isLoggedIn) return const SizedBox.shrink();

    final featuredAsync = ref.watch(featuredArticlesProvider);
    return featuredAsync.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (articles) {
        if (articles.isEmpty) {
          return Card(
            child: ListTile(
              leading: Icon(Iconsax.star_1, color: palette.accent),
              title: Text(l10n.userArticlesFeaturedHomeTitle),
              subtitle: Text(l10n.userArticlesFeaturedHomeEmpty),
              trailing: const Icon(Iconsax.arrow_right_3),
              onTap: () {
                ShellNavigationIntent.openCommunityArticles();
                ref.read(navigationIndexProvider.notifier).state = 5;
              },
            ),
          );
        }

        final locale = Localizations.localeOf(context).languageCode;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.star_1, size: 18, color: palette.accent),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        l10n.userArticlesFeaturedHomeTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: palette.accent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ShellNavigationIntent.openCommunityArticles();
                        ref.read(navigationIndexProvider.notifier).state = 5;
                      },
                      child: Text(l10n.userArticlesFeaturedHomeOpen),
                    ),
                  ],
                ),
                const Gap(4),
                Text(
                  l10n.userArticlesFeaturedHomeSubtitle,
                  style: TextStyle(color: palette.textSecondary, fontSize: 12),
                ),
                const Gap(12),
                for (final article in articles) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      article.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${articleCategoryLabel(l10n, article.category)} · '
                      '${DateFormat.MMMd(locale).format(article.updatedAt)}',
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(Iconsax.arrow_right_3, size: 16),
                    onTap: () => openAppPage(
                      context,
                      ArticleDetailScreen(articleId: article.id),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
