import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/home_widget_context_strip.dart';
import '../../core/utils/home_widget_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization/home_widget_preview_provider.dart';
import '../../providers/widget_config_provider.dart';

/// Mock-превью Android home widget (4×1 compact / 2×2 expanded).
class CustomizationWidgetPreview extends ConsumerStatefulWidget {
  const CustomizationWidgetPreview({
    super.key,
    required this.palette,
    this.embedded = false,
  });

  final AppPalette palette;
  final bool embedded;

  @override
  ConsumerState<CustomizationWidgetPreview> createState() =>
      _CustomizationWidgetPreviewState();
}

class _CustomizationWidgetPreviewState
    extends ConsumerState<CustomizationWidgetPreview> {
  bool _showExpanded = true;

  static const _widgetBg = Color(0xFF161B22);
  static const _cellBg = Color(0xFF21262D);
  static const _labelColor = Color(0xFF8B949E);
  static const _valueColor = Color(0xFFF0F6FC);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final payload = ref.watch(homeWidgetPreviewProvider);
    final configLayout = payload.layout;

    final effectiveExpanded = switch (configLayout) {
      WidgetLayout.compact => false,
      WidgetLayout.expanded => true,
      WidgetLayout.auto => _showExpanded,
    };

    final previewBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (configLayout == WidgetLayout.auto) ...[
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                label: Text(l10n.settingsWidgetLayoutCompact),
              ),
              ButtonSegment(
                value: true,
                label: Text(l10n.settingsWidgetLayoutExpanded),
              ),
            ],
            selected: {_showExpanded},
            onSelectionChanged: (s) => setState(() => _showExpanded = s.first),
          ),
          const Gap(8),
          Text(
            l10n.customizationWidgetPreviewAutoHint,
            style: TextStyle(fontSize: 11, color: widget.palette.textSecondary),
          ),
          const Gap(8),
        ],
        _AndroidWidgetMock(
          payload: payload,
          expanded: effectiveExpanded,
          accent: widget.palette.accent,
        ),
      ],
    );

    if (widget.embedded) {
      return previewBody;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.mobile, color: widget.palette.accent, size: 20),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.customizationWidgetPreviewTitle,
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
              l10n.customizationWidgetPreviewSubtitle,
              style: TextStyle(
                fontSize: 12,
                color: widget.palette.textSecondary,
              ),
            ),
            const Gap(12),
            previewBody,
          ],
        ),
      ),
    );
  }
}

class _AndroidWidgetMock extends StatelessWidget {
  const _AndroidWidgetMock({
    required this.payload,
    required this.expanded,
    required this.accent,
  });

  final HomeWidgetPayload payload;
  final bool expanded;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final updated = Formatters.formatDateTime(
      payload.updatedAt,
      includeDate: false,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _CustomizationWidgetPreviewState._widgetBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: expanded
            ? _ExpandedLayout(
                slots: payload.slots,
                accent: accent,
                updated: updated,
                contextStrip: payload.contextStrip,
              )
            : _CompactLayout(
                slots: payload.slots,
                accent: accent,
                updated: updated,
                contextStrip: payload.contextStrip,
              ),
      ),
    );
  }
}

class _CompactLayout extends StatelessWidget {
  const _CompactLayout({
    required this.slots,
    required this.accent,
    required this.updated,
    this.contextStrip,
  });

  final List<HomeWidgetSlotData> slots;
  final Color accent;
  final String updated;
  final HomeWidgetContextStrip? contextStrip;

  @override
  Widget build(BuildContext context) {
    final s1 = slots.elementAtOrNull(0);
    final s2 = slots.elementAtOrNull(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EcoPulse',
          style: TextStyle(
            color: accent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        Row(
          children: [
            Expanded(child: _SlotColumn(slot: s1, valueSize: 18)),
            Expanded(child: _SlotColumn(slot: s2, valueSize: 18)),
          ],
        ),
        if (updated.isNotEmpty) ...[
          const Gap(6),
          Text(
            '↻ $updated',
            style: const TextStyle(
              color: _CustomizationWidgetPreviewState._labelColor,
              fontSize: 10,
            ),
          ),
        ],
        if (contextStrip != null) ...[
          const Gap(8),
          _ContextStripRow(strip: contextStrip!),
        ],
      ],
    );
  }
}

class _ExpandedLayout extends StatelessWidget {
  const _ExpandedLayout({
    required this.slots,
    required this.accent,
    required this.updated,
    this.contextStrip,
  });

  final List<HomeWidgetSlotData> slots;
  final Color accent;
  final String updated;
  final HomeWidgetContextStrip? contextStrip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'EcoPulse',
                style: TextStyle(
                  color: accent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (updated.isNotEmpty)
              Text(
                '↻ $updated',
                style: const TextStyle(
                  color: _CustomizationWidgetPreviewState._labelColor,
                  fontSize: 10,
                ),
              ),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            Expanded(
              child: _SlotCell(slot: slots.elementAtOrNull(0)),
            ),
            const Gap(8),
            Expanded(
              child: _SlotCell(slot: slots.elementAtOrNull(1)),
            ),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            Expanded(
              child: _SlotCell(slot: slots.elementAtOrNull(2)),
            ),
            const Gap(8),
            Expanded(
              child: _SlotCell(slot: slots.elementAtOrNull(3)),
            ),
          ],
        ),
        if (contextStrip != null) ...[
          const Gap(8),
          _ContextStripRow(strip: contextStrip!),
        ],
      ],
    );
  }
}

class _ContextStripRow extends StatelessWidget {
  const _ContextStripRow({required this.strip});

  final HomeWidgetContextStrip strip;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _CustomizationWidgetPreviewState._cellBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strip.portfolioLabel,
                    style: const TextStyle(
                      color: _CustomizationWidgetPreviewState._labelColor,
                      fontSize: 9,
                    ),
                  ),
                  Text(
                    strip.portfolioValue,
                    style: const TextStyle(
                      color: _CustomizationWidgetPreviewState._valueColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (strip.portfolioChange.isNotEmpty)
                    Text(
                      strip.portfolioChange,
                      style: TextStyle(
                        color: _changeColor(strip.portfolioChange),
                        fontSize: 9,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    strip.calendarLabel,
                    style: const TextStyle(
                      color: _CustomizationWidgetPreviewState._labelColor,
                      fontSize: 9,
                    ),
                  ),
                  Text(
                    strip.calendarTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: _CustomizationWidgetPreviewState._valueColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (strip.calendarDate.isNotEmpty)
                    Text(
                      strip.calendarDate,
                      style: const TextStyle(
                        color: _CustomizationWidgetPreviewState._labelColor,
                        fontSize: 9,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotCell extends StatelessWidget {
  const _SlotCell({required this.slot});

  final HomeWidgetSlotData? slot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _CustomizationWidgetPreviewState._cellBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: _SlotColumn(slot: slot, valueSize: 16),
      ),
    );
  }
}

class _SlotColumn extends StatelessWidget {
  const _SlotColumn({required this.slot, required this.valueSize});

  final HomeWidgetSlotData? slot;
  final double valueSize;

  @override
  Widget build(BuildContext context) {
    final data = slot;
    if (data == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.label,
          style: TextStyle(
            color: _CustomizationWidgetPreviewState._labelColor,
            fontSize: valueSize <= 16 ? 10 : 11,
          ),
        ),
        Text(
          data.value,
          style: TextStyle(
            color: _CustomizationWidgetPreviewState._valueColor,
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (data.change.isNotEmpty)
          Text(
            data.change,
            style: TextStyle(
              color: _changeColor(data.change),
              fontSize: valueSize <= 16 ? 10 : 11,
            ),
          ),
      ],
    );
  }
}

Color _changeColor(String change) {
  if (change.startsWith('-')) return const Color(0xFFF85149);
  if (change.startsWith('+') || change.contains('%')) {
    return const Color(0xFF3FB950);
  }
  return _CustomizationWidgetPreviewState._labelColor;
}

extension _ElementAtOrNull<E> on List<E> {
  E? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
