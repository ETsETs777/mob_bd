import 'dart:async';



import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';



import '../../core/utils/article_draft_storage.dart';
import '../../core/utils/home_server_error_message.dart';

import '../../l10n/app_localizations.dart';

import '../../providers/articles_provider.dart';



class ArticleEditorSheet extends ConsumerStatefulWidget {

  const ArticleEditorSheet({
    super.key,
    this.articleId,
    this.initialTitle,
    this.initialBody,
  });

  final String? articleId;
  final String? initialTitle;
  final String? initialBody;



  @override

  ConsumerState<ArticleEditorSheet> createState() => _ArticleEditorSheetState();

}



class _ArticleEditorSheetState extends ConsumerState<ArticleEditorSheet> {

  final _titleController = TextEditingController();

  final _bodyController = TextEditingController();

  bool _saving = false;

  bool _draftRestored = false;

  Timer? _saveDebounce;



  @override

  void initState() {

    super.initState();

    final seedTitle = widget.initialTitle?.trim();
    final seedBody = widget.initialBody?.trim();
    final hasSeed = widget.articleId != null ||
        (seedTitle != null && seedTitle.isNotEmpty) ||
        (seedBody != null && seedBody.isNotEmpty);

    if (hasSeed) {
      _titleController.text = seedTitle ?? '';
      _bodyController.text = seedBody ?? '';
    } else {
      final draft = ArticleDraftStorage.load();
      if (draft != null) {
        _titleController.text = draft.title;
        _bodyController.text = draft.body;
        _draftRestored = true;
      }
    }

    _titleController.addListener(_scheduleDraftSave);

    _bodyController.addListener(_scheduleDraftSave);

  }



  void _scheduleDraftSave() {

    _saveDebounce?.cancel();

    _saveDebounce = Timer(const Duration(milliseconds: 600), () {

      ArticleDraftStorage.save(

        title: _titleController.text,

        body: _bodyController.text,

      );

    });

  }



  @override

  void dispose() {

    _saveDebounce?.cancel();

    _titleController.dispose();

    _bodyController.dispose();

    super.dispose();

  }



  Future<void> _clearDraft(AppLocalizations l10n) async {

    _saveDebounce?.cancel();

    _titleController.clear();

    _bodyController.clear();

    await ArticleDraftStorage.clear();

    if (mounted) {

      setState(() => _draftRestored = false);

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(l10n.userArticlesDraftCleared),

          behavior: SnackBarBehavior.floating,

        ),

      );

    }

  }



  void _insertMarkdown(String prefix, {String suffix = ''}) {

    final controller = _bodyController;

    final text = controller.text;

    final selection = controller.selection;

    final start = selection.start >= 0 ? selection.start : text.length;

    final end = selection.end >= 0 ? selection.end : text.length;

    final selected = text.substring(start, end);

    final replacement = '$prefix$selected$suffix';

    final next = text.replaceRange(start, end, replacement);

    controller.value = TextEditingValue(

      text: next,

      selection: TextSelection.collapsed(offset: start + replacement.length),

    );

  }



  Future<void> _submit(AppLocalizations l10n) async {

    final title = _titleController.text.trim();

    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) return;



    setState(() => _saving = true);

    final notifier = ref.read(articlesProvider.notifier);
    final editId = widget.articleId;
    final article = editId != null
        ? await notifier.update(id: editId, title: title, body: body)
        : await notifier.submit(title: title, body: body);

    if (!mounted) return;

    setState(() => _saving = false);

    if (article != null) {
      _saveDebounce?.cancel();

      if (editId == null) {
        await ArticleDraftStorage.clear();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editId != null
                ? l10n.userArticlesUpdated
                : l10n.userArticlesSubmitted,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
      return;
    }

    final error = ref.read(articlesProvider).error;
    if (error.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(homeServerErrorMessage(l10n, error)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }



  @override

  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;



    return Padding(

      padding: EdgeInsets.only(

        left: 16,

        right: 16,

        top: 16,

        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,

      ),

      child: SingleChildScrollView(

        child: Column(

          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            Text(
              widget.articleId != null
                  ? l10n.userArticlesEdit
                  : l10n.userArticlesWrite,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const Gap(8),

            Text(l10n.userArticlesWriteHint),

            if (_draftRestored) ...[

              const Gap(8),

              Row(

                children: [

                  Expanded(

                    child: Text(

                      l10n.userArticlesDraftRestored,

                      style: TextStyle(

                        color: Theme.of(context).colorScheme.primary,

                        fontSize: 13,

                      ),

                    ),

                  ),

                  TextButton(

                    onPressed: _saving ? null : () => _clearDraft(l10n),

                    child: Text(l10n.userArticlesDraftClear),

                  ),

                ],

              ),

            ],

            const Gap(16),

            TextField(

              controller: _titleController,

              decoration: InputDecoration(

                labelText: l10n.userArticlesFieldTitle,

                hintText: l10n.userArticlesFieldTitleHint,

              ),

              textCapitalization: TextCapitalization.sentences,

            ),

            const Gap(12),

            TextField(

              controller: _bodyController,

              decoration: InputDecoration(

                labelText: l10n.userArticlesFieldBody,

                hintText: l10n.userArticlesFieldBodyHint,

                alignLabelWithHint: true,

              ),

              maxLines: 10,

              textCapitalization: TextCapitalization.sentences,

            ),

            const Gap(8),

            Wrap(

              spacing: 6,

              runSpacing: 6,

              children: [

                ActionChip(

                  label: Text(l10n.userArticlesMarkdownHeading),

                  onPressed: () => _insertMarkdown('## '),

                ),

                ActionChip(

                  label: Text(l10n.userArticlesMarkdownList),

                  onPressed: () => _insertMarkdown('- '),

                ),

                ActionChip(

                  label: Text(l10n.userArticlesMarkdownLink),

                  onPressed: () => _insertMarkdown('[', suffix: '](url)'),

                ),

              ],

            ),

            const Gap(16),

            FilledButton(

              onPressed: _saving ? null : () => _submit(l10n),

              child: _saving

                  ? const SizedBox(

                      width: 20,

                      height: 20,

                      child: CircularProgressIndicator(strokeWidth: 2),

                    )

                  : Text(
                      widget.articleId != null
                          ? l10n.userArticlesSave
                          : l10n.userArticlesSubmit,
                    ),

            ),

          ],

        ),

      ),

    );

  }

}



Future<bool?> showArticleEditorSheet(
  BuildContext context, {
  String? articleId,
  String? initialTitle,
  String? initialBody,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ArticleEditorSheet(
      articleId: articleId,
      initialTitle: initialTitle,
      initialBody: initialBody,
    ),
  );
}

