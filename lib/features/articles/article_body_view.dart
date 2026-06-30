import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_palette.dart';

/// Тело статьи с базовым Markdown (заголовки, списки, ссылки).
class ArticleBodyView extends StatelessWidget {
  const ArticleBodyView({super.key, required this.body});

  final String body;

  Future<void> _openLink(String href) async {
    final uri = Uri.tryParse(href);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return MarkdownBody(
      data: body,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: TextStyle(
          color: palette.textPrimary,
          height: 1.5,
          fontSize: 15,
        ),
        h1: TextStyle(
          color: palette.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 22,
        ),
        h2: TextStyle(
          color: palette.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 19,
        ),
        h3: TextStyle(
          color: palette.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
        listBullet: TextStyle(color: palette.textPrimary),
        blockquote: TextStyle(
          color: palette.textSecondary,
          fontStyle: FontStyle.italic,
        ),
        a: TextStyle(color: palette.accent, decoration: TextDecoration.underline),
        code: TextStyle(
          color: palette.textPrimary,
          backgroundColor: palette.surfaceLight,
          fontFamily: 'monospace',
          fontSize: 13,
        ),
        codeblockDecoration: BoxDecoration(
          color: palette.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: palette.border),
        ),
      ),
      onTapLink: (_, href, __) {
        if (href == null || href.isEmpty) return;
        _openLink(href);
      },
    );
  }
}
