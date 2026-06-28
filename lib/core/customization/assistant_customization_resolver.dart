import '../../data/models/user_customization.dart';

/// Эффективные настройки AI-ассистента из [AssistantCustomization].
class ResolvedAssistant {
  const ResolvedAssistant({
    required this.preferCloud,
    required this.showQuickChips,
    required this.voiceInputEnabled,
  });

  final bool preferCloud;
  final bool showQuickChips;
  final bool voiceInputEnabled;
}

/// Резолвер настроек ассистента EcoPulse.
class AssistantCustomizationResolver {
  AssistantCustomizationResolver._();

  static ResolvedAssistant resolve(AssistantCustomization assistant) {
    return ResolvedAssistant(
      preferCloud: assistant.preferCloud,
      showQuickChips: assistant.showQuickChips,
      voiceInputEnabled: assistant.voiceInputEnabled,
    );
  }
}
