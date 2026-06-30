import 'package:flutter/material.dart';

/// Извлекает `article:<id>` из хвоста сообщения (share-to-chat).
String? extractArticleLinkId(String text) {
  const marker = '\n\narticle:';
  final idx = text.lastIndexOf(marker);
  if (idx == -1) return null;
  final id = text.substring(idx + marker.length).trim();
  return id.isNotEmpty ? id : null;
}

/// Текст сообщения без служебной ссылки на статью.
String displayTextWithoutArticleLink(String text) {
  const marker = '\n\narticle:';
  final idx = text.lastIndexOf(marker);
  if (idx == -1) return text;
  return text.substring(0, idx).trimRight();
}

/// Подсветка вхождения [query] в [text].
Widget buildHighlightedText({
  required String text,
  required String query,
  required TextStyle style,
  required Color highlightColor,
}) {
  if (query.isEmpty) {
    return Text(text, style: style);
  }

  final lower = text.toLowerCase();
  final q = query.toLowerCase();
  final spans = <TextSpan>[];
  var start = 0;

  while (start < text.length) {
    final index = lower.indexOf(q, start);
    if (index == -1) {
      spans.add(TextSpan(text: text.substring(start), style: style));
      break;
    }
    if (index > start) {
      spans.add(TextSpan(text: text.substring(start, index), style: style));
    }
    spans.add(
      TextSpan(
        text: text.substring(index, index + q.length),
        style: style.copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    start = index + q.length;
  }

  return RichText(text: TextSpan(children: spans));
}
