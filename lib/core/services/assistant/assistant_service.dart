// =============================================================================
// EcoPulse · lib/core/services/assistant/assistant_service.dart
// Автор: Цымбал Е. В.
// Дата: 26.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: assistant_service.
// =============================================================================

import '../../../data/models/chat_message.dart';
import '../../../data/models/price_alert.dart';
import 'assistant_context.dart';
import 'gemini_client.dart';
import 'intent_router.dart';
import 'local_responder.dart';

/// Класс [AssistantReply].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
class AssistantReply {
/// Создаёт [AssistantReply].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  const AssistantReply({
    required this.message,
    this.action,
    this.createdAlert = false,
    this.alertToSave,
  });

/// Поле [message] класса [AssistantReply].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  final ChatMessage message;
/// Поле [action] класса [AssistantReply].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final AssistantAction? action;
/// Поле [createdAlert] класса [AssistantReply].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  final bool createdAlert;
/// Поле [alertToSave] класса [AssistantReply].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  final PriceAlert? alertToSave;
}

/// Сервис [AssistantService] — фоновая или системная логика.
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
class AssistantService {
/// Метод [reply] класса [AssistantService].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  Future<AssistantReply> reply({
    required String userText,
    required AssistantContext context,
    required String geminiKey,
    required bool preferCloud,
  }) async {
    final match = IntentRouter.route(userText);

    if (match.intent == AssistantIntent.setAlert) {
      return _handleAlert(match, context);
    }

    if (match.intent != AssistantIntent.general) {
      final local = LocalResponder.respond(match, context);
      return AssistantReply(
        message: ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: ChatRole.assistant,
          text: local.text,
          timestamp: DateTime.now(),
          source: ChatSource.local,
        ),
        action: local.action,
      );
    }

    if (preferCloud && geminiKey.isNotEmpty) {
      try {
        final text = await GeminiClient(geminiKey).ask(
          userMessage: userText,
          context: context,
        );
        return AssistantReply(
          message: ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: ChatRole.assistant,
            text: text,
            timestamp: DateTime.now(),
            source: ChatSource.cloud,
          ),
        );
      } catch (_) {}
    }

    final hint = context.isRu
        ? 'Я могу ответить на вопросы о курсе USD/RUB, BTC, сводке, портфеле и открыть разделы приложения. Для сложных вопросов добавьте Gemini API ключ в настройках.'
        : 'I can answer about USD/RUB, BTC, today\'s brief, portfolio, and open app sections. For complex questions, add a Gemini API key in Settings.';

    return AssistantReply(
      message: ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: ChatRole.assistant,
        text: hint,
        timestamp: DateTime.now(),
        source: ChatSource.local,
      ),
    );
  }

/// Приватный метод [_handleAlert] класса [AssistantService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  AssistantReply _handleAlert(IntentMatch match, AssistantContext context) {
    final symbol = switch (match.alertSymbol) {
      'btc' => PriceAlertSymbol.btc,
      'eth' => PriceAlertSymbol.eth,
      'eurRub' => PriceAlertSymbol.eurRub,
      _ => PriceAlertSymbol.usdRub,
    };

    final alert = PriceAlert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: symbol,
      condition: match.alertAbove ? AlertCondition.above : AlertCondition.below,
      threshold: match.alertThreshold ?? 90,
    );

    final cmp = match.alertAbove ? '≥' : '≤';
    final text = context.isRu
        ? 'Создан алерт: ${symbol.label} $cmp ${alert.threshold.toStringAsFixed(2)}'
        : 'Alert created: ${symbol.label} $cmp ${alert.threshold.toStringAsFixed(2)}';

    return AssistantReply(
      message: ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: ChatRole.assistant,
        text: text,
        timestamp: DateTime.now(),
        source: ChatSource.local,
      ),
      createdAlert: true,
      alertToSave: alert,
    );
  }
}
