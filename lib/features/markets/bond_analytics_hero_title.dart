// =============================================================================
// EcoPulse · lib/features/markets/bond_analytics_hero_title.dart
// Автор: Цымбал Е. В.
// Дата: 07.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: bond_analytics_hero_title.
// =============================================================================

import 'package:flutter/material.dart';

/// Hero-заголовок для перехода карточка → полноэкранный экран аналитики облигаций.
class BondAnalyticsHeroTitle extends StatelessWidget {
/// Создаёт [BondAnalyticsHeroTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const BondAnalyticsHeroTitle({
    super.key,
    required this.tag,
    required this.text,
    this.style,
    this.maxLines = 1,
  });

/// Поле [tag] класса [BondAnalyticsHeroTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final String tag;
/// Поле [text] класса [BondAnalyticsHeroTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final String text;
/// Поле [style] класса [BondAnalyticsHeroTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final TextStyle? style;
/// Поле [maxLines] класса [BondAnalyticsHeroTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final int maxLines;

/// Отрисовывает UI [BondAnalyticsHeroTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: Text(
          text,
          style: style,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Класс [BondAnalyticsHero].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
abstract final class BondAnalyticsHero {
/// Поле [yieldCurve] класса [BondAnalyticsHero].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  static const yieldCurve = 'bond-analytics-yield-curve';
/// Поле [ladder] класса [BondAnalyticsHero].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  static const ladder = 'bond-analytics-ladder';
/// Поле [calendar] класса [BondAnalyticsHero].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  static const calendar = 'bond-analytics-calendar';
}
