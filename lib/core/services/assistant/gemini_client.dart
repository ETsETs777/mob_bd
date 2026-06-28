// =============================================================================
// EcoPulse · lib/core/services/assistant/gemini_client.dart
// Автор: Цымбал Е. В.
// Дата: 27.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: gemini_client.
// =============================================================================

import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import 'assistant_context.dart';

/// Класс [GeminiClient].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
class GeminiClient {
/// Создаёт [GeminiClient].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  GeminiClient(this.apiKey);

/// Поле [apiKey] класса [GeminiClient].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final String apiKey;

/// Поле [_systemPrompt] класса [GeminiClient].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  static const _systemPrompt = '''
You are EcoPulse Assistant — a concise economic dashboard helper.
Answer in the user's language (Russian or English).
Topics: currencies, inflation, markets, crypto, key rates, commodities.
Do NOT give personalized investment advice. Keep answers under 120 words.
Use the app context JSON when relevant.
''';

/// Метод [ask] класса [GeminiClient].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  Future<String> ask({
    required String userMessage,
    required AssistantContext context,
  }) async {
    if (apiKey.isEmpty) {
      throw StateError('Gemini API key is missing');
    }

    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );

    final prompt = '''
App context:
${jsonEncode(context.toJson())}

User question:
$userMessage
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw StateError('Empty Gemini response');
    }
    return text;
  }
}
