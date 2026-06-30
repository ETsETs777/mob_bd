import 'package:flutter/material.dart';

/// Вставка и обёртка Markdown в поле редактора статей.
class ArticleMarkdownEditing {
  ArticleMarkdownEditing._();

  static void wrapSelection(
    TextEditingController controller, {
    required String prefix,
    required String suffix,
    String placeholder = '',
  }) {
    final text = controller.text;
    final selection = controller.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final selected = start == end ? placeholder : text.substring(start, end);
    final replacement = '$prefix$selected$suffix';
    final next = text.replaceRange(start, end, replacement);
    final cursor = start +
        prefix.length +
        selected.length +
        (start == end ? 0 : suffix.length);
    controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: cursor),
    );
  }

  static void insertLinePrefix(TextEditingController controller, String prefix) {
    final text = controller.text;
    final selection = controller.selection;
    var start = selection.start >= 0 ? selection.start : text.length;

    while (start > 0 && text[start - 1] != '\n') {
      start--;
    }

    final next = text.replaceRange(start, start, prefix);
    controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: start + prefix.length),
    );
  }

  static void insertBlock(TextEditingController controller, String block) {
    final text = controller.text;
    final selection = controller.selection;
    final offset = selection.start >= 0 ? selection.start : text.length;
    final needsGap = text.isNotEmpty && !text.endsWith('\n\n');
    final insertion = '${needsGap ? '\n\n' : ''}$block\n\n';
    final next = text.replaceRange(offset, offset, insertion);
    controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: offset + insertion.length),
    );
  }

  static void insertLink(TextEditingController controller, String url) {
    wrapSelection(
      controller,
      prefix: '[',
      suffix: ']($url)',
      placeholder: 'текст',
    );
  }

  static void insertImage(TextEditingController controller, String url) {
    wrapSelection(
      controller,
      prefix: '![',
      suffix: ']($url)',
      placeholder: 'описание',
    );
  }

  static void insertYoutubeEmbed(TextEditingController controller, String url) {
    insertBlock(controller, url.trim());
  }

  static void insertTable(
    TextEditingController controller, {
    int columns = 2,
    int rows = 2,
  }) {
    final cols = columns.clamp(2, 6);
    final bodyRows = rows.clamp(1, 10);
    final header = List.generate(cols, (i) => 'Col ${i + 1}').join(' | ');
    final separator = List.generate(cols, (_) => '---').join(' | ');
    final dataRow = List.generate(cols, (_) => '…').join(' | ');
    final lines = ['| $header |', '| $separator |'];
    for (var i = 0; i < bodyRows; i++) {
      lines.add('| $dataRow |');
    }
    insertBlock(controller, lines.join('\n'));
  }
}
