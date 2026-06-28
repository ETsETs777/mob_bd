// =============================================================================
// EcoPulse · lib/core/utils/bond_analytics.dart
// Автор: Цымбал Е. В.
// Дата: 06.05.2026
// Расчёты облигаций: кривая ОФЗ, ladder, календарь купонов.
// =============================================================================

import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';

/// Точка кривой доходности ОФЗ: срок до погашения (лет) × YTM.
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
class BondYieldPoint {
  /// Создаёт точку кривой для [bond] с горизонтом [yearsToMaturity] и YTM [yieldPercent].
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 08.05.2026
  const BondYieldPoint({
    required this.bond,
    required this.yearsToMaturity,
    required this.yieldPercent,
  });

  /// Облигация ОФЗ на кривой.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 09.05.2026
  final MarketAsset bond;

  /// Лет до погашения от даты расчёта.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 10.05.2026
  final double yearsToMaturity;

  /// Доходность к погашению, %.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 06.05.2026
  final double yieldPercent;
}

/// Тип события календаря облигаций: maturity, coupon, couponEstimate.
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
enum BondCalendarEventType { maturity, coupon, couponEstimate }

/// Событие календаря облигаций (купон или погашение).
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
class BondCalendarEvent {
  /// Создаёт событие [type] на [date] для [bond]; [note] — сумма/ставка купона.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 09.05.2026
  const BondCalendarEvent({
    required this.date,
    required this.type,
    required this.bond,
    this.note,
  });

  /// Дата события.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 10.05.2026
  final DateTime date;

  /// Тип: погашение, купон MOEX или оценка купона.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 06.05.2026
  final BondCalendarEventType type;

  /// Облигация-эмитент события.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 07.05.2026
  final MarketAsset bond;

  /// Доп. текст (размер купона в ₽ или %).
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 08.05.2026
  final String? note;
}

/// Строит кривую доходности ОФЗ: фильтр OFZ, YTM × срок, сортировка по maturity.
///
/// [bonds] — каталог облигаций; [asOf] — дата расчёта (по умолчанию сегодня).
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
List<BondYieldPoint> buildOfzYieldCurve(
  List<MarketAsset> bonds, {
  DateTime? asOf,
}) {
  final now = asOf ?? DateTime.now();
  final points = <BondYieldPoint>[];

  for (final bond in bonds) {
    if (bond.bondCategory != BondCategory.ofz) continue;
    final ytm = bond.yieldPercent;
    final mat = bond.maturityDate;
    if (ytm == null || mat == null) continue;

    final days = mat.difference(now).inDays;
    if (days <= 30) continue;

    points.add(
      BondYieldPoint(
        bond: bond,
        yearsToMaturity: days / 365.25,
        yieldPercent: ytm,
      ),
    );
  }

  points.sort((a, b) => a.yearsToMaturity.compareTo(b.yearsToMaturity));
  return points;
}

/// Индекс ближайшей точки кривой по оси X (срок, лет).
int nearestBondYieldPointIndex(List<BondYieldPoint> curve, double touchX) {
  if (curve.isEmpty) return 0;
  var bestIdx = 0;
  var bestDist = double.infinity;
  for (var i = 0; i < curve.length; i++) {
    final d = (curve[i].yearsToMaturity - touchX).abs();
    if (d < bestDist) {
      bestDist = d;
      bestIdx = i;
    }
  }
  return bestIdx;
}

/// Средняя YTM по ликвидным ОФЗ в каталоге.
double? averageOfzYield(List<MarketAsset> bonds) {
  final yields = bonds
      .where((b) => b.bondCategory == BondCategory.ofz && b.yieldPercent != null)
      .map((b) => b.yieldPercent!)
      .toList();
  if (yields.isEmpty) return null;
  return yields.reduce((a, b) => a + b) / yields.length;
}

/// ОФЗ с максимальной YTM.
MarketAsset? highestYieldOfz(List<MarketAsset> bonds) {
  MarketAsset? best;
  for (final b in bonds) {
    if (b.bondCategory != BondCategory.ofz || b.yieldPercent == null) continue;
    if (best == null || b.yieldPercent! > best.yieldPercent!) best = b;
  }
  return best;
}

/// Спред длинного и короткого конца кривой (п.п.).
double? ofzYieldSpread(List<MarketAsset> bonds, {DateTime? asOf}) {
  final curve = buildOfzYieldCurve(bonds, asOf: asOf);
  if (curve.length < 2) return null;
  return curve.last.yieldPercent - curve.first.yieldPercent;
}

/// Добавляет купонное событие в [events], если [date] в окне (now, end].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
void _addCouponEvents({
  required List<BondCalendarEvent> events,
  required MarketAsset bond,
  required DateTime date,
  required DateTime now,
  required DateTime end,
  required BondCalendarEventType type,
}) {
  if (!date.isAfter(now) || !date.isBefore(end)) return;
  final note = bond.couponValueRub != null
      ? bond.couponValueRub!.toStringAsFixed(2)
      : (bond.couponPercent != null
          ? bond.couponPercent!.toStringAsFixed(1)
          : null);
  events.add(
    BondCalendarEvent(
      date: date,
      type: type,
      bond: bond,
      note: note,
    ),
  );
}

/// Группировка ОФЗ по году погашения для «лестницы».
Map<int, List<MarketAsset>> buildBondLadderByYear(List<MarketAsset> bonds) {
  final ladder = <int, List<MarketAsset>>{};
  for (final bond in bonds) {
    if (bond.bondCategory != BondCategory.ofz || bond.maturityDate == null) {
      continue;
    }
    final year = bond.maturityDate!.year;
    ladder.putIfAbsent(year, () => []).add(bond);
  }
  for (final list in ladder.values) {
    list.sort(
      (a, b) => a.maturityDate!.compareTo(b.maturityDate!),
    );
  }
  return Map.fromEntries(
    ladder.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

/// Ближайшие погашения и оценка купонных дат (полугодовые от сегодня).
List<BondCalendarEvent> buildBondCalendarEvents(
  List<MarketAsset> bonds, {
  DateTime? asOf,
  int horizonDays = 365,
}) {
  final now = asOf ?? DateTime.now();
  final end = now.add(Duration(days: horizonDays));
  final events = <BondCalendarEvent>[];

  for (final bond in bonds) {
    if (bond.type != AssetType.bondRu) continue;

    final mat = bond.maturityDate;
    if (mat != null && mat.isAfter(now) && mat.isBefore(end)) {
      events.add(
        BondCalendarEvent(
          date: mat,
          type: BondCalendarEventType.maturity,
          bond: bond,
        ),
      );
    }

    final coupon = bond.couponPercent;
    final nextCoupon = bond.nextCouponDate;
    final periodDays = bond.couponPeriodDays;
    if (nextCoupon != null) {
      var couponDate = nextCoupon;
      final period = periodDays ?? 182;
      while (couponDate.isBefore(end)) {
        if (couponDate.isAfter(now)) {
          _addCouponEvents(
            events: events,
            bond: bond,
            date: couponDate,
            now: now,
            end: end,
            type: BondCalendarEventType.coupon,
          );
        }
        couponDate = couponDate.add(Duration(days: period));
        if (mat != null && !couponDate.isBefore(mat)) break;
      }
    } else if (coupon != null && coupon > 0) {
      for (var i = 1; i <= 2; i++) {
        final est = now.add(Duration(days: (182.5 * i).round()));
        if (est.isBefore(end)) {
          events.add(
            BondCalendarEvent(
              date: est,
              type: BondCalendarEventType.couponEstimate,
              bond: bond,
              note: coupon.toStringAsFixed(1),
            ),
          );
        }
      }
    }
  }

  events.sort((a, b) => a.date.compareTo(b.date));
  return events;
}

/// Оценка суммы купонных выплат по портфелю за горизонт календаря.
double portfolioCouponIncomeEstimate(
  List<BondCalendarEvent> events,
  PaperPortfolio portfolio,
) {
  final byKey = {for (final p in portfolio.positions) p.assetKey: p};
  var total = 0.0;
  for (final event in events) {
    if (event.type == BondCalendarEventType.maturity) continue;
    final key = '${event.bond.type.name}:${event.bond.id}';
    final pos = byKey[key];
    if (pos == null || event.bond.couponValueRub == null) continue;
    total += event.bond.couponValueRub! * pos.quantity;
  }
  return total;
}

/// Количество событий календаря в горизонте (купоны + погашения).
int upcomingBondEventsCount(
  List<MarketAsset> tracked, {
  DateTime? asOf,
  int horizonDays = 30,
}) {
  return buildBondCalendarEvents(
    tracked,
    asOf: asOf,
    horizonDays: horizonDays,
  ).length;
}
