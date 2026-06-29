// =============================================================================
// EcoPulse · lib/features/shared/widgets/last_updated_banner.dart
// Автор: Цымбал Е. В.
// Дата: 02.06.2026
// Общие виджеты и действия приложения. Файл: last_updated_banner.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/utils/cache_status.dart';
import '../../../data/services/cache_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/data_display_customization_provider.dart';
import '../app_actions.dart';

/// Класс [LastUpdatedBanner].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
class LastUpdatedBanner extends ConsumerWidget {
/// Создаёт [LastUpdatedBanner].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  const LastUpdatedBanner({
    super.key,
    required this.scope,
    this.hasLoadError = false,
  });

/// Поле [scope] класса [LastUpdatedBanner].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final RefreshScope scope;
/// Поле [hasLoadError] класса [LastUpdatedBanner].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final bool hasLoadError;

/// Отрисовывает UI [LastUpdatedBanner].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final refreshTime = ref.watch(refreshTimeProvider(scope));

    final status = resolveDataStatus(
      scope,
      cache: CacheService.instance,
      hasLoadError: hasLoadError,
    );

    final formatters = ref.watch(displayFormattersProvider);

    final displayTime = refreshTime ?? status.cachedAt;
    if (displayTime == null && status.kind == DataStatusKind.fresh) {
      return const SizedBox.shrink();
    }

    final Color accentColor;
    final IconData icon;
    final String message;

    switch (status.kind) {
      case DataStatusKind.fresh:
        accentColor = palette.positive;
        icon = Iconsax.tick_circle;
        message = displayTime != null
            ? l10n.dataStatusFresh(
                formatters.formatDateTime(displayTime),
              )
            : l10n.dataStatusLive;
      case DataStatusKind.cache:
        accentColor = const Color(0xFFF0883E);
        icon = Iconsax.clock;
        final age = status.age;
        message = age != null
            ? l10n.dataStatusCache(formatDataAge(age, languageCode: lang))
            : l10n.dataStatusCacheUnknown;
      case DataStatusKind.offline:
        accentColor = palette.negative;
        icon = Iconsax.wifi_square;
        final age = status.age;
        message = age != null
            ? l10n.dataStatusOffline(formatDataAge(age, languageCode: lang))
            : l10n.dataStatusOfflineUnknown;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: accentColor.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: accentColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
