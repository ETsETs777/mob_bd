import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/markdown_utils.dart';

/// Карточка YouTube-embed в теле статьи.
class ArticleYoutubeEmbed extends StatelessWidget {
  const ArticleYoutubeEmbed({super.key, required this.videoId});

  final String videoId;

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(MarkdownUtils.youtubeWatchUrl(videoId));
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final thumb = MarkdownUtils.youtubeThumbnailUrl(videoId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: palette.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _open(context),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  thumb,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => ColoredBox(
                    color: palette.surfaceLight,
                    child: Icon(Icons.play_circle_outline,
                        size: 48, color: palette.textSecondary),
                  ),
                ),
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.play_arrow, color: Colors.white, size: 36),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
