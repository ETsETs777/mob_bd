import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/chat_thread_hide_tracker.dart';
import '../../core/utils/chat_thread_mute_tracker.dart';
import '../../core/utils/chat_thread_pin_tracker.dart';
import '../../core/utils/message_article_link.dart';
import '../../core/utils/message_read_tracker.dart';
import '../../data/models/chat_thread.dart';
import '../../data/models/user_message.dart';
import '../../features/articles/article_detail_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/messages_provider.dart';

class ChatThreadScreen extends ConsumerStatefulWidget {
  const ChatThreadScreen({super.key, required this.thread});

  final ChatThread thread;

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _sending = false;
  bool _searchOpen = false;
  int _activeMatchIndex = 0;
  GlobalKey _matchScrollKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messagesProvider.notifier).loadMessages(widget.thread.id);
      ref.read(messagesProvider.notifier).startPolling(widget.thread.id);
    });
  }

  @override
  void dispose() {
    ref.read(messagesProvider.notifier).stopPolling();
    _controller.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _resetSearchMatches() {
    setState(() {
      _activeMatchIndex = 0;
      _matchScrollKey = GlobalKey();
    });
    _scrollToActiveMatch();
  }

  void _scrollToActiveMatch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _matchScrollKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          alignment: 0.35,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
  }

  void _nextMatch(int total) {
    if (total == 0) return;
    setState(() {
      _activeMatchIndex = (_activeMatchIndex + 1) % total;
      _matchScrollKey = GlobalKey();
    });
    _scrollToActiveMatch();
  }

  void _prevMatch(int total) {
    if (total == 0) return;
    setState(() {
      _activeMatchIndex = (_activeMatchIndex - 1 + total) % total;
      _matchScrollKey = GlobalKey();
    });
    _scrollToActiveMatch();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final ok = await ref
        .read(messagesProvider.notifier)
        .sendMessage(widget.thread.id, text);
    if (ok) _controller.clear();
    setState(() => _sending = false);
    if (_scrollController.hasClients) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _showMessageMenu(UserMessage message) async {
    final l10n = AppLocalizations.of(context)!;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.copy),
              title: Text(l10n.messagesCopyText),
              onTap: () => Navigator.pop(ctx, 'copy'),
            ),
            ListTile(
              leading: const Icon(Iconsax.export_3),
              title: Text(l10n.messagesShareText),
              onTap: () => Navigator.pop(ctx, 'share'),
            ),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;
    switch (action) {
      case 'copy':
        await Clipboard.setData(ClipboardData(text: message.text));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.messagesCopied),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      case 'share':
        await Share.share(message.text);
    }
  }

  Future<void> _showThreadMenu() async {
    final l10n = AppLocalizations.of(context)!;
    final thread = widget.thread;
    final pinned = ChatThreadPinTracker.isPinned(thread.id);
    final muted = ChatThreadMuteTracker.isMuted(thread.id);
    final unread = MessageReadTracker.isUnread(thread);

    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                pinned ? Icons.push_pin_outlined : Icons.push_pin,
              ),
              title: Text(
                pinned ? l10n.messagesThreadUnpin : l10n.messagesThreadPin,
              ),
              onTap: () => Navigator.pop(ctx, 'pin'),
            ),
            ListTile(
              leading: Icon(muted ? Iconsax.volume_high : Iconsax.volume_slash),
              title: Text(
                muted ? l10n.messagesThreadUnmute : l10n.messagesThreadMute,
              ),
              onTap: () => Navigator.pop(ctx, 'mute'),
            ),
            if (unread)
              ListTile(
                leading: const Icon(Iconsax.tick_circle),
                title: Text(l10n.messagesThreadMarkRead),
                onTap: () => Navigator.pop(ctx, 'read'),
              )
            else if (thread.lastAt != null && thread.lastAt!.isNotEmpty)
              ListTile(
                leading: const Icon(Iconsax.notification),
                title: Text(l10n.messagesThreadMarkUnread),
                onTap: () => Navigator.pop(ctx, 'unread'),
              ),
            ListTile(
              leading: const Icon(Iconsax.eye_slash),
              title: Text(l10n.messagesThreadHide),
              onTap: () => Navigator.pop(ctx, 'hide'),
            ),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;
    switch (action) {
      case 'pin':
        await ChatThreadPinTracker.toggle(thread.id);
      case 'mute':
        await ChatThreadMuteTracker.toggle(thread.id);
      case 'read':
        await MessageReadTracker.markRead(
          thread.id,
          lastAt: thread.lastAt,
        );
      case 'unread':
        await MessageReadTracker.markUnread(thread.id);
      case 'hide':
        await ChatThreadHideTracker.hide(thread.id);
        if (mounted) Navigator.pop(context);
        return;
    }
    if (mounted) setState(() {});
  }

  Widget _buildThreadTitle(AppLocalizations l10n) {
    final thread = widget.thread;
    final pinned = ChatThreadPinTracker.isPinned(thread.id);
    final muted = ChatThreadMuteTracker.isMuted(thread.id);

    return Row(
      children: [
        Expanded(
          child: Text(
            thread.title,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (pinned) ...[
          const Gap(4),
          Icon(Icons.push_pin, size: 16, color: Theme.of(context).colorScheme.primary),
        ],
        if (muted) ...[
          const Gap(4),
          Icon(Iconsax.volume_slash, size: 16),
        ],
      ],
    );
  }

  Widget _buildMessageBody(
    UserMessage msg,
    AppLocalizations l10n,
    AppPalette palette,
    bool highlightActive,
    String query,
  ) {
    final articleId = extractArticleLinkId(msg.text);
    final displayText = articleId != null
        ? displayTextWithoutArticleLink(msg.text)
        : msg.text;
    final textStyle = TextStyle(color: palette.textPrimary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHighlightedText(
          text: displayText,
          query: highlightActive ? query : '',
          style: textStyle,
          highlightColor: palette.accent.withValues(alpha: 0.35),
        ),
        if (articleId != null) ...[
          const Gap(6),
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => openAppPage(
              context,
              ArticleDetailScreen(articleId: articleId),
            ),
            icon: Icon(Iconsax.document_text, size: 14, color: palette.accent),
            label: Text(
              l10n.messagesOpenArticle,
              style: TextStyle(color: palette.accent, fontSize: 13),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final state = ref.watch(messagesProvider);
    final allMessages = state.messagesByThread[widget.thread.id] ?? [];
    final query = _searchController.text.trim().toLowerCase();
    final messages = query.isEmpty
        ? allMessages
        : allMessages
            .where((m) => m.text.toLowerCase().contains(query))
            .toList();
    if (_activeMatchIndex >= messages.length && messages.isNotEmpty) {
      _activeMatchIndex = 0;
    }
    final hasOlder = (state.messagesHasMore[widget.thread.id] ?? false) &&
        allMessages.isNotEmpty &&
        query.isEmpty;
    final loadingOlder = state.loadingOlder;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: _searchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.messagesThreadSearchHint,
                  border: InputBorder.none,
                ),
                onChanged: (_) => _resetSearchMatches(),
              )
            : _buildThreadTitle(l10n),
        actions: [
          if (_searchOpen && query.isNotEmpty && messages.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Iconsax.arrow_up_2),
              tooltip: l10n.messagesThreadSearchPrev,
              onPressed: () => _prevMatch(messages.length),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  l10n.messagesThreadSearchCounter(
                    _activeMatchIndex + 1,
                    messages.length,
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Iconsax.arrow_down_2),
              tooltip: l10n.messagesThreadSearchNext,
              onPressed: () => _nextMatch(messages.length),
            ),
          ],
          if (_searchOpen)
            IconButton(
              icon: const Icon(Iconsax.close_circle),
              tooltip: l10n.cancel,
              onPressed: () => setState(() {
                _searchOpen = false;
                _searchController.clear();
                _activeMatchIndex = 0;
              }),
            )
          else ...[
            IconButton(
              icon: const Icon(Iconsax.search_normal),
              tooltip: l10n.messagesThreadSearch,
              onPressed: () => setState(() => _searchOpen = true),
            ),
            IconButton(
              icon: const Icon(Iconsax.more),
              tooltip: l10n.messagesThreadMenu,
              onPressed: _showThreadMenu,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (_searchOpen && query.isNotEmpty && messages.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                l10n.messagesThreadSearchEmpty,
                style: TextStyle(color: palette.textSecondary),
              ),
            ),
          Expanded(
            child: messages.isEmpty && !hasOlder
                ? Center(
                    child: Text(
                      l10n.messagesThreadEmpty,
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length + (hasOlder ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (hasOlder && index == 0) {
                        return Center(
                          child: loadingOlder
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(),
                                )
                              : TextButton(
                                  onPressed: () => ref
                                      .read(messagesProvider.notifier)
                                      .loadOlderMessages(widget.thread.id),
                                  child: Text(l10n.messagesLoadOlder),
                                ),
                        );
                      }

                      final msgIndex = hasOlder ? index - 1 : index;
                      final msg = messages[msgIndex];
                      final isActiveMatch =
                          _searchOpen && query.isNotEmpty && msgIndex == _activeMatchIndex;
                      final dt = DateTime.tryParse(msg.createdAt)?.toLocal();
                      final time = dt != null
                          ? DateFormat('HH:mm', locale).format(dt)
                          : '';
                      final isMine = msg.isMine;

                      return Align(
                        key: isActiveMatch ? _matchScrollKey : null,
                        alignment: isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onLongPress: () => _showMessageMenu(msg),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.sizeOf(context).width * 0.78,
                            ),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? palette.accent.withValues(alpha: 0.2)
                                  : palette.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActiveMatch
                                    ? palette.accent
                                    : palette.border,
                                width: isActiveMatch ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isMine
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (!isMine && !widget.thread.isSelf)
                                  Text(
                                    msg.senderName?.trim().isNotEmpty == true
                                        ? msg.senderName!
                                        : (msg.senderLogin ?? ''),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: palette.textSecondary,
                                    ),
                                  ),
                                _buildMessageBody(
                                  msg,
                                  l10n,
                                  palette,
                                  isActiveMatch,
                                  query,
                                ),
                                const Gap(4),
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: palette.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: l10n.messagesInputHint,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const Gap(8),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
