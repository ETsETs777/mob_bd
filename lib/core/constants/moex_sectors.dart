// =============================================================================
// EcoPulse · lib/core/constants/moex_sectors.dart
// Автор: Цымбал Е. В.
// Дата: 30.04.2026
// Константы и каталоги (API, рынки, облигации). Файл: moex_sectors.
// =============================================================================

/// Секторы MOEX для heatmap и группировки списка.
const moexTickerSectors = <String, String>{
  'IMOEX': 'index',
  'RTSI': 'index',
  'SBER': 'finance',
  'SBERP': 'finance',
  'VTBR': 'finance',
  'MOEX': 'finance',
  'CBOM': 'finance',
  'BSPB': 'finance',
  'SFIN': 'finance',
  'SPBE': 'finance',
  'LEAS': 'finance',
  'RENI': 'finance',
  'SVCB': 'finance',
  'T': 'finance',
  'GAZP': 'energy',
  'LKOH': 'energy',
  'ROSN': 'energy',
  'NVTK': 'energy',
  'TATN': 'energy',
  'TATNP': 'energy',
  'SNGS': 'energy',
  'SNGSP': 'energy',
  'TRNFP': 'energy',
  'IRAO': 'energy',
  'HYDR': 'energy',
  'FEES': 'energy',
  'ENPG': 'energy',
  'SIBN': 'energy',
  'UPRO': 'energy',
  'RNFT': 'energy',
  'MRKC': 'energy',
  'MSNG': 'energy',
  'GMKN': 'metals',
  'ALRS': 'metals',
  'CHMF': 'metals',
  'NLMK': 'metals',
  'MAGN': 'metals',
  'PLZL': 'metals',
  'MTLR': 'metals',
  'RUAL': 'metals',
  'SELG': 'metals',
  'RASP': 'metals',
  'TRMK': 'metals',
  'SGZH': 'metals',
  'VSMO': 'metals',
  'YDEX': 'it',
  'VKCO': 'it',
  'OZON': 'it',
  'HEAD': 'it',
  'WUSH': 'it',
  'POSI': 'it',
  'ASTR': 'it',
  'MTSS': 'telecom',
  'RTKM': 'telecom',
  'AFKS': 'telecom',
  'MGNT': 'consumer',
  'FIVE': 'consumer',
  'LENT': 'consumer',
  'MVID': 'consumer',
  'BELU': 'consumer',
  'AQUA': 'consumer',
  'AFLT': 'transport',
  'FLOT': 'transport',
  'NMTP': 'transport',
  'PIKK': 'realestate',
  'SMLT': 'realestate',
  'PHOR': 'chemicals',
  'NKNC': 'chemicals',
  'NKNCP': 'chemicals',
  'KMAZ': 'industrial',
  'UWGN': 'industrial',
  'CARM': 'auto',
  'MDMG': 'health',
};

/// Функция [moexSectorKey] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
String? moexSectorKey(String symbol) => moexTickerSectors[symbol];

/// Функция [averageChangeBySector] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
Map<String, double> averageChangeBySector(
  List<({String sector, double change})> items,
) {
  final buckets = <String, List<double>>{};
  for (final item in items) {
    buckets.putIfAbsent(item.sector, () => []).add(item.change);
  }
  return buckets.map(
    (sector, values) => MapEntry(
      sector,
      values.reduce((a, b) => a + b) / values.length,
    ),
  );
}

/// Функция [sectorLabelKey] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
String sectorLabelKey(String sector) => sector;
