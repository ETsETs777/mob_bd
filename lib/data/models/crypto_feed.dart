// =============================================================================
// EcoPulse · lib/data/models/crypto_feed.dart
// Автор: Цымбал Е. В.
// Дата: 02.05.2026
// Модели данных (DTO, immutable классы). Файл: crypto_feed.
// =============================================================================

import '../../core/constants/market_catalog.dart';
import 'market_asset.dart';

/// Класс [CryptoFeed].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
class CryptoFeed {
/// Создаёт [CryptoFeed].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  const CryptoFeed({
    required this.assets,
    required this.loadedPages,
    this.loadingMore = false,
  });

/// Поле [assets] класса [CryptoFeed].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final List<MarketAsset> assets;
/// Поле [loadedPages] класса [CryptoFeed].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final int loadedPages;
/// Поле [loadingMore] класса [CryptoFeed].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final bool loadingMore;

/// Getter [hasMore] класса [CryptoFeed].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  bool get hasMore => loadedPages < CryptoCatalog.pages;

/// Метод [copyWith] класса [CryptoFeed].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  CryptoFeed copyWith({
    List<MarketAsset>? assets,
    int? loadedPages,
    bool? loadingMore,
  }) {
    return CryptoFeed(
      assets: assets ?? this.assets,
      loadedPages: loadedPages ?? this.loadedPages,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}
