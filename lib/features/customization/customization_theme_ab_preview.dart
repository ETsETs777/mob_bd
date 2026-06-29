import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/customization/appearance_palette_resolver.dart';
import '../../core/customization/customization_presets.dart';
import '../../core/customization/customization_sync.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization_provider.dart';
import '../../providers/locale_provider.dart';

/// A/B side-by-side preview: текущая тема vs preset appearance.
class CustomizationThemeAbPreview extends ConsumerStatefulWidget {
  const CustomizationThemeAbPreview({
    super.key,
    required this.palette,
    this.embedded = false,
  });

  final AppPalette palette;
  final bool embedded;

  @override
  ConsumerState<CustomizationThemeAbPreview> createState() =>
      _CustomizationThemeAbPreviewState();
}

class _CustomizationThemeAbPreviewState
    extends ConsumerState<CustomizationThemeAbPreview> {
  String _comparePresetId = CustomizationPresets.traderId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRu = ref.watch(localeProvider) == AppLocale.ru;
    final config = ref.watch(customizationProvider);
    final systemBrightness = MediaQuery.platformBrightnessOf(context);

    final comparePreset = CustomizationPresets.builtIn.firstWhere(
      (p) => p.id == _comparePresetId,
      orElse: () => CustomizationPresets.trader,
    );
    final appearanceA = config.appearance;
    final appearanceB = comparePreset.config.appearance;

    final paletteA = AppearancePaletteResolver.resolve(
      appearanceA,
      systemBrightness: systemBrightness,
    );
    final paletteB = AppearancePaletteResolver.resolve(
      appearanceB,
      systemBrightness: systemBrightness,
    );

    Future<void> applyB() async {
      await CustomizationSync.commit(
        ref,
        config.copyWith(appearance: appearanceB),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.customizationThemeAbApplied(
                comparePreset.label(isRu: isRu),
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          value: _comparePresetId,
          decoration: InputDecoration(
            labelText: l10n.customizationThemeAbCompareWith,
          ),
          items: CustomizationPresets.builtIn
              .map(
                (p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.label(isRu: isRu)),
                ),
              )
              .toList(),
          onChanged: (id) {
            if (id != null) setState(() => _comparePresetId = id);
          },
        ),
        const Gap(12),
        LayoutBuilder(
          builder: (context, constraints) {
            final sideBySide = constraints.maxWidth >= 340;
            final children = [
              _ThemeSidePanel(
                label: l10n.customizationThemeAbCurrent,
                summary: AppearancePaletteResolver.summaryLabel(
                  appearanceA,
                  isRu: isRu,
                ),
                palette: paletteA,
                appearance: appearanceA,
                l10n: l10n,
              ),
              _ThemeSidePanel(
                label: comparePreset.label(isRu: isRu),
                summary: AppearancePaletteResolver.summaryLabel(
                  appearanceB,
                  isRu: isRu,
                ),
                palette: paletteB,
                appearance: appearanceB,
                l10n: l10n,
              ),
            ];

            if (sideBySide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: children[0]),
                  const Gap(10),
                  Expanded(child: children[1]),
                ],
              );
            }

            return Column(
              children: [
                children[0],
                const Gap(10),
                children[1],
              ],
            );
          },
        ),
        const Gap(12),
        FilledButton.icon(
          onPressed: applyB,
          icon: const Icon(Iconsax.tick_circle, size: 18),
          label: Text(l10n.customizationThemeAbApply),
        ),
      ],
    );

    if (widget.embedded) return content;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.brush_2, color: widget.palette.accent, size: 20),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.customizationThemeAbTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: widget.palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(4),
            Text(
              l10n.customizationThemeAbSubtitle,
              style: TextStyle(
                fontSize: 12,
                color: widget.palette.textSecondary,
              ),
            ),
            const Gap(12),
            content,
          ],
        ),
      ),
    );
  }
}

class _ThemeSidePanel extends StatelessWidget {
  const _ThemeSidePanel({
    required this.label,
    required this.summary,
    required this.palette,
    required this.appearance,
    required this.l10n,
  });

  final String label;
  final String summary;
  final AppPalette palette;
  final AppearanceCustomization appearance;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: palette.accent,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(2),
        Text(
          summary,
          style: TextStyle(fontSize: 10, color: palette.textSecondary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(6),
        _ThemeMiniMock(
          palette: palette,
          cardStyle: appearance.cardStyle,
          l10n: l10n,
        ),
      ],
    );
  }
}

class _ThemeMiniMock extends StatelessWidget {
  const _ThemeMiniMock({
    required this.palette,
    required this.cardStyle,
    required this.l10n,
  });

  final AppPalette palette;
  final CardStyleId cardStyle;
  final AppLocalizations l10n;

  BoxDecoration _cardDecoration() {
    final radius = BorderRadius.circular(
      switch (cardStyle) {
        CardStyleId.flat => 8,
        CardStyleId.glass => 12,
        CardStyleId.bordered => 6,
      },
    );
    final border = switch (cardStyle) {
      CardStyleId.bordered => Border.all(color: palette.border, width: 1.5),
      CardStyleId.glass =>
        Border.all(color: palette.border.withValues(alpha: 0.5)),
      CardStyleId.flat => null,
    };
    return BoxDecoration(
      color: switch (cardStyle) {
        CardStyleId.glass => palette.surface.withValues(alpha: 0.72),
        _ => palette.surface,
      },
      borderRadius: radius,
      border: border,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ColoredBox(
        color: palette.background,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: palette.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      'EcoPulse',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              DecoratedBox(
                decoration: _cardDecoration(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'USD/RUB',
                              style: TextStyle(
                                fontSize: 9,
                                color: palette.textSecondary,
                              ),
                            ),
                            Text(
                              '92.40',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: palette.textPrimary,
                              ),
                            ),
                            Text(
                              '+0.3%',
                              style: TextStyle(
                                fontSize: 9,
                                color: palette.positive,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BTC',
                              style: TextStyle(
                                fontSize: 9,
                                color: palette.textSecondary,
                              ),
                            ),
                            Text(
                              '67 200',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: palette.textPrimary,
                              ),
                            ),
                            Text(
                              '-1.1%',
                              style: TextStyle(
                                fontSize: 9,
                                color: palette.negative,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(6),
              DecoratedBox(
                decoration: _cardDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.customizationPreviewSlideHome,
                        style: TextStyle(
                          fontSize: 9,
                          color: palette.textSecondary,
                        ),
                      ),
                      const Gap(4),
                      Container(
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [
                              palette.chartGradientStart,
                              palette.chartGradientEnd,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          border: Border(
                            bottom: BorderSide(color: palette.accent, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavDot(palette: palette, active: true),
                  _NavDot(palette: palette),
                  _NavDot(palette: palette),
                  _NavDot(palette: palette),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDot extends StatelessWidget {
  const _NavDot({required this.palette, this.active = false});

  final AppPalette palette;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 18 : 14,
      height: 4,
      decoration: BoxDecoration(
        color: active ? palette.accent : palette.border,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
