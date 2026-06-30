import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/markdown_utils.dart';
import 'article_youtube_embed.dart';

/// Тело статьи: Markdown + изображения, цитаты, код, YouTube-embed.
class ArticleBodyView extends StatelessWidget {
  const ArticleBodyView({super.key, required this.body});

  final String body;

  Future<void> _openLink(String href) async {
    final uri = Uri.tryParse(href);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  MarkdownStyleSheet _styleSheet(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);

    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: TextStyle(
        color: palette.textPrimary,
        height: 1.55,
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
        height: 1.45,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: palette.accent, width: 3),
        ),
      ),
      blockquotePadding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
      a: TextStyle(
        color: palette.accent,
        decoration: TextDecoration.underline,
      ),
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
      codeblockPadding: const EdgeInsets.all(12),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: palette.border, width: 1)),
      ),
      del: TextStyle(
        color: palette.textSecondary,
        decoration: TextDecoration.lineThrough,
      ),
      tableHead: TextStyle(
        color: palette.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      tableBody: TextStyle(color: palette.textPrimary),
      tableBorder: TableBorder.all(color: palette.border),
      tableCellsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      tableCellsDecoration: BoxDecoration(color: palette.surfaceLight),
    );
  }

  Widget _markdownChunk(BuildContext context, String chunk) {
    final palette = AppPalette.of(context);

    return MarkdownBody(
      data: chunk,
      selectable: true,
      styleSheet: _styleSheet(context),
      imageBuilder: (uri, title, alt) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              uri.toString(),
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                padding: const EdgeInsets.all(16),
                color: palette.surfaceLight,
                child: Row(
                  children: [
                    Icon(Icons.broken_image_outlined,
                        color: palette.textSecondary),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        alt ?? uri.toString(),
                        style: TextStyle(color: palette.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      onTapLink: (_, href, __) {
        if (href == null || href.isEmpty) return;
        _openLink(href);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final blocks = MarkdownUtils.splitBodyBlocks(body);
    if (blocks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final block in blocks)
          if (block.isYoutube)
            ArticleYoutubeEmbed(videoId: block.youtubeVideoId!)
          else
            _markdownChunk(context, block.markdown!),
      ],
    );
  }
}
