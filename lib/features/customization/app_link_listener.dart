import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/preset_share_link.dart';
import '../../core/navigation/app_deep_link.dart';
import '../../core/navigation/app_link_navigator.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization_presets_provider.dart';
import '../../providers/customization_provider.dart';
import '../../providers/locale_provider.dart';
import '../../core/customization/customization_preset.dart';
import '../../core/customization/customization_presets.dart';
import '../../core/customization/customization_sync.dart';

/// Слушает App Links: preset, article, thread, calendar.
class AppLinkListener extends ConsumerStatefulWidget {
  const AppLinkListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLinkListener> createState() => _AppLinkListenerState();
}

class _AppLinkListenerState extends ConsumerState<AppLinkListener> {
  StreamSubscription<Uri>? _sub;
  final _appLinks = AppLinks();
  bool _handling = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) return;
    _listenLinks();
  }

  Future<void> _listenLinks() async {
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleUri(initial);
        });
      }
      _sub = _appLinks.uriLinkStream.listen(_handleUri);
    } catch (_) {}
  }

  Future<void> _handleUri(Uri uri) async {
    if (_handling) return;

    if (PresetShareLink.looksLikePresetLink(uri.toString())) {
      _handling = true;
      try {
        await _handlePreset(uri);
      } finally {
        _handling = false;
      }
      return;
    }

    final link = AppDeepLink.parse(uri);
    if (link == null) return;

    AppLinkNavigationIntent.tryNavigateNow(link);
  }

  Future<void> _handlePreset(Uri uri) async {
    final preset = PresetShareLink.decode(uri.toString());
    if (preset == null || !mounted) return;
    await _confirmImport(preset);
  }

  Future<void> _confirmImport(CustomizationPreset preset) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    final isRu = ref.read(localeProvider) == AppLocale.ru;
    final name = preset.label(isRu: isRu);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customizationPresetLinkImportTitle),
        content: Text(l10n.customizationPresetLinkImportBody(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.customizationPresetLinkImportApply),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    try {
      final saved = await ref
          .read(userCustomizationPresetsProvider.notifier)
          .importPreset(preset);
      await CustomizationSync.commit(
        ref,
        CustomizationPresets.withActivePreset(
          ref.read(customizationProvider),
          saved,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.customizationPresetImportSuccess(saved.nameRu)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.customizationPresetImportError),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
