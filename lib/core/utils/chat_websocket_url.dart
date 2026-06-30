/// Converts HTTP(S) Home Server URL to WS(S) for chat WebSocket.
String homeServerWebSocketUrl(String serverUrl) {
  var base = serverUrl.trim();
  if (base.endsWith('/')) base = base.substring(0, base.length - 1);

  Uri uri;
  if (base.startsWith('http://') || base.startsWith('https://')) {
    uri = Uri.parse(base);
  } else {
    uri = Uri.parse('http://$base');
  }

  final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
  return Uri(
    scheme: wsScheme,
    host: uri.host,
    port: uri.hasPort ? uri.port : null,
    path: '/v1/ws/chat',
  ).toString();
}
