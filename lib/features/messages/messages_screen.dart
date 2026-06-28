import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_palette.dart';
import '../../data/models/chat_thread.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/home_server_provider.dart';
import '../../providers/messages_provider.dart';
import 'chat_thread_screen.dart';
import 'new_chat_sheet.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh() async {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.messagesTitle),
        actions: [
          if (auth.isLoggedIn)
            IconButton(
              icon: const Icon(Iconsax.add),
              tooltip: l10n.messagesNewChat,
              onPressed: () async {
                final thread = await showModalBottomSheet<ChatThread>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const NewChatSheet(),
                );
                if (thread != null && context.mounted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => ChatThreadScreen(thread: thread),
                    ),
                  );
                  await _refresh();
                }
              },
            ),
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: auth.isLoggedIn ? _refresh : null,
          ),
        ],
      ),
      body: !auth.isLoggedIn
          ? _NotConnected(palette: palette, l10n: l10n)
          : RefreshIndicator(
              onRefresh: _refresh,
              child: messages.threads.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.4,
                          child: Center(
                            child: Text(
                              l10n.messagesEmpty,
                              style: TextStyle(color: palette.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: messages.threads.length,
                      separatorBuilder: (_, _) => const Gap(8),
                      itemBuilder: (context, index) {
                        final thread = messages.threads[index];
                        return _ThreadTile(
                          thread: thread,
                          palette: palette,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => ChatThreadScreen(thread: thread),
                              ),
                            );
                            await _refresh();
                          },
                        );
                      },
                    ),
            ),
    );
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
  });

  final ChatThread thread;
  final AppPalette palette;
  final VoidCallback onTap;

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

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: palette.accent.withValues(alpha: 0.15),
          child: Icon(
            thread.isSelf ? Iconsax.user : Iconsax.message,
            color: palette.accent,
            size: 20,
          ),
        ),
        title: Text(
          thread.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
        subtitle: thread.lastText != null
            ? Text(
                thread.lastText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: palette.textSecondary, fontSize: 13),
              )
            : null,
        trailing: timeLabel.isNotEmpty
            ? Text(
                timeLabel,
                style: TextStyle(color: palette.textSecondary, fontSize: 11),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
