// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'EcoPulse';

  @override
  String get tabHome => 'Heim';

  @override
  String get tabCurrency => 'Währung';

  @override
  String get tabInflation => 'Inflation';

  @override
  String get tabMarkets => 'Märkte';

  @override
  String get tabMessages => 'Chat';

  @override
  String get tabArticles => 'Artikel';

  @override
  String get tabCommunity => 'Gemeinschaft';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get tabProfile => 'Profil';

  @override
  String get pinEnterCode => 'Geben Sie den Passcode ein';

  @override
  String get pinWrongCode => 'Falscher Passcode';

  @override
  String get pinUseBiometric => 'Melden Sie sich mit biometrischen Daten an';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsDefaultTab => 'Standard-Tab';

  @override
  String get settingsBiometric => 'Biometrie';

  @override
  String get settingsBiometricSubtitle =>
      'Fingerabdruck oder Face ID statt PIN';

  @override
  String get shareQuote => 'Teilen';

  @override
  String get copyQuote => 'Kopie';

  @override
  String get copied => 'Kopiert';

  @override
  String shareMessage(String title, String value) {
    return '$title: $value';
  }

  @override
  String get alertsTitle => 'Preisalarme';

  @override
  String get alertsAdd => 'Benachrichtigung hinzufügen';

  @override
  String get alertsEmpty =>
      'Noch keine Benachrichtigungen. Beispiel: USD/RUB über 90';

  @override
  String get alertsSymbol => 'Instrument';

  @override
  String get alertsThreshold => 'Schwelle';

  @override
  String get alertsSave => 'Speichern';

  @override
  String get alertsCheckOnRefresh =>
      'Wird überprüft, wenn die Daten aktualisiert werden';

  @override
  String get alertsSettingsSubtitle =>
      'USD/RUB, BTC und mehr – Hintergrund + Aktualisierungs-Push';

  @override
  String alertsLastTriggered(String time) {
    return 'Ausgelöst: $time';
  }

  @override
  String get alertAction => 'Alarm einstellen';

  @override
  String get homePulseTitle => 'Wirtschaftsimpuls';

  @override
  String get homePulseSubtitle => 'Wichtige Kennzahlen in Echtzeit';

  @override
  String homeUpdated(String time) {
    return 'Aktualisiert: $time';
  }

  @override
  String get sectionCurrencies => 'Währungen';

  @override
  String get sectionKeyRate => 'CBR Leitzins';

  @override
  String get sectionInflation => 'Inflation';

  @override
  String get sectionCommodities => 'Rohstoffe';

  @override
  String get sectionMarkets => 'Märkte';

  @override
  String get sectionWatchlist => 'Beobachtungsliste';

  @override
  String get actionAll => 'Alle';

  @override
  String get actionMarkets => 'Märkte';

  @override
  String get actionCalculators => 'Taschenrechner';

  @override
  String get chartTitle => 'Diagramm';

  @override
  String get chartLine => 'Linie';

  @override
  String get chartCandles => 'Kerzen';

  @override
  String get shareChart => 'Diagramm teilen';

  @override
  String get retry => 'Wiederholen';

  @override
  String errorGeneric(String message) {
    return 'Fehler: $message';
  }

  @override
  String get errorDataTitle => 'Daten konnten nicht geladen werden';

  @override
  String get errorNetwork =>
      'Verbindung zum Datenserver fehlgeschlagen. Internet prüfen und erneut versuchen.';

  @override
  String get errorTimeout =>
      'Der Server hat zu lange nicht geantwortet. Später erneut versuchen.';

  @override
  String get errorServer =>
      'Der Dienst ist vorübergehend nicht verfügbar. Später erneut versuchen.';

  @override
  String get errorNotFound => 'Daten nicht gefunden.';

  @override
  String get errorRateLimit =>
      'Zu viele Anfragen. Eine Minute warten und erneut versuchen.';

  @override
  String get errorDataUnavailable => 'Daten vorübergehend nicht verfügbar.';

  @override
  String get assetType => 'Typ';

  @override
  String get assetCurrency => 'Währung';

  @override
  String get assetSource => 'Quelle';

  @override
  String get assetTypeCrypto => 'Kryptowährung';

  @override
  String get assetTypeStockRu => 'Lagerbestand (MOEX)';

  @override
  String get assetTypeStockUs => 'Lagerbestand (USA)';

  @override
  String get settingsCompactHome => 'Kompaktes Zuhause';

  @override
  String get settingsCompactHomeSubtitle =>
      'Dichtes 2×2-Gitter, kleinerer Abstand';

  @override
  String get currencyLoadError => 'Ladefehler';

  @override
  String currencyChart30d(String pair) {
    return 'Diagramm $pair (30 days)';
  }

  @override
  String get currencyConverter => 'Konverter';

  @override
  String get currencyAmount => 'Menge';

  @override
  String get currencyFrom => 'Aus';

  @override
  String get currencyTo => 'Zu';

  @override
  String get currencyFee => 'Umtauschgebühr';

  @override
  String get currencyQuickConvert => 'Schnelle Konvertierung';

  @override
  String get currencyQuickHint => '100 USD bis EUR';

  @override
  String get currencyQuickFormatError => 'Format: 100 USD bis EUR';

  @override
  String get currencyHistory => 'Konvertierungsverlauf';

  @override
  String get currencyUnavailable =>
      'Ladefehler · Tippen Sie auf „Aktualisieren“.';

  @override
  String get marketsSearchHint => 'Suchen Sie nach BTC, SBER, AAPL…';

  @override
  String get marketsTabCrypto => 'Krypto';

  @override
  String get marketsTabStocks => 'Aktien';

  @override
  String get marketsTabBonds => 'Anleihen';

  @override
  String get assetTypeBondRu => 'Bindung (MOEX)';

  @override
  String get marketsFilterOfz => 'OFZ';

  @override
  String get marketsFilterCorporateBonds => 'Corp.';

  @override
  String get bondCategoryOfz => 'OFZ – Regierung';

  @override
  String get bondCategoryCorporate => 'Unternehmen';

  @override
  String get bondYieldLabel => 'Ertrag';

  @override
  String get bondCouponLabel => 'Coupon';

  @override
  String get bondMaturityLabel => 'Reife';

  @override
  String get bondFaceValueLabel => 'Nennwert';

  @override
  String marketsBondCatalogCounts(int count) {
    return 'Katalog: $count Anleihen · MOEX ISS';
  }

  @override
  String get bondYieldCurveTitle => 'OFZ Zinsstrukturkurve';

  @override
  String get bondYieldCurveSubtitle => 'YTM × Restlaufzeit · MOEX ISS';

  @override
  String get bondYieldCurveTapHint =>
      'Tippen Sie auf, um das Diagramm im Vollbildmodus anzuzeigen';

  @override
  String get bondYieldCurveEmpty => 'Nicht genügend OFZ-Daten für die Kurve';

  @override
  String get bondYieldCurveTableTitle => 'Kurvenpunkte';

  @override
  String get bondYieldCurveOpen => 'Renditekurve';

  @override
  String get bondYieldSpreadLabel => 'Long-Short-Spread';

  @override
  String bondYieldSpreadValue(String spread) {
    return '+$spread S';
  }

  @override
  String get bondYearsShort => 'j';

  @override
  String get bondLadderTitle => 'OFZ Bindungsleiter';

  @override
  String get bondLadderSubtitle =>
      'Nach Fälligkeitsjahr · Rendite bis zur Fälligkeit';

  @override
  String get bondLadderTapHint => 'Tippen Sie für den Vollbildmodus';

  @override
  String bondLadderFullSubtitle(int ofzCount, int yearCount) {
    return '$ofzCount OFZ · $yearCount Laufzeitjahre';
  }

  @override
  String bondLadderYearHeader(int year, int count) {
    return '$year · $count';
  }

  @override
  String bondLadderMoreYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'years',
      one: 'year',
    );
    return '$count mehr $_temp0';
  }

  @override
  String get bondYieldCurveCrosshairHint =>
      'Tippen Sie auf einen Punkt auf der Kurve';

  @override
  String get bondYieldCurveZoomHint =>
      'Scrollen oder kneifen Sie, um zu zoomen. Doppeltippen Sie, um zurückzusetzen';

  @override
  String bondYieldCurveZoomActive(String zoom) {
    return 'Zoom ×$zoom · Doppeltippen zum Zurücksetzen';
  }

  @override
  String get bondCalendarTitle => 'Bond-Kalender';

  @override
  String get bondCalendarSubtitle =>
      'Beobachtungsliste und Portfolio · MOEX-Gutscheine oder Kostenvoranschlag';

  @override
  String get bondCalendarTapHint =>
      'Tippen Sie hier, um den vollständigen Kalender anzuzeigen';

  @override
  String get bondCalendarFullSubtitle =>
      'Watchlist & Papierportfolio · Kupons und Laufzeiten';

  @override
  String get bondCalendarHorizon6m => '6 Monate';

  @override
  String get bondCalendarHorizon1y => '1 Jahr';

  @override
  String get bondCalendarHorizon2y => '2 Jahre';

  @override
  String get bondCalendarCouponIncome => 'Portfolio-Gutscheine (geschätzt)';

  @override
  String get bondCalendarCouponIncomeHint => 'MOEX GUTSCHEINWERT × Menge';

  @override
  String get bondCalendarEmptyTracked =>
      'Fügen Sie Anleihen zur Beobachtungsliste oder zum Portfolio hinzu';

  @override
  String get bondCalendarEmptyEvents =>
      'Keine Ereignisse im ausgewählten Horizont';

  @override
  String bondCalendarMoreEvents(int count) {
    return '$count weitere Veranstaltungen';
  }

  @override
  String get bondEventMaturity => 'Reife';

  @override
  String bondEventCouponRub(String amount) {
    return 'Gutschein $amount ₽';
  }

  @override
  String bondEventCouponPercent(String rate) {
    return 'Gutschein $rate%';
  }

  @override
  String bondEventCouponEstimate(String rate) {
    return 'Coupon ~$rate% (geschätzt)';
  }

  @override
  String get bondNextCouponLabel => 'Nächster Gutschein';

  @override
  String get bondCouponValueLabel => 'Gutscheinbetrag';

  @override
  String get bondHomeCardTitle => 'OFZ Anleihen';

  @override
  String get bondHomeCardSubtitle =>
      'Durchschnittliche Rendite und Spread · MOEX ISS';

  @override
  String bondHomeUpcomingEvents(int count) {
    return 'Kommende Veranstaltungen: $count';
  }

  @override
  String get bondCalendarOpen => 'Kalender';

  @override
  String get bondHomeAvgYield => 'Durchschnittlich YTM';

  @override
  String get bondHomeTopYield => 'Spitzenertrag';

  @override
  String get marketsFavorites => 'Beobachtungsliste';

  @override
  String get marketsEmptyFavoritesTitle => 'Keine Merklistenelemente';

  @override
  String get marketsEmptySearchTitle => 'Nichts gefunden';

  @override
  String get marketsEmptyFavoritesSubtitle =>
      'Tippen Sie auf ★ auf ein Asset, um es hinzuzufügen';

  @override
  String get marketsEmptySearchSubtitle =>
      'Versuchen Sie es mit einer anderen Abfrage oder löschen Sie den Filter';

  @override
  String get marketsAllAssets => 'Alle Vermögenswerte';

  @override
  String marketsRemovedFromWatchlist(String symbol) {
    return '$symbol von der Beobachtungsliste entfernt';
  }

  @override
  String get undo => 'Rückgängig machen';

  @override
  String get inflationTabCountries => 'Länder';

  @override
  String get inflationTabCalculator => 'Inflation';

  @override
  String get inflationTabFinance => 'Finanzen';

  @override
  String get inflationCpiTitle => 'Inflation (CPI), Jahr für Jahr';

  @override
  String get inflationWorldBankNote =>
      'Daten der Weltbank · letztes verfügbares Jahr';

  @override
  String get inflationCalcTitle => 'Was ist das Geld heute wert?';

  @override
  String get inflationCalcSubtitle =>
      'Verwendet die kumulative Inflation der Weltbank';

  @override
  String get inflationCountry => 'Land';

  @override
  String get inflationAmount => 'Menge';

  @override
  String get inflationYear => 'Jahr';

  @override
  String get inflationYoy => 'Jahr für Jahr';

  @override
  String get inflationUnavailable => 'Daten vorübergehend nicht verfügbar';

  @override
  String purchasingPower(String base, int year, String today) {
    return '$base in $year ≈ $today heute';
  }

  @override
  String get chartInsufficientData => 'Nicht genügend Daten für das Diagramm';

  @override
  String get chartInsufficientCandles => 'Nicht genügend Daten für Kerzen';

  @override
  String get dataUnavailable => 'Daten vorübergehend nicht verfügbar';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsThemeLight => 'Licht';

  @override
  String get settingsThemeAuto => 'Auto';

  @override
  String get settingsThemeOled => 'OLED';

  @override
  String get settingsThemeDim => 'Schwach';

  @override
  String get settingsThemeSepia => 'Sepia';

  @override
  String get settingsThemeContrast => 'Kontrast';

  @override
  String get settingsAccentColor => 'Akzentfarbe';

  @override
  String settingsThemeCurrent(String mode) {
    return 'Aktuell: $mode';
  }

  @override
  String get sectorHeatmapTitle => 'MOEX Sektoren';

  @override
  String get sectorHeatmapSubtitle =>
      'Durchschnittliche 7-Tage-Änderung nach Sektor';

  @override
  String get sectorFinance => 'Finanzen';

  @override
  String get sectorEnergy => 'Energie';

  @override
  String get sectorIt => 'ES';

  @override
  String get sectorIndex => 'Index';

  @override
  String dataStatusFresh(String time) {
    return 'Aktualisiert: $time';
  }

  @override
  String get dataStatusLive => 'Die Daten sind aktuell';

  @override
  String dataStatusCache(String age) {
    return 'Cache · $age';
  }

  @override
  String get dataStatusCacheUnknown =>
      'Cache · Daten sind möglicherweise veraltet';

  @override
  String dataStatusOffline(String age) {
    return 'Offline · Cache $age';
  }

  @override
  String get dataStatusOfflineUnknown => 'Offline · gespeicherte Daten';

  @override
  String get alertsCheckBackground =>
      'Hintergrundüberprüfung alle 15 min + bei der Aktualisierung';

  @override
  String get currencyCompareTitle => 'Tarifvergleich';

  @override
  String get currencyCompareSubtitle =>
      'Index 100 zu Beginn der Periode – bis zu 3 Paare';

  @override
  String get currencyCompareSelect =>
      'Wählen Sie ein weiteres Paar zum Vergleich aus';

  @override
  String get assetPreviewOpen => 'Diagramm öffnen';

  @override
  String get assetPreviewAddWatchlist => 'Auf die Beobachtungsliste';

  @override
  String get assetPreviewRemoveWatchlist => 'Von der Merkliste entfernen';

  @override
  String get inflationCompareTitle => 'Ländervergleich';

  @override
  String get inflationCompareSubtitle =>
      'YoY CPI – bis zu 3 Länder auf einem Diagramm';

  @override
  String get inflationCompareSelect =>
      'Wählen Sie ein weiteres Land zum Vergleich aus';

  @override
  String get settingsHomeWidget => 'Android-Widget';

  @override
  String get settingsHomeWidgetSubtitle =>
      'USD/RUB und BTC auf dem Startbildschirm – Aktualisierungen bei Aktualisierung';

  @override
  String get keyRateDetailTitle => 'CBR Leitzins';

  @override
  String keyRateUpdated(String date) {
    return 'Aktualisiert: $date';
  }

  @override
  String get keyRateEventsTitle => 'Tarifänderungen';

  @override
  String get keyRateEventsEmpty => 'Keine Änderungen in diesem Zeitraum';

  @override
  String keyRateEventChange(String date, String rate) {
    return '$date → $rate';
  }

  @override
  String keyRateSince(int day, int month, int year) {
    return 'seit $day.$month.$year';
  }

  @override
  String get sourceCbr => 'CBR';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingNext => 'Nächste';

  @override
  String get onboardingStart => 'Fangen Sie an';

  @override
  String get onboarding1Title => 'Währungen und Kurse';

  @override
  String get onboarding1Subtitle =>
      'USD/RUB, EUR/RUB und globale FX von MOEX und Frankfurter';

  @override
  String get onboarding2Title => 'Inflation und CBR-Rate';

  @override
  String get onboarding2Subtitle =>
      'Daten der Weltbank, CBR Leitzins- und Finanzrechner';

  @override
  String get onboarding3Title => 'Märkte & Beobachtungsliste';

  @override
  String get onboarding3Subtitle =>
      'Krypto, MOEX-Aktien, Charts und Watchlist an einem Ort';

  @override
  String get settingsSectionAppearance => 'Aussehen';

  @override
  String get settingsAppTheme => 'App-Thema';

  @override
  String get settingsAppBackground => 'App-Hintergrund';

  @override
  String get settingsBackgroundSubtitle => 'Farbverlauf wie Banking-Apps';

  @override
  String get settingsSectionSecurity => 'Sicherheit';

  @override
  String get settingsPinCode => 'Zugangscode';

  @override
  String get settingsPinEnabled => 'App-geschützt · 4 digits';

  @override
  String get settingsPinDisabled => 'PIN ist aus';

  @override
  String get settingsChangePin => 'Code ändern';

  @override
  String get settingsLockNow => 'Jetzt sperren';

  @override
  String get settingsLockedSnack => 'App gesperrt';

  @override
  String get settingsSectionDisplay => 'Anzeige';

  @override
  String get settingsBaseCurrency => 'Basiswährung';

  @override
  String get settingsKeysLocalNote =>
      'Schlüssel werden lokal gespeichert – kein Neuaufbau erforderlich';

  @override
  String get settingsSectionDataApi => 'Daten & API';

  @override
  String get settingsSectionAbout => 'Um';

  @override
  String get settingsAboutDescription =>
      'Wirtschafts-Dashboard mit Währungen, Inflation, Krypto und Marktkursen.';

  @override
  String get settingsAboutDesign =>
      'Design: Material 3 · fl_chart · flutter_animate';

  @override
  String get settingsAboutDeveloper =>
      'Entwickelt von Evgeny Vladislavovich Tsymbal';

  @override
  String get sourceFrankfurter => 'Frankfurter';

  @override
  String get sourceFrankfurterSub => 'Internationale Devisen';

  @override
  String get sourceMoex => 'MOEX ISS';

  @override
  String get sourceMoexSub => 'RUB FX- und RU-Aktien';

  @override
  String get sourceCbrSub => 'Leitzins';

  @override
  String get sourceWorldBank => 'Weltbank';

  @override
  String get sourceWorldBankSub => 'CPI Inflation';

  @override
  String get sourceCoingecko => 'CoinGecko';

  @override
  String get sourceCoingeckoSub => 'Kryptowährungen';

  @override
  String get sourceFinnhub => 'Finnhub';

  @override
  String get sourceFinnhubSub => 'US-Aktien';

  @override
  String get sourceCommodities => 'MOEX ISS';

  @override
  String get sourceCommoditiesSub => 'Rohstoffe';

  @override
  String get statusActive => 'Aktiv';

  @override
  String get statusKeyOk => 'Schlüssel OK';

  @override
  String get statusNoKey => 'Kein Schlüssel';

  @override
  String get statusNotConfigured => 'Nicht konfiguriert';

  @override
  String get inflationRateVsTitle => 'Leitzins vs. Inflation';

  @override
  String get inflationRateVsSubtitle =>
      'Durchschnittlicher CBR-Satz und Russland CPI pro Jahr';

  @override
  String get inflationRateVsKeyRate => 'Leitzins';

  @override
  String get inflationRateVsCpi => 'CPI Inflation';

  @override
  String get correlationTitle => 'Vermögenskorrelation';

  @override
  String correlationSubtitle(int days) {
    return 'Tägliche Renditen über $days Tage (Pearson)';
  }

  @override
  String get correlationChartTitle => 'Leistung (Index 100)';

  @override
  String get correlationNote =>
      '1 = zusammen bewegen, −1 = entgegengesetzt, 0 = keine Verbindung';

  @override
  String get correlationBtc => 'BTC';

  @override
  String get correlationUsdRub => 'USD/RUB';

  @override
  String get correlationImoex => 'IMOEX';

  @override
  String get sectorMetals => 'Metalle';

  @override
  String get sectorTelecom => 'Telekommunikation';

  @override
  String get sectorConsumer => 'Verbraucher';

  @override
  String get sectorTransport => 'Transport';

  @override
  String get sectorRealestate => 'Immobilie';

  @override
  String get sectorChemicals => 'Chemikalien';

  @override
  String get sectorEtf => 'ETF';

  @override
  String get sectorTech => 'Technologie';

  @override
  String get sectorAuto => 'Automobil';

  @override
  String get sectorHealth => 'Gesundheitspflege';

  @override
  String get sectorMedia => 'Medien';

  @override
  String get sectorIndustrial => 'Industriell';

  @override
  String get sectorUs => 'Vereinigte Staaten';

  @override
  String get sectorOther => 'Andere';

  @override
  String get marketsFilterAll => 'Alle';

  @override
  String get marketsFilterMoex => 'MOEX';

  @override
  String get marketsFilterUs => 'NYSE/NASDAQ';

  @override
  String get marketsGroupBySector => 'Nach Sektor';

  @override
  String get marketsCatalogHint =>
      '50 MOEX · 45 US · 100 Krypto · Suche nach Ticker';

  @override
  String marketsCatalogCounts(int moex, int us, int crypto) {
    return '$moex MOEX · $us US · $crypto Krypto · Suche';
  }

  @override
  String get currencyGroupMoex => 'MOEX · Rubelpaare';

  @override
  String get currencyGroupMajor => 'Wesentlich';

  @override
  String get currencyGroupEurope => 'Europa';

  @override
  String get currencyGroupAsia => 'Asien';

  @override
  String get currencyGroupEm => 'Auftauchend';

  @override
  String get currencyGroupAmericas => 'Amerika und Ozeanien';

  @override
  String get adminPanelTitle => 'Admin-Panel';

  @override
  String get adminPanelSubtitle =>
      'Entwicklungstools: API, Cache, Kataloge, Feature-Flags';

  @override
  String get adminApiStatus => 'API-Status';

  @override
  String get adminCache => 'Cache';

  @override
  String get adminCatalog => 'Kataloge';

  @override
  String get adminFeatureFlags => 'Feature-Flags';

  @override
  String get adminHttpLog => 'HTTP-Protokoll';

  @override
  String get adminHttpLogEmpty => 'Noch keine Anfragen';

  @override
  String get adminRefreshAll => 'Alles aktualisieren';

  @override
  String get adminReloadStatus => 'Status neu laden';

  @override
  String get adminRefreshed => 'Daten aktualisiert';

  @override
  String get adminFlagSectorHeatmap => 'MOEX Sektor-Heatmap';

  @override
  String get adminFlagStocksGrouped => 'Gruppieren Sie Aktien nach Sektor';

  @override
  String get adminFlagVerboseHttp => 'Ausführliches HTTP-Protokoll';

  @override
  String get adminCacheEmpty => 'Leer';

  @override
  String get adminCacheFresh => 'Frisch';

  @override
  String get adminCacheStale => 'Abgestanden';

  @override
  String adminCacheAge(String age) {
    return 'Alter: $age';
  }

  @override
  String adminCacheItems(int count) {
    return '$count Artikel';
  }

  @override
  String get adminCatalogMoex => 'MOEX';

  @override
  String get adminCatalogUs => 'UNS';

  @override
  String get adminCatalogFx => 'FX';

  @override
  String get adminCatalogCrypto => 'Krypto';

  @override
  String get profileSectionTitle => 'Profil';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileGuest => 'Gast · Richten Sie Ihr Profil ein';

  @override
  String profileGreeting(String name) {
    return 'Hallo, $name!';
  }

  @override
  String get profileDisplayName => 'Anzeigename';

  @override
  String get profileDisplayNameHint => 'Wie sollen wir Sie begrüßen?';

  @override
  String get profileAvatarHint =>
      'Wählen Sie einen Avatar oder laden Sie Ihr Foto hoch';

  @override
  String get profileAvatarPickPhoto => 'Foto hochladen';

  @override
  String get profileAvatarRemovePhoto => 'Foto entfernen';

  @override
  String get profileAvatarPickFailed => 'Bild konnte nicht verarbeitet werden';

  @override
  String get profileAvatarPickSuccess => 'Avatar-Foto aktualisiert';

  @override
  String get profileCountry => 'Land für Inflation';

  @override
  String get profileCountryHint =>
      'Wird auf der Registerkarte „Länder“ verwendet';

  @override
  String profileCountryLabel(String country) {
    return 'Land: $country';
  }

  @override
  String get profileSaved => 'ProDatei gespeichert';

  @override
  String get profileSave => 'Speichern';

  @override
  String get profileEmail => 'E-Mail';

  @override
  String get profileEmailHint => 'example@mail.com';

  @override
  String get profilePhone => 'Telefon';

  @override
  String get profilePhoneHint => '+1 (555) 000-0000';

  @override
  String get profileHubAccountsTitle => 'Meine Konten';

  @override
  String get profileHubAccountPortfolio => 'Papierportfolio';

  @override
  String get profileHubAccountWatchlist => 'Beobachtungsliste';

  @override
  String get profileHubAccountAlerts => 'Preisalarme';

  @override
  String get profileHubAccountCash => 'Verfügbares Bargeld';

  @override
  String get profileHubAccountCashSub => 'Bereit zum Handel';

  @override
  String get profileHubPortfolioEmpty => 'Keine offenen Stellen';

  @override
  String get profileHubQuickBackup => 'Sicherung';

  @override
  String get profileHubQuickSecurity => 'Sicherheit';

  @override
  String get profileHubQuickSync => 'Synchronisieren';

  @override
  String get profileHubQuickCustomize => 'Stil';

  @override
  String get profileHubSectionProfile => 'Profil';

  @override
  String get profileHubSectionFinance => 'Finanzen';

  @override
  String get profileHubSectionSecurity => 'Sicherheit und Daten';

  @override
  String get profileHubSectionApp => 'App';

  @override
  String get profileHubPersonalData => 'Persönliche Daten';

  @override
  String get profileHubPersonalDataSub => 'Name, Avatar, E-Mail, Telefon';

  @override
  String get profileHubServerAccount => 'Serverkonto';

  @override
  String get profileHubServerIntro =>
      'Melden Sie sich für Chats und Profilsynchronisierung bei Ihrem EcoPulse-Heimserver an.';

  @override
  String get profileHubMessages => 'Nachrichten';

  @override
  String get profileHubArticles => 'Artikel';

  @override
  String get profileHubPortfolio => 'Portfolio';

  @override
  String get profileHubWatchlist => 'Watchlist-Assets';

  @override
  String get profileHubSecurity => 'Sicherheit';

  @override
  String get profileHubSecuritySub => 'PIN und Biometrie';

  @override
  String get profileHubSecurityPinBio => 'PIN und Biometrie';

  @override
  String get profileHubSecurityActive => 'App ist geschützt';

  @override
  String get profileHubSecurityActiveSub =>
      'PIN ist aktiviert. Ihre Daten werden ausgeblendet, wenn die App gesperrt ist.';

  @override
  String get profileHubSecurityInactive => 'Protection ist ausgeschaltet';

  @override
  String get profileHubSecurityInactiveSub =>
      'Aktivieren Sie die PIN, um Daten auszublenden, wenn der Bildschirm gesperrt ist.';

  @override
  String get profileHubDocuments => 'Dokumente und Berichte';

  @override
  String get profileHubDocumentsSub => 'Export, Backup, Wochenbericht';

  @override
  String get profileHubDocumentsIntro =>
      'Speichern Sie App-Daten oder teilen Sie einen Watchlist-Bericht.';

  @override
  String get profileHubCloudSync => 'Cloud-Synchronisierung';

  @override
  String get profileHubNotifications => 'Benachrichtigungen';

  @override
  String get profileHubNotificationsSub => 'Morgenübersicht und Warnungen';

  @override
  String get profileHubAppSettings => 'App-Einstellungen';

  @override
  String get profileHubAppSettingsSub => 'Thema, Sprache, API, Widget';

  @override
  String get profileHubCustomization => 'Anpassung';

  @override
  String get profileHubCourses => 'Kurse & Lernen';

  @override
  String get profileHubAbout => 'Über EcoPulse';

  @override
  String get profileHubVerified => 'ProDatei vollständig';

  @override
  String get profileHubServerOnline => 'Server verbunden';

  @override
  String get profileHubServerOffline => 'Lokaler Modus';

  @override
  String get profileHubEditProfile => 'Bearbeiten';

  @override
  String profileHubPositions(int count) {
    return '$count Positionen';
  }

  @override
  String profileHubAssets(int count) {
    return '$count Vermögenswerte';
  }

  @override
  String profileHubActiveAlerts(int count) {
    return '$count-Warnungen';
  }

  @override
  String get backupSectionTitle => 'Sicherung';

  @override
  String get backupExportTitle => 'Daten exportieren';

  @override
  String get backupExportSubtitle =>
      'Beobachtungsliste, Profil, Einstellungen, Notizen – JSON';

  @override
  String get backupImportTitle => 'Daten importieren';

  @override
  String get backupImportSubtitle => 'JSON aus dem Export einfügen';

  @override
  String get backupImportHint => 'Fügen Sie hier EcoPulse export JSON ein';

  @override
  String get backupImportConfirm => 'Wiederherstellen';

  @override
  String backupImportSuccess(int count) {
    return 'Wiederhergestellte Schlüssel: $count';
  }

  @override
  String backupImportError(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get cancel => 'Stornieren';

  @override
  String get assetNoteTitle => 'Notiz';

  @override
  String get assetNoteHint => 'Gekauft bei 280, Ziel 320…';

  @override
  String get portfolioTitle => 'Papierportfolio';

  @override
  String get portfolioEmptySubtitle => '₽100.000 virtuell · Zum Starten tippen';

  @override
  String get portfolioTotal => 'Portfoliowert';

  @override
  String get portfolioPnl => 'P&L';

  @override
  String get portfolioLiveBadge => 'LIVE';

  @override
  String portfolioLiveUpdated(String time) {
    return 'Aktualisiert $time';
  }

  @override
  String get portfolioCash => 'Kasse';

  @override
  String get portfolioPositions => 'Positionen';

  @override
  String get portfolioEmptyPositions =>
      'Kaufen Sie von der Watchlist oder Asset-Vorschau auf Markets';

  @override
  String get portfolioAdd => 'Kaufen';

  @override
  String get portfolioBuy => 'Kaufpreis';

  @override
  String get portfolioBuyAction => 'Zum Portfolio hinzufügen';

  @override
  String portfolioBought(String symbol) {
    return '$symbol zum Portfolio hinzugefügt';
  }

  @override
  String get portfolioInsufficientCash => 'Unzureichendes virtuelles Bargeld';

  @override
  String get portfolioReset => 'Zurücksetzen';

  @override
  String get portfolioResetConfirm =>
      'Auf ₽100.000 zurücksetzen und alle Positionen löschen?';

  @override
  String portfolioRemoved(String symbol) {
    return '$symbol entfernt (langes Drücken)';
  }

  @override
  String get portfolioPickAsset => 'Wählen Sie einen Vermögenswert aus';

  @override
  String get portfolioPickFromWatchlist =>
      'Fügen Sie zuerst Vermögenswerte zur Beobachtungsliste unter „Märkte“ hinzu';

  @override
  String cryptoLoadMore(int loaded, int total) {
    return 'Mehr laden ($loaded / $total)';
  }

  @override
  String get homeShareDashboard => 'Dashboard teilen';

  @override
  String get newsSectionTitle => 'Nachricht';

  @override
  String get newsFinnhubHint =>
      'Fügen Sie in den Einstellungen für Nachrichten und Kalender einen Finnhub-Schlüssel hinzu';

  @override
  String get newsEmpty => 'Noch keine Neuigkeiten';

  @override
  String get newsLoadError => 'Nachrichten konnten nicht geladen werden';

  @override
  String get macroCalendarTitle => 'Makrokalender';

  @override
  String get macroCalendarEmpty =>
      'Keine Veranstaltungen für die nächste Woche';

  @override
  String get digestSectionTitle => 'Benachrichtigungen';

  @override
  String get digestMorningTitle => 'Morgendliche Zusammenfassung';

  @override
  String get digestMorningSubtitle =>
      'Push-Brief mit USD/RUB, BTC, IMOEX zur gewählten Stunde';

  @override
  String get digestMorningHour => 'Lieferzeit';

  @override
  String get indicesSectionTitle => 'US-Indizes';

  @override
  String get radarTitle => 'Wirtschaftsradar';

  @override
  String get radarSubtitle =>
      'Ergebnis aus Markt, FX, Inflation, Zinssatz und F&G';

  @override
  String get timelineTitle => 'Zeitleiste der Veranstaltung';

  @override
  String get timelineEmpty =>
      'Noch keine Ereignisse · Finnhub-Taste für Makro erforderlich';

  @override
  String get macroWeekTitle => 'Makrowoche';

  @override
  String macroWeekRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get macroWeekBriefTitle => 'Marktübersicht';

  @override
  String get macroWeekToday => 'Heute';

  @override
  String get macroWeekKeyRateToday => 'CBR Leitzins';

  @override
  String macroWeekStats(int events, int days) {
    return '$events Makroereignisse · $days Tage mit Ereignissen';
  }

  @override
  String get macroWeekEmptyDay => 'Keine Veranstaltungen';

  @override
  String get macroWeekMon => 'Mo';

  @override
  String get macroWeekTue => 'Di';

  @override
  String get macroWeekWed => 'Heiraten';

  @override
  String get macroWeekThu => 'Do';

  @override
  String get macroWeekFri => 'Fr';

  @override
  String get macroWeekSat => 'Sa';

  @override
  String get macroWeekSun => 'Sonne';

  @override
  String get portfolioExportCsv => 'CSV exportieren';

  @override
  String get portfolioExportDone => 'CSV geteilt';

  @override
  String get demoModeTitle => 'Demo-Modus';

  @override
  String get demoModeSubtitle =>
      'Scheindaten offline – für Screenshots und Demos';

  @override
  String get demoModeBadge => 'Demodaten';

  @override
  String get homeLayoutTitle => 'Home-Bereiche';

  @override
  String get homeSectionPortfolio => 'Papierportfolio';

  @override
  String get homeSectionNews => 'Nachricht';

  @override
  String get homeSectionRadar => 'Wirtschaftsradar';

  @override
  String get homeSectionIndices => 'US-Indizes';

  @override
  String get homeSectionFearGreed => 'Angst und Gier';

  @override
  String get homeSectionCurrencies => 'Währungen';

  @override
  String get homeSectionKeyRate => 'Leitzins';

  @override
  String get homeSectionInflation => 'Inflation';

  @override
  String get homeSectionCommodities => 'Rohstoffe';

  @override
  String get homeSectionMarkets => 'Märkte';

  @override
  String get homeSectionBonds => 'Anleihen';

  @override
  String get homeSectionWatchlist => 'Beobachtungsliste';

  @override
  String get homeSectionCorrelation => 'Korrelation';

  @override
  String get homeSectionFeaturedArticles => 'Empfohlene Artikel';

  @override
  String get articleCategoryAll => 'Alle';

  @override
  String get articleCategoryMarkets => 'Märkte';

  @override
  String get articleCategoryPortfolio => 'Depot';

  @override
  String get articleCategoryMacro => 'Makro';

  @override
  String get articleCategoryLearn => 'Lernen';

  @override
  String get articleCategoryCommunity => 'Gemeinschaft';

  @override
  String get articleCategoryOther => 'Sonstiges';

  @override
  String get userArticlesFilterCategory => 'Kategorie:';

  @override
  String get userArticlesFeaturedHomeTitle => 'Community-Empfehlungen';

  @override
  String get userArticlesFeaturedHomeSubtitle => 'Auswahl vom Home Server';

  @override
  String get userArticlesFeaturedHomeOpen => 'Alle Artikel';

  @override
  String get userArticlesFeaturedHomeEmpty => 'Noch keine empfohlenen Artikel';

  @override
  String get userArticlesFieldCategory => 'Kategorie';

  @override
  String get userArticlesFieldTags => 'Schlagwörter';

  @override
  String get userArticlesFieldTagsHint => 'Kommagetrennt, bis zu 8 Tags';

  @override
  String get compareTitle => 'Vergleichen Sie Vermögenswerte';

  @override
  String compareSubtitle(int max) {
    return 'Nehmen Sie bis zu $max Assets für das Overlay-Diagramm auf';
  }

  @override
  String get compareEmpty => 'Wählen Sie oben die Ticker aus';

  @override
  String get compareClear => 'Klar';

  @override
  String get compareChartTitle => 'Index 100 · 30 days';

  @override
  String get compareLoadError => 'Der Verlauf konnte nicht geladen werden';

  @override
  String get settingsApiKeysTitle => 'API Schlüssel';

  @override
  String settingsApiKeySaved(String label) {
    return '$label gespeichert';
  }

  @override
  String get settingsBaseCurrencyHint => 'Wird im Konverter verwendet';

  @override
  String get settingsWidgetConfigTitle => 'Android-Widget';

  @override
  String get settingsWidgetConfigSubtitle =>
      '4×1-Streifen oder 2×2-Raster · bis zu 4 Metriken';

  @override
  String get settingsWidgetLayout => 'Layout';

  @override
  String get settingsWidgetLayoutAuto => 'Automatisch (nach Größe)';

  @override
  String get settingsWidgetLayoutCompact => 'Kompakt 4×1';

  @override
  String get settingsWidgetLayoutExpanded => 'Erweitert 2×2';

  @override
  String get settingsWidgetLayoutHint =>
      'Wechselt das Layout automatisch, wenn Sie die Größe des Widgets auf dem Startbildschirm ändern';

  @override
  String get settingsWidgetSlot1 => 'Steckplatz 1';

  @override
  String get settingsWidgetSlot2 => 'Steckplatz 2';

  @override
  String get settingsWidgetSlot3 => 'Steckplatz 3';

  @override
  String get settingsWidgetSlot4 => 'Steckplatz 4';

  @override
  String get widgetMetricUsdRub => 'USD/RUB';

  @override
  String get widgetMetricEurRub => 'EUR/RUB';

  @override
  String get widgetMetricBtc => 'BTC';

  @override
  String get widgetMetricEth => 'ETH';

  @override
  String get widgetMetricKeyRate => 'CBR-Rate';

  @override
  String get widgetMetricBrent => 'Brent';

  @override
  String get widgetMetricWti => 'WTI';

  @override
  String get widgetMetricImoex => 'IMOEX';

  @override
  String get widgetMetricPortfolio => 'Papierportfolio';

  @override
  String get widgetMetricInflationRu => 'Inflation RU';

  @override
  String get homeLayoutReorderHint =>
      'Zum Neuanordnen ziehen · Sichtbarkeit umschalten';

  @override
  String get alertsKindThreshold => 'Preisniveau';

  @override
  String get alertsKindPercentChange => 'Tägliche Änderung %';

  @override
  String get alertsPercentHint => 'Täglicher Änderungsschwellenwert, %';

  @override
  String get alertsHistoryTitle => 'Trigger-Historie';

  @override
  String get alertsHistoryEmpty => 'Noch keine Auslöser';

  @override
  String get alertsQuietHoursTitle => 'Ruhige Stunden';

  @override
  String get alertsQuietHoursSubtitle =>
      'In diesem Fenster gibt es keine Push-Benachrichtigungen';

  @override
  String alertsQuietHoursRange(int start, int end) {
    return '$start:00 – $end:00';
  }

  @override
  String get alertsQuietHoursStart => 'Aus';

  @override
  String get alertsQuietHoursEnd => 'Zu';

  @override
  String get alertsConditionRise => 'Erheben';

  @override
  String get alertsConditionDrop => 'Fallen';

  @override
  String get alertsConditionAbove => 'Über';

  @override
  String get alertsConditionBelow => 'Unten';

  @override
  String get alertsPresetsTitle => 'Schnelle Voreinstellungen';

  @override
  String get alertsPresetUsd100 => 'USD/RUB > 100';

  @override
  String get alertsPresetBtcDrop5 => 'BTC −5 % täglich';

  @override
  String get alertsPresetBtcRise5 => 'BTC +5 % täglich';

  @override
  String get alertsPresetImoexDrop3 => 'IMOEX −3 % täglich';

  @override
  String get exportReportTitle => 'Wochenbericht';

  @override
  String get exportReportSubtitle => 'Brief + Beobachtungsliste + FX';

  @override
  String get exportReportDone => 'Bericht geteilt';

  @override
  String get portfolioBacktestTitle => 'Backtest ~30d';

  @override
  String portfolioBacktestResult(String past, String current, String change) {
    return 'War $past → jetzt $current ($change)';
  }

  @override
  String get portfolioBacktestUnavailable =>
      'Nicht genügend Preishistorie für Positionen';

  @override
  String get portfolioAllocationTitle => 'Zuweisung';

  @override
  String get portfolioAllocationSubtitle =>
      'Gewichtung der Anlageklassen · Papierportfolio';

  @override
  String get portfolioAllocationCash => 'Kasse';

  @override
  String get portfolioAllocationCrypto => 'Krypto';

  @override
  String get portfolioAllocationStocks => 'Aktien';

  @override
  String get portfolioAllocationBonds => 'Anleihen';

  @override
  String portfolioAllocationTotal(String total) {
    return 'Gesamtvermögen: $total';
  }

  @override
  String get portfolioRebalanceTitle => 'Neuausrichtung';

  @override
  String get portfolioRebalanceSubtitle =>
      'Zielgewichte und Kauf-/Verkaufshinweise nach Anlageklasse';

  @override
  String get portfolioRebalanceConservative => 'Konservativ';

  @override
  String get portfolioRebalancePresetBalanced => 'Ausgewogen';

  @override
  String get portfolioRebalanceGrowth => 'Wachstum';

  @override
  String get portfolioRebalanceCustom => 'Brauch';

  @override
  String portfolioRebalanceDrift(String drift) {
    return 'Maximale Drift: $drift';
  }

  @override
  String get portfolioRebalanceOnTarget =>
      'Das Portfolio liegt nahe an der Zielallokation';

  @override
  String portfolioRebalanceBuy(String amount) {
    return 'Kaufen Sie $amount';
  }

  @override
  String portfolioRebalanceSell(String amount) {
    return 'Verkaufe $amount';
  }

  @override
  String get portfolioRebalanceHold => 'OK';

  @override
  String portfolioRebalanceInvestCash(String amount) {
    return 'Investieren Sie $amount';
  }

  @override
  String portfolioRebalanceFreeCash(String amount) {
    return 'Geben Sie $amount frei';
  }

  @override
  String portfolioRebalanceCurrentTarget(int current, int target) {
    return 'Jetzt $current% → Ziel $target%';
  }

  @override
  String get portfolioIncomeTitle => 'Einkommenskalender';

  @override
  String get portfolioIncomeSubtitle =>
      'Coupons, Dividenden und Fälligkeiten Ihrer Positionen';

  @override
  String get portfolioIncomeNext30 => '30 days';

  @override
  String get portfolioIncomeNext90 => '90 days';

  @override
  String get portfolioIncomeByMonth => 'Monatlich';

  @override
  String portfolioIncomeMonthChip(String month, String amount) {
    return '$month · $amount ₽';
  }

  @override
  String get portfolioIncomeUpcoming => 'Kommende Cashflows';

  @override
  String get portfolioIncomeCoupon => 'Coupon';

  @override
  String get portfolioIncomeCouponEstimate => 'Gutschein (geschätzt)';

  @override
  String get portfolioIncomeMaturity => 'Nennwert bei Fälligkeit';

  @override
  String get portfolioIncomeDividendEstimate => 'Dividenden (geschätzt)';

  @override
  String get userCalendarTitle => 'Ereigniskalender';

  @override
  String get userCalendarShare => 'Kalender teilen';

  @override
  String get userCalendarShareEmpty => 'Keine Ereignisse zum Teilen';

  @override
  String userCalendarShareMore(int count) {
    return '…und $count weitere Ereignisse';
  }

  @override
  String get userCalendarExportIcs => '.ics exportieren';

  @override
  String get userCalendarExportIcsEmpty =>
      'Keine manuellen Ereignisse zum Export';

  @override
  String get userCalendarImportIcs => '.ics importieren';

  @override
  String get userCalendarImportIcsHint => 'Kalendertext (.ics) einfügen';

  @override
  String get userCalendarImportIcsFile => 'Aus Datei';

  @override
  String get userCalendarImportIcsEmpty => 'Keine Ereignisse im Text gefunden';

  @override
  String userCalendarImportIcsDone(int count) {
    return '$count Ereignisse importiert';
  }

  @override
  String get userCalendarDuplicateEvent => 'Duplizieren';

  @override
  String get userCalendarViewDetails => 'Details anzeigen';

  @override
  String get userCalendarDuplicateDone => 'Ereignis dupliziert';

  @override
  String get userCalendarDuplicateSuffix => ' (Kopie)';

  @override
  String userCalendarDayEvents(String date) {
    return 'Ereignisse am $date';
  }

  @override
  String get userCalendarSubtitle => 'Ihre Ereignisse und Portfolio-Cashflows';

  @override
  String get userCalendarAddEvent => 'Ereignis hinzufügen';

  @override
  String get userCalendarEditEvent => 'Ereignis bearbeiten';

  @override
  String get userCalendarShowPortfolio => 'Portfolio-Ereignisse';

  @override
  String get userCalendarShowPortfolioHint =>
      'Coupons, Dividenden und Fälligkeiten aus dem Papierportfolio';

  @override
  String get userCalendarHorizon30 => '30 T.';

  @override
  String get userCalendarHorizon90 => '90 T.';

  @override
  String get userCalendarHorizon365 => '1 J.';

  @override
  String get userCalendarTotalsTitle => 'Summen für Zeitraum';

  @override
  String get userCalendarTotalsEmpty => 'Keine Beträge im gewählten Zeitraum';

  @override
  String get userCalendarByMonth => 'Nach Monat';

  @override
  String get userCalendarUpcoming => 'Ereignisse';

  @override
  String get userCalendarEmpty =>
      'Keine Ereignisse. Tippen Sie + zum Hinzufügen.';

  @override
  String get userCalendarManualBadge => 'Mein';

  @override
  String get userCalendarPortfolioBadge => 'Portfolio';

  @override
  String get userCalendarEstimateBadge => 'gesch.';

  @override
  String get userCalendarFieldTitle => 'Titel';

  @override
  String get userCalendarFieldTitleHint => 'z. B. SU26238 Couponzahlung';

  @override
  String get userCalendarFieldDate => 'Datum';

  @override
  String get userCalendarFieldAmount => 'Betrag';

  @override
  String get userCalendarFieldAmountHint => 'Optional';

  @override
  String get userCalendarFieldCurrency => 'Währung';

  @override
  String get userCalendarFieldNote => 'Notiz';

  @override
  String get userCalendarFieldNoteHint => 'Kommentar zum Ereignis';

  @override
  String get userCalendarAttachFile => 'Datei anhängen';

  @override
  String get userCalendarRemoveAttachment => 'Anhang entfernen';

  @override
  String get userCalendarAttachmentFailed =>
      'Datei konnte nicht angehängt werden (max. 5 MB, PDF oder Bild)';

  @override
  String get userCalendarSave => 'Speichern';

  @override
  String get userCalendarDelete => 'Löschen';

  @override
  String get userCalendarDeleteConfirm => 'Dieses Ereignis löschen?';

  @override
  String get userCalendarSaved => 'Ereignis gespeichert';

  @override
  String get userCalendarDeleted => 'Ereignis gelöscht';

  @override
  String get userCalendarOpenAll => 'Alle Ereignisse';

  @override
  String get userCalendarViewAttachment => 'Anhang öffnen';

  @override
  String get userCalendarAttachmentShare => 'Teilen';

  @override
  String userCalendarAttachmentPdfSize(int kb) {
    return '$kb KB';
  }

  @override
  String get userCalendarAttachmentPdfHint =>
      'Auf dem Handy PDF über Teilen öffnen. Im Web wird die Datei unten angezeigt.';

  @override
  String get userCalendarFieldRecurrence => 'Wiederholung';

  @override
  String get userCalendarRecurrenceNone => 'Einmalig';

  @override
  String get userCalendarRecurrenceMonthly => 'Monatlich';

  @override
  String get userCalendarRecurrenceYearly => 'Jährlich';

  @override
  String get userCalendarFieldReminders => 'Erinnerungen';

  @override
  String userCalendarReminderDays(int days) {
    return '$days T. vorher';
  }

  @override
  String get userCalendarHubTitle => 'Ereigniskalender';

  @override
  String get userCalendarHubSubtitle =>
      'Coupons, Zahlungen und Ihre Erinnerungen';

  @override
  String get userArticlesTitle => 'Artikel';

  @override
  String get userArticlesFeedTab => 'Aktuelles';

  @override
  String get userArticlesMineTab => 'Meine';

  @override
  String get userArticlesWrite => 'Artikel schreiben';

  @override
  String get userArticlesWriteHint =>
      'Der Artikel wird moderiert, bevor er im Feed erscheint.';

  @override
  String get userArticlesFieldTitle => 'Titel';

  @override
  String get userArticlesFieldTitleHint => 'Worum geht es';

  @override
  String get userArticlesFieldBody => 'Text';

  @override
  String get userArticlesFieldBodyHint => 'Mindestens 10 Zeichen';

  @override
  String get userArticlesDraftRestored => 'Entwurf wiederhergestellt';

  @override
  String get userArticlesContinueDraft =>
      'Unvollständiger Artikelentwurf vorhanden';

  @override
  String get userArticlesContinueDraftAction => 'Fortsetzen';

  @override
  String get userArticlesShareToChat => 'An Selbst-Chat senden';

  @override
  String get userArticlesShareToChatDone => 'Artikel an Selbst-Chat gesendet';

  @override
  String get userArticlesShareToChatFailed => 'Senden an Chat fehlgeschlagen';

  @override
  String get userArticlesDetailMenu => 'Artikelaktionen';

  @override
  String get userArticlesDraftClear => 'Löschen';

  @override
  String get userArticlesDraftCleared => 'Entwurf gelöscht';

  @override
  String get userArticlesMarkdownHeading => 'Überschrift';

  @override
  String get userArticlesMarkdownList => 'Liste';

  @override
  String get userArticlesMarkdownLink => 'Verknüpfung';

  @override
  String get userArticlesMarkdownBold => 'Fett';

  @override
  String get userArticlesMarkdownItalic => 'Kursiv';

  @override
  String get userArticlesMarkdownQuote => 'Zitat';

  @override
  String get userArticlesMarkdownCode => 'Code';

  @override
  String get userArticlesMarkdownCodeBlock => 'Codeblock';

  @override
  String get userArticlesMarkdownImage => 'Bild';

  @override
  String get userArticlesMarkdownEmbed => 'YouTube';

  @override
  String get userArticlesMarkdownDivider => 'Trenner';

  @override
  String get userArticlesMarkdownStrikethrough => 'Durchgestrichen';

  @override
  String get userArticlesMarkdownNumberedList => 'Nummerierte Liste';

  @override
  String get userArticlesMarkdownHeading1 => 'Überschrift 1';

  @override
  String get userArticlesMarkdownHeading2 => 'Überschrift 2';

  @override
  String get userArticlesMarkdownHeading3 => 'Überschrift 3';

  @override
  String get userArticlesMarkdownTable => 'Tabelle';

  @override
  String get userArticlesLinkUrlPrompt => 'Link-URL';

  @override
  String get userArticlesTabEdit => 'Bearbeiten';

  @override
  String get userArticlesTabPreview => 'Vorschau';

  @override
  String get userArticlesPreviewEmpty => 'Noch nichts zur Vorschau';

  @override
  String get userArticlesImageUrlPrompt => 'Bild-URL';

  @override
  String get userArticlesEmbedUrlPrompt => 'YouTube-Link';

  @override
  String get userArticlesUrlHint => 'https://';

  @override
  String get userArticlesEmbedInvalid => 'Gültigen YouTube-Link einfügen';

  @override
  String get userArticlesSubmit => 'Zur Moderation senden';

  @override
  String get userArticlesSubmitted => 'Artikel zur Moderation gesendet';

  @override
  String get userArticlesNeedLogin =>
      'Melden Sie sich am Server an, um Artikel zu lesen und zu schreiben';

  @override
  String get userArticlesFeedEmpty => 'Noch keine veröffentlichten Artikel';

  @override
  String get userArticlesMineEmpty =>
      'Sie haben noch keine Artikel eingereicht';

  @override
  String get userArticlesDetailTitle => 'Artikel';

  @override
  String get userArticlesNotFound => 'Artikel nicht gefunden';

  @override
  String get userArticlesStatusPending => 'Ausstehend';

  @override
  String get userArticlesStatusApproved => 'Veröffentlicht';

  @override
  String get userArticlesStatusRejected => 'Abgelehnt';

  @override
  String get userArticlesRejectReason => 'Ablehnungsgrund';

  @override
  String get userArticlesModerationTitle => 'Artikelmoderation';

  @override
  String get userArticlesModerationHubSubtitle =>
      'Benutzerartikel freigeben oder ablehnen';

  @override
  String get userArticlesModerationNeedLogin =>
      'Für Moderation am Server anmelden';

  @override
  String get userArticlesModerationNotAdmin =>
      'Server-Adminrechte erforderlich';

  @override
  String get userArticlesModerationEmpty => 'Keine Artikel zur Moderation';

  @override
  String get userArticlesModerationOpen => 'Öffnen';

  @override
  String get userArticlesModerationApprove => 'Genehmigen';

  @override
  String get userArticlesModerationReject => 'Ablehnen';

  @override
  String get userArticlesModerationApproved => 'Artikel veröffentlicht';

  @override
  String get userArticlesModerationRejected => 'Artikel abgelehnt';

  @override
  String get userArticlesErrorNeedLogin =>
      'Melden Sie sich am Server an, um Artikel zu nutzen';

  @override
  String get userArticlesErrorUnauthorized =>
      'Sitzung abgelaufen — erneut anmelden';

  @override
  String get userArticlesErrorForbidden => 'Unzureichende Berechtigungen';

  @override
  String get userArticlesErrorNotFound =>
      'Artikel auf dem Server nicht gefunden';

  @override
  String get userArticlesErrorTitleRequired => 'Artikelüberschrift eingeben';

  @override
  String get userArticlesErrorBodyRequired => 'Artikeltext hinzufügen';

  @override
  String get userArticlesErrorInvalidPayload => 'Ungültige Artikeldaten';

  @override
  String get userArticlesErrorTitleTooShort => 'Titel zu kurz';

  @override
  String get userArticlesErrorTitleTooLong => 'Titel zu lang';

  @override
  String get userArticlesErrorBodyTooShort => 'Text zu kurz';

  @override
  String get userArticlesErrorBodyTooLong => 'Text zu lang';

  @override
  String get userArticlesErrorInvalidStatus =>
      'Artikel in diesem Status nicht änderbar';

  @override
  String get userArticlesErrorServer => 'Artikel-Server nicht erreichbar';

  @override
  String get userArticlesNotifyTitle => 'Artikelstatus';

  @override
  String get userArticlesNotifySubtitle =>
      'Benachrichtigung bei Freigabe oder Ablehnung';

  @override
  String get userArticlesModerationNotifyTitle => 'Moderations-Warteschlange';

  @override
  String get userArticlesModerationNotifySubtitle =>
      'Benachrichtigung bei neuen Artikeln zur Prüfung';

  @override
  String get userArticlesShare => 'Artikel teilen';

  @override
  String get userArticlesSearchHint => 'Suche nach Titel oder Autor';

  @override
  String get userArticlesSearchEmpty => 'Keine Treffer';

  @override
  String userArticlesReadingTime(int minutes) {
    return '$minutes Min. Lesezeit';
  }

  @override
  String get userArticlesCopy => 'Kopieren';

  @override
  String get userArticlesCopied => 'Artikeltext kopiert';

  @override
  String get userArticlesStaleCache =>
      'Gespeicherte Artikel — Server nicht erreichbar';

  @override
  String get userArticlesSavedOffline =>
      'Lokal gespeichert — Sync bei Verbindung';

  @override
  String userArticlesPendingSync(int count) {
    return '$count Änderungen warten auf Sync';
  }

  @override
  String get userArticlesSyncConflictBanner =>
      'Artikeländerung kollidiert mit der Serverversion';

  @override
  String get userArticlesSyncResolve => 'Auflösen';

  @override
  String get userArticlesSyncConflictTitle => 'Artikelkonflikt';

  @override
  String get userArticlesSyncConflictMessage =>
      'Auf dem Server gibt es eine neuere Version. Ihre Änderungen behalten oder Serverversion verwenden?';

  @override
  String userArticlesSyncConflictLocal(String title) {
    return 'Ihre Version: $title';
  }

  @override
  String userArticlesSyncConflictServer(String title) {
    return 'Serverversion: $title';
  }

  @override
  String get userArticlesSyncKeepLocal => 'Meine behalten';

  @override
  String get userArticlesSyncUseServer => 'Server verwenden';

  @override
  String get userArticlesSortLabel => 'Sortierung:';

  @override
  String get userArticlesSortNewest => 'Neueste';

  @override
  String get userArticlesSortOldest => 'Älteste';

  @override
  String get userArticlesFilterAll => 'Alle';

  @override
  String get userArticlesResubmit => 'Erneut einreichen';

  @override
  String get userArticlesEdit => 'Bearbeiten';

  @override
  String get userArticlesSave => 'Speichern';

  @override
  String get userArticlesUpdated => 'Artikel aktualisiert';

  @override
  String get userArticlesDelete => 'Löschen';

  @override
  String get userArticlesDeleteConfirm =>
      'Diesen Artikel löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get userArticlesDeleted => 'Artikel gelöscht';

  @override
  String get userArticlesBookmark => 'Lesezeichen';

  @override
  String get userArticlesLoadMore => 'Mehr laden';

  @override
  String get userArticlesShareBookmarks => 'Lesezeichen teilen';

  @override
  String get userArticlesShareBookmarksEmpty => 'Keine Lesezeichen zum Teilen';

  @override
  String get userArticlesUnreadOnly => 'Ungelesen';

  @override
  String get userArticlesMarkAllRead => 'Alle als gelesen';

  @override
  String get userArticlesMarkRead => 'Als gelesen markieren';

  @override
  String get userArticlesMarkUnread => 'Als ungelesen markieren';

  @override
  String get userArticlesSavedOnly => 'Gespeichert';

  @override
  String userArticlesAuthorFilter(String name) {
    return 'Autor: $name';
  }

  @override
  String get userArticlesDetailStaleCache =>
      'Gespeicherte Version — Server nicht erreichbar';

  @override
  String get userCalendarImportFromPortfolio => 'Zum Kalender hinzufügen';

  @override
  String get userCalendarImportFromPortfolioDone =>
      'Ereignis zum Kalender hinzugefügt';

  @override
  String get userCalendarImportPortfolioBatch =>
      'Portfolio-Ereignisse importieren';

  @override
  String userCalendarImportPortfolioBatchConfirm(int count) {
    return '$count Portfolio-Ereignisse in den Kalender importieren?';
  }

  @override
  String userCalendarImportPortfolioBatchDone(int count) {
    return '$count Portfolio-Ereignisse importiert';
  }

  @override
  String get userCalendarImportPortfolioBatchEmpty =>
      'Alle Portfolio-Ereignisse sind bereits im Kalender';

  @override
  String get userCalendarImportPortfolioEstimateNote => 'Portfolioschätzung';

  @override
  String get userLocalDataSyncTitle => 'Gerätedaten-Sync';

  @override
  String get userLocalDataSyncSubtitle =>
      'Avatar, Kalender, Lesezeichen, Gelesen-Status, Chat-Einstellungen und Artikelentwurf';

  @override
  String get userLocalDataSyncPush => 'Hochladen';

  @override
  String get userLocalDataSyncPull => 'Herunterladen';

  @override
  String get userLocalDataSyncSmart => 'Smart Sync';

  @override
  String get userLocalDataSyncPushed => 'Daten auf Server hochgeladen';

  @override
  String get userLocalDataSyncPulled => 'Daten vom Server geladen';

  @override
  String get userLocalDataSyncDone => 'Synchronisation abgeschlossen';

  @override
  String userLocalDataSyncLast(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Letzte Sync: $dateString';
  }

  @override
  String get userLocalDataSyncWifiOnly => 'Nur über Wi‑Fi';

  @override
  String get userLocalDataSyncWifiOnlySubtitle =>
      'Auto-Sync bei Anmeldung und App-Rückkehr';

  @override
  String get userLocalDataSyncConflictTitle => 'Datenkonflikt';

  @override
  String get userLocalDataSyncConflictMessage =>
      'Kalender, Avatar und Community-Einstellungen unterscheiden sich auf Server und Gerät. Welche Version behalten?';

  @override
  String get userLocalDataSyncKeepLocal => 'Dieses Gerät';

  @override
  String get userLocalDataSyncUseRemote => 'Vom Server';

  @override
  String get userLocalDataSyncAutoPush => 'Auto-Upload zum Server';

  @override
  String get userLocalDataSyncAutoPushSubtitle =>
      'Nach Kalender-, Avatar- oder Community-Änderungen (2 s Verzögerung)';

  @override
  String get portfolioScenarioTitle => 'Was-wäre-wenn-Szenarien';

  @override
  String get portfolioScenarioSubtitle => 'Portfoliowert unter Marktschocks';

  @override
  String get portfolioScenarioUsdUp10 => 'USD/RUB +10 %';

  @override
  String get portfolioScenarioBtcDown30 => 'BTC −30 %';

  @override
  String get portfolioScenarioImoexDown15 => 'IMOEX −15 %';

  @override
  String get portfolioScenarioKeyRateUp2 => 'Preis +2 pP';

  @override
  String portfolioScenarioResult(String base, String scenario) {
    return '$base → $scenario';
  }

  @override
  String portfolioScenarioDelta(String amount, String percent) {
    return 'Δ $amount ($percent)';
  }

  @override
  String get portfolioRealReturnTitle => 'Echte Rendite';

  @override
  String get portfolioRealReturnSubtitle =>
      'Nominal minus Inflation · gegenüber IMOEX und Einlage';

  @override
  String get portfolioRealReturnHorizon30d => '30 days';

  @override
  String get portfolioRealReturnHorizonAll => 'Seit Beginn';

  @override
  String get portfolioRealReturnNominal => 'Portfolio (nominal)';

  @override
  String get portfolioRealReturnReal => 'Portfolio (real)';

  @override
  String get portfolioRealReturnInflation => 'Inflation (RU)';

  @override
  String get portfolioRealReturnImoex => 'IMOEX';

  @override
  String get portfolioRealReturnDeposit => 'Anzahlung (CBR-Satz)';

  @override
  String portfolioRealReturnBeatInflation(String value) {
    return 'Reale Rendite $value – übertrifft die Inflation';
  }

  @override
  String portfolioRealReturnLoseInflation(String value) {
    return 'Reale Rendite $value – unter der Inflation';
  }

  @override
  String portfolioRealReturnBeatImoex(String delta) {
    return 'Vor IMOEX um $delta';
  }

  @override
  String portfolioRealReturnLoseImoex(String delta) {
    return 'Hinter IMOEX von $delta';
  }

  @override
  String get portfolioRealReturnBeatDeposit =>
      'Einzahlung über einem Zinssatz von CBR';

  @override
  String get portfolioRealReturnLoseDeposit => 'Einzahlungszins unter CBR';

  @override
  String get watchlistVolatilityTitle => 'Volatilität der Beobachtungsliste';

  @override
  String get watchlistVolatilitySubtitle =>
      'Jährlicher σ aus täglichen Erträgen · ~30d Sparkline';

  @override
  String watchlistVolatilityAnnual(String value) {
    return 'σ $value';
  }

  @override
  String get watchlistVolatilityLow => 'Niedrig';

  @override
  String get watchlistVolatilityHigh => 'Hoch';

  @override
  String get portfolioTradeJournalTitle => 'Fachzeitschrift';

  @override
  String get portfolioTradeJournalSubtitle =>
      'Kauf- und Verkaufshistorie für das Papierportfolio';

  @override
  String get portfolioTradeJournalEmpty =>
      'Noch keine Trades · Von der Beobachtungsliste kaufen';

  @override
  String get portfolioTradeJournalBuy => 'Kaufen';

  @override
  String get portfolioTradeJournalSell => 'Verkaufen';

  @override
  String get portfolioTradeJournalOpenAll => 'Alle';

  @override
  String get portfolioTradeJournalExport => 'CSV exportieren';

  @override
  String portfolioTradeJournalStats(int total, int buys, int sells) {
    return '$total handelt · $buys kauft · $sells verkauft';
  }

  @override
  String portfolioTradeJournalRealizedPnl(String value) {
    return 'Realisiert P&L: $value';
  }

  @override
  String get portfolioTradeJournalImport => 'CSV importieren';

  @override
  String get portfolioTradeJournalImportHint =>
      'CSV-Export von EcoPulse oder Broker einfügen';

  @override
  String get portfolioTradeJournalImportEmpty =>
      'In der Datei wurden keine Trades gefunden';

  @override
  String portfolioTradeJournalImportDone(int added, int skipped) {
    return '$added-Geschäfte importiert · $skipped übersprungen';
  }

  @override
  String portfolioTradeJournalImportError(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get portfolioTaxTitle => 'Steuerschätzung';

  @override
  String get portfolioTaxSubtitle =>
      'Lokale NDFL Schätzung aus Fachzeitschrift · keine Steuerberatung';

  @override
  String get portfolioTaxOpenDetails => 'Einzelheiten';

  @override
  String get portfolioTaxExport => 'CSV exportieren';

  @override
  String get portfolioTaxEmpty =>
      'Für dieses Jahr gibt es keine steuerpflichtigen Ereignisse';

  @override
  String get portfolioTaxNetRealized => 'Netto realisiert P&L';

  @override
  String get portfolioTaxEstimatedNdfl => 'Geschätzte NDFL';

  @override
  String get portfolioTaxPassiveIncome => 'Schätzung: Coupons und Dividenden';

  @override
  String get portfolioTaxPassiveTax =>
      'Schätzung: Steuer auf passives Einkommen';

  @override
  String get portfolioTaxRealizedGain => 'Realisierte Gewinne';

  @override
  String get portfolioTaxRealizedLoss => 'Realisierte Verluste';

  @override
  String get portfolioTaxTaxableBase => 'Besteuerungsgrundlage';

  @override
  String get portfolioTaxSellCount => 'Trades verkaufen';

  @override
  String get portfolioTaxUnrealizedGain => 'Nicht realisierte Gewinne (Info)';

  @override
  String get portfolioTaxUnrealizedLoss => 'Nicht realisierte Verluste (Info)';

  @override
  String get portfolioTaxSectionTrading => 'Handelserträge';

  @override
  String get portfolioTaxSectionPassive => 'Coupons und Dividenden (geschätzt)';

  @override
  String get portfolioTaxSectionUnrealized => 'Offene Stellen';

  @override
  String get portfolioTaxTotalLabel => 'Geschätzte Gesamtsteuer';

  @override
  String portfolioTaxRateLabel(String rate) {
    return 'Rate $rate% · vereinfacht';
  }

  @override
  String get portfolioTaxIisNote =>
      'IIS-Konto: Die Steuer kann gemäß den Typ-A/B-Regeln reduziert werden – erkundigen Sie sich bei Ihrem Broker.';

  @override
  String get portfolioTaxDisclaimer =>
      'Nur pädagogische Schätzung. Tarife, Ausnahmen und IIS-Regeln ändern sich. EcoPulse gibt keine Steuererklärungen ab.';

  @override
  String get portfolioTaxSellsHeader => 'Verkaufen Sie dieses Jahr Trades';

  @override
  String portfolioTaxSellPnl(String value) {
    return 'P&L: $value';
  }

  @override
  String get portfolioRoboTitle => 'Robo-Advisor Lite';

  @override
  String get portfolioRoboSubtitle =>
      'Allokationsvorschlag basierend auf Kontotyp, Zielen und Marktstimmung';

  @override
  String portfolioRoboRecommended(String preset) {
    return 'Empfohlen: $preset';
  }

  @override
  String portfolioRoboRiskScore(int score) {
    return 'Risikoprofil: $score/100';
  }

  @override
  String get portfolioRoboActionsHeader => 'Vorrangige Maßnahmen';

  @override
  String portfolioRoboApplyPreset(String preset) {
    return 'Verwenden Sie die $preset-Zuordnung';
  }

  @override
  String get portfolioRoboDisclaimer =>
      'Nur pädagogischer Vorschlag. Keine Anlageberatung. Bestätigen Sie mit Ihrem eigenen Plan.';

  @override
  String get portfolioRoboReasonIis =>
      'IIS-Konto – ein langer Horizont begünstigt Bindungen und Stabilität';

  @override
  String get portfolioRoboReasonCrypto =>
      'Kryptokonto – höheres Wachstumsziel mit mehr Kryptogewicht';

  @override
  String get portfolioRoboReasonUsd =>
      'USD-Konto – ausgewogener Mix mit globalen Aktien';

  @override
  String get portfolioRoboReasonShortGoal =>
      'Zielfrist innerhalb von 2 Jahren – geringere Risikoallokation';

  @override
  String get portfolioRoboReasonLongGoal =>
      'Langfristiges Ziel – Raum für Wachstumsvermögen';

  @override
  String get portfolioRoboReasonFngHigh =>
      'Angst und Gier sind hoch – Risiko reduzieren, FOMO vermeiden';

  @override
  String get portfolioRoboReasonFngLow =>
      'Die Marktangst ist groß – bleiben Sie diszipliniert und geraten Sie nicht in Panik, wenn Sie verkaufen';

  @override
  String get portfolioRoboReasonEmpty =>
      'Leeres Portfolio – beginnen Sie mit einer ausgewogenen Mischung';

  @override
  String get portfolioRoboReasonHighCash =>
      'Hoher Cash-Anteil – erwägen Sie die Investition ungenutzter Barmittel';

  @override
  String get portfolioRoboReasonHighCrypto =>
      'Krypto-Übergewichtung – Neugewichtung hin zu Aktien und Anleihen';

  @override
  String get portfolioRoboReasonDefault =>
      'Ausgewogener Mix passt zu Ihrem aktuellen Profil';

  @override
  String get cloudSyncTitle => 'Cloud-Synchronisierung';

  @override
  String get cloudSyncSubtitle =>
      'Synchronisierung über JSON-Datei · Google-Laufwerk, Telegram, E-Mail';

  @override
  String get cloudSyncStatusSynced => 'Daten werden synchronisiert';

  @override
  String get cloudSyncStatusPending =>
      'Lokale Änderungen – Synchronisierungsdatei exportieren';

  @override
  String get cloudSyncStatusNever => 'Noch nicht synchronisiert';

  @override
  String cloudSyncLastOut(String date) {
    return 'Gesendet: $date';
  }

  @override
  String cloudSyncLastIn(String date) {
    return 'Geladen: $date';
  }

  @override
  String get cloudSyncExport => 'Schicken';

  @override
  String get cloudSyncImport => 'Laden';

  @override
  String get cloudSyncExportDone =>
      'Synchronisierungsdatei bereit – in der Cloud speichern';

  @override
  String cloudSyncImportSuccess(int count) {
    return '$count Datenschlüssel geladen';
  }

  @override
  String get cloudSyncImportNotNewer =>
      'Die Datei ist nicht neuer als die Daten auf diesem Gerät';

  @override
  String get cloudSyncShareSubject => 'EcoPulse-Synchronisierung';

  @override
  String cloudSyncError(String message) {
    return 'Synchronisierungsfehler: $message';
  }

  @override
  String get adminCrashReports => 'Absturzberichte';

  @override
  String get assistantTitle => 'EcoPulse Assistent';

  @override
  String get assistantHint =>
      'Fragen Sie nach Preisen, Briefings oder Portfolios …';

  @override
  String get assistantThinking => 'Denken…';

  @override
  String get assistantDisclaimer => 'Keine Anlageberatung';

  @override
  String get assistantClearHistory => 'Klarer Chat';

  @override
  String get assistantVoiceListen => 'Hören';

  @override
  String get assistantSourceLocal => 'lokal';

  @override
  String get assistantSourceCloud => 'Gemini';

  @override
  String get assistantQuickPrice => 'USD/RUB';

  @override
  String get assistantQuickBrief => 'Knapp';

  @override
  String get assistantQuickPortfolio => 'Portfolio';

  @override
  String get assistantQuickExplain => 'Inflation';

  @override
  String get assistantQuickPriceQuery => 'USD-Rub-Kurs';

  @override
  String get assistantQuickBriefQuery => 'heute kurz';

  @override
  String get assistantQuickPortfolioQuery => 'mein Portfolio';

  @override
  String get assistantQuickExplainQuery => 'Was ist Inflation?';

  @override
  String get settingsGeminiKey => 'Gemini API Schlüssel';

  @override
  String get courseLibraryTitle => 'Kurse';

  @override
  String get courseLibrarySubtitle =>
      'Bildung in den Bereichen Investieren und persönliche Finanzen';

  @override
  String get courseDisclaimer =>
      'EcoPulse Bildungsinhalte. Keine Anlageberatung.';

  @override
  String get courseHomeCardTitle => 'Anlegerkurs';

  @override
  String courseChaptersCount(int count) {
    return '$count Kapitel';
  }

  @override
  String courseReadMinutes(int minutes) {
    return '~$minutes Min. gelesen';
  }

  @override
  String courseProgressPercent(int percent) {
    return '$percent% abgeschlossen';
  }

  @override
  String get courseStartReading => 'Lesen';

  @override
  String get courseReadFromStart => 'Von Anfang an';

  @override
  String get courseContinue => 'Weitermachen';

  @override
  String get courseTableOfContents => 'Inhaltsverzeichnis';

  @override
  String courseChapterProgress(int current, int total) {
    return 'Kapitel $current von $total';
  }

  @override
  String get courseChapterDone => 'Erledigt';

  @override
  String get courseMarkRead => 'Mark hat gelesen';

  @override
  String get courseMarkedRead => 'Kapitel als gelesen markiert';

  @override
  String get coursePrevChapter => 'Zurück';

  @override
  String get courseNextChapter => 'Nächste';

  @override
  String get courseFinish => 'Beenden';

  @override
  String get homeSectionLearn => 'Kurse';

  @override
  String get assistantQuickCourse => 'Kurs';

  @override
  String get assistantQuickCourseQuery => 'offener Anlagekurs';

  @override
  String coursePagesCount(int pages) {
    return '~$pages pp.';
  }

  @override
  String courseChapterShort(int current, int total) {
    return 'Kap. $current/$total';
  }

  @override
  String get courseReaderSettings => 'Leseeinstellungen';

  @override
  String get courseFontSize => 'Schriftgröße';

  @override
  String get courseReadingTheme => 'Thema';

  @override
  String get courseThemeSystem => 'System';

  @override
  String get courseThemeSepia => 'Sepia';

  @override
  String get courseThemeDark => 'Dunkel';

  @override
  String get courseSearch => 'Buch durchsuchen';

  @override
  String get courseSearchHint => 'Stichwort…';

  @override
  String get courseSearchEmpty => 'Keine Ergebnisse';

  @override
  String get courseSearchClose => 'Schließen';

  @override
  String courseQuizProgress(int current, int total) {
    return 'Frage $current von $total';
  }

  @override
  String get courseQuizNext => 'Einreichen';

  @override
  String get courseQuizPassed => 'Großartig! Teil komplett';

  @override
  String get courseQuizRetry => 'Versuchen Sie es erneut';

  @override
  String courseQuizScore(int correct, int total) {
    return 'Richtig: $correct von $total';
  }

  @override
  String get courseQuizContinue => 'Lesen Sie weiter';

  @override
  String get courseQuizTryAgain => 'Wiederholen Sie das Quiz';

  @override
  String get homeServerTitle => 'Heimserver';

  @override
  String get homeServerSubtitle =>
      'LAN-Backend auf Ihrem PC für Profil-ID und Chats';

  @override
  String get homeServerUrlLabel => 'Server-URL';

  @override
  String get homeServerUrlHint => 'http://192.168.1.105:8081';

  @override
  String get homeServerIpHint =>
      'Führen Sie auf dem PC ipconfig aus und verwenden Sie IPv4 vom Wi-Fi-Adapter';

  @override
  String get homeServerCheckConnection => 'Verbindung prüfen';

  @override
  String get homeServerStatusOnline => 'Online';

  @override
  String get homeServerStatusOffline => 'Offline';

  @override
  String get homeServerStatusUnknown => 'Nicht geprüft';

  @override
  String get homeServerLogin => 'anmelden';

  @override
  String get homeServerRegister => 'Registrieren';

  @override
  String get homeServerLoginLabel => 'Login';

  @override
  String get homeServerPasswordLabel => 'Passwort';

  @override
  String get homeServerProfileId => 'ProDatei-ID';

  @override
  String get homeServerCopyProfileId => 'Kopieren Sie die Datei-ID Pro';

  @override
  String get homeServerProfileIdCopied => 'ProDatei-ID kopiert';

  @override
  String homeServerLoggedInAs(String login) {
    return 'Angemeldet als $login';
  }

  @override
  String get homeServerLogout => 'Abmelden';

  @override
  String get homeServerSwitchAccount => 'Konto wechseln';

  @override
  String get homeServerEnsureSelfChat =>
      'Stellen Sie sicher, dass Sie selbst chatten';

  @override
  String get homeServerSelfChatReady => 'Der Selbstchat ist fertig';

  @override
  String get homeServerRegisterSuccess => 'Registrierung erfolgreich';

  @override
  String get homeServerLoginSuccess => 'Angemeldet';

  @override
  String get homeServerLoggedOut => 'Abgemeldet';

  @override
  String get homeServerCreateTestAccount => 'Erstellen Sie ein test2-Konto';

  @override
  String get homeServerTestAccountCreated =>
      'Konto test2 erstellt (oder existiert bereits)';

  @override
  String get homeServerErrorLoginTaken => 'Anmeldung bereits vergeben';

  @override
  String get homeServerErrorInvalidCredentials =>
      'Ungültiger Benutzername oder Passwort';

  @override
  String get homeServerErrorLoginShort =>
      'Der Login muss mindestens 3 Zeichen lang sein';

  @override
  String get homeServerErrorPasswordShort =>
      'Das Passwort muss mindestens 4 Zeichen lang sein';

  @override
  String get homeServerErrorUpgrade =>
      'Für diesen Server ist ein App-Update erforderlich';

  @override
  String get homeServerErrorNoUrl => 'Geben Sie zuerst die Server-URL ein';

  @override
  String get homeServerErrorNetwork =>
      'Server kann nicht erreicht werden – überprüfen Sie Wi-Fi und Firewall';

  @override
  String get homeServerErrorRateLimit =>
      'Zu viele Anfragen – bitte kurz warten und erneut versuchen';

  @override
  String get cloudAccountTitle => 'EcoPulse Wolke';

  @override
  String get cloudAccountSubtitle =>
      'Profil und Watchlist über Supabase synchronisieren';

  @override
  String get cloudAccountNotConfigured =>
      'Erstellen Sie mit --dart-define=SUPABASE_URL und SUPABASE_ANON_KEY, um die Cloud-Synchronisierung zu aktivieren.';

  @override
  String get cloudEmailLabel => 'E-Mail';

  @override
  String get cloudPasswordLabel => 'Passwort';

  @override
  String get cloudLogin => 'anmelden';

  @override
  String get cloudRegister => 'Benutzerkonto erstellen';

  @override
  String get cloudSignInGoogle => 'Weiter mit Google';

  @override
  String get cloudSwitchToLogin => 'Sie haben bereits ein Konto? anmelden';

  @override
  String get cloudSwitchToRegister => 'Neu hier? Benutzerkonto erstellen';

  @override
  String get cloudLoginSuccess => 'Bei EcoPulse Cloud angemeldet';

  @override
  String get cloudRegisterSuccess =>
      'Konto erstellt – E-Mails prüfen, ob eine Bestätigung erforderlich ist';

  @override
  String get cloudLoggedOut => 'Aus der Cloud abgemeldet';

  @override
  String cloudLoggedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String get cloudLogout => 'Abmelden';

  @override
  String get cloudSyncPush => 'Hochladen';

  @override
  String get cloudSyncPull => 'Herunterladen';

  @override
  String get cloudSyncPushSuccess =>
      'ProDatei und Beobachtungsliste hochgeladen';

  @override
  String get cloudSyncPullSuccess =>
      'ProDatei und Beobachtungsliste heruntergeladen';

  @override
  String get cloudSyncFailed => 'Die Cloud-Synchronisierung ist fehlgeschlagen';

  @override
  String get cloudSyncNever => 'Noch nicht synchronisiert';

  @override
  String cloudSyncLastAt(String time) {
    return 'Letzte Synchronisierung: $time';
  }

  @override
  String get marketsTabletSelectAsset =>
      'Wählen Sie einen Vermögenswert aus, um das Diagramm anzuzeigen';

  @override
  String get messagePushTitle => 'Chat-Benachrichtigungen';

  @override
  String get messagePushSubtitle =>
      'Push, wenn eine neue Nachricht auf dem Heimserver eintrifft';

  @override
  String get messagePushRequiresServer =>
      'Melden Sie sich beim Heimserver an, um Chat-Push zu aktivieren';

  @override
  String get messagePushFcmReady =>
      'FCM aktiviert – sofortige Zustellung, wenn der Server Push sendet';

  @override
  String get marketsLiveBadge => 'LIVE';

  @override
  String get proTierTitle => 'EcoPulse Pro';

  @override
  String get proTierFreeTitle => 'Kostenloser Plan';

  @override
  String get proTierActiveTitle => 'Pro aktiv';

  @override
  String get proTierSubtitle =>
      'Unbegrenzte Warnungen, erweiterte Diagramme und Export ohne Einschränkungen.';

  @override
  String get proTierFreeBadge => 'Upgrade für unbegrenzte Benachrichtigungen';

  @override
  String get proTierActiveBadge => 'Pro Vorteile freigeschaltet';

  @override
  String get proTierComingSoon =>
      'In-App-Kauf bald verfügbar. Dev-Builds: im Admin-Panel aktivieren.';

  @override
  String get proBenefitAlertsTitle => 'Preisalarme';

  @override
  String proBenefitAlertsFree(int count) {
    return 'Bis zu $count aktive Warnungen';
  }

  @override
  String get proBenefitAlertsPro => 'Unbegrenzte aktive Benachrichtigungen';

  @override
  String get proBenefitChartsTitle => 'Erweiterte Diagramme';

  @override
  String get proBenefitChartsSub =>
      'Alle MA-Perioden, Indikatoren, Vollbildmodus';

  @override
  String get proBenefitExportTitle => 'Export';

  @override
  String get proBenefitExportSub =>
      'CSV/PDF ohne Wasserzeichen (in Kürze verfügbar)';

  @override
  String proAlertLimitReached(int count) {
    return 'Limit des kostenlosen Plans: $count Benachrichtigungen. Upgrade auf Pro.';
  }

  @override
  String get adminDashboardMetrics => 'Benutzermetriken';

  @override
  String get adminMetricWatchlist => 'Beobachtungsliste';

  @override
  String get adminMetricAlerts => 'Warnungen';

  @override
  String get adminMetricThreads => 'Chats';

  @override
  String get adminMetricPositions => 'Positionen';

  @override
  String get adminMetricServer => 'Server';

  @override
  String get adminFlagLiveCrypto => 'Live-Krypto WebSocket (Binance)';

  @override
  String get adminFlagProTier => 'EcoPulse Pro (Entsperrung durch Entwickler)';

  @override
  String get brokerConnectTitle => 'Connect-Broker (schreibgeschützt)';

  @override
  String get brokerConnectSubtitle =>
      'Sehen Sie sich neben dem Papierhandel auch ein echtes T-Bank-Portfolio an';

  @override
  String get brokerReadOnlyTitle => 'T-Bank · schreibgeschützt';

  @override
  String get brokerReadOnlyDisclaimer =>
      'Nur Ansicht – EcoPulse gibt niemals Bestellungen auf oder bewegt Gelder.';

  @override
  String get brokerTokenLabel => 'T-Invest API Token';

  @override
  String get brokerTokenHint =>
      'Schreibgeschütztes Token von tbank.ru/invest/settings';

  @override
  String get brokerRefresh => 'Aktualisieren';

  @override
  String get brokerAccountLabel => 'Brokerkonto';

  @override
  String brokerTotalValue(String value) {
    return 'Gesamt: $value';
  }

  @override
  String brokerSyncedAt(String time) {
    return 'Aktualisiert: $time';
  }

  @override
  String get brokerEmptyPositions => 'Keine Wertpapiere auf diesem Konto';

  @override
  String brokerMorePositions(int count) {
    return '+$count weitere Positionen';
  }

  @override
  String get messagesTitle => 'Nachrichten';

  @override
  String get messagesNewChat => 'Neuer Chat';

  @override
  String get messagesEmpty => 'Noch keine Chats';

  @override
  String get messagesMarkAllRead => 'Alle als gelesen';

  @override
  String get messagesFilterHint => 'Chats durchsuchen';

  @override
  String get messagesFilterEmpty => 'Keine Chats gefunden';

  @override
  String get messagesUnreadFirst => 'Ungelesen zuerst';

  @override
  String get messagesUnreadOnly => 'Nur ungelesen';

  @override
  String messagesShowHidden(int count) {
    return 'Ausgeblendet ($count)';
  }

  @override
  String get messagesUnhide => 'Wiederherstellen';

  @override
  String get messagesThreadPin => 'Anheften';

  @override
  String get messagesThreadMenu => 'Chat-Optionen';

  @override
  String get messagesThreadSearch => 'Im Chat suchen';

  @override
  String get messagesThreadSearchHint => 'Nachrichten suchen…';

  @override
  String get messagesThreadSearchEmpty => 'Keine passenden Nachrichten';

  @override
  String get messagesThreadSearchPrev => 'Vorheriger Treffer';

  @override
  String get messagesThreadSearchNext => 'Nächster Treffer';

  @override
  String messagesThreadSearchCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String get messagesOpenArticle => 'Artikel öffnen';

  @override
  String get messagesThreadUnpin => 'Loslösen';

  @override
  String get messagesThreadMute => 'Stumm schalten';

  @override
  String get messagesThreadUnmute => 'Stummschaltung aufheben';

  @override
  String get messagesThreadMarkRead => 'Als gelesen markieren';

  @override
  String get messagesThreadMarkUnread => 'Als ungelesen markieren';

  @override
  String get messagesThreadHide => 'Chat ausblenden';

  @override
  String get messagesLoadOlder => 'Frühere laden';

  @override
  String get messagesCopyText => 'Text kopieren';

  @override
  String get messagesShareText => 'Text teilen';

  @override
  String get messagesCopied => 'Kopiert';

  @override
  String get messagesNotConnected =>
      'Stellen Sie in den Einstellungen eine Verbindung zum Heimserver her, um Chats zu nutzen';

  @override
  String get messagesSelfChat => 'Schreiben Sie sich selbst eine Nachricht';

  @override
  String get messagesSearchHint => 'Suche nach Login oder ProDatei-ID';

  @override
  String get messagesSearchEmpty => 'Keine Benutzer gefunden';

  @override
  String get messagesInputHint => 'Nachricht…';

  @override
  String messagesTyping(String name) {
    return '$name tippt…';
  }

  @override
  String get messagesThreadEmpty =>
      'Noch keine Nachrichten – schreiben Sie die erste';

  @override
  String get profileIdLabel => 'ProDatei-ID';

  @override
  String get profileIdHint =>
      'UUID von Ihrem Heimserver – teilen Sie ihn, um einen Chat zu starten';

  @override
  String get customizationSectionTitle => 'Anpassung';

  @override
  String get customizationTitle => 'Anpassung';

  @override
  String get customizationSubtitle =>
      'Thema, Diagramme, Startseite und Navigation an einem Ort';

  @override
  String get customizationSettingsEntry => 'Alle Darstellungseinstellungen';

  @override
  String get customizationSettingsEntrySubtitle =>
      'Diagramme, Thema, Startseite, Navigation und Widgets';

  @override
  String get customizationPreview => 'Vorschau';

  @override
  String get customizationPreviewSample =>
      'Beispieldiagramm mit aktuellen Einstellungen';

  @override
  String customizationPreviewTheme(String mode) {
    return 'Thema: $mode';
  }

  @override
  String customizationPreviewAccent(String color) {
    return 'Akzent: $color';
  }

  @override
  String get customizationPreviewCarouselHint =>
      'Wischen Sie zur Vorschau des Diagramms, der Startseite, der Märkte, des Portfolios und der Navigation';

  @override
  String get customizationPreviewSlideChart => 'Diagramm';

  @override
  String get customizationPreviewSlideHome => 'Heim';

  @override
  String get customizationPreviewSlideMarkets => 'Märkte';

  @override
  String get customizationPreviewSlidePortfolio => 'Portfolio';

  @override
  String get customizationPreviewSlideNavigation => 'Navigation';

  @override
  String get customizationPreviewCompact => 'Kompakt';

  @override
  String get customizationWidgetPreviewTitle => 'Vorschau des Android-Widgets';

  @override
  String get customizationWidgetPreviewSubtitle =>
      'Live-Nachbildung des Startbildschirm-Widgets mit aktuellen Messwerten';

  @override
  String get customizationWidgetPreviewAutoHint =>
      'Automatisches Layout: kompakt auf 4×1, erweitert, wenn das Widget größer ist';

  @override
  String get customizationThemeAbTitle => 'Vorschau des A/B-Themas';

  @override
  String get customizationThemeAbSubtitle =>
      'Vergleichen Sie Ihr aktuelles Design nebeneinander mit einer integrierten Voreinstellung';

  @override
  String get customizationThemeAbCompareWith => 'Vergleichen Sie mit';

  @override
  String get customizationThemeAbCurrent => 'Strom (A)';

  @override
  String get customizationThemeAbApply => 'Vergleichsthema anwenden';

  @override
  String customizationThemeAbApplied(String name) {
    return 'Theme von „$name“ angewendet';
  }

  @override
  String get customizationResetSection => 'Abschnitt zurücksetzen';

  @override
  String get customizationResetAll => 'Alles zurücksetzen';

  @override
  String get customizationResetAllConfirm =>
      'Alle Einstellungen auf Standardwerte zurücksetzen?';

  @override
  String get customizationPresetsTitle => 'Voreinstellungen';

  @override
  String get customizationPresetsHint =>
      'Integrierte Profile oder Ihre gespeicherten Konfigurationen';

  @override
  String get customizationPresetSave => 'Aktuelles speichern';

  @override
  String get customizationPresetSaveDialogTitle => 'Neue Voreinstellung';

  @override
  String get customizationPresetNameRu => 'Name (RU)';

  @override
  String get customizationPresetNameEn => 'Name (EN)';

  @override
  String get customizationPresetExport => 'Export';

  @override
  String get customizationPresetImport => 'Import';

  @override
  String get customizationPresetImportHint =>
      'EcoPulse-Voreinstellung JSON einfügen oder Link teilen';

  @override
  String get customizationPresetShareLink => 'Link teilen';

  @override
  String get customizationPresetMarketplaceTitle =>
      'Voreingestellter Marktplatz';

  @override
  String get customizationPresetMarketplaceSubtitle =>
      'Ausgewählte Profile – bewerben Sie sich oder teilen Sie einen Link';

  @override
  String get customizationPresetMarketplaceApply => 'Anwenden';

  @override
  String get customizationPresetLinkImportTitle => 'Voreinstellung importieren';

  @override
  String customizationPresetLinkImportBody(String name) {
    return 'Voreinstellung „$name“ über Link installieren?';
  }

  @override
  String get customizationPresetLinkImportApply => 'Installieren';

  @override
  String customizationPresetImportSuccess(String name) {
    return 'Voreinstellung „$name“ hinzugefügt';
  }

  @override
  String get customizationPresetImportError =>
      'Voreinstellung konnte nicht importiert werden';

  @override
  String customizationPresetApplied(String name) {
    return 'Voreinstellung „$name“ angewendet';
  }

  @override
  String customizationPresetSaved(String name) {
    return 'Voreinstellung „$name“ gespeichert';
  }

  @override
  String get customizationPresetShareSubject => 'EcoPulse voreingestellt';

  @override
  String get customizationSectionCharts => 'Diagramme';

  @override
  String get customizationSectionAppearance => 'Aussehen';

  @override
  String get customizationSectionHome => 'Heim';

  @override
  String get customizationSectionNavigation => 'Navigation';

  @override
  String get customizationSectionMarkets => 'Märkte';

  @override
  String get customizationSectionPortfolio => 'Portfolio';

  @override
  String get customizationSectionWidgets => 'Widget';

  @override
  String get customizationSectionDataDisplay => 'Datenanzeige';

  @override
  String get customizationSectionAssistant => 'Assistent';

  @override
  String get customizationChartDefaultType => 'Standarddiagrammtyp';

  @override
  String get customizationChartPeriod => 'Zeitraum';

  @override
  String get customizationChartHeight => 'Höhe';

  @override
  String get customizationChartShowLegend => 'Legende';

  @override
  String get customizationChartPreferCandles => 'Kerzen, sofern verfügbar';

  @override
  String get customizationChartNormalizedCompare => 'Normalisierter Vergleich';

  @override
  String get customizationChartVisualTitle => 'Visuelle Optionen';

  @override
  String get customizationChartSeriesPalette => 'Serienpalette';

  @override
  String get customizationChartGridStyle => 'Rasterstil';

  @override
  String get customizationChartLineWidth => 'Linienbreite';

  @override
  String get customizationChartShowGrid => 'Netz';

  @override
  String get customizationChartShowGradientFill => 'Farbverlaufsfüllung';

  @override
  String get customizationChartShowCrosshair => 'Berühren Sie das Fadenkreuz';

  @override
  String get customizationChartShowEventMarkers => 'Ereignismarkierungen';

  @override
  String get customizationChartShowPointMarkers => 'Punktmarkierungen';

  @override
  String get customizationChartAnimateOnLoad => 'Beim Laden animieren';

  @override
  String get customizationChartShowVolume => 'Lautstärke (Kerzen)';

  @override
  String get customizationChartEnablePanZoom =>
      'Zoomen und Schwenken mit zwei Fingern';

  @override
  String get customizationChartPriceAxisRight => 'Preisachse rechts';

  @override
  String get customizationChartContextProfilesTitle =>
      'Bildschirmdiagrammprofile';

  @override
  String get customizationChartContextProfilesHint =>
      'Überschreiben Sie Diagrammtyp und -zeitraum für bestimmte Bildschirme.';

  @override
  String get customizationChartUseGlobalDefaults =>
      'Verwenden Sie globale Standardeinstellungen';

  @override
  String get customizationChartContextTypeOverride => 'Diagrammtyp';

  @override
  String get customizationChartContextPeriodOverride => 'Zeitraum';

  @override
  String get customizationChartContextAssetDetail => 'Asset-Detail';

  @override
  String get customizationChartContextInflation => 'Inflation (CPI)';

  @override
  String get customizationChartContextCurrency => 'Währungskurse';

  @override
  String get customizationChartContextCompare =>
      'Vergleichen Sie Vermögenswerte';

  @override
  String get customizationChartContextPortfolio => 'Portfolioaufteilung';

  @override
  String get customizationChartContextBonds => 'Anleiherenditekurve';

  @override
  String get customizationChartContextKeyRate => 'Leitzins';

  @override
  String get customizationChartContextHomeSparkline => 'Sparklines zu Hause';

  @override
  String get customizationFontScale => 'Textskala';

  @override
  String get customizationUiDensity => 'UI-Dichte';

  @override
  String get customizationCardStyle => 'Kartenstil';

  @override
  String get customizationMotionReduced => 'Bewegung reduzieren';

  @override
  String get customizationUiDensityCompact => 'Kompakt';

  @override
  String get customizationUiDensityComfortable => 'Komfortabel';

  @override
  String get customizationUiDensitySpacious => 'Geräumig';

  @override
  String get customizationCardStyleFlat => 'Wohnung';

  @override
  String get customizationCardStyleGlass => 'Glas';

  @override
  String get customizationCardStyleBordered => 'Umrandet';

  @override
  String get customizationAmoledPureBlack => 'Reines Schwarz (OLED)';

  @override
  String get customizationNavDefaultTab => 'Registerkarte „Standard“.';

  @override
  String get customizationNavShowFab => 'Assistententaste';

  @override
  String get customizationNavHideLabels => 'Tab-Beschriftungen ausblenden';

  @override
  String get customizationNavVisibleTabs => 'Sichtbare Registerkarten';

  @override
  String get customizationNavTabOrder =>
      'Ziehen Sie, um die Registerkarten in der unteren Leiste neu anzuordnen';

  @override
  String get customizationNavTabHidden => 'Versteckt';

  @override
  String get customizationHomeNewsCount => 'Neuigkeiten zu Hause';

  @override
  String get customizationHomeSparklines => 'Sparklines';

  @override
  String get customizationMarketsGroupStocks =>
      'Gruppieren Sie Aktien nach Sektor';

  @override
  String get customizationMarketsHeatmap => 'Sektor-Heatmap';

  @override
  String get customizationMarketsCompactRows => 'Kompakte Reihen';

  @override
  String get customizationMarketsDefaultRegion => 'Standard-Aktienfilter';

  @override
  String get customizationMarketsRegionAll => 'Alle';

  @override
  String get customizationMarketsRegionRu => 'MOEX';

  @override
  String get customizationMarketsRegionUs => 'UNS';

  @override
  String get customizationPortfolioAllocation => 'Zuordnungstabelle';

  @override
  String get customizationPortfolioRealizedPnl => 'Realisiert P/L';

  @override
  String get customizationPortfolioJournal => 'Fachzeitschrift';

  @override
  String get customizationAssistantPreferCloud => 'Cloud-KI (Gemini)';

  @override
  String get customizationAssistantQuickChips => 'Schnelle Chips';

  @override
  String get customizationAssistantVoice => 'Spracheingabe';

  @override
  String get customizationDataDecimalPlaces => 'Dezimalstellen';

  @override
  String get customizationDataLargeNumbers => 'Große Zahlen';

  @override
  String get customizationDataShowCurrencyCode => 'Währungscode anzeigen';

  @override
  String get customizationData24HourTime => '24-Stunden-Zeit';

  @override
  String get customizationSyncTitle => 'Serversynchronisierung';

  @override
  String get customizationSyncSubtitle =>
      'Push/Pull-Anpassung über Homeserver (LAN)';

  @override
  String get customizationSyncNotLoggedIn =>
      'Melden Sie sich zur Synchronisierung beim Heimserver an';

  @override
  String get customizationSyncNever =>
      'Noch nicht mit dem Server synchronisiert';

  @override
  String get customizationSyncSynced => 'Die Anpassung entspricht dem Server';

  @override
  String get customizationSyncLocalNewer =>
      'Lokale Einstellungen sind neuer – Push empfohlen';

  @override
  String get customizationSyncRemoteNewer =>
      'Der Server verfügt über neuere Einstellungen – Pull empfohlen';

  @override
  String get customizationSyncRemoteMissing =>
      'Keine Einstellungen auf dem Server – zum Hochladen drücken';

  @override
  String customizationSyncLastPush(String date) {
    return 'Gepusht: $date';
  }

  @override
  String customizationSyncLastPull(String date) {
    return 'Gezogen: $date';
  }

  @override
  String customizationSyncError(String message) {
    return 'Synchronisierungsfehler: $message';
  }

  @override
  String get customizationSyncOpenServer => 'Heimserverkonto';

  @override
  String get customizationSyncSmart => 'Intelligente Synchronisierung';

  @override
  String get customizationSyncPush => 'Drücken';

  @override
  String get customizationSyncPull => 'Ziehen';

  @override
  String get customizationSyncDone => 'Anpassung synchronisiert';

  @override
  String get customizationSyncPushDone =>
      'An den Server gesendete Einstellungen';

  @override
  String get customizationSyncPullDone => 'Vom Server geladene Einstellungen';

  @override
  String get customizationSyncFailed =>
      'Synchronisierung fehlgeschlagen – Verbindung prüfen';

  @override
  String get customizationChartShowMa7 => 'MA(7)';

  @override
  String get customizationChartShowMa25 => 'MA(25)';

  @override
  String get customizationChartShowMa99 => 'MA(99)';

  @override
  String get chartFullscreen => 'Vollbild-Diagramm';

  @override
  String get customizationHubSectionsTitle => 'Abschnitte';

  @override
  String get settingsHubSubtitle => 'App-Einstellungen und Daten';

  @override
  String get settingsHubGroupsTitle => 'Einstellungsgruppen';

  @override
  String get portfolioAccountsTitle => 'Konten';

  @override
  String get portfolioAccountsAdd => 'Konto hinzufügen';

  @override
  String get portfolioAccountKindMain => 'Hauptsächlich';

  @override
  String get portfolioAccountKindIis => 'IIS';

  @override
  String get portfolioAccountKindUsd => 'USD';

  @override
  String get portfolioAccountKindCrypto => 'Krypto';

  @override
  String get portfolioAccountKindCustom => 'Brauch';

  @override
  String get portfolioAccountNameHint => 'Kontoname';

  @override
  String get portfolioAccountCreate => 'Benutzerkonto erstellen';

  @override
  String get portfolioAccountDelete => 'Konto entfernen';

  @override
  String portfolioAccountDeleteConfirm(String name) {
    return '„$name“ und alle seine Positionen entfernen?';
  }

  @override
  String get portfolioAccountMaxReached => 'Maximal 8 Konten';

  @override
  String get portfolioSavingsGoalsTitle => 'Sparziele';

  @override
  String get portfolioSavingsGoalsSubtitle =>
      'Verfolgen Sie den Fortschritt in Richtung eines Zielbetrags';

  @override
  String get portfolioSavingsGoalAdd => 'Ziel hinzufügen';

  @override
  String get portfolioSavingsGoalTitleHint => 'Zielname';

  @override
  String get portfolioSavingsGoalTargetHint => 'Zielbetrag, ₽';

  @override
  String get portfolioSavingsGoalDeadline => 'Frist';

  @override
  String portfolioSavingsGoalProgress(String current, String target) {
    return '$current von $target';
  }

  @override
  String portfolioSavingsGoalDaysLeft(int days) {
    return 'Noch $days Tage';
  }

  @override
  String get portfolioSavingsGoalOverdue => 'Frist verstrichen';

  @override
  String get portfolioSavingsGoalLinkedAccount => 'Mit dem Girokonto verknüpft';

  @override
  String get portfolioSavingsGoalEmpty =>
      'Noch keine Ziele – legen Sie Ihr erstes Ziel fest';

  @override
  String get overnightChangesTitle => 'Seit Ihrem letzten Besuch';

  @override
  String overnightChangesSince(int hours) {
    return 'Snapshot vor $hours Std.';
  }

  @override
  String get supportCenterTitle => 'Hilfe & Support';

  @override
  String get supportCenterSubtitle => 'FAQ und Kontakte';

  @override
  String get supportCenterIntro =>
      'Antworten auf häufige Fragen und Kontakt zum Team.';

  @override
  String get supportCenterFaqTitle => 'FAQ';

  @override
  String get supportCenterContactTitle => 'Kontakt';

  @override
  String get supportCenterFeedback => 'Feedback senden';

  @override
  String get supportCenterGithub => 'GitHub Issues';

  @override
  String get sectorHeatmapTapHint => 'Sektor antippen — MOEX-Aktien filtern';

  @override
  String marketsSectorFilterActive(String sector) {
    return 'Sektor: $sector';
  }

  @override
  String get shareWatchlistToChat => 'Watchlist an Messages senden';

  @override
  String get shareWatchlistToChatHint => 'Kurzbericht + Watchlist an Self-Chat';

  @override
  String get shareWatchlistToChatNeedServer =>
      'Zuerst beim Home Server anmelden';

  @override
  String get shareWatchlistToChatSuccess => 'Watchlist an Self-Chat gesendet';

  @override
  String get shareWatchlistToChatFailed =>
      'Senden fehlgeschlagen — Server prüfen';

  @override
  String get featureTourSkip => 'Überspringen';

  @override
  String get featureTourNext => 'Weiter';

  @override
  String get featureTourDone => 'Verstanden';

  @override
  String get featureTourReplay => 'Tipps anzeigen';

  @override
  String get featureTourCommunityTabsTitle => 'Chats und Artikel';

  @override
  String get featureTourCommunityTabsBody =>
      'Wechseln Sie zwischen privaten Chats und dem Artikel-Feed.';

  @override
  String get featureTourCommunityFabTitle => 'Unterhaltung starten';

  @override
  String get featureTourCommunityFabBody =>
      'Neuer Chat oder Artikel — ein Tippen unten links.';

  @override
  String get featureTourCommunityRefreshTitle => 'Synchronisieren';

  @override
  String get featureTourCommunityRefreshBody =>
      'Nach unten ziehen oder Aktualisieren für neue Daten.';

  @override
  String get featureTourCalendarGridTitle => 'Monatsansicht';

  @override
  String get featureTourCalendarGridBody =>
      'Tag antippen für Ereignisse. Punkte markieren Zahlungstage.';

  @override
  String get featureTourCalendarHorizonTitle => 'Zeitraum';

  @override
  String get featureTourCalendarHorizonBody =>
      '30, 90 Tage oder ein Jahr — wählen Sie den Planungshorizont.';

  @override
  String get featureTourCalendarPortfolioTitle => 'Portfolio-Ereignisse';

  @override
  String get featureTourCalendarPortfolioBody =>
      'Kupons und Dividenden aus dem Papierportfolio ein-/ausschalten.';

  @override
  String get featureTourCalendarAddTitle => 'Ereignis hinzufügen';

  @override
  String get featureTourCalendarAddBody =>
      'Eigene Erinnerungen mit Betrag und Benachrichtigungen.';

  @override
  String get featureTourHomeServerUrlTitle => 'Serveradresse';

  @override
  String get featureTourHomeServerUrlBody =>
      'LAN-IP Ihres PCs und Port (ipconfig unter Windows).';

  @override
  String get featureTourHomeServerCheckTitle => 'Verbindung prüfen';

  @override
  String get featureTourHomeServerCheckBody =>
      'Prüfen Sie die Erreichbarkeit vor der Anmeldung.';

  @override
  String get featureTourHomeServerLoginTitle => 'Anmelden';

  @override
  String get featureTourHomeServerLoginBody =>
      'Konto erstellen oder anmelden — Profile ID wird auf dem Server erzeugt.';

  @override
  String get communityConnectAction => 'Server verbinden';

  @override
  String get communityConnectHint =>
      'Melden Sie sich am EcoPulse-Heimserver für Chats und Artikel an.';

  @override
  String get communityEmptyMessagesSubtitle =>
      'Privaten Chat starten — Schaltfläche unten links.';

  @override
  String get communityEmptyArticlesSubtitle =>
      'Teilen Sie Einblicke — Schaltfläche „Schreiben“ unten.';

  @override
  String get userCalendarEmptySubtitle =>
      'Erinnerung hinzufügen oder Portfolio-Ereignisse importieren.';

  @override
  String get userCalendarEmptyImportAction => 'Portfolio importieren';

  @override
  String get tabThemePerTabTitle => 'Thema pro Tab';

  @override
  String get tabThemePerTabSubtitle =>
      'Eigene Presets für Märkte und Profil; andere Tabs nutzen das globale Thema oben.';

  @override
  String get tabThemeMarketsLabel => 'Tab Märkte';

  @override
  String get tabThemeProfileLabel => 'Tab Profil';
}
