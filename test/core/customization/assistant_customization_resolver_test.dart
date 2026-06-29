import 'package:ecopulse/core/customization/assistant_customization_resolver.dart';
import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AssistantCustomizationResolver resolves assistant flags', () {
    const assistant = AssistantCustomization(
      preferCloud: true,
      showQuickChips: false,
      voiceInputEnabled: false,
    );

    final resolved = AssistantCustomizationResolver.resolve(assistant);

    expect(resolved.preferCloud, isTrue);
    expect(resolved.showQuickChips, isFalse);
    expect(resolved.voiceInputEnabled, isFalse);
  });

  test('defaults match CustomizationDefaults', () {
    final defaults = CustomizationDefaults.create().assistant;
    final resolved = AssistantCustomizationResolver.resolve(defaults);

    expect(resolved.preferCloud, isFalse);
    expect(resolved.showQuickChips, isTrue);
    expect(resolved.voiceInputEnabled, isTrue);
  });
}
