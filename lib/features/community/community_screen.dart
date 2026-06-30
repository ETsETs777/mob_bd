import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../assistant/assistant_fab_layout.dart';
import '../../data/models/chat_thread.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/article_draft_storage.dart';
import '../../core/utils/article_read_tracker.dart';
import '../../providers/app_providers.dart';
import '../../core/utils/message_read_tracker.dart';
import '../../providers/articles_provider.dart';
import '../../providers/home_server_provider.dart';
import '../../providers/messages_provider.dart';
import '../articles/article_moderation_screen.dart';
import '../articles/article_editor_sheet.dart';
import '../messages/chat_thread_screen.dart';
import '../messages/new_chat_sheet.dart';
import 'articles_tab.dart';
import 'messages_tab.dart';

/// Вкладка «Сообщество»: чаты и статьи пользователей.
class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key, this.initialTab});

  /// Явная подвкладка при открытии отдельной страницей (0 — чаты, 1 — статьи).
  /// В shell используется [communityInitialTabProvider].
  final int? initialTab;

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _messagesKey = GlobalKey<MessagesTabState>();
  final _articlesKey = GlobalKey<ArticlesTabState>();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyInitialTab();
      final auth = ref.read(homeServerProvider).auth;
      if (auth.isLoggedIn && auth.isAdmin) {
        ref.read(articlesProvider.notifier).refreshAll();
      }
    });
  }

  void _applyInitialTab() {
    final fromWidget = widget.initialTab;
    final fromProvider = ref.read(communityInitialTabProvider);
    final target = (fromWidget ?? fromProvider).clamp(0, 1);
    if (target != _tabs.index) {
      _tabs.index = target;
    }
    if (fromProvider != 0) {
      ref.read(communityInitialTabProvider.notifier).state = 0;
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _refreshCurrent() async {
    if (_tabs.index == 0) {
      await _messagesKey.currentState?.refresh();
    } else {
      await _articlesKey.currentState?.refresh();
    }
  }

  Future<void> _openNewChat() async {
    final thread = await showModalBottomSheet<ChatThread>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const NewChatSheet(),
    );
    if (thread != null && mounted) {
      await openAppPage(context, ChatThreadScreen(thread: thread));
      await _messagesKey.currentState?.refresh();
    }
  }

  Future<void> _openArticleEditor() async {
    final ok = await showArticleEditorSheet(context);
    if (ok == true) {
      await ref.read(articlesProvider.notifier).refreshAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(homeServerProvider).auth;
    final onChats = _tabs.index == 0;
    final pendingModeration = ref.watch(pendingArticlesCountProvider);
    final unreadMessages = ref.watch(unreadMessagesCountProvider);
    final unreadArticles = ref.watch(unreadArticlesCountProvider);
    final onArticles = _tabs.index == 1;

    ref.listen<int>(communityInitialTabProvider, (previous, next) {
      if (next == 0) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final target = next.clamp(0, 1);
        if (_tabs.index != target) {
          _tabs.animateTo(target);
        }
        ref.read(communityInitialTabProvider.notifier).state = 0;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabCommunity),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.tabMessages),
                  if (unreadMessages > 0) ...[
                    const SizedBox(width: 6),
                    Badge(label: Text('$unreadMessages')),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.tabArticles),
                  if (unreadArticles > 0) ...[
                    const SizedBox(width: 6),
                    Badge(label: Text('$unreadArticles')),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (auth.isLoggedIn && auth.isAdmin)
            Badge(
              isLabelVisible: pendingModeration > 0,
              label: Text('$pendingModeration'),
              child: IconButton(
                icon: const Icon(Iconsax.shield_tick),
                tooltip: l10n.userArticlesModerationTitle,
                onPressed: () => openAppPage(
                  context,
                  const ArticleModerationScreen(),
                ),
              ),
            ),
          if (auth.isLoggedIn && onChats && unreadMessages > 0)
            IconButton(
              icon: const Icon(Iconsax.tick_circle),
              tooltip: l10n.messagesMarkAllRead,
              onPressed: () async {
                await MessageReadTracker.markAllRead(
                  ref.read(messagesProvider).threads,
                );
                if (mounted) setState(() {});
              },
            ),
          if (auth.isLoggedIn && onArticles && unreadArticles > 0)
            IconButton(
              icon: const Icon(Iconsax.tick_circle),
              tooltip: l10n.userArticlesMarkAllRead,
              onPressed: () async {
                await ArticleReadTracker.markAllRead(
                  ref.read(articlesProvider).published,
                );
                _articlesKey.currentState?.refreshReadState();
                if (mounted) setState(() {});
              },
            ),
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: auth.isLoggedIn ? _refreshCurrent : null,
          ),
        ],
      ),
      floatingActionButton: auth.isLoggedIn
          ? Padding(
              padding: EdgeInsets.only(
                left: AssistantFabLayout.margin,
                bottom: AssistantFabLayout.margin,
              ),
              child: FloatingActionButton.extended(
                heroTag: 'community_compose_fab',
                onPressed: onChats ? _openNewChat : _openArticleEditor,
                icon: Icon(onChats ? Iconsax.message : Iconsax.edit),
                label: Text(
                  onChats ? l10n.messagesNewChat : l10n.userArticlesWrite,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Stack(
        children: [
          Column(
            children: [
              if (auth.isLoggedIn &&
                  onArticles &&
                  ArticleDraftStorage.load() != null)
                MaterialBanner(
                  content: Text(l10n.userArticlesContinueDraft),
                  leading: const Icon(Iconsax.edit),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await ArticleDraftStorage.clear();
                        if (mounted) setState(() {});
                      },
                      child: Text(l10n.userArticlesDraftClear),
                    ),
                    TextButton(
                      onPressed: () async {
                        final ok = await showArticleEditorSheet(context);
                        if (ok == true) {
                          await ref.read(articlesProvider.notifier).refreshAll();
                          if (mounted) setState(() {});
                        }
                      },
                      child: Text(l10n.userArticlesContinueDraftAction),
                    ),
                  ],
                ),
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    MessagesTab(key: _messagesKey),
                    ArticlesTab(key: _articlesKey),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
