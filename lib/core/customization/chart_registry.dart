import '../../data/models/chart_render_input.dart';
import '../../data/models/user_customization.dart';

/// Форма данных, необходимая для типа графика.
enum ChartDataShape {
  priceSeries,
  candleSeries,
  multiSeries,
  labeledValues,
  pieValues,
  custom,
}

/// Метаданные типа графика в реестре (пункт 3).
class ChartTypeDescriptor {
  const ChartTypeDescriptor({
    required this.id,
    required this.labelRu,
    required this.labelEn,
    required this.dataShape,
    required this.supportedContexts,
    this.fallback = ChartTypeId.line,
  });

  final ChartTypeId id;
  final String labelRu;
  final String labelEn;
  final ChartDataShape dataShape;
  final Set<ChartContextId> supportedContexts;
  final ChartTypeId fallback;

  String label({required bool isRu}) => isRu ? labelRu : labelEn;
}

/// Реестр типов графиков EcoPulse.
class ChartRegistry {
  ChartRegistry._();

  static const _descriptors = <ChartTypeId, ChartTypeDescriptor>{
    ChartTypeId.line: ChartTypeDescriptor(
      id: ChartTypeId.line,
      labelRu: 'Линия',
      labelEn: 'Line',
      dataShape: ChartDataShape.priceSeries,
      supportedContexts: {
        ChartContextId.assetDetail,
        ChartContextId.currency,
        ChartContextId.keyRate,
        ChartContextId.homeSparkline,
      },
    ),
    ChartTypeId.area: ChartTypeDescriptor(
      id: ChartTypeId.area,
      labelRu: 'Область',
      labelEn: 'Area',
      dataShape: ChartDataShape.priceSeries,
      supportedContexts: {
        ChartContextId.assetDetail,
        ChartContextId.currency,
        ChartContextId.keyRate,
        ChartContextId.homeSparkline,
      },
    ),
    ChartTypeId.bar: ChartTypeDescriptor(
      id: ChartTypeId.bar,
      labelRu: 'Столбцы',
      labelEn: 'Bar',
      dataShape: ChartDataShape.labeledValues,
      supportedContexts: {
        ChartContextId.inflation,
        ChartContextId.bonds,
      },
      fallback: ChartTypeId.line,
    ),
    ChartTypeId.candlestick: ChartTypeDescriptor(
      id: ChartTypeId.candlestick,
      labelRu: 'Свечи',
      labelEn: 'Candles',
      dataShape: ChartDataShape.candleSeries,
      supportedContexts: {ChartContextId.assetDetail},
      fallback: ChartTypeId.line,
    ),
    ChartTypeId.stepLine: ChartTypeDescriptor(
      id: ChartTypeId.stepLine,
      labelRu: 'Ступени',
      labelEn: 'Step',
      dataShape: ChartDataShape.priceSeries,
      supportedContexts: {
        ChartContextId.keyRate,
        ChartContextId.assetDetail,
      },
    ),
    ChartTypeId.normalizedOverlay: ChartTypeDescriptor(
      id: ChartTypeId.normalizedOverlay,
      labelRu: 'Сравнение',
      labelEn: 'Compare',
      dataShape: ChartDataShape.multiSeries,
      supportedContexts: {
        ChartContextId.compare,
        ChartContextId.currency,
        ChartContextId.inflation,
      },
      fallback: ChartTypeId.line,
    ),
    ChartTypeId.pie: ChartTypeDescriptor(
      id: ChartTypeId.pie,
      labelRu: 'Круг',
      labelEn: 'Pie',
      dataShape: ChartDataShape.pieValues,
      supportedContexts: {ChartContextId.portfolio},
      fallback: ChartTypeId.bar,
    ),
    ChartTypeId.donut: ChartTypeDescriptor(
      id: ChartTypeId.donut,
      labelRu: 'Кольцо',
      labelEn: 'Donut',
      dataShape: ChartDataShape.pieValues,
      supportedContexts: {ChartContextId.portfolio},
      fallback: ChartTypeId.pie,
    ),
    ChartTypeId.heatmap: ChartTypeDescriptor(
      id: ChartTypeId.heatmap,
      labelRu: 'Тепловая',
      labelEn: 'Heatmap',
      dataShape: ChartDataShape.labeledValues,
      supportedContexts: {ChartContextId.bonds},
      fallback: ChartTypeId.bar,
    ),
    ChartTypeId.ladder: ChartTypeDescriptor(
      id: ChartTypeId.ladder,
      labelRu: 'Лестница',
      labelEn: 'Ladder',
      dataShape: ChartDataShape.labeledValues,
      supportedContexts: {ChartContextId.bonds},
      fallback: ChartTypeId.bar,
    ),
    ChartTypeId.yieldCurve: ChartTypeDescriptor(
      id: ChartTypeId.yieldCurve,
      labelRu: 'Кривая YTM',
      labelEn: 'Yield curve',
      dataShape: ChartDataShape.custom,
      supportedContexts: {ChartContextId.bonds},
      fallback: ChartTypeId.line,
    ),
  };

  static ChartTypeDescriptor describe(ChartTypeId id) =>
      _descriptors[id] ?? _descriptors[ChartTypeId.line]!;

  static List<ChartTypeId> allTypes() => ChartTypeId.values;

  static List<ChartTypeId> typesForContext(ChartContextId context) {
    return ChartTypeId.values
        .where((id) => describe(id).supportedContexts.contains(context))
        .toList();
  }

  static bool supports(ChartTypeId type, ChartContextId context) =>
      describe(type).supportedContexts.contains(context);

  static bool inputMatches(ChartTypeId type, ChartRenderInput input) {
    return switch (describe(type).dataShape) {
      ChartDataShape.priceSeries => input.hasPoints,
      ChartDataShape.candleSeries => input.hasCandles,
      ChartDataShape.multiSeries => input.hasMultiSeries,
      ChartDataShape.labeledValues => input.hasBarData,
      ChartDataShape.pieValues => input.hasPieData || input.hasBarData,
      ChartDataShape.custom => input.hasCustom,
    };
  }

  static ChartTypeId resolveCompatible({
    required ChartTypeId preferred,
    required ChartContextId context,
    required ChartRenderInput input,
  }) {
    if (supports(preferred, context) && inputMatches(preferred, input)) {
      return preferred;
    }

    for (final candidate in typesForContext(context)) {
      if (inputMatches(candidate, input)) return candidate;
    }

    if (input.hasPoints) return ChartTypeId.line;
    if (input.hasCandles) return ChartTypeId.candlestick;
    if (input.hasMultiSeries) return ChartTypeId.normalizedOverlay;
    if (input.hasBarData) return ChartTypeId.bar;
    if (input.hasPieData) return ChartTypeId.pie;
    if (input.hasCustom) return ChartTypeId.yieldCurve;

    return ChartTypeId.line;
  }
}
