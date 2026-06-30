import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/article_markdown_editing.dart';

void main() {
  testWidgets('wrapSelection wraps selected text with markers', (tester) async {
    final controller = TextEditingController(text: 'hello world');
    controller.selection = const TextSelection(baseOffset: 0, extentOffset: 5);

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    ArticleMarkdownEditing.wrapSelection(
      controller,
      prefix: '**',
      suffix: '**',
    );

    expect(controller.text, '**hello** world');
  });

  testWidgets('insertLinePrefix adds bullet at line start', (tester) async {
    final controller = TextEditingController(text: 'line one\nline two');
    controller.selection = const TextSelection.collapsed(offset: 10);

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    ArticleMarkdownEditing.insertLinePrefix(controller, '- ');

    expect(controller.text, 'line one\n- line two');
  });

  testWidgets('insertTable adds markdown table block', (tester) async {
    final controller = TextEditingController(text: 'intro');

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    ArticleMarkdownEditing.insertTable(controller);

    expect(controller.text, contains('| Col 1 | Col 2 |'));
    expect(controller.text, contains('| --- | --- |'));
  });

  testWidgets('insertLink wraps selection with url', (tester) async {
    final controller = TextEditingController(text: 'read more');
    controller.selection = const TextSelection(baseOffset: 0, extentOffset: 9);

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    ArticleMarkdownEditing.insertLink(controller, 'https://example.com');

    expect(controller.text, '[read more](https://example.com)');
  });
}
