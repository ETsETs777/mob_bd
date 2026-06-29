import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/customization_preset.dart';
import '../../core/customization/customization_presets.dart';
import '../../data/services/cache_service.dart';
import 'package:ecopulse/providers/customization/customization_provider.dart';

final allCustomizationPresetsProvider = Provider<List<CustomizationPreset>>((ref) {
  return [
    ...CustomizationPresets.builtIn,
    ...ref.watch(userCustomizationPresetsProvider),
  ];
});

final userCustomizationPresetsProvider =
    NotifierProvider<UserCustomizationPresetsNotifier, List<CustomizationPreset>>(
  UserCustomizationPresetsNotifier.new,
);

class UserCustomizationPresetsNotifier extends Notifier<List<CustomizationPreset>> {
  static const cacheKey = 'customization_presets_v1';

  @override
  List<CustomizationPreset> build() => _load();

  List<CustomizationPreset> _load() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => CustomizationPreset.fromJson(e as Map<String, dynamic>))
          .where((p) => !p.isBuiltIn)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _persist(List<CustomizationPreset> presets) async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(presets.map((p) => p.toJson()).toList()),
    );
    state = presets;
  }

  Future<CustomizationPreset> saveFromCurrent({
    required String nameRu,
    required String nameEn,
  }) async {
    final config = ref.read(customizationProvider);
    final preset = CustomizationPreset(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      nameRu: nameRu.trim().isEmpty ? nameEn.trim() : nameRu.trim(),
      nameEn: nameEn.trim().isEmpty ? nameRu.trim() : nameEn.trim(),
      config: CustomizationPresets.stripPresetMeta(config),
    );
    await _persist([...state, preset]);
    return preset;
  }

  Future<void> delete(String id) async {
    await _persist(state.where((p) => p.id != id).toList());
  }

  String exportPreset(String id) {
    final preset = state.firstWhere((p) => p.id == id);
    return const JsonEncoder.withIndent('  ').convert(preset.toJson());
  }

  Future<CustomizationPreset> importFromJson(String raw) async {
    final decoded = jsonDecode(raw.trim());
    final map = decoded is Map<String, dynamic>
        ? decoded
        : (decoded as List<dynamic>).first as Map<String, dynamic>;
    final preset = CustomizationPreset.fromJson(map).copyWithId(
      'user_${DateTime.now().millisecondsSinceEpoch}',
    );
    if (preset.isBuiltIn) {
      throw FormatException('built_in_preset');
    }
    await _persist([...state, preset]);
    return preset;
  }
}

extension on CustomizationPreset {
  CustomizationPreset copyWithId(String newId) {
    return CustomizationPreset(
      id: newId,
      nameRu: nameRu,
      nameEn: nameEn,
      config: config,
      isBuiltIn: false,
    );
  }
}
