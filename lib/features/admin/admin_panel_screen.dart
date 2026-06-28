// =============================================================================
// EcoPulse · lib/features/admin/admin_panel_screen.dart
// Автор: Цымбал Е. В.
// Дата: 21.06.2026
// Скрытая admin-панель разработчика. Файл: admin_panel_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_palette.dart';
import '../../core/services/error_reporting_service.dart';
import '../../data/services/http_log_store.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/admin_provider.dart';
import '../../providers/app_providers.dart';
import '../../providers/feature_flags_provider.dart';

/// Класс [AdminPanelScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
class AdminPanelScreen extends ConsumerWidget {
/// Создаёт [AdminPanelScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  const AdminPanelScreen({super.key});

/// Отрисовывает UI [AdminPanelScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final snapshot = ref.watch(adminSnapshotProvider);
    final flags = ref.watch(featureFlagsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminPanelTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.adminRefreshAll,
            onPressed: () => _forceRefreshAll(ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.adminPanelSubtitle,
            style: TextStyle(color: palette.textSecondary, height: 1.4),
          ),
          const Gap(20),
          _SectionTitle(title: l10n.adminApiStatus),
          snapshot.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text(e.toString(), style: TextStyle(color: palette.negative)),
            data: (data) => Column(
              children: [
                ...data.pings.map(
                  (p) => _StatusTile(
                    title: p.name,
                    subtitle: p.detail ?? '—',
                    ok: p.ok,
                    trailing: p.latencyMs != null ? '${p.latencyMs} ms' : null,
                  ),
                ),
                const Gap(16),
                _SectionTitle(title: l10n.adminCache),
                ...data.cacheEntries.map(
                  (c) => _CacheTile(entry: c, l10n: l10n, palette: palette),
                ),
                const Gap(16),
                _SectionTitle(title: l10n.adminCatalog),
                _CatalogCard(catalog: data.catalog, l10n: l10n),
              ],
            ),
          ),
          const Gap(16),
          _SectionTitle(title: l10n.adminFeatureFlags),
          SwitchListTile(
            title: Text(l10n.adminFlagSectorHeatmap),
            value: flags[FeatureFlag.sectorHeatmap] ?? true,
            onChanged: (v) =>
                ref.read(featureFlagsProvider.notifier).setFlag(FeatureFlag.sectorHeatmap, v),
          ),
          SwitchListTile(
            title: Text(l10n.adminFlagStocksGrouped),
            value: flags[FeatureFlag.stocksGrouped] ?? true,
            onChanged: (v) =>
                ref.read(featureFlagsProvider.notifier).setFlag(FeatureFlag.stocksGrouped, v),
          ),
          SwitchListTile(
            title: Text(l10n.adminFlagVerboseHttp),
            value: flags[FeatureFlag.verboseHttpLog] ?? false,
            onChanged: (v) =>
                ref.read(featureFlagsProvider.notifier).setFlag(FeatureFlag.verboseHttpLog, v),
          ),
          const Gap(16),
          _SectionTitle(title: l10n.adminHttpLog),
          ...HttpLogStore.instance.entries.map(
            (e) => ListTile(
              dense: true,
              leading: Icon(
                e.isError ? Icons.error_outline : Icons.http,
                color: e.isError ? palette.negative : palette.textSecondary,
                size: 18,
              ),
              title: Text(
                e.message,
                style: TextStyle(
                  fontSize: 12,
                  color: e.isError ? palette.negative : palette.textPrimary,
                ),
              ),
              subtitle: Text(
                DateFormat('HH:mm:ss').format(e.at),
                style: TextStyle(fontSize: 10, color: palette.textSecondary),
              ),
            ),
          ),
          if (HttpLogStore.instance.entries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(l10n.adminHttpLogEmpty, style: TextStyle(color: palette.textSecondary)),
            ),
          const Gap(16),
          _SectionTitle(title: l10n.adminCrashReports),
          ...ErrorReportingService.instance.loadReports().reversed.map(
            (report) => ListTile(
              dense: true,
              leading: Icon(Icons.bug_report_outlined, color: palette.negative, size: 18),
              title: Text(
                report.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: palette.textPrimary),
              ),
              subtitle: Text(
                DateFormat('dd.MM HH:mm:ss').format(report.at),
                style: TextStyle(fontSize: 10, color: palette.textSecondary),
              ),
            ),
          ),
          if (ErrorReportingService.instance.loadReports().isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l10n.alertsHistoryEmpty,
                style: TextStyle(color: palette.textSecondary),
              ),
            ),
          const Gap(24),
          FilledButton.icon(
            onPressed: () {
              ref.invalidate(adminSnapshotProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.adminRefreshed), behavior: SnackBarBehavior.floating),
              );
            },
            icon: const Icon(Icons.sync),
            label: Text(l10n.adminReloadStatus),
          ),
        ],
      ),
    );
  }

/// Приватный метод [_forceRefreshAll] класса [AdminPanelScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
  Future<void> _forceRefreshAll(WidgetRef ref) async {
    await Future.wait([
      ref.read(currencyRatesProvider.notifier).refresh(force: true),
      ref.read(stocksProvider.notifier).refresh(force: true),
      ref.read(bondsProvider.notifier).refresh(force: true),
      ref.read(cryptoProvider.notifier).loadAll(force: true),
    ]);
    ref.invalidate(adminSnapshotProvider);
  }
}

/// Приватный класс [_SectionTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
class _SectionTitle extends StatelessWidget {
/// Создаёт [_SectionTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  const _SectionTitle({required this.title});

/// Поле [title] класса [_SectionTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final String title;

/// Отрисовывает UI [_SectionTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: palette.accent,
        ),
      ),
    );
  }
}

/// Приватный класс [_StatusTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
class _StatusTile extends StatelessWidget {
/// Создаёт [_StatusTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  const _StatusTile({
    required this.title,
    required this.subtitle,
    required this.ok,
    this.trailing,
  });

/// Поле [title] класса [_StatusTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final String title;
/// Поле [subtitle] класса [_StatusTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final String subtitle;
/// Поле [ok] класса [_StatusTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  final bool ok;
/// Поле [trailing] класса [_StatusTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
  final String? trailing;

/// Отрисовывает UI [_StatusTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          ok ? Icons.check_circle : Icons.error,
          color: ok ? palette.positive : palette.negative,
        ),
        title: Text(title),
        subtitle: Text(subtitle, style: TextStyle(color: palette.textSecondary, fontSize: 12)),
        trailing: trailing != null
            ? Text(trailing!, style: TextStyle(color: palette.textSecondary, fontSize: 12))
            : null,
      ),
    );
  }
}

/// Приватный класс [_CacheTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
class _CacheTile extends StatelessWidget {
/// Создаёт [_CacheTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  const _CacheTile({
    required this.entry,
    required this.l10n,
    required this.palette,
  });

/// Поле [entry] класса [_CacheTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  final CacheEntryInfo entry;
/// Поле [l10n] класса [_CacheTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
  final AppLocalizations l10n;
/// Поле [palette] класса [_CacheTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_CacheTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  @override
  Widget build(BuildContext context) {
    final age = entry.age;
    final ageLabel = age == null
        ? l10n.adminCacheEmpty
        : l10n.adminCacheAge(_formatAge(age));

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(entry.key),
        subtitle: Text(ageLabel),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              entry.fresh ? l10n.adminCacheFresh : l10n.adminCacheStale,
              style: TextStyle(
                color: entry.fresh ? palette.positive : palette.negative,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (entry.itemCount != null)
              Text(
                l10n.adminCacheItems(entry.itemCount!),
                style: TextStyle(color: palette.textSecondary, fontSize: 10),
              ),
          ],
        ),
      ),
    );
  }

/// Приватный метод [_formatAge] класса [_CacheTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  String _formatAge(Duration d) {
    if (d.inHours >= 1) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes >= 1) return '${d.inMinutes}m';
    return '${d.inSeconds}s';
  }
}

/// Приватный класс [_CatalogCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
class _CatalogCard extends StatelessWidget {
/// Создаёт [_CatalogCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
  const _CatalogCard({required this.catalog, required this.l10n});

/// Поле [catalog] класса [_CatalogCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final Map<String, int> catalog;
/// Поле [l10n] класса [_CatalogCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final AppLocalizations l10n;

/// Отрисовывает UI [_CatalogCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Chip(label: l10n.adminCatalogMoex, count: catalog['moex'] ?? 0),
            _Chip(label: l10n.adminCatalogUs, count: catalog['us'] ?? 0),
            _Chip(label: l10n.adminCatalogFx, count: catalog['fx'] ?? 0),
            _Chip(label: l10n.adminCatalogCrypto, count: catalog['crypto'] ?? 0),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_Chip].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
class _Chip extends StatelessWidget {
/// Создаёт [_Chip].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
  const _Chip({required this.label, required this.count});

/// Поле [label] класса [_Chip].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final String label;
/// Поле [count] класса [_Chip].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final int count;

/// Отрисовывает UI [_Chip].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.accent.withValues(alpha: 0.25)),
      ),
      child: Text(
        '$label · $count',
        style: TextStyle(
          color: palette.accent,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
