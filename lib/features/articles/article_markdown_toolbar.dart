import 'package:flutter/material.dart';

import '../../core/utils/article_markdown_editing.dart';
import '../../l10n/app_localizations.dart';

/// Панель форматирования Markdown для редактора статей.
class ArticleMarkdownToolbar extends StatelessWidget {
  const ArticleMarkdownToolbar({
    super.key,
    required this.bodyController,
    required this.onPickImage,
    required this.onInsertEmbed,
    required this.onInsertLink,
  });

  final TextEditingController bodyController;
  final VoidCallback onPickImage;
  final VoidCallback onInsertEmbed;
  final VoidCallback onInsertLink;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Wrap(
          spacing: 2,
          runSpacing: 2,
          children: [
            _Btn(
              icon: Icons.format_bold,
              tooltip: l10n.userArticlesMarkdownBold,
              onPressed: () => ArticleMarkdownEditing.wrapSelection(
                bodyController,
                prefix: '**',
                suffix: '**',
              ),
            ),
            _Btn(
              icon: Icons.format_italic,
              tooltip: l10n.userArticlesMarkdownItalic,
              onPressed: () => ArticleMarkdownEditing.wrapSelection(
                bodyController,
                prefix: '*',
                suffix: '*',
              ),
            ),
            _Btn(
              icon: Icons.format_strikethrough,
              tooltip: l10n.userArticlesMarkdownStrikethrough,
              onPressed: () => ArticleMarkdownEditing.wrapSelection(
                bodyController,
                prefix: '~~',
                suffix: '~~',
              ),
            ),
            _HeadingMenu(
              tooltip: l10n.userArticlesMarkdownHeading,
              onPick: (prefix) =>
                  ArticleMarkdownEditing.insertLinePrefix(bodyController, prefix),
              labels: {
                '# ': l10n.userArticlesMarkdownHeading1,
                '## ': l10n.userArticlesMarkdownHeading2,
                '### ': l10n.userArticlesMarkdownHeading3,
              },
            ),
            _Btn(
              icon: Icons.format_list_bulleted,
              tooltip: l10n.userArticlesMarkdownList,
              onPressed: () => ArticleMarkdownEditing.insertLinePrefix(
                bodyController,
                '- ',
              ),
            ),
            _Btn(
              icon: Icons.format_list_numbered,
              tooltip: l10n.userArticlesMarkdownNumberedList,
              onPressed: () => ArticleMarkdownEditing.insertLinePrefix(
                bodyController,
                '1. ',
              ),
            ),
            _Btn(
              icon: Icons.format_quote,
              tooltip: l10n.userArticlesMarkdownQuote,
              onPressed: () => ArticleMarkdownEditing.insertLinePrefix(
                bodyController,
                '> ',
              ),
            ),
            _Btn(
              icon: Icons.code,
              tooltip: l10n.userArticlesMarkdownCode,
              onPressed: () => ArticleMarkdownEditing.wrapSelection(
                bodyController,
                prefix: '`',
                suffix: '`',
              ),
            ),
            _Btn(
              icon: Icons.data_object,
              tooltip: l10n.userArticlesMarkdownCodeBlock,
              onPressed: () => ArticleMarkdownEditing.wrapSelection(
                bodyController,
                prefix: '```\n',
                suffix: '\n```',
                placeholder: 'code',
              ),
            ),
            _Btn(
              icon: Icons.link,
              tooltip: l10n.userArticlesMarkdownLink,
              onPressed: onInsertLink,
            ),
            _Btn(
              icon: Icons.table_chart_outlined,
              tooltip: l10n.userArticlesMarkdownTable,
              onPressed: () => ArticleMarkdownEditing.insertTable(bodyController),
            ),
            _Btn(
              icon: Icons.image_outlined,
              tooltip: l10n.userArticlesMarkdownImage,
              onPressed: onPickImage,
            ),
            _Btn(
              icon: Icons.play_circle_outline,
              tooltip: l10n.userArticlesMarkdownEmbed,
              onPressed: onInsertEmbed,
            ),
            _Btn(
              icon: Icons.horizontal_rule,
              tooltip: l10n.userArticlesMarkdownDivider,
              onPressed: () =>
                  ArticleMarkdownEditing.insertBlock(bodyController, '---'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeadingMenu extends StatelessWidget {
  const _HeadingMenu({
    required this.tooltip,
    required this.onPick,
    required this.labels,
  });

  final String tooltip;
  final ValueChanged<String> onPick;
  final Map<String, String> labels;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: tooltip,
      icon: const Icon(Icons.title, size: 20),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      onSelected: onPick,
      itemBuilder: (context) => [
        for (final entry in labels.entries)
          PopupMenuItem(value: entry.key, child: Text(entry.value)),
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  const _Btn({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      onPressed: onPressed,
    );
  }
}
