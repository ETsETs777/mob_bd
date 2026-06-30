import 'package:flutter/material.dart';

import '../navigation/app_deep_link.dart';

String? extractArticleLinkId(String text) => extractArticleReferenceId(text);

String displayTextWithoutArticleLink(String text) =>
    displayTextWithoutArticleReference(text);

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
