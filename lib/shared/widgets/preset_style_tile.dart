import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/customization/customization_preset.dart';
import '../../core/theme/app_accent.dart';
import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_palette.dart';

/// Визуальная плитка пресета: градиент фона + цветной круг акцента.
class PresetStyleTile extends StatelessWidget {
  const PresetStyleTile({
    super.key,
    required this.preset,
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
    this.size = 72,
    this.showLabel = true,
  });

  final CustomizationPreset preset;
  final String label;
  final bool selected;
  final AppPalette palette;
  final VoidCallback onTap;
  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final background = AppBackgroundPresetX.fromString(
      preset.config.appearance.backgroundKey,
    );
    final accent = AppAccentColor.fromKey(preset.config.appearance.accentKey);
    final isDark = !background.isLight;
    final accentColor = isDark ? accent.darkAccent : accent.lightAccent;
    final colors = background.gradientColors;
    final checkColor =
        colors.first.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            SizedBox(
              height: size,
              width: size,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: colors,
                        begin: background.gradientBegin,
                        end: background.gradientEnd,
                      ),
                      border: Border.all(
                        color: selected ? palette.accent : palette.border,
                        width: selected ? 2.5 : 1,
                      ),
                    ),
                    child: selected
                        ? Center(
                            child: Icon(Icons.check, color: checkColor, size: 22),
                          )
                        : null,
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: palette.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showLabel && label.isNotEmpty) ...[
              const Gap(4),
              Text(
                label,
                maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                height: 1.15,
                color: selected ? palette.accent : palette.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            ],
          ],
        ),
      ),
    );
  }
}
