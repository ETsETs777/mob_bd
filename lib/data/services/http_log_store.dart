// =============================================================================
// EcoPulse · lib/data/services/http_log_store.dart
// Автор: Цымбал Е. В.
// Дата: 12.05.2026
// HTTP-клиент (Dio), Hive-кэш. Файл: http_log_store.
// =============================================================================

/// Класс [HttpLogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
class HttpLogEntry {
/// Создаёт [HttpLogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  const HttpLogEntry({
    required this.at,
    required this.message,
    this.isError = false,
  });

/// Поле [at] класса [HttpLogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  final DateTime at;
/// Поле [message] класса [HttpLogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  final String message;
/// Поле [isError] класса [HttpLogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  final bool isError;
}

/// Кольцевой буфер последних HTTP-событий для dev admin panel.
class HttpLogStore {
/// Создаёт [HttpLogStore] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  HttpLogStore._();
/// Поле [instance] класса [HttpLogStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static final instance = HttpLogStore._();

/// Поле [_maxEntries] класса [HttpLogStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static const _maxEntries = 30;
/// Поле [_entries] класса [HttpLogStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  final _entries = <HttpLogEntry>[];

/// Getter [entries] класса [HttpLogStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  List<HttpLogEntry> get entries => List.unmodifiable(_entries.reversed);

/// Метод [add] класса [HttpLogStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  void add(String message, {bool isError = false}) {
    _entries.add(HttpLogEntry(at: DateTime.now(), message: message, isError: isError));
    while (_entries.length > _maxEntries) {
      _entries.removeAt(0);
    }
  }

/// Метод [clear] класса [HttpLogStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  void clear() => _entries.clear();
}
