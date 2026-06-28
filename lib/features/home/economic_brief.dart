// =============================================================================
// EcoPulse · lib/features/home/economic_brief.dart
// Автор: Цымбал Е. В.
// Дата: 04.06.2026
// Главный экран и виджеты секций. Файл: economic_brief.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../shared/widgets/app_card.dart';
import '../../data/models/commodity_quote.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/key_rate_point.dart';
import '../../data/models/market_asset.dart';

/// Класс [BriefLine].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class BriefLine {
/// Создаёт [BriefLine].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  const BriefLine({
    required this.label,
    required this.text,
    this.isPositive,
  });

/// Поле [label] класса [BriefLine].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final String label;
/// Поле [text] класса [BriefLine].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final String text;
/// Поле [isPositive] класса [BriefLine].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final bool? isPositive;
}

/// Функция [buildEconomicBrief] — построение данных или UI.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
List<BriefLine> buildEconomicBrief({
  List<CurrencyRate>? rates,
  KeyRateSnapshot? keyRate,
  List<MarketAsset>? crypto,
  List<MarketAsset>? stocks,
  List<CommodityQuote>? commodities,
  FearGreedIndex? fearGreed,
}) {
  final lines = <BriefLine>[];

  if (rates != null) {
    final rub = rates.where((CurrencyRate r) => r.isRub).firstOrNull;
    if (rub != null) {
      lines.add(BriefLine(
        label: 'USD/RUB',
        text: '${Formatters.rub(rub.rate)} · ${Formatters.percent(rub.changePercent)}',
        isPositive: rub.changePercent != null ? rub.changePercent! >= 0 : null,
      ));
    }
    final eurRub =
        rates.where((CurrencyRate r) => r.base == 'RUB' && r.code == 'EUR').firstOrNull;
    if (eurRub != null) {
      lines.add(BriefLine(
        label: 'EUR/RUB',
        text: '${Formatters.rub(eurRub.rate)} · ${Formatters.percent(eurRub.changePercent)}',
        isPositive:
            eurRub.changePercent != null ? eurRub.changePercent! >= 0 : null,
      ));
    }
  }

  if (keyRate != null) {
    lines.add(BriefLine(
      label: 'Ставка ЦБ',
      text: '${keyRate.current.toStringAsFixed(2)}%',
      isPositive: keyRate.changePercent != null
          ? keyRate.changePercent! >= 0
          : null,
    ));
  }

  if (crypto != null) {
    final btc = crypto.where((a) => a.symbol == 'BTC').firstOrNull;
    if (btc != null) {
      lines.add(BriefLine(
        label: 'Bitcoin',
        text: '${Formatters.price(btc.price)} · ${Formatters.percent(btc.changePercent)}',
        isPositive: btc.changePercent >= 0,
      ));
    }
  }

  if (stocks != null) {
    final imoex = stocks.where((a) => a.symbol == 'IMOEX').firstOrNull;
    if (imoex != null) {
      lines.add(BriefLine(
        label: 'IMOEX',
        text: '${Formatters.rub(imoex.price)} · ${Formatters.percent(imoex.changePercent)}',
        isPositive: imoex.changePercent >= 0,
      ));
    }
  }

  if (commodities != null) {
    for (final c in commodities) {
      lines.add(BriefLine(
        label: c.name,
        text: '${Formatters.rub(c.price)} · ${Formatters.percent(c.changePercent)}',
        isPositive:
            c.changePercent != null ? c.changePercent! >= 0 : null,
      ));
    }
  }

  if (fearGreed != null) {
    lines.add(BriefLine(
      label: 'F&G',
      text: '${fearGreed.value} · ${fearGreed.label}',
      isPositive: fearGreed.value >= 50 ? true : fearGreed.value <= 25 ? false : null,
    ));
  }

  return lines;
}

/// StatelessWidget [EconomicBriefCard] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class EconomicBriefCard extends StatelessWidget {
/// Создаёт [EconomicBriefCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  const EconomicBriefCard({super.key, required this.lines});

/// Поле [lines] класса [EconomicBriefCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final List<BriefLine> lines;

/// Отрисовывает UI [EconomicBriefCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) return const SizedBox.shrink();

    final palette = AppPalette.of(context);

    return AppCard(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.flash_1, size: 18, color: palette.accent),
                const Gap(8),
                Text(
                  'Сегодня',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
              ],
            ),
            const Gap(12),
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 72,
                      child: Text(
                        line.label,
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        line.text,
                        style: TextStyle(
                          color: _lineColor(palette, line),
                          fontSize: 13,
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
    )
        .animate()
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.04, end: 0, curve: Curves.easeOut);
  }

/// Приватный метод [_lineColor] класса [EconomicBriefCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  Color _lineColor(AppPalette palette, BriefLine line) {
    if (line.isPositive == null) return palette.textPrimary;
    return line.isPositive! ? palette.positive : palette.negative;
  }
}

/// Extension [_FirstOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
