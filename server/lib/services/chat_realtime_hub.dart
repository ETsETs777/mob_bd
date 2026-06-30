import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

/// Real-time chat: WebSocket connections, thread rooms, typing broadcast.
class ChatRealtimeHub {
  final _channelsByUser = <String, Set<WebSocketChannel>>{};
  final _threadsByUser = <String, Set<String>>{};
  final _typingTimers = <String, Timer>{};

  void register(String userId, WebSocketChannel channel) {
    _channelsByUser.putIfAbsent(userId, () => {}).add(channel);
  }

  void unregister(String userId, WebSocketChannel channel) {
    final set = _channelsByUser[userId];
    set?.remove(channel);
    if (set != null && set.isEmpty) {
      _channelsByUser.remove(userId);
      final threads = _threadsByUser.remove(userId);
      if (threads != null) {
        for (final threadId in threads) {
          _clearTyping(threadId, userId);
        }
      }
    }
  }

  void joinThread(String userId, String threadId) {
    _threadsByUser.putIfAbsent(userId, () => {}).add(threadId);
    _send(userId, {'type': 'joined', 'threadId': threadId});
  }

  void leaveThread(String userId, String threadId) {
    _threadsByUser[userId]?.remove(threadId);
    _clearTyping(threadId, userId);
  }

  void broadcastMessage(
    String threadId,
    Map<String, dynamic> message, {
    required List<String> memberIds,
    String? senderId,
  }) {
    for (final memberId in memberIds) {
      if (memberId == senderId) continue;
      if (!_isSubscribed(memberId, threadId)) continue;
      _send(memberId, {'type': 'message', 'message': message});
    }
    for (final memberId in memberIds) {
      if (memberId == senderId) continue;
      _send(memberId, {'type': 'threads_refresh'});
    }
  }

  void broadcastTyping({
    required String threadId,
    required String userId,
    required String userName,
    required bool typing,
    required List<String> memberIds,
  }) {
    final key = '$threadId:$userId';
    _typingTimers[key]?.cancel();
    _typingTimers.remove(key);

    if (typing) {
      _typingTimers[key] = Timer(const Duration(seconds: 4), () {
        _broadcastTypingStop(threadId, userId, userName, memberIds);
        _typingTimers.remove(key);
      });
    }

    for (final memberId in memberIds) {
      if (memberId == userId) continue;
      if (!_isSubscribed(memberId, threadId)) continue;
      _send(memberId, {
        'type': 'typing',
        'threadId': threadId,
        'userId': userId,
        'userName': userName,
        'typing': typing,
      });
    }
  }

  void _broadcastTypingStop(
    String threadId,
    String userId,
    String userName,
    List<String> memberIds,
  ) {
    for (final memberId in memberIds) {
      if (memberId == userId) continue;
      if (!_isSubscribed(memberId, threadId)) continue;
      _send(memberId, {
        'type': 'typing',
        'threadId': threadId,
        'userId': userId,
        'userName': userName,
        'typing': false,
      });
    }
  }

  void _clearTyping(String threadId, String userId) {
    final key = '$threadId:$userId';
    _typingTimers[key]?.cancel();
    _typingTimers.remove(key);
  }

  bool _isSubscribed(String userId, String threadId) =>
      _threadsByUser[userId]?.contains(threadId) ?? false;

  void _send(String userId, Map<String, dynamic> payload) {
    final channels = _channelsByUser[userId];
    if (channels == null || channels.isEmpty) return;
    final data = jsonEncode(payload);
    for (final channel in channels.toList()) {
      try {
        channel.sink.add(data);
      } catch (_) {
        unregister(userId, channel);
      }
    }
  }
}
