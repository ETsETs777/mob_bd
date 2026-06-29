import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/motion/app_motion.dart';
import '../../../core/theme/app_accent.dart';
import '../../../core/theme/app_backgrounds.dart';
import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/theme_provider.dart';
import '../../admin/admin_panel_screen.dart';

String settingsThemeModeLabel(AppThemeMode mode, AppLocalizations l10n) => switch (mode) {
      AppThemeMode.dark => l10n.settingsThemeDark,
      AppThemeMode.light => l10n.settingsThemeLight,
      AppThemeMode.system => l10n.settingsThemeAuto,
      AppThemeMode.oled => l10n.settingsThemeOled,
      AppThemeMode.dim => l10n.settingsThemeDim,
      AppThemeMode.sepia => l10n.settingsThemeSepia,
      AppThemeMode.contrast => l10n.settingsThemeContrast,
    };

IconData settingsThemeModeIcon(AppThemeMode mode) => switch (mode) {
      AppThemeMode.dark => Iconsax.moon,
      AppThemeMode.light => Iconsax.sun_1,
      AppThemeMode.system => Iconsax.mobile,
      AppThemeMode.oled => Iconsax.monitor,
      AppThemeMode.dim => Iconsax.moon,
      AppThemeMode.sepia => Iconsax.book,
      AppThemeMode.contrast => Iconsax.eye,
    };
/// РџСЂРёРІР°С‚РЅС‹Р№ РєР»Р°СЃСЃ [_AboutCard] вЂ” РєР°СЂС‚РѕС‡РєР° СЃРµРєС†РёРё.
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 23.06.2026
class SettingsAboutCard extends StatefulWidget {
/// РЎРѕР·РґР°С‘С‚ [_AboutCard].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 19.06.2026
  const SettingsAboutCard({required this.palette, required this.l10n});

/// РџРѕР»Рµ [palette] РєР»Р°СЃСЃР° [_AboutCard].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 20.06.2026
  final AppPalette palette;
/// РџРѕР»Рµ [l10n] РєР»Р°СЃСЃР° [_AboutCard].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 21.06.2026
  final AppLocalizations l10n;

/// РЎРѕР·РґР°С‘С‚ State РґР»СЏ [_AboutCard].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 22.06.2026
  @override
  State<SettingsAboutCard> createState() => SettingsAboutCardState();
}

/// РџСЂРёРІР°С‚РЅС‹Р№ РєР»Р°СЃСЃ [_AboutCardState] вЂ” РєР°СЂС‚РѕС‡РєР° СЃРµРєС†РёРё.
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 23.06.2026
class SettingsAboutCardState extends State<SettingsAboutCard> {
/// РџРѕР»Рµ [_versionTaps] РєР»Р°СЃСЃР° [_AboutCardState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 19.06.2026
  int _versionTaps = 0;
/// РџРѕР»Рµ [_revealed] РєР»Р°СЃСЃР° [_AboutCardState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 20.06.2026
  bool _revealed = false;

/// РџСЂРёРІР°С‚РЅС‹Р№ РјРµС‚РѕРґ [_onVersionTap] РєР»Р°СЃСЃР° [_AboutCardState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 21.06.2026
  void _onVersionTap() {
    _versionTaps++;
    if (_versionTaps >= 5 && !_revealed) {
      setState(() => _revealed = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Localizations.localeOf(context).languageCode == 'ru'
                ? 'EcoPulse В· Р¦С‹РјР±Р°Р» Р•. Р’.'
                : 'EcoPulse В· Tsymbal E. V.',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
    if (_versionTaps >= 10 && mounted) {
      openAppPage<void>(context, const AdminPanelScreen());
      _versionTaps = 0;
    }
  }

/// РћС‚СЂРёСЃРѕРІС‹РІР°РµС‚ UI [_AboutCardState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 22.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _onVersionTap,
              child: Text(
                'EcoPulse v1.0.45',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: palette.textPrimary,
                ),
              ),
            ),
            if (_revealed) ...[
              const Gap(6),
              Text(
                'Р¦С‹РјР±Р°Р» Р•. Р’.',
                style: TextStyle(
                  color: palette.accent.withValues(alpha: 0.7),
                  fontSize: 12,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const Gap(8),
            Text(
              widget.l10n.settingsAboutDescription,
              style: TextStyle(color: palette.textSecondary, height: 1.4),
            ),
            const Gap(12),
            Text(
              widget.l10n.settingsAboutDesign,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(8),
            Text(
              widget.l10n.settingsAboutDeveloper,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }
}

/// РџСЂРёРІР°С‚РЅС‹Р№ РєР»Р°СЃСЃ [_ApiKeyField].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 23.06.2026
class SettingsApiKeyField extends StatefulWidget {
/// РЎРѕР·РґР°С‘С‚ [_ApiKeyField].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 19.06.2026
  const SettingsApiKeyField({
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.onSave,
  });

/// РџРѕР»Рµ [label] РєР»Р°СЃСЃР° [_ApiKeyField].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 20.06.2026
  final String label;
/// РџРѕР»Рµ [hint] РєР»Р°СЃСЃР° [_ApiKeyField].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 21.06.2026
  final String hint;
/// РџРѕР»Рµ [initialValue] РєР»Р°СЃСЃР° [_ApiKeyField].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 22.06.2026
  final String initialValue;
/// РџРѕР»Рµ [onSave] РєР»Р°СЃСЃР° [_ApiKeyField].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 23.06.2026
  final Future<void> Function(String) onSave;

/// РЎРѕР·РґР°С‘С‚ State РґР»СЏ [_ApiKeyField].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 19.06.2026
  @override
  State<SettingsApiKeyField> createState() => SettingsApiKeyFieldState();
}

/// РџСЂРёРІР°С‚РЅС‹Р№ РєР»Р°СЃСЃ [_ApiKeyFieldState] вЂ” СЌРєСЂР°РЅ/state.
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 20.06.2026
class SettingsApiKeyFieldState extends State<SettingsApiKeyField> {
/// РџРѕР»Рµ [_controller] РєР»Р°СЃСЃР° [_ApiKeyFieldState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 21.06.2026
  late final TextEditingController _controller;
/// РџРѕР»Рµ [_obscure] РєР»Р°СЃСЃР° [_ApiKeyFieldState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 22.06.2026
  bool _obscure = true;

/// РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ state [_ApiKeyFieldState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 23.06.2026
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

/// РњРµС‚РѕРґ [didUpdateWidget] РєР»Р°СЃСЃР° [_ApiKeyFieldState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 19.06.2026
  @override
  void didUpdateWidget(covariant SettingsApiKeyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

/// РћСЃРІРѕР±РѕР¶РґР°РµС‚ СЂРµСЃСѓСЂСЃС‹ [_ApiKeyFieldState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 20.06.2026
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

/// РћС‚СЂРёСЃРѕРІС‹РІР°РµС‚ UI [_ApiKeyFieldState].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 21.06.2026
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
        ),
        const Gap(8),
        FilledButton.tonal(
          onPressed: () async {
            await widget.onSave(_controller.text.trim());
            if (context.mounted) {
              final l10n = AppLocalizations.of(context)!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.settingsApiKeySaved(widget.label)),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

/// РџСЂРёРІР°С‚РЅС‹Р№ РєР»Р°СЃСЃ [_SettingsBackgroundTile] вЂ” РїР»РёС‚РєР° СЃРїРёСЃРєР°.
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 22.06.2026
class SettingsBackgroundTile extends StatelessWidget {
/// РЎРѕР·РґР°С‘С‚ [_SettingsBackgroundTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 23.06.2026
  const SettingsBackgroundTile({
    required this.preset,
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final AppBackgroundPreset preset;
  final String label;
  final bool selected;
/// РџРѕР»Рµ [palette] РєР»Р°СЃСЃР° [_SettingsBackgroundTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 21.06.2026
  final AppPalette palette;
/// РџРѕР»Рµ [onTap] РєР»Р°СЃСЃР° [_SettingsBackgroundTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 22.06.2026
  final VoidCallback onTap;

/// РћС‚СЂРёСЃРѕРІС‹РІР°РµС‚ UI [_SettingsBackgroundTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 23.06.2026
  @override
  Widget build(BuildContext context) {
    final colors = preset.gradientColors;

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
                      child: Icon(Icons.check, color: colors.first.computeLuminance() > 0.5 ? Colors.black87 : Colors.white, size: 20),
                    )
                  : null,
            ),
            const Gap(4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

/// РџСЂРёРІР°С‚РЅС‹Р№ РєР»Р°СЃСЃ [_SectionTitle].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 19.06.2026
class SettingsSectionTitle extends StatelessWidget {
/// РЎРѕР·РґР°С‘С‚ [_SectionTitle].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 20.06.2026
  const SettingsSectionTitle({required this.title, required this.palette});

/// РџРѕР»Рµ [title] РєР»Р°СЃСЃР° [_SectionTitle].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 21.06.2026
  final String title;
/// РџРѕР»Рµ [palette] РєР»Р°СЃСЃР° [_SectionTitle].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 22.06.2026
  final AppPalette palette;

/// РћС‚СЂРёСЃРѕРІС‹РІР°РµС‚ UI [_SectionTitle].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 23.06.2026
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: palette.textSecondary,
      ),
    );
  }
}

/// РџСЂРёРІР°С‚РЅС‹Р№ РєР»Р°СЃСЃ [_SettingsTile] вЂ” РїР»РёС‚РєР° СЃРїРёСЃРєР°.
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 19.06.2026
class SettingsTile extends StatelessWidget {
/// РЎРѕР·РґР°С‘С‚ [_SettingsTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 20.06.2026
  const SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    this.onTap,
  });

/// РџРѕР»Рµ [icon] РєР»Р°СЃСЃР° [_SettingsTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 21.06.2026
  final IconData icon;
/// РџРѕР»Рµ [title] РєР»Р°СЃСЃР° [_SettingsTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 22.06.2026
  final String title;
/// РџРѕР»Рµ [subtitle] РєР»Р°СЃСЃР° [_SettingsTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 23.06.2026
  final String subtitle;
/// РџРѕР»Рµ [status] РєР»Р°СЃСЃР° [_SettingsTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 19.06.2026
  final String status;
/// РџРѕР»Рµ [statusColor] РєР»Р°СЃСЃР° [_SettingsTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 20.06.2026
  final Color statusColor;
/// РџРѕР»Рµ [onTap] РєР»Р°СЃСЃР° [_SettingsTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 21.06.2026
  final VoidCallback? onTap;

/// РћС‚СЂРёСЃРѕРІС‹РІР°РµС‚ UI [_SettingsTile].
///
/// РђРІС‚РѕСЂ: Р¦С‹РјР±Р°Р» Р•. Р’.
/// Р”Р°С‚Р°: 22.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: palette.accent),
        title: Text(title, style: TextStyle(color: palette.textPrimary)),
        subtitle: Text(subtitle, style: TextStyle(color: palette.textSecondary)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
