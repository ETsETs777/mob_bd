import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../auth/auth_service.dart';
import '../services/chat_realtime_hub.dart';
import '../services/thread_service.dart';

Handler createChatWebSocketHandler({
  required AuthService auth,
  required ThreadService threads,
  required ChatRealtimeHub hub,
}) {
  return webSocketHandler((WebSocketChannel channel, String? _) {
    var authed = false;
    String? userId;
    String userName = '';

    channel.stream.listen(
      (raw) async {
        Map<String, dynamic> data;
        try {
          data = jsonDecode(raw as String) as Map<String, dynamic>;
        } catch (_) {
          return;
        }

        final type = data['type'] as String? ?? '';

        if (!authed) {
          if (type != 'auth') {
            channel.sink.add(jsonEncode({'type': 'error', 'code': 'unauthorized'}));
            channel.sink.close();
            return;
          }
          final token = data['token'] as String? ?? '';
          final user = await auth.verifyBearer('Bearer $token');
          if (user == null) {
            channel.sink.add(jsonEncode({'type': 'error', 'code': 'unauthorized'}));
            channel.sink.close();
            return;
          }
          authed = true;
          userId = user['id']!;
          final displayName = user['displayName']?.trim() ?? '';
          userName = displayName.isNotEmpty
              ? displayName
              : (user['login'] ?? '');
          hub.register(userId!, channel);
          channel.sink.add(jsonEncode({'type': 'auth_ok'}));
          return;
        }

        final threadId = data['threadId'] as String? ?? '';
        final uid = userId!;

        switch (type) {
          case 'join':
            if (threadId.isEmpty || !await threads.isMember(threadId, uid)) {
              channel.sink.add(jsonEncode({'type': 'error', 'code': 'forbidden'}));
              return;
            }
            hub.joinThread(uid, threadId);
            break;
          case 'leave':
            if (threadId.isNotEmpty) hub.leaveThread(uid, threadId);
            break;
          case 'typing':
            if (threadId.isEmpty || !await threads.isMember(threadId, uid)) return;
            hub.broadcastTyping(
              threadId: threadId,
              userId: uid,
              userName: userName,
              typing: data['typing'] == true,
              memberIds: await threads.memberIds(threadId),
            );
            break;
          case 'ping':
            channel.sink.add(jsonEncode({'type': 'pong'}));
            break;
        }
      },
      onDone: () {
        if (userId != null) hub.unregister(userId!, channel);
      },
      onError: (_) {
        if (userId != null) hub.unregister(userId!, channel);
      },
      cancelOnError: true,
    );
  });
}

String chatWebSocketPath() => 'v1/ws/chat';
