# Live market data (WebSocket)

EcoPulse streams **live crypto prices** from Binance when the feature flag is enabled.

## Source

- **Binance** combined stream: `wss://stream.binance.com:9443/stream?streams=btcusdt@miniTicker/...`
- Updates: last price + 24h change percent (`miniTicker` event)
- Pairs: `{SYMBOL}USDT` for assets on the crypto tab (top 30) + watchlist crypto

## Client architecture

| Component | Role |
|-----------|------|
| `BinanceLiveStream` | WebSocket connect/disconnect |
| `liveCryptoPricesProvider` | Riverpod notifier, tick map by symbol |
| `cryptoWithLiveProvider` | Merges REST feed + live ticks |
| `FeatureFlag.liveCryptoWebSocket` | Toggle (default **on**) |

Markets screen shows a green **LIVE** badge when connected.

## Enable / disable

- **Admin panel** → Feature flags → *Live crypto WebSocket*
- Or set Hive key `flag_live_crypto_ws` to `0`

## MOEX / stocks (planned)

Real-time MOEX ISS WebSocket is not public; future options:

- Polling interval reduction for active watchlist
- Licensed data vendor
- Home server relay

## Testing

Unit tests: `test/core/utils/live_crypto_utils_test.dart`

Manual: open **Markets → Crypto**, watch prices update without pull-to-refresh.
