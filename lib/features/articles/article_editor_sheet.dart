import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/constants/article_categories.dart';
import '../../core/utils/article_draft_storage.dart';
import '../../core/utils/article_markdown_editing.dart';
import '../../core/utils/home_server_error_message.dart';
import '../../core/utils/markdown_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/articles_provider.dart';
import 'article_body_view.dart';
import 'article_markdown_toolbar.dart';

class ArticleEditorSheet extends ConsumerStatefulWidget {
  const ArticleEditorSheet({
    super.key,
    this.articleId,
    this.initialTitle,
    this.initialBody,
    this.initialCategory,
    this.initialTags,
  });

  final String? articleId;
  final String? initialTitle;
  final String? initialBody;
  final String? initialCategory;
  final List<String>? initialTags;

  @override
  ConsumerState<ArticleEditorSheet> createState() => _ArticleEditorSheetState();
}

class _ArticleEditorSheetState extends ConsumerState<ArticleEditorSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _tagsController = TextEditingController();
  String _category = ArticleCategoryId.other;
  bool _saving = false;
  bool _draftRestored = false;
  bool _preview = false;
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
      _category = widget.initialCategory ?? ArticleCategoryId.other;
      if (widget.initialTags != null && widget.initialTags!.isNotEmpty) {
        _tagsController.text = widget.initialTags!.join(', ');
      }
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
    _tagsController.dispose();
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

  Future<String?> _promptUrl(AppLocalizations l10n, {required String title}) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.userArticlesUrlHint,
          ),
          keyboardType: TextInputType.url,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _insertLink(AppLocalizations l10n) async {
    final url = await _promptUrl(l10n, title: l10n.userArticlesLinkUrlPrompt);
    if (url == null || url.isEmpty) return;
    ArticleMarkdownEditing.insertLink(_bodyController, url);
  }

  Future<void> _insertImage(AppLocalizations l10n) async {
    final url = await _promptUrl(l10n, title: l10n.userArticlesImageUrlPrompt);
    if (url == null || url.isEmpty) return;
    ArticleMarkdownEditing.insertImage(_bodyController, url);
  }

  Future<void> _insertEmbed(AppLocalizations l10n) async {
    final url = await _promptUrl(l10n, title: l10n.userArticlesEmbedUrlPrompt);
    if (url == null || url.isEmpty) return;
    final id = MarkdownUtils.extractYoutubeVideoId(url);
    if (id == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.userArticlesEmbedInvalid),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ArticleMarkdownEditing.insertYoutubeEmbed(
      _bodyController,
      MarkdownUtils.youtubeWatchUrl(id),
    );
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) return;

    setState(() => _saving = true);
    final notifier = ref.read(articlesProvider.notifier);
    final editId = widget.articleId;
    final baseUpdatedAt = editId != null
        ? ref
            .read(articlesProvider)
            .mine
            .where((a) => a.id == editId)
            .firstOrNull
            ?.updatedAt
        : null;
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    final result = editId != null
        ? await notifier.update(
            id: editId,
            title: title,
            body: body,
            category: _category,
            tags: tags,
            baseUpdatedAt: baseUpdatedAt,
          )
        : await notifier.submit(
            title: title,
            body: body,
            category: _category,
            tags: tags,
          );

    if (!mounted) return;
    setState(() => _saving = false);

    if (result.status == SubmitArticleStatus.ok ||
        result.status == SubmitArticleStatus.queued) {
      _saveDebounce?.cancel();
      if (editId == null) await ArticleDraftStorage.clear();
      if (!mounted) return;

      final message = switch (result.status) {
        SubmitArticleStatus.queued => l10n.userArticlesSavedOffline,
        SubmitArticleStatus.ok =>
          editId != null ? l10n.userArticlesUpdated : l10n.userArticlesSubmitted,
        SubmitArticleStatus.failed => '',
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
      return;
    }

    if (result.error.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(homeServerErrorMessage(l10n, result.error)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

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
                        color: scheme.primary,
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
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(
                labelText: l10n.userArticlesFieldCategory,
              ),
              items: [
                for (final id in ArticleCategoryId.slugs)
                  DropdownMenuItem(
                    value: id,
                    child: Text(articleCategoryLabel(l10n, id)),
                  ),
              ],
              onChanged: _saving
                  ? null
                  : (v) => setState(() => _category = v ?? ArticleCategoryId.other),
            ),
            const Gap(12),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: l10n.userArticlesFieldTags,
                hintText: l10n.userArticlesFieldTagsHint,
              ),
            ),
            const Gap(12),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: false,
                  label: Text(l10n.userArticlesTabEdit),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                ),
                ButtonSegment(
                  value: true,
                  label: Text(l10n.userArticlesTabPreview),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                ),
              ],
              selected: {_preview},
              onSelectionChanged: _saving
                  ? null
                  : (s) => setState(() => _preview = s.first),
            ),
            const Gap(8),
            if (!_preview) ...[
              ArticleMarkdownToolbar(
                bodyController: _bodyController,
                onPickImage: () => _insertImage(l10n),
                onInsertEmbed: () => _insertEmbed(l10n),
                onInsertLink: () => _insertLink(l10n),
              ),
              const Gap(8),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: l10n.userArticlesFieldBody,
                  hintText: l10n.userArticlesFieldBodyHint,
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                ),
                minLines: 10,
                maxLines: 18,
                textCapitalization: TextCapitalization.sentences,
              ),
            ] else ...[
              Container(
                constraints: const BoxConstraints(minHeight: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _bodyController.text.trim().isEmpty
                    ? Text(
                        l10n.userArticlesPreviewEmpty,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_titleController.text.trim().isNotEmpty) ...[
                            Text(
                              _titleController.text.trim(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Gap(12),
                          ],
                          ArticleBodyView(body: _bodyController.text),
                        ],
                      ),
              ),
            ],
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
  String? initialCategory,
  List<String>? initialTags,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ArticleEditorSheet(
      articleId: articleId,
      initialTitle: initialTitle,
      initialBody: initialBody,
      initialCategory: initialCategory,
      initialTags: initialTags,
    ),
  );
}
