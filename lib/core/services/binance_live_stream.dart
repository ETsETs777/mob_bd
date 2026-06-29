import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils/live_crypto_utils.dart';

/// Binance combined stream для miniTicker (live цены crypto/USDT).
class BinanceLiveStream {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  final _controller = StreamController<LiveCryptoTick>.broadcast();
  List<String> _symbols = const [];

  Stream<LiveCryptoTick> get ticks => _controller.stream;

  bool get isConnected => _channel != null;

  Future<void> connect(List<String> cryptoSymbols) async {
    final normalized = cryptoSymbols
        .map((s) => s.toUpperCase())
        .where((s) => s.isNotEmpty)
        .toSet()
        .take(40)
        .toList();
    if (normalized.isEmpty) {
      await disconnect();
      return;
    }

    if (_symbols.join(',') == normalized.join(',') && isConnected) return;

    await disconnect();
    _symbols = normalized;

    final streams =
        normalized.map((s) => '${binanceUsdtPair(s).toLowerCase()}@miniTicker');
    final uri = Uri.parse(
      'wss://stream.binance.com:9443/stream?streams=${streams.join('/')}',
    );

    _channel = WebSocketChannel.connect(uri);
    _sub = _channel!.stream.listen(
      (event) {
        try {
          final map = jsonDecode(event as String) as Map<String, dynamic>;
          final tick = parseBinanceMiniTicker(map);
          if (tick != null) _controller.add(tick);
        } catch (_) {}
      },
      onError: (_) => disconnect(),
      onDone: () => disconnect(),
    );
  }

  Future<void> disconnect() async {
    await _sub?.cancel();
    _sub = null;
    await _channel?.sink.close();
    _channel = null;
    _symbols = const [];
  }

  Future<void> dispose() async {
    await disconnect();
    await _controller.close();
  }
}
