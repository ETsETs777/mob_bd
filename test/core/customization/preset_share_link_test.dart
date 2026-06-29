// =============================================================================
// EcoPulse · test/core/customization/preset_share_link_test.dart
// =============================================================================

import 'package:ecopulse/core/customization/customization_presets.dart';
import 'package:ecopulse/core/customization/preset_share_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encode and decode roundtrip built-in preset', () {
    final preset = CustomizationPresets.trader;
    final link = PresetShareLink.encode(preset);
    expect(link, contains('ecopulse.app/preset'));
    expect(PresetShareLink.looksLikePresetLink(link), isTrue);

    final decoded = PresetShareLink.decode(link);
    expect(decoded, isNotNull);
    expect(decoded!.id, preset.id);
    expect(decoded.nameRu, preset.nameRu);
    expect(
      decoded.config.appearance.accentKey,
      preset.config.appearance.accentKey,
    );
  });

  test('decode ecopulse custom scheme link', () {
    final preset = CustomizationPresets.minimal;
    final webLink = PresetShareLink.encode(preset);
    final uri = Uri.parse(webLink);
    final custom = Uri(
      scheme: PresetShareLink.customScheme,
      host: PresetShareLink.customHost,
      queryParameters: uri.queryParameters,
    ).toString();

    expect(PresetShareLink.looksLikePresetLink(custom), isTrue);
    final decoded = PresetShareLink.decode(custom);
    expect(decoded?.id, preset.id);
  });

  test('looksLikePresetLink rejects unrelated urls', () {
    expect(PresetShareLink.looksLikePresetLink('https://google.com'), isFalse);
    expect(PresetShareLink.looksLikePresetLink('hello'), isFalse);
  });
}
