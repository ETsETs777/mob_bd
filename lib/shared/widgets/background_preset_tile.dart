import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_palette.dart';

/// Плитка фона приложения: градиент + подпись (как в настройках).
class BackgroundPresetTile extends StatelessWidget {
  const BackgroundPresetTile({
    super.key,
    required this.preset,
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final AppBackgroundPreset preset;
  final String label;
  final bool selected;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = preset.gradientColors;
    final checkColor =
        colors.first.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Container(
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: colors,
                  begin: preset.gradientBegin,
                  end: preset.gradientEnd,
                ),
                border: Border.all(
                  color: selected ? palette.accent : palette.border,
                  width: selected ? 2.5 : 1,
                ),
              ),
              child: selected
                  ? Center(
                      child: Icon(Icons.check, color: checkColor, size: 20),
                    )
                  : null,
            ),
            const Gap(4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: selected ? palette.accent : palette.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
