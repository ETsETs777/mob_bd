import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../data/models/chat_thread.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/home_server_provider.dart';
import '../community/messages_tab.dart';
import '../../core/motion/app_motion.dart';
import 'chat_thread_screen.dart';
import 'new_chat_sheet.dart';

/// Отдельная страница чатов (из профиля / настроек).
class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(homeServerProvider).auth;

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
                  await openAppPage(
                    context,
                    ChatThreadScreen(thread: thread),
                  );
                }
              },
            ),
        ],
      ),
      body: const MessagesTab(),
    );
  }
}
