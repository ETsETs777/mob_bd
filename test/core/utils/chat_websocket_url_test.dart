import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/chat_websocket_url.dart';

void main() {
  test('homeServerWebSocketUrl converts http to ws', () {
    final url = homeServerWebSocketUrl('http://192.168.1.10:8081');
    expect(url, 'ws://192.168.1.10:8081/v1/ws/chat');
  });

  test('homeServerWebSocketUrl converts https to wss', () {
    final url = homeServerWebSocketUrl('https://example.com');
    expect(url, 'wss://example.com/v1/ws/chat');
  });
}
