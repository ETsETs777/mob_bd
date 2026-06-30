import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/app_deep_link.dart';
import '../../data/models/chat_thread.dart';
import '../../providers/messages/messages_provider.dart';
import '../../providers/profile/home_server_provider.dart';
import 'markdown_utils.dart';

Future<bool> shareArticleToSelfChat(
  WidgetRef ref, {
  required String title,
  required String body,
  String? articleId,
}) async {
  if (!ref.read(homeServerProvider).auth.isLoggedIn) return false;

  final messages = ref.read(messagesProvider.notifier);
  await messages.ensureSelfThread();
  await messages.refreshThreads();

  ChatThread? selfThread;
  for (final t in ref.read(messagesProvider).threads) {
    if (t.isSelf) {
      selfThread = t;
      break;
    }
  }
  if (selfThread == null) return false;

  final excerpt = MarkdownUtils.previewExcerpt(body, maxLength: 400);
  final link = articleId != null ? '\n${AppDeepLink.article(articleId).shareLink}' : '';
  final text = '$title\n\n$excerpt$link';

  return messages.sendMessage(selfThread.id, text);
}
