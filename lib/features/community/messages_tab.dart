import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/motion/app_motion.dart';
import '../assistant/assistant_fab_layout.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/chat_sort_preferences.dart';
import '../../core/utils/chat_thread_hide_tracker.dart';
import '../../core/utils/chat_thread_mute_tracker.dart';
import '../../core/utils/chat_thread_pin_tracker.dart';
import '../../core/utils/message_read_tracker.dart';
import '../../data/models/chat_thread.dart';
import '../../core/utils/home_server_error_message.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/home_server_provider.dart';
import '../../providers/messages_provider.dart';
import '../messages/chat_thread_screen.dart';

/// Список чатов без собственного [Scaffold] — для вкладки «Сообщество».
class MessagesTab extends ConsumerStatefulWidget {
  const MessagesTab({super.key});

  @override
  ConsumerState<MessagesTab> createState() => MessagesTabState();
}

class MessagesTabState extends ConsumerState<MessagesTab> {
  final _filterController = TextEditingController();
  String _query = '';
  bool _showHidden = false;
  bool _unreadOnly = false;
  bool _unreadFirst = ChatSortPreferences.unreadFirst;
  int _listTick = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  List<ChatThread> _visibleThreads(List<ChatThread> all) {
    final hidden = ChatThreadHideTracker.load();
    var threads = _showHidden
        ? all.where((t) => hidden.contains(t.id)).toList()
        : all.where((t) => !hidden.contains(t.id)).toList();

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      threads = threads.where((t) {
        final title = t.title.toLowerCase();
        final preview = (t.lastText ?? '').toLowerCase();
        return title.contains(q) || preview.contains(q);
      }).toList();
    }

    if (_unreadOnly) {
      threads =
          threads.where((t) => MessageReadTracker.isUnread(t)).toList();
    }

    if (_unreadFirst) {
      threads.sort((a, b) {
        final ap = ChatThreadPinTracker.isPinned(a.id);
        final bp = ChatThreadPinTracker.isPinned(b.id);
        if (ap != bp) return ap ? -1 : 1;
        final au = MessageReadTracker.isUnread(a);
        final bu = MessageReadTracker.isUnread(b);
        if (au != bu) return au ? -1 : 1;
        final at = DateTime.tryParse(a.lastAt ?? '') ?? DateTime(1970);
        final bt = DateTime.tryParse(b.lastAt ?? '') ?? DateTime(1970);
        return bt.compareTo(at);
      });
    } else {
      threads.sort((a, b) {
        final ap = ChatThreadPinTracker.isPinned(a.id);
        final bp = ChatThreadPinTracker.isPinned(b.id);
        if (ap != bp) return ap ? -1 : 1;
        return 0;
      });
    }

    return threads;
  }

  Future<void> refresh() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return;
    await ref.read(messagesProvider.notifier).refreshThreads();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final auth = ref.watch(homeServerProvider).auth;
    final messages = ref.watch(messagesProvider);

    if (!auth.isLoggedIn) {
      return _NotConnected(palette: palette, l10n: l10n);
    }

    final q = _query.trim().toLowerCase();
    final threads = _visibleThreads(messages.threads);
    final hiddenCount =
        ChatThreadHideTracker.hiddenCount(messages.threads.map((t) => t.id));
    // ignore: unused_local_variable
    final _ = _listTick;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: TextField(
            controller: _filterController,
            decoration: InputDecoration(
              hintText: l10n.messagesFilterHint,
              prefixIcon: const Icon(Iconsax.search_normal_1, size: 20),
              isDense: true,
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Iconsax.close_circle, size: 18),
                      onPressed: () {
                        _filterController.clear();
                        setState(() => _query = '');
                      },
                    ),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
          child: Row(
            children: [
              FilterChip(
                label: Text(l10n.messagesUnreadFirst),
                selected: _unreadFirst,
                onSelected: (v) async {
                  setState(() => _unreadFirst = v);
                  await ChatSortPreferences.setUnreadFirst(v);
                },
              ),
              FilterChip(
                label: Text(l10n.messagesUnreadOnly),
                selected: _unreadOnly,
                onSelected: (v) => setState(() => _unreadOnly = v),
              ),
              if (hiddenCount > 0) ...[
                const Gap(8),
                FilterChip(
                  label: Text(l10n.messagesShowHidden(hiddenCount)),
                  selected: _showHidden,
                  onSelected: (v) => setState(() => _showHidden = v),
                ),
              ],
            ],
          ),
        ),
        if (messages.error.isNotEmpty)
          MaterialBanner(
            content: Text(homeServerErrorMessage(l10n, messages.error)),
            leading: Icon(Iconsax.warning_2, color: palette.negative),
            actions: [
              TextButton(onPressed: refresh, child: Text(l10n.retry)),
            ],
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: threads.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: Center(
                    child: Text(
                      q.isEmpty && !_showHidden
                          ? l10n.messagesEmpty
                          : l10n.messagesFilterEmpty,
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                12,
                12,
                12,
                12 + AssistantFabLayout.scrollBottomPadding(context),
              ),
              itemCount: threads.length,
              separatorBuilder: (_, __) => const Gap(8),
              itemBuilder: (context, index) {
                final thread = threads[index];
                return Dismissible(
                  key: ValueKey('thread-${thread.id}'),
                  direction: _showHidden
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: palette.textSecondary.withValues(alpha: 0.25),
                    child: Icon(Iconsax.eye_slash, color: palette.textSecondary),
                  ),
                  confirmDismiss: (_) async {
                    if (_showHidden) return false;
                    await ChatThreadHideTracker.hide(thread.id);
                    setState(() => _listTick++);
                    return true;
                  },
                  child: _ThreadTile(
                    thread: thread,
                    palette: palette,
                    showUnhide: _showHidden,
                    onUnhide: () async {
                      await ChatThreadHideTracker.unhide(thread.id);
                      setState(() {
                        _listTick++;
                        _showHidden = false;
                      });
                    },
                    onLongPress: _showHidden
                        ? null
                        : () => _showThreadMenu(context, thread),
                    onTap: () async {
                      await openAppPage(
                        context,
                        ChatThreadScreen(thread: thread),
                      );
                      await refresh();
                      if (mounted) setState(() => _listTick++);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showThreadMenu(BuildContext context, ChatThread thread) async {
    final l10n = AppLocalizations.of(context)!;
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
    }
    setState(() => _listTick++);
  }
}

class _NotConnected extends StatelessWidget {
  const _NotConnected({required this.palette, required this.l10n});

  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.cloud, size: 48, color: palette.textSecondary),
            const Gap(16),
            Text(
              l10n.messagesNotConnected,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.palette,
    required this.onTap,
    this.showUnhide = false,
    this.onUnhide,
    this.onLongPress,
  });

  final ChatThread thread;
  final AppPalette palette;
  final VoidCallback onTap;
  final bool showUnhide;
  final VoidCallback? onUnhide;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    DateTime? lastAt;
    if (thread.lastAt != null) {
      lastAt = DateTime.tryParse(thread.lastAt!);
    }
    final timeLabel = lastAt != null
        ? DateFormat('d MMM HH:mm', locale).format(lastAt.toLocal())
        : '';
    final unread = MessageReadTracker.isUnread(thread);
    final pinned = ChatThreadPinTracker.isPinned(thread.id);
    final muted = ChatThreadMuteTracker.isMuted(thread.id);

    return Card(
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundColor: palette.accent.withValues(alpha: 0.15),
              child: Icon(
                thread.isSelf ? Iconsax.user : Iconsax.message,
                color: palette.accent,
                size: 20,
              ),
            ),
            if (unread)
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: palette.accent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).cardColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            if (pinned) ...[
              Icon(Icons.push_pin, size: 14, color: palette.accent),
              const Gap(4),
            ],
            Expanded(
              child: Text(
                thread.title,
                style: TextStyle(
                  fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
            ),
            if (muted)
              Icon(Iconsax.volume_slash, size: 14, color: palette.textSecondary),
          ],
        ),
        subtitle: thread.lastText != null
            ? Text(
                thread.lastText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: palette.textSecondary, fontSize: 13),
              )
            : null,
        trailing: showUnhide
            ? TextButton(
                onPressed: onUnhide,
                child: Text(AppLocalizations.of(context)!.messagesUnhide),
              )
            : timeLabel.isNotEmpty
            ? Text(
                timeLabel,
                style: TextStyle(color: palette.textSecondary, fontSize: 11),
              )
            : null,
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
