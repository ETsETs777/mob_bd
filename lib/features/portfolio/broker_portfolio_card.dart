import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/constants/api_keys_store.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/broker_account.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/api_keys_provider.dart';
import '../../providers/broker_provider.dart';
import '../settings/settings_section_screen.dart';

class BrokerPortfolioCard extends ConsumerStatefulWidget {
  const BrokerPortfolioCard({super.key});

  @override
  ConsumerState<BrokerPortfolioCard> createState() =>
      _BrokerPortfolioCardState();
}

class _BrokerPortfolioCardState extends ConsumerState<BrokerPortfolioCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeRefresh());
  }

  void _maybeRefresh() {
    if (!ApiKeysStore.instance.hasTinkoffBrokerToken) return;
    final broker = ref.read(brokerPortfolioProvider);
    if (broker.snapshot == null && !broker.loading) {
      ref.read(brokerPortfolioProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final apiKeys = ref.watch(apiKeysProvider);
    final broker = ref.watch(brokerPortfolioProvider);

    if (!apiKeys.hasTinkoffBroker) {
      return Card(
        child: ListTile(
          leading: Icon(Iconsax.bank, color: palette.accent),
          title: Text(
            l10n.brokerConnectTitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(l10n.brokerConnectSubtitle),
          trailing: const Icon(Iconsax.arrow_right_3, size: 18),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const SettingsSectionScreen(
                section: SettingsHubSection.apiData,
              ),
            ),
          ),
        ),
      );
    }

    final snapshot = broker.snapshot;
    final dateFmt = DateFormat.yMMMd().add_Hm();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.bank, color: palette.accent, size: 22),
                const Gap(10),
                Expanded(
                  child: Text(
                    l10n.brokerReadOnlyTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.brokerRefresh,
                  onPressed: broker.loading
                      ? null
                      : () => ref.read(brokerPortfolioProvider.notifier).refresh(),
                  icon: broker.loading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: palette.accent,
                          ),
                        )
                      : Icon(Iconsax.refresh, color: palette.accent, size: 20),
                ),
              ],
            ),
            Text(
              l10n.brokerReadOnlyDisclaimer,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
            if (broker.accounts.length > 1) ...[
              const Gap(12),
              DropdownButtonFormField<String>(
                value: broker.selectedAccountId.isEmpty
                    ? null
                    : broker.selectedAccountId,
                decoration: InputDecoration(
                  labelText: l10n.brokerAccountLabel,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: broker.accounts
                    .map(
                      (BrokerAccount a) => DropdownMenuItem(
                        value: a.id,
                        child: Text(a.name.isEmpty ? a.id : a.name),
                      ),
                    )
                    .toList(),
                onChanged: broker.loading
                    ? null
                    : (id) {
                        if (id != null) {
                          ref.read(brokerPortfolioProvider.notifier).selectAccount(id);
                        }
                      },
              ),
            ],
            if (broker.error.isNotEmpty) ...[
              const Gap(8),
              Text(broker.error, style: TextStyle(color: palette.negative)),
            ],
            if (snapshot != null) ...[
              const Gap(12),
              Text(
                l10n.brokerTotalValue(Formatters.rub(snapshot.totalAmountRub)),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              Text(
                l10n.brokerSyncedAt(dateFmt.format(snapshot.syncedAt.toLocal())),
                style: TextStyle(fontSize: 12, color: palette.textSecondary),
              ),
              const Gap(8),
              if (snapshot.positions.isEmpty)
                Text(l10n.brokerEmptyPositions, style: TextStyle(color: palette.textSecondary))
              else
                ...snapshot.positions.take(8).map(
                      (p) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.ticker,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${p.quantity.toStringAsFixed(p.quantity >= 1 ? 0 : 4)} · ${p.instrumentType}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: palette.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              Formatters.rub(p.marketValue),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
              if (snapshot.positions.length > 8)
                Text(
                  l10n.brokerMorePositions(snapshot.positions.length - 8),
                  style: TextStyle(fontSize: 12, color: palette.textSecondary),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
