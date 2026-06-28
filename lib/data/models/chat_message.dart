// =============================================================================
// EcoPulse · lib/data/models/chat_message.dart
// Автор: Цымбал Е. В.
// Дата: 01.05.2026
// Модели данных (DTO, immutable классы). Файл: chat_message.
// =============================================================================

/// Значение enum [assistant].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
/// Значение enum [user].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
/// Enum [ChatRole] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
/// Значение enum [assistant].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
/// Значение enum [user].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
enum ChatRole { user, assistant }

/// Значение enum [system].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
/// Значение enum [cloud].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
/// Значение enum [local].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
/// Enum [ChatSource] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
/// Значение enum [system].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
/// Значение enum [cloud].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
/// Значение enum [local].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
enum ChatSource { local, cloud, system }

/// Класс [ChatMessage].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
class ChatMessage {
/// Создаёт [ChatMessage].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.source = ChatSource.local,
  });

/// Поле [id] класса [ChatMessage].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  final String id;
/// Поле [role] класса [ChatMessage].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final ChatRole role;
/// Поле [text] класса [ChatMessage].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final String text;
/// Поле [timestamp] класса [ChatMessage].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final DateTime timestamp;
/// Поле [source] класса [ChatMessage].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final ChatSource source;

/// Метод [toJson] класса [ChatMessage].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'source': source.name,
      };

/// Создаёт [ChatMessage] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        role: ChatRole.values.byName(json['role'] as String),
        text: json['text'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        source: ChatSource.values.byName(json['source'] as String? ?? 'local'),
      );

/// Метод [copyWith] класса [ChatMessage].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  ChatMessage copyWith({String? text, ChatSource? source}) => ChatMessage(
        id: id,
        role: role,
        text: text ?? this.text,
        timestamp: timestamp,
        source: source ?? this.source,
      );
}
