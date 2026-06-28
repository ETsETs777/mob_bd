// =============================================================================
// EcoPulse · lib/core/utils/sector_labels.dart
// Автор: Цымбал Е. В.
// Дата: 10.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: sector_labels.
// =============================================================================

import '../constants/market_catalog.dart';
import '../../l10n/app_localizations.dart';

/// Функция [sectorLabelForKey] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
String sectorLabelForKey(String key, AppLocalizations l10n) => switch (key) {
      'index' => l10n.sectorIndex,
      'finance' => l10n.sectorFinance,
      'energy' => l10n.sectorEnergy,
      'metals' => l10n.sectorMetals,
      'it' => l10n.sectorIt,
      'telecom' => l10n.sectorTelecom,
      'consumer' => l10n.sectorConsumer,
      'transport' => l10n.sectorTransport,
      'realestate' => l10n.sectorRealestate,
      'chemicals' => l10n.sectorChemicals,
      'etf' => l10n.sectorEtf,
      'tech' => l10n.sectorTech,
      'auto' => l10n.sectorAuto,
      'health' => l10n.sectorHealth,
      'media' => l10n.sectorMedia,
      'industrial' => l10n.sectorIndustrial,
      'us' => l10n.sectorUs,
      'other' => l10n.sectorOther,
      _ => key,
    };

/// Функция [currencyGroupLabel] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
String currencyGroupLabel(CurrencyGroup group, AppLocalizations l10n) =>
    switch (group) {
      CurrencyGroup.moex => l10n.currencyGroupMoex,
      CurrencyGroup.major => l10n.currencyGroupMajor,
      CurrencyGroup.europe => l10n.currencyGroupEurope,
      CurrencyGroup.asia => l10n.currencyGroupAsia,
      CurrencyGroup.em => l10n.currencyGroupEm,
      CurrencyGroup.americas => l10n.currencyGroupAmericas,
    };
