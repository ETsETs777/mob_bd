// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EcoPulse';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCurrency => 'Currency';

  @override
  String get tabInflation => 'Inflation';

  @override
  String get tabMarkets => 'Markets';

  @override
  String get tabMessages => 'Messages';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tabProfile => 'Profile';

  @override
  String get pinEnterCode => 'Enter passcode';

  @override
  String get pinWrongCode => 'Wrong passcode';

  @override
  String get pinUseBiometric => 'Sign in with biometrics';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsDefaultTab => 'Default tab';

  @override
  String get settingsBiometric => 'Biometrics';

  @override
  String get settingsBiometricSubtitle =>
      'Fingerprint or Face ID instead of PIN';

  @override
  String get shareQuote => 'Share';

  @override
  String get copyQuote => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String shareMessage(String title, String value) {
    return '$title: $value';
  }

  @override
  String get alertsTitle => 'Price alerts';

  @override
  String get alertsAdd => 'Add alert';

  @override
  String get alertsEmpty => 'No alerts yet. Example: USD/RUB above 90';

  @override
  String get alertsSymbol => 'Instrument';

  @override
  String get alertsThreshold => 'Threshold';

  @override
  String get alertsSave => 'Save';

  @override
  String get alertsCheckOnRefresh => 'Checked when data refreshes';

  @override
  String get alertsSettingsSubtitle =>
      'USD/RUB, BTC and more — background + refresh push';

  @override
  String alertsLastTriggered(String time) {
    return 'Triggered: $time';
  }

  @override
  String get alertAction => 'Set alert';

  @override
  String get homePulseTitle => 'Economy pulse';

  @override
  String get homePulseSubtitle => 'Key metrics in real time';

  @override
  String homeUpdated(String time) {
    return 'Updated: $time';
  }

  @override
  String get sectionCurrencies => 'Currencies';

  @override
  String get sectionKeyRate => 'CBR key rate';

  @override
  String get sectionInflation => 'Inflation';

  @override
  String get sectionCommodities => 'Commodities';

  @override
  String get sectionMarkets => 'Markets';

  @override
  String get sectionWatchlist => 'Watchlist';

  @override
  String get actionAll => 'All';

  @override
  String get actionMarkets => 'Markets';

  @override
  String get actionCalculators => 'Calculators';

  @override
  String get chartTitle => 'Chart';

  @override
  String get chartLine => 'Line';

  @override
  String get chartCandles => 'Candles';

  @override
  String get shareChart => 'Share chart';

  @override
  String get retry => 'Retry';

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }

  @override
  String get assetType => 'Type';

  @override
  String get assetCurrency => 'Currency';

  @override
  String get assetSource => 'Source';

  @override
  String get assetTypeCrypto => 'Cryptocurrency';

  @override
  String get assetTypeStockRu => 'Stock (MOEX)';

  @override
  String get assetTypeStockUs => 'Stock (US)';

  @override
  String get settingsCompactHome => 'Compact home';

  @override
  String get settingsCompactHomeSubtitle => 'Dense 2×2 grid, smaller spacing';

  @override
  String get currencyLoadError => 'Load error';

  @override
  String currencyChart30d(String pair) {
    return 'Chart $pair (30 days)';
  }

  @override
  String get currencyConverter => 'Converter';

  @override
  String get currencyAmount => 'Amount';

  @override
  String get currencyFrom => 'From';

  @override
  String get currencyTo => 'To';

  @override
  String get currencyFee => 'Exchange fee';

  @override
  String get currencyQuickConvert => 'Quick convert';

  @override
  String get currencyQuickHint => '100 USD to EUR';

  @override
  String get currencyQuickFormatError => 'Format: 100 USD to EUR';

  @override
  String get currencyHistory => 'Conversion history';

  @override
  String get currencyUnavailable => 'Load error · tap refresh';

  @override
  String get marketsSearchHint => 'Search BTC, SBER, AAPL…';

  @override
  String get marketsTabCrypto => 'Crypto';

  @override
  String get marketsTabStocks => 'Stocks';

  @override
  String get marketsTabBonds => 'Bonds';

  @override
  String get assetTypeBondRu => 'Bond (MOEX)';

  @override
  String get marketsFilterOfz => 'OFZ';

  @override
  String get marketsFilterCorporateBonds => 'Corp.';

  @override
  String get bondCategoryOfz => 'OFZ — government';

  @override
  String get bondCategoryCorporate => 'Corporate';

  @override
  String get bondYieldLabel => 'Yield';

  @override
  String get bondCouponLabel => 'Coupon';

  @override
  String get bondMaturityLabel => 'Maturity';

  @override
  String get bondFaceValueLabel => 'Face value';

  @override
  String marketsBondCatalogCounts(int count) {
    return 'Catalog: $count bonds · MOEX ISS';
  }

  @override
  String get bondYieldCurveTitle => 'OFZ yield curve';

  @override
  String get bondYieldCurveSubtitle => 'YTM × time to maturity · MOEX ISS';

  @override
  String get bondYieldCurveTapHint => 'Tap for full-screen chart';

  @override
  String get bondYieldCurveEmpty => 'Not enough OFZ data for the curve';

  @override
  String get bondYieldCurveTableTitle => 'Curve points';

  @override
  String get bondYieldCurveOpen => 'Yield curve';

  @override
  String get bondYieldSpreadLabel => 'Long–short spread';

  @override
  String bondYieldSpreadValue(String spread) {
    return '+$spread pp';
  }

  @override
  String get bondYearsShort => 'y';

  @override
  String get bondLadderTitle => 'OFZ bond ladder';

  @override
  String get bondLadderSubtitle => 'By maturity year · yield to maturity';

  @override
  String get bondLadderTapHint => 'Tap for full screen';

  @override
  String bondLadderFullSubtitle(int ofzCount, int yearCount) {
    return '$ofzCount OFZ · $yearCount maturity years';
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
    return '$count more $_temp0';
  }

  @override
  String get bondYieldCurveCrosshairHint => 'Tap a point on the curve';

  @override
  String get bondYieldCurveZoomHint =>
      'Scroll or pinch to zoom · double-tap to reset';

  @override
  String bondYieldCurveZoomActive(String zoom) {
    return 'Zoom ×$zoom · double-tap to reset';
  }

  @override
  String get bondCalendarTitle => 'Bond calendar';

  @override
  String get bondCalendarSubtitle =>
      'Watchlist & portfolio · MOEX coupons or estimate';

  @override
  String get bondCalendarTapHint => 'Tap for full calendar';

  @override
  String get bondCalendarFullSubtitle =>
      'Watchlist & paper portfolio · coupons and maturities';

  @override
  String get bondCalendarHorizon6m => '6 mo';

  @override
  String get bondCalendarHorizon1y => '1 yr';

  @override
  String get bondCalendarHorizon2y => '2 yr';

  @override
  String get bondCalendarCouponIncome => 'Portfolio coupons (est.)';

  @override
  String get bondCalendarCouponIncomeHint => 'MOEX COUPONVALUE × quantity';

  @override
  String get bondCalendarEmptyTracked => 'Add bonds to watchlist or portfolio';

  @override
  String get bondCalendarEmptyEvents => 'No events in selected horizon';

  @override
  String bondCalendarMoreEvents(int count) {
    return '$count more events';
  }

  @override
  String get bondEventMaturity => 'Maturity';

  @override
  String bondEventCouponRub(String amount) {
    return 'Coupon $amount ₽';
  }

  @override
  String bondEventCouponPercent(String rate) {
    return 'Coupon $rate%';
  }

  @override
  String bondEventCouponEstimate(String rate) {
    return 'Coupon ~$rate% (est.)';
  }

  @override
  String get bondNextCouponLabel => 'Next coupon';

  @override
  String get bondCouponValueLabel => 'Coupon amount';

  @override
  String get bondHomeCardTitle => 'OFZ bonds';

  @override
  String get bondHomeCardSubtitle => 'Average yield and spread · MOEX ISS';

  @override
  String bondHomeUpcomingEvents(int count) {
    return 'Upcoming events: $count';
  }

  @override
  String get bondCalendarOpen => 'Calendar';

  @override
  String get bondHomeAvgYield => 'Avg YTM';

  @override
  String get bondHomeTopYield => 'Top yield';

  @override
  String get marketsFavorites => 'Watchlist';

  @override
  String get marketsEmptyFavoritesTitle => 'No watchlist items';

  @override
  String get marketsEmptySearchTitle => 'Nothing found';

  @override
  String get marketsEmptyFavoritesSubtitle => 'Tap ★ on an asset to add it';

  @override
  String get marketsEmptySearchSubtitle =>
      'Try another query or clear the filter';

  @override
  String get marketsAllAssets => 'All assets';

  @override
  String marketsRemovedFromWatchlist(String symbol) {
    return '$symbol removed from watchlist';
  }

  @override
  String get undo => 'Undo';

  @override
  String get inflationTabCountries => 'Countries';

  @override
  String get inflationTabCalculator => 'Inflation';

  @override
  String get inflationTabFinance => 'Finance';

  @override
  String get inflationCpiTitle => 'Inflation (CPI), year over year';

  @override
  String get inflationWorldBankNote =>
      'World Bank data · latest available year';

  @override
  String get inflationCalcTitle => 'What is that money worth today?';

  @override
  String get inflationCalcSubtitle =>
      'Uses cumulative inflation from World Bank';

  @override
  String get inflationCountry => 'Country';

  @override
  String get inflationAmount => 'Amount';

  @override
  String get inflationYear => 'Year';

  @override
  String get inflationYoy => 'year over year';

  @override
  String get inflationUnavailable => 'Data temporarily unavailable';

  @override
  String purchasingPower(String base, int year, String today) {
    return '$base in $year ≈ $today today';
  }

  @override
  String get chartInsufficientData => 'Not enough data for chart';

  @override
  String get chartInsufficientCandles => 'Not enough data for candles';

  @override
  String get dataUnavailable => 'Data temporarily unavailable';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeAuto => 'Auto';

  @override
  String get settingsThemeOled => 'OLED';

  @override
  String get settingsThemeDim => 'Dim';

  @override
  String get settingsThemeSepia => 'Sepia';

  @override
  String get settingsThemeContrast => 'Contrast';

  @override
  String get settingsAccentColor => 'Accent color';

  @override
  String settingsThemeCurrent(String mode) {
    return 'Current: $mode';
  }

  @override
  String get sectorHeatmapTitle => 'MOEX sectors';

  @override
  String get sectorHeatmapSubtitle => 'Average 7-day change by sector';

  @override
  String get sectorFinance => 'Finance';

  @override
  String get sectorEnergy => 'Energy';

  @override
  String get sectorIt => 'IT';

  @override
  String get sectorIndex => 'Index';

  @override
  String dataStatusFresh(String time) {
    return 'Updated: $time';
  }

  @override
  String get dataStatusLive => 'Data is up to date';

  @override
  String dataStatusCache(String age) {
    return 'Cache · $age';
  }

  @override
  String get dataStatusCacheUnknown => 'Cache · data may be stale';

  @override
  String dataStatusOffline(String age) {
    return 'Offline · cache $age';
  }

  @override
  String get dataStatusOfflineUnknown => 'Offline · saved data';

  @override
  String get alertsCheckBackground =>
      'Background check every 15 min + on refresh';

  @override
  String get currencyCompareTitle => 'Rate comparison';

  @override
  String get currencyCompareSubtitle =>
      'Index 100 at period start — up to 3 pairs';

  @override
  String get currencyCompareSelect => 'Select one more pair to compare';

  @override
  String get assetPreviewOpen => 'Open chart';

  @override
  String get assetPreviewAddWatchlist => 'Add to watchlist';

  @override
  String get assetPreviewRemoveWatchlist => 'Remove from watchlist';

  @override
  String get inflationCompareTitle => 'Country comparison';

  @override
  String get inflationCompareSubtitle =>
      'YoY CPI — up to 3 countries on one chart';

  @override
  String get inflationCompareSelect => 'Select one more country to compare';

  @override
  String get settingsHomeWidget => 'Android widget';

  @override
  String get settingsHomeWidgetSubtitle =>
      'USD/RUB and BTC on home screen — updates on refresh';

  @override
  String get keyRateDetailTitle => 'CBR key rate';

  @override
  String keyRateUpdated(String date) {
    return 'Updated: $date';
  }

  @override
  String get keyRateEventsTitle => 'Rate changes';

  @override
  String get keyRateEventsEmpty => 'No changes in this period';

  @override
  String keyRateEventChange(String date, String rate) {
    return '$date → $rate';
  }

  @override
  String keyRateSince(int day, int month, int year) {
    return 'since $day.$month.$year';
  }

  @override
  String get sourceCbr => 'CBR';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboarding1Title => 'Currencies & rates';

  @override
  String get onboarding1Subtitle =>
      'USD/RUB, EUR/RUB and global FX from MOEX and Frankfurter';

  @override
  String get onboarding2Title => 'Inflation & CBR rate';

  @override
  String get onboarding2Subtitle =>
      'World Bank data, CBR key rate and finance calculators';

  @override
  String get onboarding3Title => 'Markets & watchlist';

  @override
  String get onboarding3Subtitle =>
      'Crypto, MOEX stocks, charts and watchlist in one place';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsAppTheme => 'App theme';

  @override
  String get settingsAppBackground => 'App background';

  @override
  String get settingsBackgroundSubtitle => 'Gradient like banking apps';

  @override
  String get settingsSectionSecurity => 'Security';

  @override
  String get settingsPinCode => 'Access code';

  @override
  String get settingsPinEnabled => 'App protected · 4 digits';

  @override
  String get settingsPinDisabled => 'PIN is off';

  @override
  String get settingsChangePin => 'Change code';

  @override
  String get settingsLockNow => 'Lock now';

  @override
  String get settingsLockedSnack => 'App locked';

  @override
  String get settingsSectionDisplay => 'Display';

  @override
  String get settingsBaseCurrency => 'Base currency';

  @override
  String get settingsKeysLocalNote => 'Keys stored locally — no rebuild needed';

  @override
  String get settingsSectionDataApi => 'Data & API';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsAboutDescription =>
      'Economic dashboard with currencies, inflation, crypto and market quotes.';

  @override
  String get settingsAboutDesign =>
      'Design: Material 3 · fl_chart · flutter_animate';

  @override
  String get settingsAboutDeveloper =>
      'Developed by Evgeny Vladislavovich Tsymbal';

  @override
  String get sourceFrankfurter => 'Frankfurter';

  @override
  String get sourceFrankfurterSub => 'International FX';

  @override
  String get sourceMoex => 'MOEX ISS';

  @override
  String get sourceMoexSub => 'RUB FX and RU stocks';

  @override
  String get sourceCbrSub => 'Key rate';

  @override
  String get sourceWorldBank => 'World Bank';

  @override
  String get sourceWorldBankSub => 'CPI inflation';

  @override
  String get sourceCoingecko => 'CoinGecko';

  @override
  String get sourceCoingeckoSub => 'Cryptocurrencies';

  @override
  String get sourceFinnhub => 'Finnhub';

  @override
  String get sourceFinnhubSub => 'US stocks';

  @override
  String get sourceCommodities => 'MOEX ISS';

  @override
  String get sourceCommoditiesSub => 'Commodities';

  @override
  String get statusActive => 'Active';

  @override
  String get statusKeyOk => 'Key OK';

  @override
  String get statusNoKey => 'No key';

  @override
  String get statusNotConfigured => 'Not configured';

  @override
  String get inflationRateVsTitle => 'Key rate vs inflation';

  @override
  String get inflationRateVsSubtitle =>
      'Average CBR rate and Russia CPI by year';

  @override
  String get inflationRateVsKeyRate => 'Key rate';

  @override
  String get inflationRateVsCpi => 'CPI inflation';

  @override
  String get correlationTitle => 'Asset correlation';

  @override
  String correlationSubtitle(int days) {
    return 'Daily returns over $days days (Pearson)';
  }

  @override
  String get correlationChartTitle => 'Performance (index 100)';

  @override
  String get correlationNote => '1 = move together, −1 = opposite, 0 = no link';

  @override
  String get correlationBtc => 'BTC';

  @override
  String get correlationUsdRub => 'USD/RUB';

  @override
  String get correlationImoex => 'IMOEX';

  @override
  String get sectorMetals => 'Metals';

  @override
  String get sectorTelecom => 'Telecom';

  @override
  String get sectorConsumer => 'Consumer';

  @override
  String get sectorTransport => 'Transport';

  @override
  String get sectorRealestate => 'Real estate';

  @override
  String get sectorChemicals => 'Chemicals';

  @override
  String get sectorEtf => 'ETF';

  @override
  String get sectorTech => 'Technology';

  @override
  String get sectorAuto => 'Automotive';

  @override
  String get sectorHealth => 'Healthcare';

  @override
  String get sectorMedia => 'Media';

  @override
  String get sectorIndustrial => 'Industrial';

  @override
  String get sectorUs => 'United States';

  @override
  String get sectorOther => 'Other';

  @override
  String get marketsFilterAll => 'All';

  @override
  String get marketsFilterMoex => 'MOEX';

  @override
  String get marketsFilterUs => 'NYSE/NASDAQ';

  @override
  String get marketsGroupBySector => 'By sector';

  @override
  String get marketsCatalogHint =>
      '50 MOEX · 45 US · 100 crypto · search by ticker';

  @override
  String marketsCatalogCounts(int moex, int us, int crypto) {
    return '$moex MOEX · $us US · $crypto crypto · search';
  }

  @override
  String get currencyGroupMoex => 'MOEX · ruble pairs';

  @override
  String get currencyGroupMajor => 'Major';

  @override
  String get currencyGroupEurope => 'Europe';

  @override
  String get currencyGroupAsia => 'Asia';

  @override
  String get currencyGroupEm => 'Emerging';

  @override
  String get currencyGroupAmericas => 'Americas & Oceania';

  @override
  String get adminPanelTitle => 'Admin Panel';

  @override
  String get adminPanelSubtitle =>
      'Dev tools: API, cache, catalogs, feature flags';

  @override
  String get adminApiStatus => 'API status';

  @override
  String get adminCache => 'Cache';

  @override
  String get adminCatalog => 'Catalogs';

  @override
  String get adminFeatureFlags => 'Feature flags';

  @override
  String get adminHttpLog => 'HTTP log';

  @override
  String get adminHttpLogEmpty => 'No requests yet';

  @override
  String get adminRefreshAll => 'Refresh all';

  @override
  String get adminReloadStatus => 'Reload status';

  @override
  String get adminRefreshed => 'Data refreshed';

  @override
  String get adminFlagSectorHeatmap => 'MOEX sector heatmap';

  @override
  String get adminFlagStocksGrouped => 'Group stocks by sector';

  @override
  String get adminFlagVerboseHttp => 'Verbose HTTP log';

  @override
  String get adminCacheEmpty => 'Empty';

  @override
  String get adminCacheFresh => 'Fresh';

  @override
  String get adminCacheStale => 'Stale';

  @override
  String adminCacheAge(String age) {
    return 'Age: $age';
  }

  @override
  String adminCacheItems(int count) {
    return '$count items';
  }

  @override
  String get adminCatalogMoex => 'MOEX';

  @override
  String get adminCatalogUs => 'US';

  @override
  String get adminCatalogFx => 'FX';

  @override
  String get adminCatalogCrypto => 'Crypto';

  @override
  String get profileSectionTitle => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileGuest => 'Guest · set up your profile';

  @override
  String profileGreeting(String name) {
    return 'Hello, $name!';
  }

  @override
  String get profileDisplayName => 'Display name';

  @override
  String get profileDisplayNameHint => 'How should we greet you';

  @override
  String get profileAvatarHint => 'Pick an avatar';

  @override
  String get profileCountry => 'Country for inflation';

  @override
  String get profileCountryHint => 'Used on the Countries tab';

  @override
  String profileCountryLabel(String country) {
    return 'Country: $country';
  }

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileSave => 'Save';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailHint => 'example@mail.com';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profilePhoneHint => '+1 (555) 000-0000';

  @override
  String get profileHubAccountsTitle => 'My accounts';

  @override
  String get profileHubAccountPortfolio => 'Paper portfolio';

  @override
  String get profileHubAccountWatchlist => 'Watchlist';

  @override
  String get profileHubAccountAlerts => 'Price alerts';

  @override
  String get profileHubAccountCash => 'Available cash';

  @override
  String get profileHubAccountCashSub => 'Ready to trade';

  @override
  String get profileHubPortfolioEmpty => 'No open positions';

  @override
  String get profileHubQuickBackup => 'Backup';

  @override
  String get profileHubQuickSecurity => 'Security';

  @override
  String get profileHubQuickSync => 'Sync';

  @override
  String get profileHubQuickCustomize => 'Style';

  @override
  String get profileHubSectionProfile => 'Profile';

  @override
  String get profileHubSectionFinance => 'Finance';

  @override
  String get profileHubSectionSecurity => 'Security & data';

  @override
  String get profileHubSectionApp => 'App';

  @override
  String get profileHubPersonalData => 'Personal data';

  @override
  String get profileHubPersonalDataSub => 'Name, avatar, email, phone';

  @override
  String get profileHubServerAccount => 'Server account';

  @override
  String get profileHubServerIntro =>
      'Sign in to your EcoPulse home server for chats and profile sync.';

  @override
  String get profileHubMessages => 'Messages';

  @override
  String get profileHubPortfolio => 'Portfolio';

  @override
  String get profileHubWatchlist => 'Watchlist assets';

  @override
  String get profileHubSecurity => 'Security';

  @override
  String get profileHubSecuritySub => 'PIN and biometrics';

  @override
  String get profileHubSecurityPinBio => 'PIN and biometrics';

  @override
  String get profileHubSecurityActive => 'App is protected';

  @override
  String get profileHubSecurityActiveSub =>
      'PIN is enabled. Your data is hidden when the app is locked.';

  @override
  String get profileHubSecurityInactive => 'Protection is off';

  @override
  String get profileHubSecurityInactiveSub =>
      'Enable PIN to hide data when the screen is locked.';

  @override
  String get profileHubDocuments => 'Documents & reports';

  @override
  String get profileHubDocumentsSub => 'Export, backup, weekly report';

  @override
  String get profileHubDocumentsIntro =>
      'Save app data or share a watchlist report.';

  @override
  String get profileHubCloudSync => 'Cloud sync';

  @override
  String get profileHubNotifications => 'Notifications';

  @override
  String get profileHubNotificationsSub => 'Morning digest and alerts';

  @override
  String get profileHubAppSettings => 'App settings';

  @override
  String get profileHubAppSettingsSub => 'Theme, language, API, widget';

  @override
  String get profileHubCustomization => 'Customization';

  @override
  String get profileHubCourses => 'Courses & learning';

  @override
  String get profileHubAbout => 'About EcoPulse';

  @override
  String get profileHubVerified => 'Profile complete';

  @override
  String get profileHubServerOnline => 'Server connected';

  @override
  String get profileHubServerOffline => 'Local mode';

  @override
  String get profileHubEditProfile => 'Edit';

  @override
  String profileHubPositions(int count) {
    return '$count positions';
  }

  @override
  String profileHubAssets(int count) {
    return '$count assets';
  }

  @override
  String profileHubActiveAlerts(int count) {
    return '$count alerts';
  }

  @override
  String get backupSectionTitle => 'Backup';

  @override
  String get backupExportTitle => 'Export data';

  @override
  String get backupExportSubtitle =>
      'Watchlist, profile, settings, notes — JSON';

  @override
  String get backupImportTitle => 'Import data';

  @override
  String get backupImportSubtitle => 'Paste JSON from export';

  @override
  String get backupImportHint => 'Paste EcoPulse export JSON here';

  @override
  String get backupImportConfirm => 'Restore';

  @override
  String backupImportSuccess(int count) {
    return 'Restored keys: $count';
  }

  @override
  String backupImportError(String error) {
    return 'Import failed: $error';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get assetNoteTitle => 'Note';

  @override
  String get assetNoteHint => 'Bought @ 280, target 320…';

  @override
  String get portfolioTitle => 'Paper portfolio';

  @override
  String get portfolioEmptySubtitle => '₽100,000 virtual · tap to start';

  @override
  String get portfolioTotal => 'Portfolio value';

  @override
  String get portfolioPnl => 'P&L';

  @override
  String get portfolioLiveBadge => 'LIVE';

  @override
  String portfolioLiveUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get portfolioCash => 'Cash';

  @override
  String get portfolioPositions => 'Positions';

  @override
  String get portfolioEmptyPositions =>
      'Buy from watchlist or asset preview on Markets';

  @override
  String get portfolioAdd => 'Buy';

  @override
  String get portfolioBuy => 'Buy price';

  @override
  String get portfolioBuyAction => 'Add to portfolio';

  @override
  String portfolioBought(String symbol) {
    return '$symbol added to portfolio';
  }

  @override
  String get portfolioInsufficientCash => 'Insufficient virtual cash';

  @override
  String get portfolioReset => 'Reset';

  @override
  String get portfolioResetConfirm =>
      'Reset to ₽100,000 and clear all positions?';

  @override
  String portfolioRemoved(String symbol) {
    return '$symbol removed (long press)';
  }

  @override
  String get portfolioPickAsset => 'Pick an asset';

  @override
  String get portfolioPickFromWatchlist =>
      'Add assets to watchlist on Markets first';

  @override
  String cryptoLoadMore(int loaded, int total) {
    return 'Load more ($loaded / $total)';
  }

  @override
  String get homeShareDashboard => 'Share dashboard';

  @override
  String get newsSectionTitle => 'News';

  @override
  String get newsFinnhubHint =>
      'Add a Finnhub Key in Settings for news and calendar';

  @override
  String get newsEmpty => 'No news yet';

  @override
  String get newsLoadError => 'Could not load news';

  @override
  String get macroCalendarTitle => 'Macro calendar';

  @override
  String get macroCalendarEmpty => 'No events for the next week';

  @override
  String get digestSectionTitle => 'Notifications';

  @override
  String get digestMorningTitle => 'Morning digest';

  @override
  String get digestMorningSubtitle =>
      'Push brief with USD/RUB, BTC, IMOEX at chosen hour';

  @override
  String get digestMorningHour => 'Delivery time';

  @override
  String get indicesSectionTitle => 'US indices';

  @override
  String get radarTitle => 'Economic radar';

  @override
  String get radarSubtitle => 'Score from market, FX, inflation, rate and F&G';

  @override
  String get timelineTitle => 'Event timeline';

  @override
  String get timelineEmpty => 'No events yet · Finnhub key needed for macro';

  @override
  String get macroWeekTitle => 'Macro week';

  @override
  String macroWeekRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get macroWeekBriefTitle => 'Market brief';

  @override
  String get macroWeekToday => 'Today';

  @override
  String get macroWeekKeyRateToday => 'CBR key rate';

  @override
  String macroWeekStats(int events, int days) {
    return '$events macro events · $days days with events';
  }

  @override
  String get macroWeekEmptyDay => 'No events';

  @override
  String get macroWeekMon => 'Mon';

  @override
  String get macroWeekTue => 'Tue';

  @override
  String get macroWeekWed => 'Wed';

  @override
  String get macroWeekThu => 'Thu';

  @override
  String get macroWeekFri => 'Fri';

  @override
  String get macroWeekSat => 'Sat';

  @override
  String get macroWeekSun => 'Sun';

  @override
  String get portfolioExportCsv => 'Export CSV';

  @override
  String get portfolioExportDone => 'CSV shared';

  @override
  String get demoModeTitle => 'Demo mode';

  @override
  String get demoModeSubtitle =>
      'Mock data offline — for screenshots and demos';

  @override
  String get demoModeBadge => 'Demo data';

  @override
  String get homeLayoutTitle => 'Home sections';

  @override
  String get homeSectionPortfolio => 'Paper portfolio';

  @override
  String get homeSectionNews => 'News';

  @override
  String get homeSectionRadar => 'Economic radar';

  @override
  String get homeSectionIndices => 'US indices';

  @override
  String get homeSectionFearGreed => 'Fear & Greed';

  @override
  String get homeSectionCurrencies => 'Currencies';

  @override
  String get homeSectionKeyRate => 'Key rate';

  @override
  String get homeSectionInflation => 'Inflation';

  @override
  String get homeSectionCommodities => 'Commodities';

  @override
  String get homeSectionMarkets => 'Markets';

  @override
  String get homeSectionBonds => 'Bonds';

  @override
  String get homeSectionWatchlist => 'Watchlist';

  @override
  String get homeSectionCorrelation => 'Correlation';

  @override
  String get compareTitle => 'Compare assets';

  @override
  String compareSubtitle(int max) {
    return 'Pick up to $max assets for overlay chart';
  }

  @override
  String get compareEmpty => 'Select tickers above';

  @override
  String get compareClear => 'Clear';

  @override
  String get compareChartTitle => 'Index 100 · 30 days';

  @override
  String get compareLoadError => 'Could not load history';

  @override
  String get settingsApiKeysTitle => 'API keys';

  @override
  String settingsApiKeySaved(String label) {
    return '$label saved';
  }

  @override
  String get settingsBaseCurrencyHint => 'Used in the converter';

  @override
  String get settingsWidgetConfigTitle => 'Android widget';

  @override
  String get settingsWidgetConfigSubtitle =>
      '4×1 strip or 2×2 grid · up to 4 metrics';

  @override
  String get settingsWidgetLayout => 'Layout';

  @override
  String get settingsWidgetLayoutAuto => 'Auto (by size)';

  @override
  String get settingsWidgetLayoutCompact => 'Compact 4×1';

  @override
  String get settingsWidgetLayoutExpanded => 'Expanded 2×2';

  @override
  String get settingsWidgetLayoutHint =>
      'Auto switches layout when you resize the widget on the home screen';

  @override
  String get settingsWidgetSlot1 => 'Slot 1';

  @override
  String get settingsWidgetSlot2 => 'Slot 2';

  @override
  String get settingsWidgetSlot3 => 'Slot 3';

  @override
  String get settingsWidgetSlot4 => 'Slot 4';

  @override
  String get widgetMetricUsdRub => 'USD/RUB';

  @override
  String get widgetMetricEurRub => 'EUR/RUB';

  @override
  String get widgetMetricBtc => 'BTC';

  @override
  String get widgetMetricEth => 'ETH';

  @override
  String get widgetMetricKeyRate => 'CBR rate';

  @override
  String get widgetMetricBrent => 'Brent';

  @override
  String get widgetMetricWti => 'WTI';

  @override
  String get widgetMetricImoex => 'IMOEX';

  @override
  String get widgetMetricPortfolio => 'Paper portfolio';

  @override
  String get widgetMetricInflationRu => 'Inflation RU';

  @override
  String get homeLayoutReorderHint => 'Drag to reorder · toggle visibility';

  @override
  String get alertsKindThreshold => 'Price level';

  @override
  String get alertsKindPercentChange => 'Daily change %';

  @override
  String get alertsPercentHint => 'Daily change threshold, %';

  @override
  String get alertsHistoryTitle => 'Trigger history';

  @override
  String get alertsHistoryEmpty => 'No triggers yet';

  @override
  String get alertsQuietHoursTitle => 'Quiet hours';

  @override
  String get alertsQuietHoursSubtitle =>
      'No push notifications during this window';

  @override
  String alertsQuietHoursRange(int start, int end) {
    return '$start:00 – $end:00';
  }

  @override
  String get alertsQuietHoursStart => 'From';

  @override
  String get alertsQuietHoursEnd => 'To';

  @override
  String get alertsConditionRise => 'Rise';

  @override
  String get alertsConditionDrop => 'Drop';

  @override
  String get alertsConditionAbove => 'Above';

  @override
  String get alertsConditionBelow => 'Below';

  @override
  String get alertsPresetsTitle => 'Quick presets';

  @override
  String get alertsPresetUsd100 => 'USD/RUB > 100';

  @override
  String get alertsPresetBtcDrop5 => 'BTC −5% daily';

  @override
  String get alertsPresetBtcRise5 => 'BTC +5% daily';

  @override
  String get alertsPresetImoexDrop3 => 'IMOEX −3% daily';

  @override
  String get exportReportTitle => 'Weekly report';

  @override
  String get exportReportSubtitle => 'Brief + watchlist + FX';

  @override
  String get exportReportDone => 'Report shared';

  @override
  String get portfolioBacktestTitle => 'Backtest ~30d';

  @override
  String portfolioBacktestResult(String past, String current, String change) {
    return 'Was $past → now $current ($change)';
  }

  @override
  String get portfolioBacktestUnavailable =>
      'Not enough price history for positions';

  @override
  String get portfolioAllocationTitle => 'Allocation';

  @override
  String get portfolioAllocationSubtitle =>
      'Asset class weights · paper portfolio';

  @override
  String get portfolioAllocationCash => 'Cash';

  @override
  String get portfolioAllocationCrypto => 'Crypto';

  @override
  String get portfolioAllocationStocks => 'Stocks';

  @override
  String get portfolioAllocationBonds => 'Bonds';

  @override
  String portfolioAllocationTotal(String total) {
    return 'Total in assets: $total';
  }

  @override
  String get portfolioRebalanceTitle => 'Rebalancing';

  @override
  String get portfolioRebalanceSubtitle =>
      'Target weights and buy/sell hints by asset class';

  @override
  String get portfolioRebalanceConservative => 'Conservative';

  @override
  String get portfolioRebalancePresetBalanced => 'Balanced';

  @override
  String get portfolioRebalanceGrowth => 'Growth';

  @override
  String get portfolioRebalanceCustom => 'Custom';

  @override
  String portfolioRebalanceDrift(String drift) {
    return 'Max drift: $drift';
  }

  @override
  String get portfolioRebalanceOnTarget =>
      'Portfolio is close to target allocation';

  @override
  String portfolioRebalanceBuy(String amount) {
    return 'Buy $amount';
  }

  @override
  String portfolioRebalanceSell(String amount) {
    return 'Sell $amount';
  }

  @override
  String get portfolioRebalanceHold => 'OK';

  @override
  String portfolioRebalanceInvestCash(String amount) {
    return 'Invest $amount';
  }

  @override
  String portfolioRebalanceFreeCash(String amount) {
    return 'Free up $amount';
  }

  @override
  String portfolioRebalanceCurrentTarget(int current, int target) {
    return 'Now $current% → target $target%';
  }

  @override
  String get portfolioIncomeTitle => 'Income calendar';

  @override
  String get portfolioIncomeSubtitle =>
      'Coupons, dividends and maturities from your positions';

  @override
  String get portfolioIncomeNext30 => '30 days';

  @override
  String get portfolioIncomeNext90 => '90 days';

  @override
  String get portfolioIncomeByMonth => 'By month';

  @override
  String portfolioIncomeMonthChip(String month, String amount) {
    return '$month · $amount ₽';
  }

  @override
  String get portfolioIncomeUpcoming => 'Upcoming cashflows';

  @override
  String get portfolioIncomeCoupon => 'Coupon';

  @override
  String get portfolioIncomeCouponEstimate => 'Coupon (est.)';

  @override
  String get portfolioIncomeMaturity => 'Face value at maturity';

  @override
  String get portfolioIncomeDividendEstimate => 'Dividends (est.)';

  @override
  String get portfolioScenarioTitle => 'What-if scenarios';

  @override
  String get portfolioScenarioSubtitle => 'Portfolio value under market shocks';

  @override
  String get portfolioScenarioUsdUp10 => 'USD/RUB +10%';

  @override
  String get portfolioScenarioBtcDown30 => 'BTC −30%';

  @override
  String get portfolioScenarioImoexDown15 => 'IMOEX −15%';

  @override
  String get portfolioScenarioKeyRateUp2 => 'Rate +2 pp';

  @override
  String portfolioScenarioResult(String base, String scenario) {
    return '$base → $scenario';
  }

  @override
  String portfolioScenarioDelta(String amount, String percent) {
    return 'Δ $amount ($percent)';
  }

  @override
  String get portfolioRealReturnTitle => 'Real return';

  @override
  String get portfolioRealReturnSubtitle =>
      'Nominal minus inflation · vs IMOEX and deposit';

  @override
  String get portfolioRealReturnHorizon30d => '30 days';

  @override
  String get portfolioRealReturnHorizonAll => 'Since start';

  @override
  String get portfolioRealReturnNominal => 'Portfolio (nominal)';

  @override
  String get portfolioRealReturnReal => 'Portfolio (real)';

  @override
  String get portfolioRealReturnInflation => 'Inflation (RU)';

  @override
  String get portfolioRealReturnImoex => 'IMOEX';

  @override
  String get portfolioRealReturnDeposit => 'Deposit (CBR rate)';

  @override
  String portfolioRealReturnBeatInflation(String value) {
    return 'Real return $value — beats inflation';
  }

  @override
  String portfolioRealReturnLoseInflation(String value) {
    return 'Real return $value — below inflation';
  }

  @override
  String portfolioRealReturnBeatImoex(String delta) {
    return 'Ahead of IMOEX by $delta';
  }

  @override
  String portfolioRealReturnLoseImoex(String delta) {
    return 'Behind IMOEX by $delta';
  }

  @override
  String get portfolioRealReturnBeatDeposit => 'Above CBR-rate deposit';

  @override
  String get portfolioRealReturnLoseDeposit => 'Below CBR-rate deposit';

  @override
  String get watchlistVolatilityTitle => 'Watchlist volatility';

  @override
  String get watchlistVolatilitySubtitle =>
      'Annual σ from daily returns · ~30d sparkline';

  @override
  String watchlistVolatilityAnnual(String value) {
    return 'σ $value';
  }

  @override
  String get watchlistVolatilityLow => 'Low';

  @override
  String get watchlistVolatilityHigh => 'High';

  @override
  String get portfolioTradeJournalTitle => 'Trade journal';

  @override
  String get portfolioTradeJournalSubtitle =>
      'Buy and sell history for the paper portfolio';

  @override
  String get portfolioTradeJournalEmpty => 'No trades yet · buy from watchlist';

  @override
  String get portfolioTradeJournalBuy => 'Buy';

  @override
  String get portfolioTradeJournalSell => 'Sell';

  @override
  String get portfolioTradeJournalOpenAll => 'All';

  @override
  String get portfolioTradeJournalExport => 'Export CSV';

  @override
  String portfolioTradeJournalStats(int total, int buys, int sells) {
    return '$total trades · $buys buys · $sells sells';
  }

  @override
  String portfolioTradeJournalRealizedPnl(String value) {
    return 'Realized P&L: $value';
  }

  @override
  String get portfolioTradeJournalImport => 'Import CSV';

  @override
  String get portfolioTradeJournalImportHint =>
      'Paste CSV export from EcoPulse or broker';

  @override
  String get portfolioTradeJournalImportEmpty => 'No trades found in file';

  @override
  String portfolioTradeJournalImportDone(int added, int skipped) {
    return 'Imported $added trades · skipped $skipped';
  }

  @override
  String portfolioTradeJournalImportError(String error) {
    return 'Import failed: $error';
  }

  @override
  String get portfolioTaxTitle => 'Tax estimate';

  @override
  String get portfolioTaxSubtitle =>
      'Local NDFL estimate from trade journal · not tax advice';

  @override
  String get portfolioTaxOpenDetails => 'Details';

  @override
  String get portfolioTaxExport => 'Export CSV';

  @override
  String get portfolioTaxEmpty => 'No taxable events for this year';

  @override
  String get portfolioTaxNetRealized => 'Net realized P&L';

  @override
  String get portfolioTaxEstimatedNdfl => 'Estimated NDFL';

  @override
  String get portfolioTaxPassiveIncome => 'Est. coupons & dividends';

  @override
  String get portfolioTaxPassiveTax => 'Est. tax on passive income';

  @override
  String get portfolioTaxRealizedGain => 'Realized gains';

  @override
  String get portfolioTaxRealizedLoss => 'Realized losses';

  @override
  String get portfolioTaxTaxableBase => 'Taxable base';

  @override
  String get portfolioTaxSellCount => 'Sell trades';

  @override
  String get portfolioTaxUnrealizedGain => 'Unrealized gains (info)';

  @override
  String get portfolioTaxUnrealizedLoss => 'Unrealized losses (info)';

  @override
  String get portfolioTaxSectionTrading => 'Trading income';

  @override
  String get portfolioTaxSectionPassive => 'Coupons & dividends (est.)';

  @override
  String get portfolioTaxSectionUnrealized => 'Open positions';

  @override
  String get portfolioTaxTotalLabel => 'Total estimated tax';

  @override
  String portfolioTaxRateLabel(String rate) {
    return 'Rate $rate% · simplified';
  }

  @override
  String get portfolioTaxIisNote =>
      'IIS account: tax may be reduced under Type A/B rules — confirm with your broker.';

  @override
  String get portfolioTaxDisclaimer =>
      'Educational estimate only. Rates, exemptions, and IIS rules change. EcoPulse does not file tax returns.';

  @override
  String get portfolioTaxSellsHeader => 'Sell trades this year';

  @override
  String portfolioTaxSellPnl(String value) {
    return 'P&L: $value';
  }

  @override
  String get portfolioRoboTitle => 'Robo-advisor lite';

  @override
  String get portfolioRoboSubtitle =>
      'Allocation suggestion from account type, goals, and market mood';

  @override
  String portfolioRoboRecommended(String preset) {
    return 'Recommended: $preset';
  }

  @override
  String portfolioRoboRiskScore(int score) {
    return 'Risk profile: $score/100';
  }

  @override
  String get portfolioRoboActionsHeader => 'Priority actions';

  @override
  String portfolioRoboApplyPreset(String preset) {
    return 'Use $preset allocation';
  }

  @override
  String get portfolioRoboDisclaimer =>
      'Educational suggestion only. Not investment advice. Confirm with your own plan.';

  @override
  String get portfolioRoboReasonIis =>
      'IIS account — long horizon favors bonds and stability';

  @override
  String get portfolioRoboReasonCrypto =>
      'Crypto account — higher growth target with more crypto weight';

  @override
  String get portfolioRoboReasonUsd =>
      'USD account — balanced mix with global stocks';

  @override
  String get portfolioRoboReasonShortGoal =>
      'Goal deadline within 2 years — lower risk allocation';

  @override
  String get portfolioRoboReasonLongGoal =>
      'Long-term goal — room for growth assets';

  @override
  String get portfolioRoboReasonFngHigh =>
      'Fear & Greed is high — reduce risk, avoid FOMO';

  @override
  String get portfolioRoboReasonFngLow =>
      'Market fear is elevated — stay disciplined, don\'t panic sell';

  @override
  String get portfolioRoboReasonEmpty =>
      'Empty portfolio — start with a balanced mix';

  @override
  String get portfolioRoboReasonHighCash =>
      'High cash share — consider investing idle cash';

  @override
  String get portfolioRoboReasonHighCrypto =>
      'Crypto overweight — rebalance toward stocks and bonds';

  @override
  String get portfolioRoboReasonDefault =>
      'Balanced mix fits your current profile';

  @override
  String get cloudSyncTitle => 'Cloud sync';

  @override
  String get cloudSyncSubtitle =>
      'Sync via JSON file · Google Drive, Telegram, email';

  @override
  String get cloudSyncStatusSynced => 'Data is synced';

  @override
  String get cloudSyncStatusPending => 'Local changes — export sync file';

  @override
  String get cloudSyncStatusNever => 'Not synced yet';

  @override
  String cloudSyncLastOut(String date) {
    return 'Sent: $date';
  }

  @override
  String cloudSyncLastIn(String date) {
    return 'Loaded: $date';
  }

  @override
  String get cloudSyncExport => 'Send';

  @override
  String get cloudSyncImport => 'Load';

  @override
  String get cloudSyncExportDone => 'Sync file ready — save to cloud';

  @override
  String cloudSyncImportSuccess(int count) {
    return 'Loaded $count data keys';
  }

  @override
  String get cloudSyncImportNotNewer =>
      'File is not newer than data on this device';

  @override
  String get cloudSyncShareSubject => 'EcoPulse sync';

  @override
  String cloudSyncError(String message) {
    return 'Sync error: $message';
  }

  @override
  String get adminCrashReports => 'Crash reports';

  @override
  String get assistantTitle => 'EcoPulse Assistant';

  @override
  String get assistantHint => 'Ask about rates, brief or portfolio…';

  @override
  String get assistantThinking => 'Thinking…';

  @override
  String get assistantDisclaimer => 'Not investment advice';

  @override
  String get assistantClearHistory => 'Clear chat';

  @override
  String get assistantVoiceListen => 'Listen';

  @override
  String get assistantSourceLocal => 'local';

  @override
  String get assistantSourceCloud => 'Gemini';

  @override
  String get assistantQuickPrice => 'USD/RUB';

  @override
  String get assistantQuickBrief => 'Brief';

  @override
  String get assistantQuickPortfolio => 'Portfolio';

  @override
  String get assistantQuickExplain => 'Inflation';

  @override
  String get assistantQuickPriceQuery => 'usd rub rate';

  @override
  String get assistantQuickBriefQuery => 'today brief';

  @override
  String get assistantQuickPortfolioQuery => 'my portfolio';

  @override
  String get assistantQuickExplainQuery => 'what is inflation';

  @override
  String get settingsGeminiKey => 'Gemini API Key';

  @override
  String get courseLibraryTitle => 'Courses';

  @override
  String get courseLibrarySubtitle =>
      'Investing and personal finance education';

  @override
  String get courseDisclaimer =>
      'EcoPulse educational content. Not investment advice.';

  @override
  String get courseHomeCardTitle => 'Investor course';

  @override
  String courseChaptersCount(int count) {
    return '$count chapters';
  }

  @override
  String courseReadMinutes(int minutes) {
    return '~$minutes min read';
  }

  @override
  String courseProgressPercent(int percent) {
    return '$percent% complete';
  }

  @override
  String get courseStartReading => 'Read';

  @override
  String get courseReadFromStart => 'From start';

  @override
  String get courseContinue => 'Continue';

  @override
  String get courseTableOfContents => 'Table of contents';

  @override
  String courseChapterProgress(int current, int total) {
    return 'Chapter $current of $total';
  }

  @override
  String get courseChapterDone => 'Done';

  @override
  String get courseMarkRead => 'Mark read';

  @override
  String get courseMarkedRead => 'Chapter marked as read';

  @override
  String get coursePrevChapter => 'Back';

  @override
  String get courseNextChapter => 'Next';

  @override
  String get courseFinish => 'Finish';

  @override
  String get homeSectionLearn => 'Courses';

  @override
  String get assistantQuickCourse => 'Course';

  @override
  String get assistantQuickCourseQuery => 'open investing course';

  @override
  String coursePagesCount(int pages) {
    return '~$pages pp.';
  }

  @override
  String courseChapterShort(int current, int total) {
    return 'Ch. $current/$total';
  }

  @override
  String get courseReaderSettings => 'Reading settings';

  @override
  String get courseFontSize => 'Font size';

  @override
  String get courseReadingTheme => 'Theme';

  @override
  String get courseThemeSystem => 'System';

  @override
  String get courseThemeSepia => 'Sepia';

  @override
  String get courseThemeDark => 'Dark';

  @override
  String get courseSearch => 'Search book';

  @override
  String get courseSearchHint => 'Keyword…';

  @override
  String get courseSearchEmpty => 'No results';

  @override
  String get courseSearchClose => 'Close';

  @override
  String courseQuizProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get courseQuizNext => 'Submit';

  @override
  String get courseQuizPassed => 'Great! Part complete';

  @override
  String get courseQuizRetry => 'Try again';

  @override
  String courseQuizScore(int correct, int total) {
    return 'Correct: $correct of $total';
  }

  @override
  String get courseQuizContinue => 'Continue reading';

  @override
  String get courseQuizTryAgain => 'Retry quiz';

  @override
  String get homeServerTitle => 'Home server';

  @override
  String get homeServerSubtitle =>
      'LAN backend on your PC for profile ID and chats';

  @override
  String get homeServerUrlLabel => 'Server URL';

  @override
  String get homeServerUrlHint => 'http://192.168.1.105:8081';

  @override
  String get homeServerIpHint =>
      'On PC run ipconfig and use IPv4 from Wi-Fi adapter';

  @override
  String get homeServerCheckConnection => 'Check connection';

  @override
  String get homeServerStatusOnline => 'Online';

  @override
  String get homeServerStatusOffline => 'Offline';

  @override
  String get homeServerStatusUnknown => 'Not checked';

  @override
  String get homeServerLogin => 'Sign in';

  @override
  String get homeServerRegister => 'Register';

  @override
  String get homeServerLoginLabel => 'Login';

  @override
  String get homeServerPasswordLabel => 'Password';

  @override
  String get homeServerProfileId => 'Profile ID';

  @override
  String get homeServerCopyProfileId => 'Copy Profile ID';

  @override
  String get homeServerProfileIdCopied => 'Profile ID copied';

  @override
  String homeServerLoggedInAs(String login) {
    return 'Signed in as $login';
  }

  @override
  String get homeServerLogout => 'Sign out';

  @override
  String get homeServerSwitchAccount => 'Switch account';

  @override
  String get homeServerEnsureSelfChat => 'Ensure self chat';

  @override
  String get homeServerSelfChatReady => 'Self chat is ready';

  @override
  String get homeServerRegisterSuccess => 'Registration successful';

  @override
  String get homeServerLoginSuccess => 'Signed in';

  @override
  String get homeServerLoggedOut => 'Signed out';

  @override
  String get homeServerCreateTestAccount => 'Create test2 account';

  @override
  String get homeServerTestAccountCreated =>
      'Account test2 created (or already exists)';

  @override
  String get homeServerErrorLoginTaken => 'Login already taken';

  @override
  String get homeServerErrorInvalidCredentials => 'Invalid login or password';

  @override
  String get homeServerErrorLoginShort => 'Login must be at least 3 characters';

  @override
  String get homeServerErrorPasswordShort =>
      'Password must be at least 4 characters';

  @override
  String get homeServerErrorUpgrade => 'App update required for this server';

  @override
  String get homeServerErrorNoUrl => 'Enter server URL first';

  @override
  String get homeServerErrorNetwork =>
      'Cannot reach server — check Wi-Fi and firewall';

  @override
  String get cloudAccountTitle => 'EcoPulse Cloud';

  @override
  String get cloudAccountSubtitle => 'Sync profile and watchlist via Supabase';

  @override
  String get cloudAccountNotConfigured =>
      'Build with --dart-define=SUPABASE_URL and SUPABASE_ANON_KEY to enable cloud sync.';

  @override
  String get cloudEmailLabel => 'Email';

  @override
  String get cloudPasswordLabel => 'Password';

  @override
  String get cloudLogin => 'Sign in';

  @override
  String get cloudRegister => 'Create account';

  @override
  String get cloudSignInGoogle => 'Continue with Google';

  @override
  String get cloudSwitchToLogin => 'Already have an account? Sign in';

  @override
  String get cloudSwitchToRegister => 'New here? Create account';

  @override
  String get cloudLoginSuccess => 'Signed in to EcoPulse Cloud';

  @override
  String get cloudRegisterSuccess =>
      'Account created — check email if confirmation is required';

  @override
  String get cloudLoggedOut => 'Signed out of cloud';

  @override
  String cloudLoggedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get cloudLogout => 'Sign out';

  @override
  String get cloudSyncPush => 'Upload';

  @override
  String get cloudSyncPull => 'Download';

  @override
  String get cloudSyncPushSuccess => 'Profile and watchlist uploaded';

  @override
  String get cloudSyncPullSuccess => 'Profile and watchlist downloaded';

  @override
  String get cloudSyncFailed => 'Cloud sync failed';

  @override
  String get cloudSyncNever => 'Not synced yet';

  @override
  String cloudSyncLastAt(String time) {
    return 'Last sync: $time';
  }

  @override
  String get marketsTabletSelectAsset => 'Select an asset to view the chart';

  @override
  String get messagePushTitle => 'Chat notifications';

  @override
  String get messagePushSubtitle =>
      'Push when a new message arrives on home server';

  @override
  String get messagePushRequiresServer =>
      'Sign in to home server to enable chat push';

  @override
  String get messagePushFcmReady =>
      'FCM enabled — instant delivery when server sends push';

  @override
  String get marketsLiveBadge => 'LIVE';

  @override
  String get proTierTitle => 'EcoPulse Pro';

  @override
  String get proTierFreeTitle => 'Free plan';

  @override
  String get proTierActiveTitle => 'Pro active';

  @override
  String get proTierSubtitle =>
      'Unlimited alerts, advanced charts, and export without limits.';

  @override
  String get proTierFreeBadge => 'Upgrade for unlimited alerts';

  @override
  String get proTierActiveBadge => 'Pro benefits unlocked';

  @override
  String get proTierComingSoon =>
      'In-app purchase coming soon. Dev builds: enable in Admin panel.';

  @override
  String get proBenefitAlertsTitle => 'Price alerts';

  @override
  String proBenefitAlertsFree(int count) {
    return 'Up to $count active alerts';
  }

  @override
  String get proBenefitAlertsPro => 'Unlimited active alerts';

  @override
  String get proBenefitChartsTitle => 'Advanced charts';

  @override
  String get proBenefitChartsSub =>
      'All MA periods, indicators, fullscreen mode';

  @override
  String get proBenefitExportTitle => 'Export';

  @override
  String get proBenefitExportSub => 'CSV/PDF without watermark (coming soon)';

  @override
  String proAlertLimitReached(int count) {
    return 'Free plan limit: $count alerts. Upgrade to Pro.';
  }

  @override
  String get adminDashboardMetrics => 'User metrics';

  @override
  String get adminMetricWatchlist => 'Watchlist';

  @override
  String get adminMetricAlerts => 'Alerts';

  @override
  String get adminMetricThreads => 'Chats';

  @override
  String get adminMetricPositions => 'Positions';

  @override
  String get adminMetricServer => 'Server';

  @override
  String get adminFlagLiveCrypto => 'Live crypto WebSocket (Binance)';

  @override
  String get adminFlagProTier => 'EcoPulse Pro (dev unlock)';

  @override
  String get brokerConnectTitle => 'Connect broker (read-only)';

  @override
  String get brokerConnectSubtitle =>
      'View real T-Bank portfolio alongside paper trading';

  @override
  String get brokerReadOnlyTitle => 'T-Bank · read-only';

  @override
  String get brokerReadOnlyDisclaimer =>
      'View only — EcoPulse never places orders or moves funds.';

  @override
  String get brokerTokenLabel => 'T-Invest API token';

  @override
  String get brokerTokenHint => 'Read-only token from tbank.ru/invest/settings';

  @override
  String get brokerRefresh => 'Refresh';

  @override
  String get brokerAccountLabel => 'Broker account';

  @override
  String brokerTotalValue(String value) {
    return 'Total: $value';
  }

  @override
  String brokerSyncedAt(String time) {
    return 'Updated: $time';
  }

  @override
  String get brokerEmptyPositions => 'No securities in this account';

  @override
  String brokerMorePositions(int count) {
    return '+$count more positions';
  }

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesNewChat => 'New chat';

  @override
  String get messagesEmpty => 'No chats yet';

  @override
  String get messagesNotConnected =>
      'Connect to home server in Settings to use chats';

  @override
  String get messagesSelfChat => 'Message yourself';

  @override
  String get messagesSearchHint => 'Search by login or Profile ID';

  @override
  String get messagesSearchEmpty => 'No users found';

  @override
  String get messagesInputHint => 'Message…';

  @override
  String get messagesThreadEmpty => 'No messages yet — write the first one';

  @override
  String get profileIdLabel => 'Profile ID';

  @override
  String get profileIdHint =>
      'UUID from your home server — share to start a chat';

  @override
  String get customizationSectionTitle => 'Customization';

  @override
  String get customizationTitle => 'Customization';

  @override
  String get customizationSubtitle =>
      'Theme, charts, home and navigation in one place';

  @override
  String get customizationSettingsEntry => 'All appearance settings';

  @override
  String get customizationSettingsEntrySubtitle =>
      'Charts, theme, home, navigation and widgets';

  @override
  String get customizationPreview => 'Preview';

  @override
  String get customizationPreviewSample => 'Sample chart with current settings';

  @override
  String customizationPreviewTheme(String mode) {
    return 'Theme: $mode';
  }

  @override
  String customizationPreviewAccent(String color) {
    return 'Accent: $color';
  }

  @override
  String get customizationPreviewCarouselHint =>
      'Swipe to preview chart, home, markets, portfolio, navigation';

  @override
  String get customizationPreviewSlideChart => 'Chart';

  @override
  String get customizationPreviewSlideHome => 'Home';

  @override
  String get customizationPreviewSlideMarkets => 'Markets';

  @override
  String get customizationPreviewSlidePortfolio => 'Portfolio';

  @override
  String get customizationPreviewSlideNavigation => 'Navigation';

  @override
  String get customizationPreviewCompact => 'Compact';

  @override
  String get customizationWidgetPreviewTitle => 'Android widget preview';

  @override
  String get customizationWidgetPreviewSubtitle =>
      'Live mock of home screen widget with current metrics';

  @override
  String get customizationWidgetPreviewAutoHint =>
      'Auto layout: compact on 4×1, expanded when widget is taller';

  @override
  String get customizationThemeAbTitle => 'A/B theme preview';

  @override
  String get customizationThemeAbSubtitle =>
      'Compare your current theme with a built-in preset side-by-side';

  @override
  String get customizationThemeAbCompareWith => 'Compare with';

  @override
  String get customizationThemeAbCurrent => 'Current (A)';

  @override
  String get customizationThemeAbApply => 'Apply comparison theme';

  @override
  String customizationThemeAbApplied(String name) {
    return 'Theme from \"$name\" applied';
  }

  @override
  String get customizationResetSection => 'Reset section';

  @override
  String get customizationResetAll => 'Reset all';

  @override
  String get customizationResetAllConfirm =>
      'Restore all settings to defaults?';

  @override
  String get customizationPresetsTitle => 'Presets';

  @override
  String get customizationPresetsHint =>
      'Built-in profiles or your saved configurations';

  @override
  String get customizationPresetSave => 'Save current';

  @override
  String get customizationPresetSaveDialogTitle => 'New preset';

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
      'Paste EcoPulse preset JSON or share link';

  @override
  String get customizationPresetShareLink => 'Share link';

  @override
  String get customizationPresetMarketplaceTitle => 'Preset marketplace';

  @override
  String get customizationPresetMarketplaceSubtitle =>
      'Featured profiles — apply or share a link';

  @override
  String get customizationPresetMarketplaceApply => 'Apply';

  @override
  String get customizationPresetLinkImportTitle => 'Import preset';

  @override
  String customizationPresetLinkImportBody(String name) {
    return 'Install preset \"$name\" from link?';
  }

  @override
  String get customizationPresetLinkImportApply => 'Install';

  @override
  String customizationPresetImportSuccess(String name) {
    return 'Preset \"$name\" added';
  }

  @override
  String get customizationPresetImportError => 'Could not import preset';

  @override
  String customizationPresetApplied(String name) {
    return 'Preset \"$name\" applied';
  }

  @override
  String customizationPresetSaved(String name) {
    return 'Preset \"$name\" saved';
  }

  @override
  String get customizationPresetShareSubject => 'EcoPulse preset';

  @override
  String get customizationSectionCharts => 'Charts';

  @override
  String get customizationSectionAppearance => 'Appearance';

  @override
  String get customizationSectionHome => 'Home';

  @override
  String get customizationSectionNavigation => 'Navigation';

  @override
  String get customizationSectionMarkets => 'Markets';

  @override
  String get customizationSectionPortfolio => 'Portfolio';

  @override
  String get customizationSectionWidgets => 'Widget';

  @override
  String get customizationSectionDataDisplay => 'Data display';

  @override
  String get customizationSectionAssistant => 'Assistant';

  @override
  String get customizationChartDefaultType => 'Default chart type';

  @override
  String get customizationChartPeriod => 'Period';

  @override
  String get customizationChartHeight => 'Height';

  @override
  String get customizationChartShowLegend => 'Legend';

  @override
  String get customizationChartPreferCandles => 'Candles when available';

  @override
  String get customizationChartNormalizedCompare => 'Normalized compare';

  @override
  String get customizationChartVisualTitle => 'Visual options';

  @override
  String get customizationChartSeriesPalette => 'Series palette';

  @override
  String get customizationChartGridStyle => 'Grid style';

  @override
  String get customizationChartLineWidth => 'Line width';

  @override
  String get customizationChartShowGrid => 'Grid';

  @override
  String get customizationChartShowGradientFill => 'Gradient fill';

  @override
  String get customizationChartShowCrosshair => 'Touch crosshair';

  @override
  String get customizationChartShowEventMarkers => 'Event markers';

  @override
  String get customizationChartShowPointMarkers => 'Point markers';

  @override
  String get customizationChartAnimateOnLoad => 'Animate on load';

  @override
  String get customizationChartShowVolume => 'Volume (candles)';

  @override
  String get customizationChartEnablePanZoom => 'Pinch zoom & pan';

  @override
  String get customizationChartPriceAxisRight => 'Price axis on right';

  @override
  String get customizationChartContextProfilesTitle => 'Screen chart profiles';

  @override
  String get customizationChartContextProfilesHint =>
      'Override chart type and period for specific screens.';

  @override
  String get customizationChartUseGlobalDefaults => 'Use global defaults';

  @override
  String get customizationChartContextTypeOverride => 'Chart type';

  @override
  String get customizationChartContextPeriodOverride => 'Period';

  @override
  String get customizationChartContextAssetDetail => 'Asset detail';

  @override
  String get customizationChartContextInflation => 'Inflation (CPI)';

  @override
  String get customizationChartContextCurrency => 'Currency rates';

  @override
  String get customizationChartContextCompare => 'Compare assets';

  @override
  String get customizationChartContextPortfolio => 'Portfolio allocation';

  @override
  String get customizationChartContextBonds => 'Bond yield curve';

  @override
  String get customizationChartContextKeyRate => 'Key rate';

  @override
  String get customizationChartContextHomeSparkline => 'Home sparklines';

  @override
  String get customizationFontScale => 'Text scale';

  @override
  String get customizationUiDensity => 'UI density';

  @override
  String get customizationCardStyle => 'Card style';

  @override
  String get customizationMotionReduced => 'Reduce motion';

  @override
  String get customizationUiDensityCompact => 'Compact';

  @override
  String get customizationUiDensityComfortable => 'Comfortable';

  @override
  String get customizationUiDensitySpacious => 'Spacious';

  @override
  String get customizationCardStyleFlat => 'Flat';

  @override
  String get customizationCardStyleGlass => 'Glass';

  @override
  String get customizationCardStyleBordered => 'Bordered';

  @override
  String get customizationAmoledPureBlack => 'Pure black (OLED)';

  @override
  String get customizationNavDefaultTab => 'Default tab';

  @override
  String get customizationNavShowFab => 'Assistant button';

  @override
  String get customizationNavHideLabels => 'Hide tab labels';

  @override
  String get customizationNavVisibleTabs => 'Visible tabs';

  @override
  String get customizationNavTabOrder =>
      'Drag to reorder tabs in the bottom bar';

  @override
  String get customizationNavTabHidden => 'Hidden';

  @override
  String get customizationHomeNewsCount => 'News on home';

  @override
  String get customizationHomeSparklines => 'Sparklines';

  @override
  String get customizationMarketsGroupStocks => 'Group stocks by sector';

  @override
  String get customizationMarketsHeatmap => 'Sector heatmap';

  @override
  String get customizationMarketsCompactRows => 'Compact rows';

  @override
  String get customizationMarketsDefaultRegion => 'Default stock filter';

  @override
  String get customizationMarketsRegionAll => 'All';

  @override
  String get customizationMarketsRegionRu => 'MOEX';

  @override
  String get customizationMarketsRegionUs => 'US';

  @override
  String get customizationPortfolioAllocation => 'Allocation chart';

  @override
  String get customizationPortfolioRealizedPnl => 'Realized P/L';

  @override
  String get customizationPortfolioJournal => 'Trade journal';

  @override
  String get customizationAssistantPreferCloud => 'Cloud AI (Gemini)';

  @override
  String get customizationAssistantQuickChips => 'Quick chips';

  @override
  String get customizationAssistantVoice => 'Voice input';

  @override
  String get customizationDataDecimalPlaces => 'Decimal places';

  @override
  String get customizationDataLargeNumbers => 'Large numbers';

  @override
  String get customizationDataShowCurrencyCode => 'Show currency code';

  @override
  String get customizationData24HourTime => '24-hour time';

  @override
  String get customizationSyncTitle => 'Server sync';

  @override
  String get customizationSyncSubtitle =>
      'Push/pull customization via home server (LAN)';

  @override
  String get customizationSyncNotLoggedIn => 'Sign in to home server to sync';

  @override
  String get customizationSyncNever => 'Not synced with server yet';

  @override
  String get customizationSyncSynced => 'Customization matches server';

  @override
  String get customizationSyncLocalNewer =>
      'Local settings are newer — push recommended';

  @override
  String get customizationSyncRemoteNewer =>
      'Server has newer settings — pull recommended';

  @override
  String get customizationSyncRemoteMissing =>
      'No settings on server — push to upload';

  @override
  String customizationSyncLastPush(String date) {
    return 'Pushed: $date';
  }

  @override
  String customizationSyncLastPull(String date) {
    return 'Pulled: $date';
  }

  @override
  String customizationSyncError(String message) {
    return 'Sync error: $message';
  }

  @override
  String get customizationSyncOpenServer => 'Home server account';

  @override
  String get customizationSyncSmart => 'Smart sync';

  @override
  String get customizationSyncPush => 'Push';

  @override
  String get customizationSyncPull => 'Pull';

  @override
  String get customizationSyncDone => 'Customization synced';

  @override
  String get customizationSyncPushDone => 'Settings sent to server';

  @override
  String get customizationSyncPullDone => 'Settings loaded from server';

  @override
  String get customizationSyncFailed => 'Sync failed — check connection';

  @override
  String get customizationChartShowMa7 => 'MA(7)';

  @override
  String get customizationChartShowMa25 => 'MA(25)';

  @override
  String get customizationChartShowMa99 => 'MA(99)';

  @override
  String get chartFullscreen => 'Fullscreen chart';

  @override
  String get customizationHubSectionsTitle => 'Sections';

  @override
  String get settingsHubSubtitle => 'App preferences and data';

  @override
  String get settingsHubGroupsTitle => 'Settings groups';

  @override
  String get portfolioAccountsTitle => 'Accounts';

  @override
  String get portfolioAccountsAdd => 'Add account';

  @override
  String get portfolioAccountKindMain => 'Main';

  @override
  String get portfolioAccountKindIis => 'IIS';

  @override
  String get portfolioAccountKindUsd => 'USD';

  @override
  String get portfolioAccountKindCrypto => 'Crypto';

  @override
  String get portfolioAccountKindCustom => 'Custom';

  @override
  String get portfolioAccountNameHint => 'Account name';

  @override
  String get portfolioAccountCreate => 'Create account';

  @override
  String get portfolioAccountDelete => 'Remove account';

  @override
  String portfolioAccountDeleteConfirm(String name) {
    return 'Remove \"$name\" and all its positions?';
  }

  @override
  String get portfolioAccountMaxReached => 'Maximum 8 accounts';

  @override
  String get portfolioSavingsGoalsTitle => 'Savings goals';

  @override
  String get portfolioSavingsGoalsSubtitle =>
      'Track progress toward a target amount';

  @override
  String get portfolioSavingsGoalAdd => 'Add goal';

  @override
  String get portfolioSavingsGoalTitleHint => 'Goal name';

  @override
  String get portfolioSavingsGoalTargetHint => 'Target amount, ₽';

  @override
  String get portfolioSavingsGoalDeadline => 'Deadline';

  @override
  String portfolioSavingsGoalProgress(String current, String target) {
    return '$current of $target';
  }

  @override
  String portfolioSavingsGoalDaysLeft(int days) {
    return '$days days left';
  }

  @override
  String get portfolioSavingsGoalOverdue => 'Deadline passed';

  @override
  String get portfolioSavingsGoalLinkedAccount => 'Linked to current account';

  @override
  String get portfolioSavingsGoalEmpty =>
      'No goals yet — set your first target';
}
