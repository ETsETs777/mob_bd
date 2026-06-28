import '../../data/models/user_customization.dart';

/// Именованный пресет кастомизации EcoPulse.
class CustomizationPreset {
  const CustomizationPreset({
    required this.id,
    required this.nameRu,
    required this.nameEn,
    required this.config,
    this.isBuiltIn = false,
  });

  final String id;
  final String nameRu;
  final String nameEn;
  final UserCustomization config;
  final bool isBuiltIn;

  String label({required bool isRu}) => isRu ? nameRu : nameEn;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameRu': nameRu,
        'nameEn': nameEn,
        'isBuiltIn': isBuiltIn,
        'config': config.toJson(),
      };

  factory CustomizationPreset.fromJson(Map<String, dynamic> json) {
    return CustomizationPreset(
      id: json['id'] as String,
      nameRu: json['nameRu'] as String? ?? json['name'] as String? ?? 'Preset',
      nameEn: json['nameEn'] as String? ?? json['name'] as String? ?? 'Preset',
      isBuiltIn: json['isBuiltIn'] as bool? ?? false,
      config: UserCustomization.fromJson(
        json['config'] as Map<String, dynamic>? ?? json,
      ),
    );
  }
}
