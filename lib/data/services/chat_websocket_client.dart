import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/utils/chat_websocket_url.dart';

typedef ChatWsEventHandler = void Function(Map<String, dynamic> event);

/// WebSocket-клиент real-time чата Home Server.
class ChatWebSocketClient {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  ChatWsEventHandler? onEvent;
  void Function()? onDisconnected;

  bool _connecting = false;
  bool _authed = false;
  Completer<void>? _authWaiter;
  bool get isConnected => _channel != null && _authed;

  Future<void> connect({
    required String serverUrl,
    required String token,
  }) async {
    if (_connecting || isConnected) return;
    _connecting = true;
    _authed = false;
    _authWaiter = Completer<void>();
    try {
      final url = homeServerWebSocketUrl(serverUrl);
      final channel = WebSocketChannel.connect(Uri.parse(url));
      _channel = channel;
      _subscription = channel.stream.listen(
        (raw) {
          try {
            final event = jsonDecode(raw as String) as Map<String, dynamic>;
            if (!_authed) {
              if (event['type'] == 'auth_ok') {
                _authed = true;
                if (!(_authWaiter?.isCompleted ?? true)) {
                  _authWaiter!.complete();
                }
              } else if (event['type'] == 'error') {
                if (!(_authWaiter?.isCompleted ?? true)) {
                  _authWaiter!.completeError(event['code'] ?? 'auth_failed');
                }
              }
              return;
            }
            onEvent?.call(event);
          } catch (_) {}
        },
        onDone: _handleDisconnect,
        onError: (_) => _handleDisconnect(),
        cancelOnError: true,
      );
      channel.sink.add(jsonEncode({'type': 'auth', 'token': token}));
      await _authWaiter!.future.timeout(const Duration(seconds: 8));
    } finally {
      _connecting = false;
    }
  }

  void joinThread(String threadId) =>
      _send({'type': 'join', 'threadId': threadId});

  void leaveThread(String threadId) =>
      _send({'type': 'leave', 'threadId': threadId});

  void sendTyping(String threadId, bool typing) =>
      _send({'type': 'typing', 'threadId': threadId, 'typing': typing});

  void ping() => _send({'type': 'ping'});

  void _send(Map<String, dynamic> payload) {
    final channel = _channel;
    if (channel == null || !_authed) return;
    try {
      channel.sink.add(jsonEncode(payload));
    } catch (_) {
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    _subscription?.cancel();
    _subscription = null;
    _channel = null;
    _authed = false;
    if (!(_authWaiter?.isCompleted ?? true)) {
      _authWaiter!.completeError('disconnected');
    }
    onDisconnected?.call();
  }

  Future<void> disconnect() async {
    _subscription?.cancel();
    _subscription = null;
    _authed = false;
    await _channel?.sink.close();
    _channel = null;
  }
}
