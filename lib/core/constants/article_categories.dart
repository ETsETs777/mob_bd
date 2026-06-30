import '../../l10n/app_localizations.dart';

/// Slugs категорий статей Community (совпадают с сервером).
abstract final class ArticleCategoryId {
  static const all = 'all';
  static const markets = 'markets';
  static const portfolio = 'portfolio';
  static const macro = 'macro';
  static const learn = 'learn';
  static const community = 'community';
  static const other = 'other';

  static const slugs = [
    markets,
    portfolio,
    macro,
    learn,
    community,
    other,
  ];
}

String articleCategoryLabel(AppLocalizations l10n, String id) {
  return switch (id) {
    ArticleCategoryId.markets => l10n.articleCategoryMarkets,
    ArticleCategoryId.portfolio => l10n.articleCategoryPortfolio,
    ArticleCategoryId.macro => l10n.articleCategoryMacro,
    ArticleCategoryId.learn => l10n.articleCategoryLearn,
    ArticleCategoryId.community => l10n.articleCategoryCommunity,
    ArticleCategoryId.other => l10n.articleCategoryOther,
    _ => l10n.articleCategoryOther,
  };
}
