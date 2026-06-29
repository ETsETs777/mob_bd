// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'EcoPulse';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCurrency => 'Valuta';

  @override
  String get tabInflation => 'Inflazione';

  @override
  String get tabMarkets => 'Mercati';

  @override
  String get tabMessages => 'Messaggi';

  @override
  String get tabSettings => 'Impostazioni';

  @override
  String get tabProfile => 'Profilo';

  @override
  String get pinEnterCode => 'Inserisci il codice di accesso';

  @override
  String get pinWrongCode => 'Codice di accesso errato';

  @override
  String get pinUseBiometric => 'Accedi con la biometria';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsDefaultTab => 'Scheda predefinita';

  @override
  String get settingsBiometric => 'Biometria';

  @override
  String get settingsBiometricSubtitle =>
      'Impronta digitale o Face ID invece del PIN';

  @override
  String get shareQuote => 'Condividi';

  @override
  String get copyQuote => 'Copia';

  @override
  String get copied => 'Copiato';

  @override
  String shareMessage(String title, String value) {
    return '$title: $value';
  }

  @override
  String get alertsTitle => 'Avvisi sui prezzi';

  @override
  String get alertsAdd => 'Aggiungi avviso';

  @override
  String get alertsEmpty =>
      'Nessun avviso ancora. Esempio: USD/RUB superiore a 90';

  @override
  String get alertsSymbol => 'Strumento';

  @override
  String get alertsThreshold => 'Soglia';

  @override
  String get alertsSave => 'Salva';

  @override
  String get alertsCheckOnRefresh => 'Controllato quando i dati si aggiornano';

  @override
  String get alertsSettingsSubtitle =>
      'USD/RUB, BTC e altro: sfondo + push di aggiornamento';

  @override
  String alertsLastTriggered(String time) {
    return 'Attivato: $time';
  }

  @override
  String get alertAction => 'Imposta avviso';

  @override
  String get homePulseTitle => 'Impulso economico';

  @override
  String get homePulseSubtitle => 'Metriche chiave in tempo reale';

  @override
  String homeUpdated(String time) {
    return 'Aggiornato: $time';
  }

  @override
  String get sectionCurrencies => 'Valute';

  @override
  String get sectionKeyRate => 'Tasso chiave CBR';

  @override
  String get sectionInflation => 'Inflazione';

  @override
  String get sectionCommodities => 'Merci';

  @override
  String get sectionMarkets => 'Mercati';

  @override
  String get sectionWatchlist => 'Lista di controllo';

  @override
  String get actionAll => 'Tutto';

  @override
  String get actionMarkets => 'Mercati';

  @override
  String get actionCalculators => 'Calcolatrici';

  @override
  String get chartTitle => 'Grafico';

  @override
  String get chartLine => 'Linea';

  @override
  String get chartCandles => 'Candele';

  @override
  String get shareChart => 'Condividi il grafico';

  @override
  String get retry => 'Riprova';

  @override
  String errorGeneric(String message) {
    return 'Errore: $message';
  }

  @override
  String get assetType => 'Tipo';

  @override
  String get assetCurrency => 'Valuta';

  @override
  String get assetSource => 'Fonte';

  @override
  String get assetTypeCrypto => 'Criptovaluta';

  @override
  String get assetTypeStockRu => 'Scorte (MOEX)';

  @override
  String get assetTypeStockUs => 'Azioni (Stati Uniti)';

  @override
  String get settingsCompactHome => 'Casa compatta';

  @override
  String get settingsCompactHomeSubtitle =>
      'Griglia 2×2 densa, spaziatura più piccola';

  @override
  String get currencyLoadError => 'Errore di caricamento';

  @override
  String currencyChart30d(String pair) {
    return 'Grafico $pair (30 days)';
  }

  @override
  String get currencyConverter => 'Convertitore';

  @override
  String get currencyAmount => 'Quantità';

  @override
  String get currencyFrom => 'Da';

  @override
  String get currencyTo => 'A';

  @override
  String get currencyFee => 'Commissione di cambio';

  @override
  String get currencyQuickConvert => 'Conversione rapida';

  @override
  String get currencyQuickHint => 'da 100 USD a EUR';

  @override
  String get currencyQuickFormatError => 'Formato: da 100 USD a EUR';

  @override
  String get currencyHistory => 'Cronologia delle conversioni';

  @override
  String get currencyUnavailable => 'Carica errore · tocca Aggiorna';

  @override
  String get marketsSearchHint => 'Cerca BTC, SBER, AAPL…';

  @override
  String get marketsTabCrypto => 'Criptovaluta';

  @override
  String get marketsTabStocks => 'Azioni';

  @override
  String get marketsTabBonds => 'Obbligazioni';

  @override
  String get assetTypeBondRu => 'Vincolo (MOEX)';

  @override
  String get marketsFilterOfz => 'OFZ';

  @override
  String get marketsFilterCorporateBonds => 'Corp.';

  @override
  String get bondCategoryOfz => 'OFZ: governo';

  @override
  String get bondCategoryCorporate => 'Aziendale';

  @override
  String get bondYieldLabel => 'Prodotto';

  @override
  String get bondCouponLabel => 'Buono';

  @override
  String get bondMaturityLabel => 'Scadenza';

  @override
  String get bondFaceValueLabel => 'Valore nominale';

  @override
  String marketsBondCatalogCounts(int count) {
    return 'Catalogo: obbligazioni $count · MOEX ISS';
  }

  @override
  String get bondYieldCurveTitle => 'OFZ curva dei rendimenti';

  @override
  String get bondYieldCurveSubtitle =>
      'YTM × tempo mancante alla maturità · MOEX ISS';

  @override
  String get bondYieldCurveTapHint => 'Tocca per il grafico a schermo intero';

  @override
  String get bondYieldCurveEmpty => 'Dati OFZ insufficienti per la curva';

  @override
  String get bondYieldCurveTableTitle => 'Punti della curva';

  @override
  String get bondYieldCurveOpen => 'Curva dei rendimenti';

  @override
  String get bondYieldSpreadLabel => 'Diffusione lungo-breve';

  @override
  String bondYieldSpreadValue(String spread) {
    return '+$spread pag';
  }

  @override
  String get bondYearsShort => 'sì';

  @override
  String get bondLadderTitle => 'OFZ scala obbligazionaria';

  @override
  String get bondLadderSubtitle =>
      'Per anno di scadenza · rendimento alla scadenza';

  @override
  String get bondLadderTapHint => 'Tocca per lo schermo intero';

  @override
  String bondLadderFullSubtitle(int ofzCount, int yearCount) {
    return '$ofzCount OFZ · $yearCount anni di scadenza';
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
    return '$count altro $_temp0';
  }

  @override
  String get bondYieldCurveCrosshairHint => 'Tocca un punto sulla curva';

  @override
  String get bondYieldCurveZoomHint =>
      'Scorri o pizzica per ingrandire · tocca due volte per reimpostare';

  @override
  String bondYieldCurveZoomActive(String zoom) {
    return 'Zoom ×$zoom · toccare due volte per reimpostare';
  }

  @override
  String get bondCalendarTitle => 'Calendario obbligazionario';

  @override
  String get bondCalendarSubtitle =>
      'Watchlist e portafoglio · MOEX coupon o stima';

  @override
  String get bondCalendarTapHint => 'Tocca per il calendario completo';

  @override
  String get bondCalendarFullSubtitle =>
      'Watchlist e portafoglio cartaceo · cedole e scadenze';

  @override
  String get bondCalendarHorizon6m => '6 mesi';

  @override
  String get bondCalendarHorizon1y => '1 anno';

  @override
  String get bondCalendarHorizon2y => '2 anni';

  @override
  String get bondCalendarCouponIncome => 'Cedole di portafoglio (stima)';

  @override
  String get bondCalendarCouponIncomeHint => 'MOEX VALORE COUPON × quantità';

  @override
  String get bondCalendarEmptyTracked =>
      'Aggiungi obbligazioni alla watchlist o al portafoglio';

  @override
  String get bondCalendarEmptyEvents =>
      'Nessun evento nell\'orizzonte selezionato';

  @override
  String bondCalendarMoreEvents(int count) {
    return '$count altri eventi';
  }

  @override
  String get bondEventMaturity => 'Scadenza';

  @override
  String bondEventCouponRub(String amount) {
    return 'Buono sconto $amount ₽';
  }

  @override
  String bondEventCouponPercent(String rate) {
    return 'Coupon $rate%';
  }

  @override
  String bondEventCouponEstimate(String rate) {
    return 'Coupon ~$rate% (stima)';
  }

  @override
  String get bondNextCouponLabel => 'Prossimo buono';

  @override
  String get bondCouponValueLabel => 'Importo del buono';

  @override
  String get bondHomeCardTitle => 'OFZ obbligazioni';

  @override
  String get bondHomeCardSubtitle => 'Rendimento medio e spread · MOEX ISS';

  @override
  String bondHomeUpcomingEvents(int count) {
    return 'Prossimi eventi: $count';
  }

  @override
  String get bondCalendarOpen => 'Calendario';

  @override
  String get bondHomeAvgYield => 'Media YTM';

  @override
  String get bondHomeTopYield => 'Massima resa';

  @override
  String get marketsFavorites => 'Lista di controllo';

  @override
  String get marketsEmptyFavoritesTitle =>
      'Nessun elemento della lista di controllo';

  @override
  String get marketsEmptySearchTitle => 'Niente trovato';

  @override
  String get marketsEmptyFavoritesSubtitle =>
      'Tocca ★ su una risorsa per aggiungerla';

  @override
  String get marketsEmptySearchSubtitle =>
      'Prova un\'altra query o cancella il filtro';

  @override
  String get marketsAllAssets => 'Tutti i beni';

  @override
  String marketsRemovedFromWatchlist(String symbol) {
    return '$symbol rimosso dalla lista di titoli';
  }

  @override
  String get undo => 'Disfare';

  @override
  String get inflationTabCountries => 'Paesi';

  @override
  String get inflationTabCalculator => 'Inflazione';

  @override
  String get inflationTabFinance => 'Finanza';

  @override
  String get inflationCpiTitle => 'Inflazione (CPI), anno su anno';

  @override
  String get inflationWorldBankNote =>
      'Dati della Banca Mondiale · ultimo anno disponibile';

  @override
  String get inflationCalcTitle => 'Quanto valgono oggi quei soldi?';

  @override
  String get inflationCalcSubtitle =>
      'Utilizza l\'inflazione cumulativa della Banca Mondiale';

  @override
  String get inflationCountry => 'Paese';

  @override
  String get inflationAmount => 'Quantità';

  @override
  String get inflationYear => 'Anno';

  @override
  String get inflationYoy => 'anno dopo anno';

  @override
  String get inflationUnavailable => 'Dati momentaneamente non disponibili';

  @override
  String purchasingPower(String base, int year, String today) {
    return '$base in $year ≈ $today oggi';
  }

  @override
  String get chartInsufficientData => 'Dati insufficienti per il grafico';

  @override
  String get chartInsufficientCandles => 'Dati insufficienti per le candele';

  @override
  String get dataUnavailable => 'Dati momentaneamente non disponibili';

  @override
  String get settingsThemeDark => 'Buio';

  @override
  String get settingsThemeLight => 'Leggero';

  @override
  String get settingsThemeAuto => 'Auto';

  @override
  String get settingsThemeOled => 'OLED';

  @override
  String get settingsThemeDim => 'Fioco';

  @override
  String get settingsThemeSepia => 'Seppia';

  @override
  String get settingsThemeContrast => 'Contrasto';

  @override
  String get settingsAccentColor => 'Colore accento';

  @override
  String settingsThemeCurrent(String mode) {
    return 'Attuale: $mode';
  }

  @override
  String get sectorHeatmapTitle => 'MOEX settori';

  @override
  String get sectorHeatmapSubtitle =>
      'Variazione media su 7 giorni per settore';

  @override
  String get sectorFinance => 'Finanza';

  @override
  String get sectorEnergy => 'Energia';

  @override
  String get sectorIt => 'ESSO';

  @override
  String get sectorIndex => 'Indice';

  @override
  String dataStatusFresh(String time) {
    return 'Aggiornato: $time';
  }

  @override
  String get dataStatusLive => 'I dati sono aggiornati';

  @override
  String dataStatusCache(String age) {
    return 'Cache · $age';
  }

  @override
  String get dataStatusCacheUnknown =>
      'Cache · i dati potrebbero essere obsoleti';

  @override
  String dataStatusOffline(String age) {
    return 'Offline · cache $age';
  }

  @override
  String get dataStatusOfflineUnknown => 'Offline · dati salvati';

  @override
  String get alertsCheckBackground =>
      'Controllo in background ogni 15 min + all\'aggiornamento';

  @override
  String get currencyCompareTitle => 'Confronto delle tariffe';

  @override
  String get currencyCompareSubtitle =>
      'Indice 100 all\'inizio del periodo: fino a 3 coppie';

  @override
  String get currencyCompareSelect => 'Seleziona un altro paio da confrontare';

  @override
  String get assetPreviewOpen => 'Apri il grafico';

  @override
  String get assetPreviewAddWatchlist => 'Aggiungi alla lista di controllo';

  @override
  String get assetPreviewRemoveWatchlist => 'Rimuovi dalla lista di controllo';

  @override
  String get inflationCompareTitle => 'Confronto tra paesi';

  @override
  String get inflationCompareSubtitle =>
      'YoY CPI: fino a 3 paesi su un grafico';

  @override
  String get inflationCompareSelect =>
      'Seleziona un altro paese da confrontare';

  @override
  String get settingsHomeWidget => 'Android widget';

  @override
  String get settingsHomeWidgetSubtitle =>
      'USD/RUB e BTC nella schermata iniziale: aggiornamenti all\'aggiornamento';

  @override
  String get keyRateDetailTitle => 'Tasso chiave CBR';

  @override
  String keyRateUpdated(String date) {
    return 'Aggiornato: $date';
  }

  @override
  String get keyRateEventsTitle => 'Cambiamenti di tariffa';

  @override
  String get keyRateEventsEmpty => 'Nessun cambiamento in questo periodo';

  @override
  String keyRateEventChange(String date, String rate) {
    return '$date → $rate';
  }

  @override
  String keyRateSince(int day, int month, int year) {
    return 'dal $day.$month.$year';
  }

  @override
  String get sourceCbr => 'CBR';

  @override
  String get onboardingSkip => 'Saltare';

  @override
  String get onboardingNext => 'Prossimo';

  @override
  String get onboardingStart => 'Inizia';

  @override
  String get onboarding1Title => 'Valute e tariffe';

  @override
  String get onboarding1Subtitle =>
      'USD/RUB, EUR/RUB e FX globale da MOEX e Frankfurter';

  @override
  String get onboarding2Title => 'Inflazione e tasso CBR';

  @override
  String get onboarding2Subtitle =>
      'Dati della Banca Mondiale, tasso di riferimento CBR e calcolatori finanziari';

  @override
  String get onboarding3Title => 'Mercati e watchlist';

  @override
  String get onboarding3Subtitle =>
      'Criptovalute, azioni MOEX, grafici e watchlist in un unico posto';

  @override
  String get settingsSectionAppearance => 'Aspetto';

  @override
  String get settingsAppTheme => 'Tema dell\'app';

  @override
  String get settingsAppBackground => 'Sfondo dell\'app';

  @override
  String get settingsBackgroundSubtitle => 'Gradiente come le app bancarie';

  @override
  String get settingsSectionSecurity => 'Sicurezza';

  @override
  String get settingsPinCode => 'Codice di accesso';

  @override
  String get settingsPinEnabled => 'Protetto dall\'app · 4 digits';

  @override
  String get settingsPinDisabled => 'Il PIN è disattivato';

  @override
  String get settingsChangePin => 'Cambia codice';

  @override
  String get settingsLockNow => 'Blocca adesso';

  @override
  String get settingsLockedSnack => 'Applicazione bloccata';

  @override
  String get settingsSectionDisplay => 'Display';

  @override
  String get settingsBaseCurrency => 'Valuta di base';

  @override
  String get settingsKeysLocalNote =>
      'Chiavi archiviate localmente: non è necessaria alcuna ricostruzione';

  @override
  String get settingsSectionDataApi => 'Dati e API';

  @override
  String get settingsSectionAbout => 'Di';

  @override
  String get settingsAboutDescription =>
      'Cruscotto economico con valute, inflazione, criptovalute e quotazioni di mercato.';

  @override
  String get settingsAboutDesign =>
      'Modello: Material 3 · fl_chart · flutter_animate';

  @override
  String get settingsAboutDeveloper =>
      'Sviluppato da Evgeny Vladislavovich Tsymbal';

  @override
  String get sourceFrankfurter => 'Frankfurter';

  @override
  String get sourceFrankfurterSub => 'Cambio valutario internazionale';

  @override
  String get sourceMoex => 'MOEXISS';

  @override
  String get sourceMoexSub => 'RUB Azioni FX e RU';

  @override
  String get sourceCbrSub => 'Tasso chiave';

  @override
  String get sourceWorldBank => 'Banca Mondiale';

  @override
  String get sourceWorldBankSub => 'CPI inflazione';

  @override
  String get sourceCoingecko => 'CoinGecko';

  @override
  String get sourceCoingeckoSub => 'Criptovalute';

  @override
  String get sourceFinnhub => 'Finnhub';

  @override
  String get sourceFinnhubSub => 'Azioni statunitensi';

  @override
  String get sourceCommodities => 'MOEXISS';

  @override
  String get sourceCommoditiesSub => 'Merci';

  @override
  String get statusActive => 'Attivo';

  @override
  String get statusKeyOk => 'Chiave OK';

  @override
  String get statusNoKey => 'Nessuna chiave';

  @override
  String get statusNotConfigured => 'Non configurato';

  @override
  String get inflationRateVsTitle => 'Tasso chiave vs inflazione';

  @override
  String get inflationRateVsSubtitle =>
      'Tasso medio di CBR e Russia CPI per anno';

  @override
  String get inflationRateVsKeyRate => 'Tasso chiave';

  @override
  String get inflationRateVsCpi => 'CPI inflazione';

  @override
  String get correlationTitle => 'Correlazione delle risorse';

  @override
  String correlationSubtitle(int days) {
    return 'Resi giornalieri nell\'arco di $days giorni (Pearson)';
  }

  @override
  String get correlationChartTitle => 'Prestazioni (indice 100)';

  @override
  String get correlationNote =>
      '1 = si muovono insieme, −1 = opposto, 0 = nessun collegamento';

  @override
  String get correlationBtc => 'BTC';

  @override
  String get correlationUsdRub => 'USD/RUB';

  @override
  String get correlationImoex => 'IMOEX';

  @override
  String get sectorMetals => 'Metalli';

  @override
  String get sectorTelecom => 'Telecomunicazioni';

  @override
  String get sectorConsumer => 'Consumatore';

  @override
  String get sectorTransport => 'Trasporto';

  @override
  String get sectorRealestate => 'Immobiliare';

  @override
  String get sectorChemicals => 'Prodotti chimici';

  @override
  String get sectorEtf => 'ETF';

  @override
  String get sectorTech => 'Tecnologia';

  @override
  String get sectorAuto => 'Automobilistico';

  @override
  String get sectorHealth => 'Assistenza sanitaria';

  @override
  String get sectorMedia => 'Media';

  @override
  String get sectorIndustrial => 'Industriale';

  @override
  String get sectorUs => 'Stati Uniti';

  @override
  String get sectorOther => 'Altro';

  @override
  String get marketsFilterAll => 'Tutto';

  @override
  String get marketsFilterMoex => 'MOEX';

  @override
  String get marketsFilterUs => 'NYSE/NASDAQ';

  @override
  String get marketsGroupBySector => 'Per settore';

  @override
  String get marketsCatalogHint =>
      '50 MOEX · 45 US · 100 criptovalute · cerca per ticker';

  @override
  String marketsCatalogCounts(int moex, int us, int crypto) {
    return '$moex MOEX · $us USA · $crypto criptovaluta · ricerca';
  }

  @override
  String get currencyGroupMoex => 'MOEX · coppie di rubli';

  @override
  String get currencyGroupMajor => 'Maggiore';

  @override
  String get currencyGroupEurope => 'Europa';

  @override
  String get currencyGroupAsia => 'Asia';

  @override
  String get currencyGroupEm => 'Emergente';

  @override
  String get currencyGroupAmericas => 'Americhe e Oceania';

  @override
  String get adminPanelTitle => 'Admin Pannello';

  @override
  String get adminPanelSubtitle =>
      'Strumenti di sviluppo: API, cache, cataloghi, flag di funzionalità';

  @override
  String get adminApiStatus => 'Stato API';

  @override
  String get adminCache => 'Cache';

  @override
  String get adminCatalog => 'Cataloghi';

  @override
  String get adminFeatureFlags => 'Flag di funzionalità';

  @override
  String get adminHttpLog => 'Registro HTTP';

  @override
  String get adminHttpLogEmpty => 'Nessuna richiesta ancora';

  @override
  String get adminRefreshAll => 'Aggiorna tutto';

  @override
  String get adminReloadStatus => 'Ricarica lo stato';

  @override
  String get adminRefreshed => 'Dati aggiornati';

  @override
  String get adminFlagSectorHeatmap => 'MOEX mappa termica del settore';

  @override
  String get adminFlagStocksGrouped => 'Azioni del Gruppo per settore';

  @override
  String get adminFlagVerboseHttp => 'Registro HTTP dettagliato';

  @override
  String get adminCacheEmpty => 'Vuoto';

  @override
  String get adminCacheFresh => 'Fresco';

  @override
  String get adminCacheStale => 'Stanco';

  @override
  String adminCacheAge(String age) {
    return 'Età: $age';
  }

  @override
  String adminCacheItems(int count) {
    return '$count elementi';
  }

  @override
  String get adminCatalogMoex => 'MOEX';

  @override
  String get adminCatalogUs => 'NOI';

  @override
  String get adminCatalogFx => 'FX';

  @override
  String get adminCatalogCrypto => 'Criptovaluta';

  @override
  String get profileSectionTitle => 'Profilo';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get profileGuest => 'Ospite · imposta il tuo profilo';

  @override
  String profileGreeting(String name) {
    return 'Ciao, $name!';
  }

  @override
  String get profileDisplayName => 'Nome da visualizzare';

  @override
  String get profileDisplayNameHint => 'Come dovremmo salutarti?';

  @override
  String get profileAvatarHint => 'Scegli un avatar';

  @override
  String get profileCountry => 'Paese per l\'inflazione';

  @override
  String get profileCountryHint => 'Utilizzato nella scheda Paesi';

  @override
  String profileCountryLabel(String country) {
    return 'Paese: $country';
  }

  @override
  String get profileSaved => 'Profile salvato';

  @override
  String get profileSave => 'Salva';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileEmailHint => 'esempio@mail.com';

  @override
  String get profilePhone => 'Telefono';

  @override
  String get profilePhoneHint => '+1 (555) 000-0000';

  @override
  String get profileHubAccountsTitle => 'I miei conti';

  @override
  String get profileHubAccountPortfolio => 'Portafoglio cartaceo';

  @override
  String get profileHubAccountWatchlist => 'Lista di controllo';

  @override
  String get profileHubAccountAlerts => 'Avvisi sui prezzi';

  @override
  String get profileHubAccountCash => 'Contanti disponibili';

  @override
  String get profileHubAccountCashSub => 'Pronto per lo scambio';

  @override
  String get profileHubPortfolioEmpty => 'Nessuna posizione aperta';

  @override
  String get profileHubQuickBackup => 'Backup';

  @override
  String get profileHubQuickSecurity => 'Sicurezza';

  @override
  String get profileHubQuickSync => 'Sincronizzazione';

  @override
  String get profileHubQuickCustomize => 'Stile';

  @override
  String get profileHubSectionProfile => 'Profilo';

  @override
  String get profileHubSectionFinance => 'Finanza';

  @override
  String get profileHubSectionSecurity => 'Sicurezza e dati';

  @override
  String get profileHubSectionApp => 'App';

  @override
  String get profileHubPersonalData => 'Dati personali';

  @override
  String get profileHubPersonalDataSub => 'Nome, avatar, email, telefono';

  @override
  String get profileHubServerAccount => 'Conto del server';

  @override
  String get profileHubServerIntro =>
      'Accedi al tuo server principale EcoPulse per le chat e la sincronizzazione del profilo.';

  @override
  String get profileHubMessages => 'Messaggi';

  @override
  String get profileHubPortfolio => 'Portfolio';

  @override
  String get profileHubWatchlist => 'Risorse della lista di controllo';

  @override
  String get profileHubSecurity => 'Sicurezza';

  @override
  String get profileHubSecuritySub => 'PIN e dati biometrici';

  @override
  String get profileHubSecurityPinBio => 'PIN e dati biometrici';

  @override
  String get profileHubSecurityActive => 'L\'applicazione è protetta';

  @override
  String get profileHubSecurityActiveSub =>
      'Il PIN è abilitato. I tuoi dati vengono nascosti quando l\'app è bloccata.';

  @override
  String get profileHubSecurityInactive => 'Protection è disattivato';

  @override
  String get profileHubSecurityInactiveSub =>
      'Abilita il PIN per nascondere i dati quando lo schermo è bloccato.';

  @override
  String get profileHubDocuments => 'Documenti e rapporti';

  @override
  String get profileHubDocumentsSub =>
      'Esportazione, backup, report settimanale';

  @override
  String get profileHubDocumentsIntro =>
      'Salva i dati dell\'app o condividi un rapporto sulla lista di controllo.';

  @override
  String get profileHubCloudSync => 'Sincronizzazione nel cloud';

  @override
  String get profileHubNotifications => 'Notifiche';

  @override
  String get profileHubNotificationsSub => 'Raccolta mattutina e avvisi';

  @override
  String get profileHubAppSettings => 'Impostazioni dell\'app';

  @override
  String get profileHubAppSettingsSub => 'Tema, lingua, API, widget';

  @override
  String get profileHubCustomization => 'Personalizzazione';

  @override
  String get profileHubCourses => 'Corsi e apprendimento';

  @override
  String get profileHubAbout => 'Informazioni su EcoPulse';

  @override
  String get profileHubVerified => 'Profile completato';

  @override
  String get profileHubServerOnline => 'Server connesso';

  @override
  String get profileHubServerOffline => 'Modalità locale';

  @override
  String get profileHubEditProfile => 'Modificare';

  @override
  String profileHubPositions(int count) {
    return '$count posizioni';
  }

  @override
  String profileHubAssets(int count) {
    return '$count risorse';
  }

  @override
  String profileHubActiveAlerts(int count) {
    return '$count avvisi';
  }

  @override
  String get backupSectionTitle => 'Backup';

  @override
  String get backupExportTitle => 'Esporta dati';

  @override
  String get backupExportSubtitle =>
      'Watchlist, profilo, impostazioni, note — JSON';

  @override
  String get backupImportTitle => 'Importa dati';

  @override
  String get backupImportSubtitle => 'Incolla JSON dall\'esportazione';

  @override
  String get backupImportHint => 'Incolla EcoPulse esporta JSON qui';

  @override
  String get backupImportConfirm => 'Ripristinare';

  @override
  String backupImportSuccess(int count) {
    return 'Chiavi ripristinate: $count';
  }

  @override
  String backupImportError(String error) {
    return 'Importazione non riuscita: $error';
  }

  @override
  String get cancel => 'Cancellare';

  @override
  String get assetNoteTitle => 'Nota';

  @override
  String get assetNoteHint => 'Acquistato a 280, obiettivo 320…';

  @override
  String get portfolioTitle => 'Portafoglio cartaceo';

  @override
  String get portfolioEmptySubtitle => '₽100.000 virtuali · tocca per iniziare';

  @override
  String get portfolioTotal => 'Valore del portafoglio';

  @override
  String get portfolioPnl => 'P&L';

  @override
  String get portfolioLiveBadge => 'LIVE';

  @override
  String portfolioLiveUpdated(String time) {
    return 'Aggiornato $time';
  }

  @override
  String get portfolioCash => 'Contanti';

  @override
  String get portfolioPositions => 'Posizioni';

  @override
  String get portfolioEmptyPositions =>
      'Acquista dalla watchlist o dall\'anteprima degli asset sui mercati';

  @override
  String get portfolioAdd => 'Acquistare';

  @override
  String get portfolioBuy => 'Acquista il prezzo';

  @override
  String get portfolioBuyAction => 'Aggiungi al portafoglio';

  @override
  String portfolioBought(String symbol) {
    return '$symbol aggiunto al portafoglio';
  }

  @override
  String get portfolioInsufficientCash => 'Contanti virtuali insufficienti';

  @override
  String get portfolioReset => 'Reset';

  @override
  String get portfolioResetConfirm =>
      'Reimpostare su ₽100.000 e cancellare tutte le posizioni?';

  @override
  String portfolioRemoved(String symbol) {
    return '$symbol rimosso (pressione lunga)';
  }

  @override
  String get portfolioPickAsset => 'Scegli una risorsa';

  @override
  String get portfolioPickFromWatchlist =>
      'Aggiungi prima gli asset alla watchlist su Markets';

  @override
  String cryptoLoadMore(int loaded, int total) {
    return 'Carica altro ($loaded / $total)';
  }

  @override
  String get homeShareDashboard => 'Condividi dashboard';

  @override
  String get newsSectionTitle => 'Notizia';

  @override
  String get newsFinnhubHint =>
      'Aggiungi una chiave Finnhub nelle Impostazioni per notizie e calendario';

  @override
  String get newsEmpty => 'Nessuna notizia ancora';

  @override
  String get newsLoadError => 'Impossibile caricare le notizie';

  @override
  String get macroCalendarTitle => 'Calendario macro';

  @override
  String get macroCalendarEmpty => 'Nessun evento per la prossima settimana';

  @override
  String get digestSectionTitle => 'Notifiche';

  @override
  String get digestMorningTitle => 'Digestione mattutina';

  @override
  String get digestMorningSubtitle =>
      'Invia brief con USD/RUB, BTC, IMOEX all\'ora prescelta';

  @override
  String get digestMorningHour => 'Tempi di consegna';

  @override
  String get indicesSectionTitle => 'Indici statunitensi';

  @override
  String get radarTitle => 'Radar economico';

  @override
  String get radarSubtitle =>
      'Punteggio derivante da mercato, cambio, inflazione, tasso e F&G';

  @override
  String get timelineTitle => 'Cronologia dell\'evento';

  @override
  String get timelineEmpty =>
      'Nessun evento ancora · Chiave Finnhub necessaria per la macro';

  @override
  String get macroWeekTitle => 'Settimana macro';

  @override
  String macroWeekRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get macroWeekBriefTitle => 'Brief di mercato';

  @override
  String get macroWeekToday => 'Oggi';

  @override
  String get macroWeekKeyRateToday => 'Tasso chiave CBR';

  @override
  String macroWeekStats(int events, int days) {
    return '$events macro eventi · $days giorni con eventi';
  }

  @override
  String get macroWeekEmptyDay => 'Nessun evento';

  @override
  String get macroWeekMon => 'Lun';

  @override
  String get macroWeekTue => 'Mar';

  @override
  String get macroWeekWed => 'Mercoledì';

  @override
  String get macroWeekThu => 'Gio';

  @override
  String get macroWeekFri => 'Ven';

  @override
  String get macroWeekSat => 'Sab';

  @override
  String get macroWeekSun => 'Sole';

  @override
  String get portfolioExportCsv => 'Esporta CSV';

  @override
  String get portfolioExportDone => 'CSV condiviso';

  @override
  String get demoModeTitle => 'Modalità dimostrativa';

  @override
  String get demoModeSubtitle => 'Dati simulati offline: per screenshot e demo';

  @override
  String get demoModeBadge => 'Dati dimostrativi';

  @override
  String get homeLayoutTitle => 'Sezioni domestiche';

  @override
  String get homeSectionPortfolio => 'Portafoglio cartaceo';

  @override
  String get homeSectionNews => 'Notizia';

  @override
  String get homeSectionRadar => 'Radar economico';

  @override
  String get homeSectionIndices => 'Indici statunitensi';

  @override
  String get homeSectionFearGreed => 'Paura e avidità';

  @override
  String get homeSectionCurrencies => 'Valute';

  @override
  String get homeSectionKeyRate => 'Tasso chiave';

  @override
  String get homeSectionInflation => 'Inflazione';

  @override
  String get homeSectionCommodities => 'Merci';

  @override
  String get homeSectionMarkets => 'Mercati';

  @override
  String get homeSectionBonds => 'Obbligazioni';

  @override
  String get homeSectionWatchlist => 'Lista di controllo';

  @override
  String get homeSectionCorrelation => 'Correlazione';

  @override
  String get compareTitle => 'Confronta le risorse';

  @override
  String compareSubtitle(int max) {
    return 'Scegli fino a $max risorse per il grafico sovrapposto';
  }

  @override
  String get compareEmpty => 'Seleziona i ticker qui sopra';

  @override
  String get compareClear => 'Chiaro';

  @override
  String get compareChartTitle => 'Indice 100 · 30 days';

  @override
  String get compareLoadError => 'Impossibile caricare la cronologia';

  @override
  String get settingsApiKeysTitle => 'API tasti';

  @override
  String settingsApiKeySaved(String label) {
    return '$label salvato';
  }

  @override
  String get settingsBaseCurrencyHint => 'Utilizzato nel convertitore';

  @override
  String get settingsWidgetConfigTitle => 'Android widget';

  @override
  String get settingsWidgetConfigSubtitle =>
      '4×1 striscia o 2×2 griglia · fino a 4 metriche';

  @override
  String get settingsWidgetLayout => 'Disposizione';

  @override
  String get settingsWidgetLayoutAuto => 'Automatico (per dimensione)';

  @override
  String get settingsWidgetLayoutCompact => 'Compatto 4×1';

  @override
  String get settingsWidgetLayoutExpanded => '2×2 espanso';

  @override
  String get settingsWidgetLayoutHint =>
      'Cambia automaticamente il layout quando ridimensioni il widget nella schermata principale';

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
  String get widgetMetricKeyRate => 'CBR tasso';

  @override
  String get widgetMetricBrent => 'Brent';

  @override
  String get widgetMetricWti => 'WTI';

  @override
  String get widgetMetricImoex => 'IMOEX';

  @override
  String get widgetMetricPortfolio => 'Portafoglio cartaceo';

  @override
  String get widgetMetricInflationRu => 'Inflazione RU';

  @override
  String get homeLayoutReorderHint =>
      'Trascina per riordinare · attiva/disattiva la visibilità';

  @override
  String get alertsKindThreshold => 'Livello dei prezzi';

  @override
  String get alertsKindPercentChange => 'Variazione giornaliera %';

  @override
  String get alertsPercentHint => 'Soglia di variazione giornaliera, %';

  @override
  String get alertsHistoryTitle => 'Attiva la cronologia';

  @override
  String get alertsHistoryEmpty => 'Nessun trigger ancora';

  @override
  String get alertsQuietHoursTitle => 'Ore tranquille';

  @override
  String get alertsQuietHoursSubtitle =>
      'Nessuna notifica push durante questo periodo';

  @override
  String alertsQuietHoursRange(int start, int end) {
    return '$start:00 – $end:00';
  }

  @override
  String get alertsQuietHoursStart => 'Da';

  @override
  String get alertsQuietHoursEnd => 'A';

  @override
  String get alertsConditionRise => 'Salita';

  @override
  String get alertsConditionDrop => 'Gocciolare';

  @override
  String get alertsConditionAbove => 'Sopra';

  @override
  String get alertsConditionBelow => 'Sotto';

  @override
  String get alertsPresetsTitle => 'Preimpostazioni rapide';

  @override
  String get alertsPresetUsd100 => 'USD/RUB > 100';

  @override
  String get alertsPresetBtcDrop5 => 'BTC −5% al ​​giorno';

  @override
  String get alertsPresetBtcRise5 => 'BTC +5% al ​​giorno';

  @override
  String get alertsPresetImoexDrop3 => 'IMOEX −3% al giorno';

  @override
  String get exportReportTitle => 'Rapporto settimanale';

  @override
  String get exportReportSubtitle => 'Brief + watchlist + FX';

  @override
  String get exportReportDone => 'Rapporto condiviso';

  @override
  String get portfolioBacktestTitle => 'Backtest ~30d';

  @override
  String portfolioBacktestResult(String past, String current, String change) {
    return 'Era $past → ora $current ($change)';
  }

  @override
  String get portfolioBacktestUnavailable =>
      'Storico dei prezzi insufficiente per le posizioni';

  @override
  String get portfolioAllocationTitle => 'Assegnazione';

  @override
  String get portfolioAllocationSubtitle =>
      'Pesi delle classi di attività · portafoglio cartaceo';

  @override
  String get portfolioAllocationCash => 'Contanti';

  @override
  String get portfolioAllocationCrypto => 'Criptovaluta';

  @override
  String get portfolioAllocationStocks => 'Azioni';

  @override
  String get portfolioAllocationBonds => 'Obbligazioni';

  @override
  String portfolioAllocationTotal(String total) {
    return 'Totale in risorse: $total';
  }

  @override
  String get portfolioRebalanceTitle => 'Riequilibrio';

  @override
  String get portfolioRebalanceSubtitle =>
      'Ponderazioni target e suggerimenti di acquisto/vendita per classe di attività';

  @override
  String get portfolioRebalanceConservative => 'Conservatore';

  @override
  String get portfolioRebalancePresetBalanced => 'Equilibrato';

  @override
  String get portfolioRebalanceGrowth => 'Crescita';

  @override
  String get portfolioRebalanceCustom => 'Costume';

  @override
  String portfolioRebalanceDrift(String drift) {
    return 'Deriva massima: $drift';
  }

  @override
  String get portfolioRebalanceOnTarget =>
      'Il portafoglio è vicino all’allocazione target';

  @override
  String portfolioRebalanceBuy(String amount) {
    return 'Acquista $amount';
  }

  @override
  String portfolioRebalanceSell(String amount) {
    return 'Vendi $amount';
  }

  @override
  String get portfolioRebalanceHold => 'OK';

  @override
  String portfolioRebalanceInvestCash(String amount) {
    return 'Investi $amount';
  }

  @override
  String portfolioRebalanceFreeCash(String amount) {
    return 'Libera $amount';
  }

  @override
  String portfolioRebalanceCurrentTarget(int current, int target) {
    return 'Adesso $current% → target $target%';
  }

  @override
  String get portfolioIncomeTitle => 'Calendario dei redditi';

  @override
  String get portfolioIncomeSubtitle =>
      'Cedole, dividendi e scadenze dalle tue posizioni';

  @override
  String get portfolioIncomeNext30 => '30 days';

  @override
  String get portfolioIncomeNext90 => '90 days';

  @override
  String get portfolioIncomeByMonth => 'Per mese';

  @override
  String portfolioIncomeMonthChip(String month, String amount) {
    return '$month · $amount ₽';
  }

  @override
  String get portfolioIncomeUpcoming => 'Prossimi flussi di cassa';

  @override
  String get portfolioIncomeCoupon => 'Buono';

  @override
  String get portfolioIncomeCouponEstimate => 'Coupon (stima)';

  @override
  String get portfolioIncomeMaturity => 'Valore nominale alla scadenza';

  @override
  String get portfolioIncomeDividendEstimate => 'Dividendi (stima)';

  @override
  String get portfolioScenarioTitle => 'Scenari ipotetici';

  @override
  String get portfolioScenarioSubtitle =>
      'Valore del portafoglio in caso di shock di mercato';

  @override
  String get portfolioScenarioUsdUp10 => 'USD/RUB +10%';

  @override
  String get portfolioScenarioBtcDown30 => 'BTC −30%';

  @override
  String get portfolioScenarioImoexDown15 => 'IMOEX −15%';

  @override
  String get portfolioScenarioKeyRateUp2 => 'Tariffa +2 pp';

  @override
  String portfolioScenarioResult(String base, String scenario) {
    return '$base → $scenario';
  }

  @override
  String portfolioScenarioDelta(String amount, String percent) {
    return 'Δ $amount ($percent)';
  }

  @override
  String get portfolioRealReturnTitle => 'Ritorno reale';

  @override
  String get portfolioRealReturnSubtitle =>
      'Nominale meno inflazione · rispetto a IMOEX e deposito';

  @override
  String get portfolioRealReturnHorizon30d => '30 days';

  @override
  String get portfolioRealReturnHorizonAll => 'Dall\'inizio';

  @override
  String get portfolioRealReturnNominal => 'Portafoglio (nominale)';

  @override
  String get portfolioRealReturnReal => 'Portafoglio (reale)';

  @override
  String get portfolioRealReturnInflation => 'Inflazione (RU)';

  @override
  String get portfolioRealReturnImoex => 'IMOEX';

  @override
  String get portfolioRealReturnDeposit => 'Deposito (tasso CBR)';

  @override
  String portfolioRealReturnBeatInflation(String value) {
    return 'Rendimento reale $value: batte l\'inflazione';
  }

  @override
  String portfolioRealReturnLoseInflation(String value) {
    return 'Rendimento reale $value — inferiore all\'inflazione';
  }

  @override
  String portfolioRealReturnBeatImoex(String delta) {
    return 'Davanti a IMOEX di $delta';
  }

  @override
  String portfolioRealReturnLoseImoex(String delta) {
    return 'Dietro IMOEX di $delta';
  }

  @override
  String get portfolioRealReturnBeatDeposit => 'Deposito superiore al CBR';

  @override
  String get portfolioRealReturnLoseDeposit =>
      'Deposito con tasso inferiore a CBR';

  @override
  String get watchlistVolatilityTitle => 'Volatilità delle watchlist';

  @override
  String get watchlistVolatilitySubtitle =>
      'σ annuale dai rendimenti giornalieri · ~30d sparkline';

  @override
  String watchlistVolatilityAnnual(String value) {
    return 'σ $value';
  }

  @override
  String get watchlistVolatilityLow => 'Basso';

  @override
  String get watchlistVolatilityHigh => 'Alto';

  @override
  String get portfolioTradeJournalTitle => 'Giornale commerciale';

  @override
  String get portfolioTradeJournalSubtitle =>
      'Acquista e vendi la cronologia per il portafoglio cartaceo';

  @override
  String get portfolioTradeJournalEmpty =>
      'Ancora nessuna compravendita · acquista dalla watchlist';

  @override
  String get portfolioTradeJournalBuy => 'Acquistare';

  @override
  String get portfolioTradeJournalSell => 'Vendere';

  @override
  String get portfolioTradeJournalOpenAll => 'Tutto';

  @override
  String get portfolioTradeJournalExport => 'Esporta CSV';

  @override
  String portfolioTradeJournalStats(int total, int buys, int sells) {
    return '$total scambia · $buys acquista · $sells vende';
  }

  @override
  String portfolioTradeJournalRealizedPnl(String value) {
    return 'Realizzato P&L: $value';
  }

  @override
  String get portfolioTradeJournalImport => 'Importa CSV';

  @override
  String get portfolioTradeJournalImportHint =>
      'Incolla CSV esporta da EcoPulse o broker';

  @override
  String get portfolioTradeJournalImportEmpty =>
      'Nessuna operazione trovata nel file';

  @override
  String portfolioTradeJournalImportDone(int added, int skipped) {
    return 'Operazioni $added importate · saltate $skipped';
  }

  @override
  String portfolioTradeJournalImportError(String error) {
    return 'Importazione non riuscita: $error';
  }

  @override
  String get portfolioTaxTitle => 'Stima delle tasse';

  @override
  String get portfolioTaxSubtitle =>
      'Stima locale NDFL dalla rivista specializzata · non consulenza fiscale';

  @override
  String get portfolioTaxOpenDetails => 'Dettagli';

  @override
  String get portfolioTaxExport => 'Esporta CSV';

  @override
  String get portfolioTaxEmpty => 'Nessun evento imponibile per quest\'anno';

  @override
  String get portfolioTaxNetRealized => 'Netto realizzato P&L';

  @override
  String get portfolioTaxEstimatedNdfl => 'NDFL stimato';

  @override
  String get portfolioTaxPassiveIncome => 'Est. cedole e dividendi';

  @override
  String get portfolioTaxPassiveTax => 'Est. imposta sul reddito passivo';

  @override
  String get portfolioTaxRealizedGain => 'Guadagni realizzati';

  @override
  String get portfolioTaxRealizedLoss => 'Perdite realizzate';

  @override
  String get portfolioTaxTaxableBase => 'Base imponibile';

  @override
  String get portfolioTaxSellCount => 'Vendi scambi';

  @override
  String get portfolioTaxUnrealizedGain =>
      'Plusvalenze non realizzate (informazioni)';

  @override
  String get portfolioTaxUnrealizedLoss =>
      'Perdite non realizzate (informazioni)';

  @override
  String get portfolioTaxSectionTrading => 'Redditi da negoziazione';

  @override
  String get portfolioTaxSectionPassive => 'Cedole e dividendi (stima)';

  @override
  String get portfolioTaxSectionUnrealized => 'Posizioni aperte';

  @override
  String get portfolioTaxTotalLabel => 'Imposta totale stimata';

  @override
  String portfolioTaxRateLabel(String rate) {
    return 'Tasso $rate% · semplificato';
  }

  @override
  String get portfolioTaxIisNote =>
      'Conto IIS: le tasse possono essere ridotte in base alle regole di tipo A/B: conferma con il tuo broker.';

  @override
  String get portfolioTaxDisclaimer =>
      'Solo stima educativa. Cambiano tariffe, esenzioni e regole IIS. EcoPulse non presenta dichiarazioni dei redditi.';

  @override
  String get portfolioTaxSellsHeader => 'Vendi scambi quest\'anno';

  @override
  String portfolioTaxSellPnl(String value) {
    return 'P&L: $value';
  }

  @override
  String get portfolioRoboTitle => 'Robo-advisor lite';

  @override
  String get portfolioRoboSubtitle =>
      'Suggerimento di allocazione in base al tipo di account, agli obiettivi e all\'umore del mercato';

  @override
  String portfolioRoboRecommended(String preset) {
    return 'Consigliato: $preset';
  }

  @override
  String portfolioRoboRiskScore(int score) {
    return 'Profilo di rischio: $score/100';
  }

  @override
  String get portfolioRoboActionsHeader => 'Azioni prioritarie';

  @override
  String portfolioRoboApplyPreset(String preset) {
    return 'Utilizza l\'allocazione $preset';
  }

  @override
  String get portfolioRoboDisclaimer =>
      'Solo suggerimento didattico. Non consigli sugli investimenti. Conferma con il tuo piano.';

  @override
  String get portfolioRoboReasonIis =>
      'Conto IIS: l\'orizzonte a lungo termine favorisce i legami e la stabilità';

  @override
  String get portfolioRoboReasonCrypto =>
      'Conto crittografico: obiettivo di crescita più elevato con maggiore peso crittografico';

  @override
  String get portfolioRoboReasonUsd =>
      'Conto USD: mix equilibrato con le azioni globali';

  @override
  String get portfolioRoboReasonShortGoal =>
      'Scadenza obiettivo entro 2 anni: minore allocazione del rischio';

  @override
  String get portfolioRoboReasonLongGoal =>
      'Obiettivo a lungo termine: spazio per asset di crescita';

  @override
  String get portfolioRoboReasonFngHigh =>
      'La paura e l’avidità sono elevate: riduci il rischio, evita la FOMO';

  @override
  String get portfolioRoboReasonFngLow =>
      'La paura del mercato è elevata: mantieni la disciplina e non farti prendere dal panico, vendi';

  @override
  String get portfolioRoboReasonEmpty =>
      'Portafoglio vuoto: inizia con un mix equilibrato';

  @override
  String get portfolioRoboReasonHighCash =>
      'Elevata quota di liquidità: valuta la possibilità di investire liquidità inutilizzata';

  @override
  String get portfolioRoboReasonHighCrypto =>
      'Sovrappeso criptovalute: ribilanciamento verso azioni e obbligazioni';

  @override
  String get portfolioRoboReasonDefault =>
      'Il mix bilanciato si adatta al tuo profilo attuale';

  @override
  String get cloudSyncTitle => 'Sincronizzazione nel cloud';

  @override
  String get cloudSyncSubtitle =>
      'Sincronizza tramite JSON file · Google Drive, Telegram, email';

  @override
  String get cloudSyncStatusSynced => 'I dati sono sincronizzati';

  @override
  String get cloudSyncStatusPending =>
      'Modifiche locali: esporta il file di sincronizzazione';

  @override
  String get cloudSyncStatusNever => 'Non ancora sincronizzato';

  @override
  String cloudSyncLastOut(String date) {
    return 'Inviato: $date';
  }

  @override
  String cloudSyncLastIn(String date) {
    return 'Caricato: $date';
  }

  @override
  String get cloudSyncExport => 'Inviare';

  @override
  String get cloudSyncImport => 'Carico';

  @override
  String get cloudSyncExportDone =>
      'Sincronizzazione file pronta: salva nel cloud';

  @override
  String cloudSyncImportSuccess(int count) {
    return 'Chiavi dati $count caricate';
  }

  @override
  String get cloudSyncImportNotNewer =>
      'Il file non è più recente dei dati su questo dispositivo';

  @override
  String get cloudSyncShareSubject => 'EcoPulse sincronizzazione';

  @override
  String cloudSyncError(String message) {
    return 'Errore di sincronizzazione: $message';
  }

  @override
  String get adminCrashReports => 'Rapporti sugli incidenti';

  @override
  String get assistantTitle => 'EcoPulse Assistente';

  @override
  String get assistantHint =>
      'Chiedi informazioni su tariffe, brief o portfolio...';

  @override
  String get assistantThinking => 'Pensiero…';

  @override
  String get assistantDisclaimer => 'Non consigli sugli investimenti';

  @override
  String get assistantClearHistory => 'Chiacchierata chiara';

  @override
  String get assistantVoiceListen => 'Ascoltare';

  @override
  String get assistantSourceLocal => 'locale';

  @override
  String get assistantSourceCloud => 'Gemini';

  @override
  String get assistantQuickPrice => 'USD/RUB';

  @override
  String get assistantQuickBrief => 'Breve';

  @override
  String get assistantQuickPortfolio => 'Portfolio';

  @override
  String get assistantQuickExplain => 'Inflazione';

  @override
  String get assistantQuickPriceQuery => 'tasso di sfregamento dei dollari';

  @override
  String get assistantQuickBriefQuery => 'oggi breve';

  @override
  String get assistantQuickPortfolioQuery => 'il mio portafoglio';

  @override
  String get assistantQuickExplainQuery => 'cos\'è l\'inflazione';

  @override
  String get settingsGeminiKey => 'Gemini API Chiave';

  @override
  String get courseLibraryTitle => 'Corsi';

  @override
  String get courseLibrarySubtitle =>
      'Educazione agli investimenti e alla finanza personale';

  @override
  String get courseDisclaimer =>
      'EcoPulse contenuti didattici. Non consigli sugli investimenti.';

  @override
  String get courseHomeCardTitle => 'Corso per investitori';

  @override
  String courseChaptersCount(int count) {
    return '$count capitoli';
  }

  @override
  String courseReadMinutes(int minutes) {
    return '~$minutes minuti di lettura';
  }

  @override
  String courseProgressPercent(int percent) {
    return '$percent% completato';
  }

  @override
  String get courseStartReading => 'Leggere';

  @override
  String get courseReadFromStart => 'Dall\'inizio';

  @override
  String get courseContinue => 'Continuare';

  @override
  String get courseTableOfContents => 'Sommario';

  @override
  String courseChapterProgress(int current, int total) {
    return 'Capitolo $current di $total';
  }

  @override
  String get courseChapterDone => 'Fatto';

  @override
  String get courseMarkRead => 'Marco ha letto';

  @override
  String get courseMarkedRead => 'Capitolo contrassegnato come letto';

  @override
  String get coursePrevChapter => 'Indietro';

  @override
  String get courseNextChapter => 'Prossimo';

  @override
  String get courseFinish => 'Fine';

  @override
  String get homeSectionLearn => 'Corsi';

  @override
  String get assistantQuickCourse => 'Corso';

  @override
  String get assistantQuickCourseQuery => 'corso di investimento aperto';

  @override
  String coursePagesCount(int pages) {
    return '~$pages pp.';
  }

  @override
  String courseChapterShort(int current, int total) {
    return 'cap. $current/$total';
  }

  @override
  String get courseReaderSettings => 'Impostazioni di lettura';

  @override
  String get courseFontSize => 'Dimensione del carattere';

  @override
  String get courseReadingTheme => 'Tema';

  @override
  String get courseThemeSystem => 'Sistema';

  @override
  String get courseThemeSepia => 'Seppia';

  @override
  String get courseThemeDark => 'Buio';

  @override
  String get courseSearch => 'Cerca libro';

  @override
  String get courseSearchHint => 'Parola chiave...';

  @override
  String get courseSearchEmpty => 'Nessun risultato';

  @override
  String get courseSearchClose => 'Vicino';

  @override
  String courseQuizProgress(int current, int total) {
    return 'Domanda $current di $total';
  }

  @override
  String get courseQuizNext => 'Invia';

  @override
  String get courseQuizPassed => 'Grande! Parte completa';

  @override
  String get courseQuizRetry => 'Riprova';

  @override
  String courseQuizScore(int correct, int total) {
    return 'Corretto: $correct di $total';
  }

  @override
  String get courseQuizContinue => 'Continua a leggere';

  @override
  String get courseQuizTryAgain => 'Riprova il quiz';

  @override
  String get homeServerTitle => 'Server domestico';

  @override
  String get homeServerSubtitle =>
      'LAN backend sul tuo PC per ID profilo e chat';

  @override
  String get homeServerUrlLabel => 'URL del server';

  @override
  String get homeServerUrlHint => 'http://192.168.1.105:8081';

  @override
  String get homeServerIpHint =>
      'Sul PC esegui ipconfig e utilizza IPv4 dall\'adattatore Wi-Fi';

  @override
  String get homeServerCheckConnection => 'Controlla la connessione';

  @override
  String get homeServerStatusOnline => 'In linea';

  @override
  String get homeServerStatusOffline => 'Non in linea';

  @override
  String get homeServerStatusUnknown => 'Non controllato';

  @override
  String get homeServerLogin => 'Registrazione';

  @override
  String get homeServerRegister => 'Registro';

  @override
  String get homeServerLoginLabel => 'Login';

  @override
  String get homeServerPasswordLabel => 'Password';

  @override
  String get homeServerProfileId => 'ProID file';

  @override
  String get homeServerCopyProfileId => 'Copia ProID file';

  @override
  String get homeServerProfileIdCopied => 'ProID file copiato';

  @override
  String homeServerLoggedInAs(String login) {
    return 'Accedi come $login';
  }

  @override
  String get homeServerLogout => 'disconnessione';

  @override
  String get homeServerSwitchAccount => 'Cambia account';

  @override
  String get homeServerEnsureSelfChat => 'Garantisci la chat autonoma';

  @override
  String get homeServerSelfChatReady => 'La chat personale è pronta';

  @override
  String get homeServerRegisterSuccess => 'Registrazione riuscita';

  @override
  String get homeServerLoginSuccess => 'Effettuato l\'accesso';

  @override
  String get homeServerLoggedOut => 'Disconnesso';

  @override
  String get homeServerCreateTestAccount => 'Crea un account test2';

  @override
  String get homeServerTestAccountCreated =>
      'Account test2 creato (o già esistente)';

  @override
  String get homeServerErrorLoginTaken => 'Accesso già effettuato';

  @override
  String get homeServerErrorInvalidCredentials => 'Login o password non validi';

  @override
  String get homeServerErrorLoginShort =>
      'Il login deve contenere almeno 3 caratteri';

  @override
  String get homeServerErrorPasswordShort =>
      'La password deve contenere almeno 4 caratteri';

  @override
  String get homeServerErrorUpgrade =>
      'Aggiornamento dell\'app richiesto per questo server';

  @override
  String get homeServerErrorNoUrl => 'Inserisci prima l\'URL del server';

  @override
  String get homeServerErrorNetwork =>
      'Impossibile raggiungere il server: controlla Wi-Fi e il firewall';

  @override
  String get cloudAccountTitle => 'EcoPulse Nuvola';

  @override
  String get cloudAccountSubtitle =>
      'Sincronizza profilo e watchlist tramite Supabase';

  @override
  String get cloudAccountNotConfigured =>
      'Crea con --dart-define=SUPABASE_URL e SUPABASE_ANON_KEY per abilitare la sincronizzazione cloud.';

  @override
  String get cloudEmailLabel => 'E-mail';

  @override
  String get cloudPasswordLabel => 'Password';

  @override
  String get cloudLogin => 'Registrazione';

  @override
  String get cloudRegister => 'Creare un account';

  @override
  String get cloudSignInGoogle => 'Continua con Google';

  @override
  String get cloudSwitchToLogin => 'Hai già un account? Registrazione';

  @override
  String get cloudSwitchToRegister => 'Nuovo qui? Creare un account';

  @override
  String get cloudLoginSuccess => 'Accesso a EcoPulse Cloud';

  @override
  String get cloudRegisterSuccess =>
      'Account creato: controlla l\'e-mail se è richiesta la conferma';

  @override
  String get cloudLoggedOut => 'Disconnesso dal cloud';

  @override
  String cloudLoggedInAs(String email) {
    return 'Accedi come $email';
  }

  @override
  String get cloudLogout => 'disconnessione';

  @override
  String get cloudSyncPush => 'Caricamento';

  @override
  String get cloudSyncPull => 'Scaricamento';

  @override
  String get cloudSyncPushSuccess => 'Profile e lista di controllo caricati';

  @override
  String get cloudSyncPullSuccess => 'Profile e lista di controllo scaricati';

  @override
  String get cloudSyncFailed => 'Sincronizzazione cloud non riuscita';

  @override
  String get cloudSyncNever => 'Non ancora sincronizzato';

  @override
  String cloudSyncLastAt(String time) {
    return 'Ultima sincronizzazione: $time';
  }

  @override
  String get marketsTabletSelectAsset =>
      'Seleziona un asset per visualizzare il grafico';

  @override
  String get messagePushTitle => 'Notifiche di chat';

  @override
  String get messagePushSubtitle =>
      'Premi quando arriva un nuovo messaggio sul server principale';

  @override
  String get messagePushRequiresServer =>
      'Accedi al server principale per abilitare il push della chat';

  @override
  String get messagePushFcmReady =>
      'FCM abilitato: consegna immediata quando il server invia push';

  @override
  String get marketsLiveBadge => 'LIVE';

  @override
  String get proTierTitle => 'EcoPulse Pro';

  @override
  String get proTierFreeTitle => 'Piano gratuito';

  @override
  String get proTierActiveTitle => 'Pro attivo';

  @override
  String get proTierSubtitle =>
      'Avvisi illimitati, grafici avanzati ed esportazione senza limiti.';

  @override
  String get proTierFreeBadge =>
      'Esegui l\'upgrade per ricevere avvisi illimitati';

  @override
  String get proTierActiveBadge => 'Pro vantaggi sbloccati';

  @override
  String get proTierComingSoon =>
      'Acquisto in-app disponibile a breve. Build di sviluppo: abilita nel pannello Admin.';

  @override
  String get proBenefitAlertsTitle => 'Avvisi sui prezzi';

  @override
  String proBenefitAlertsFree(int count) {
    return 'Fino a $count avvisi attivi';
  }

  @override
  String get proBenefitAlertsPro => 'Avvisi attivi illimitati';

  @override
  String get proBenefitChartsTitle => 'Grafici avanzati';

  @override
  String get proBenefitChartsSub =>
      'Tutti i periodi MA, indicatori, modalità a schermo intero';

  @override
  String get proBenefitExportTitle => 'Esportare';

  @override
  String get proBenefitExportSub =>
      'CSV/PDF senza filigrana (disponibile a breve)';

  @override
  String proAlertLimitReached(int count) {
    return 'Limite del piano gratuito: $count avvisi. Esegui l\'upgrade a Pro.';
  }

  @override
  String get adminDashboardMetrics => 'Metriche utente';

  @override
  String get adminMetricWatchlist => 'Lista di controllo';

  @override
  String get adminMetricAlerts => 'Avvisi';

  @override
  String get adminMetricThreads => 'Chat';

  @override
  String get adminMetricPositions => 'Posizioni';

  @override
  String get adminMetricServer => 'Server';

  @override
  String get adminFlagLiveCrypto =>
      'Crittografia in tempo reale WebSocket (Binance)';

  @override
  String get adminFlagProTier => 'EcoPulse Pro (sblocco sviluppatore)';

  @override
  String get brokerConnectTitle => 'Connect broker (sola lettura)';

  @override
  String get brokerConnectSubtitle =>
      'Visualizza il portafoglio T-Bank reale insieme al trading cartaceo';

  @override
  String get brokerReadOnlyTitle => 'T-Bank · sola lettura';

  @override
  String get brokerReadOnlyDisclaimer =>
      'Sola visualizzazione: EcoPulse non effettua mai ordini né sposta fondi.';

  @override
  String get brokerTokenLabel => 'T-Invest API gettone';

  @override
  String get brokerTokenHint =>
      'Token di sola lettura da tbank.ru/invest/settings';

  @override
  String get brokerRefresh => 'Aggiorna';

  @override
  String get brokerAccountLabel => 'Conto intermediario';

  @override
  String brokerTotalValue(String value) {
    return 'Totale: $value';
  }

  @override
  String brokerSyncedAt(String time) {
    return 'Aggiornato: $time';
  }

  @override
  String get brokerEmptyPositions => 'Nessun titolo in questo conto';

  @override
  String brokerMorePositions(int count) {
    return '+$count altre posizioni';
  }

  @override
  String get messagesTitle => 'Messaggi';

  @override
  String get messagesNewChat => 'Nuova chiacchierata';

  @override
  String get messagesEmpty => 'Nessuna chat ancora';

  @override
  String get messagesNotConnected =>
      'Connettiti al server principale in Impostazioni per utilizzare le chat';

  @override
  String get messagesSelfChat => 'Invia un messaggio a te stesso';

  @override
  String get messagesSearchHint => 'Cerca per login o ProID file';

  @override
  String get messagesSearchEmpty => 'Nessun utente trovato';

  @override
  String get messagesInputHint => 'Messaggio…';

  @override
  String get messagesThreadEmpty => 'Nessun messaggio ancora: scrivi il primo';

  @override
  String get profileIdLabel => 'ProID file';

  @override
  String get profileIdHint =>
      'UUID dal tuo server di casa: condividi per avviare una chat';

  @override
  String get customizationSectionTitle => 'Personalizzazione';

  @override
  String get customizationTitle => 'Personalizzazione';

  @override
  String get customizationSubtitle =>
      'Tema, grafici, home e navigazione in un unico posto';

  @override
  String get customizationSettingsEntry =>
      'Tutte le impostazioni dell\'aspetto';

  @override
  String get customizationSettingsEntrySubtitle =>
      'Grafici, temi, home, navigazione e widget';

  @override
  String get customizationPreview => 'Anteprima';

  @override
  String get customizationPreviewSample =>
      'Grafico di esempio con le impostazioni correnti';

  @override
  String customizationPreviewTheme(String mode) {
    return 'Tema: $mode';
  }

  @override
  String customizationPreviewAccent(String color) {
    return 'Accento: $color';
  }

  @override
  String get customizationPreviewCarouselHint =>
      'Scorri per visualizzare in anteprima grafico, home, mercati, portafoglio, navigazione';

  @override
  String get customizationPreviewSlideChart => 'Grafico';

  @override
  String get customizationPreviewSlideHome => 'Casa';

  @override
  String get customizationPreviewSlideMarkets => 'Mercati';

  @override
  String get customizationPreviewSlidePortfolio => 'Portfolio';

  @override
  String get customizationPreviewSlideNavigation => 'Navigazione';

  @override
  String get customizationPreviewCompact => 'Compatto';

  @override
  String get customizationWidgetPreviewTitle => 'Anteprima del widget Android';

  @override
  String get customizationWidgetPreviewSubtitle =>
      'Simulazione dal vivo del widget della schermata iniziale con le metriche attuali';

  @override
  String get customizationWidgetPreviewAutoHint =>
      'Layout automatico: compatto su 4×1, espanso quando il widget è più alto';

  @override
  String get customizationThemeAbTitle => 'Anteprima del tema A/B';

  @override
  String get customizationThemeAbSubtitle =>
      'Confronta il tuo tema attuale con un predefinito integrato fianco a fianco';

  @override
  String get customizationThemeAbCompareWith => 'Confronta con';

  @override
  String get customizationThemeAbCurrent => 'Corrente (A)';

  @override
  String get customizationThemeAbApply => 'Applica il tema di confronto';

  @override
  String customizationThemeAbApplied(String name) {
    return 'Tema da \"$name\" applicato';
  }

  @override
  String get customizationResetSection => 'Reimposta sezione';

  @override
  String get customizationResetAll => 'Reimposta tutto';

  @override
  String get customizationResetAllConfirm =>
      'Ripristinare tutte le impostazioni ai valori predefiniti?';

  @override
  String get customizationPresetsTitle => 'Preimpostazioni';

  @override
  String get customizationPresetsHint =>
      'Profili integrati o configurazioni salvate';

  @override
  String get customizationPresetSave => 'Risparmia corrente';

  @override
  String get customizationPresetSaveDialogTitle => 'Nuova preimpostazione';

  @override
  String get customizationPresetNameRu => 'Nome (RU)';

  @override
  String get customizationPresetNameEn => 'Nome (EN)';

  @override
  String get customizationPresetExport => 'Esportare';

  @override
  String get customizationPresetImport => 'Importare';

  @override
  String get customizationPresetImportHint =>
      'Incolla EcoPulse preimpostato JSON o condividi il link';

  @override
  String get customizationPresetShareLink => 'Condividi collegamento';

  @override
  String get customizationPresetMarketplaceTitle => 'Mercato preimpostato';

  @override
  String get customizationPresetMarketplaceSubtitle =>
      'Profili in primo piano: applica o condividi un collegamento';

  @override
  String get customizationPresetMarketplaceApply => 'Fare domanda a';

  @override
  String get customizationPresetLinkImportTitle => 'Importa preimpostazione';

  @override
  String customizationPresetLinkImportBody(String name) {
    return 'Installare la preimpostazione \"$name\" dal collegamento?';
  }

  @override
  String get customizationPresetLinkImportApply => 'Installare';

  @override
  String customizationPresetImportSuccess(String name) {
    return 'Preimpostazione \"$name\" aggiunta';
  }

  @override
  String get customizationPresetImportError =>
      'Impossibile importare la preimpostazione';

  @override
  String customizationPresetApplied(String name) {
    return 'Preimpostazione \"$name\" applicata';
  }

  @override
  String customizationPresetSaved(String name) {
    return 'Preimpostazione \"$name\" salvata';
  }

  @override
  String get customizationPresetShareSubject => 'EcoPulse preimpostato';

  @override
  String get customizationSectionCharts => 'Grafici';

  @override
  String get customizationSectionAppearance => 'Aspetto';

  @override
  String get customizationSectionHome => 'Casa';

  @override
  String get customizationSectionNavigation => 'Navigazione';

  @override
  String get customizationSectionMarkets => 'Mercati';

  @override
  String get customizationSectionPortfolio => 'Portfolio';

  @override
  String get customizationSectionWidgets => 'widget';

  @override
  String get customizationSectionDataDisplay => 'Visualizzazione dei dati';

  @override
  String get customizationSectionAssistant => 'Assistente';

  @override
  String get customizationChartDefaultType => 'Tipo di grafico predefinito';

  @override
  String get customizationChartPeriod => 'Periodo';

  @override
  String get customizationChartHeight => 'Altezza';

  @override
  String get customizationChartShowLegend => 'Leggenda';

  @override
  String get customizationChartPreferCandles => 'Candele quando disponibili';

  @override
  String get customizationChartNormalizedCompare => 'Confronto normalizzato';

  @override
  String get customizationChartVisualTitle => 'Opzioni visive';

  @override
  String get customizationChartSeriesPalette => 'Tavolozza della serie';

  @override
  String get customizationChartGridStyle => 'Stile griglia';

  @override
  String get customizationChartLineWidth => 'Larghezza della linea';

  @override
  String get customizationChartShowGrid => 'Griglia';

  @override
  String get customizationChartShowGradientFill => 'Riempimento sfumato';

  @override
  String get customizationChartShowCrosshair => 'Tocca il mirino';

  @override
  String get customizationChartShowEventMarkers => 'Indicatori di eventi';

  @override
  String get customizationChartShowPointMarkers => 'Segnapunti';

  @override
  String get customizationChartAnimateOnLoad => 'Animazione al caricamento';

  @override
  String get customizationChartShowVolume => 'Volume (candele)';

  @override
  String get customizationChartEnablePanZoom => 'Pizzica zoom e panoramica';

  @override
  String get customizationChartPriceAxisRight => 'Asse dei prezzi a destra';

  @override
  String get customizationChartContextProfilesTitle =>
      'Profili grafici sullo schermo';

  @override
  String get customizationChartContextProfilesHint =>
      'Sostituisci il tipo di grafico e il periodo per schermate specifiche.';

  @override
  String get customizationChartUseGlobalDefaults =>
      'Utilizza le impostazioni predefinite globali';

  @override
  String get customizationChartContextTypeOverride => 'Tipo di grafico';

  @override
  String get customizationChartContextPeriodOverride => 'Periodo';

  @override
  String get customizationChartContextAssetDetail => 'Dettaglio risorsa';

  @override
  String get customizationChartContextInflation => 'Inflazione (CPI)';

  @override
  String get customizationChartContextCurrency => 'Tassi di valuta';

  @override
  String get customizationChartContextCompare => 'Confronta le risorse';

  @override
  String get customizationChartContextPortfolio =>
      'Allocazione del portafoglio';

  @override
  String get customizationChartContextBonds =>
      'Curva dei rendimenti obbligazionari';

  @override
  String get customizationChartContextKeyRate => 'Tasso chiave';

  @override
  String get customizationChartContextHomeSparkline => 'Scintille domestiche';

  @override
  String get customizationFontScale => 'Scala del testo';

  @override
  String get customizationUiDensity => 'Densità dell\'interfaccia utente';

  @override
  String get customizationCardStyle => 'Stile della carta';

  @override
  String get customizationMotionReduced => 'Ridurre il movimento';

  @override
  String get customizationUiDensityCompact => 'Compatto';

  @override
  String get customizationUiDensityComfortable => 'Comodo';

  @override
  String get customizationUiDensitySpacious => 'Spazioso';

  @override
  String get customizationCardStyleFlat => 'Piatto';

  @override
  String get customizationCardStyleGlass => 'Bicchiere';

  @override
  String get customizationCardStyleBordered => 'Delimitato';

  @override
  String get customizationAmoledPureBlack => 'Nero puro (OLED)';

  @override
  String get customizationNavDefaultTab => 'Scheda predefinita';

  @override
  String get customizationNavShowFab => 'Pulsante Assistente';

  @override
  String get customizationNavHideLabels => 'Nascondi le etichette delle schede';

  @override
  String get customizationNavVisibleTabs => 'Schede visibili';

  @override
  String get customizationNavTabOrder =>
      'Trascina per riordinare le schede nella barra inferiore';

  @override
  String get customizationNavTabHidden => 'Nascosto';

  @override
  String get customizationHomeNewsCount => 'Novità in casa';

  @override
  String get customizationHomeSparklines => 'Linee scintillanti';

  @override
  String get customizationMarketsGroupStocks => 'Azioni del Gruppo per settore';

  @override
  String get customizationMarketsHeatmap => 'Mappa termica del settore';

  @override
  String get customizationMarketsCompactRows => 'Righe compatte';

  @override
  String get customizationMarketsDefaultRegion => 'Filtro stock predefinito';

  @override
  String get customizationMarketsRegionAll => 'Tutto';

  @override
  String get customizationMarketsRegionRu => 'MOEX';

  @override
  String get customizationMarketsRegionUs => 'NOI';

  @override
  String get customizationPortfolioAllocation => 'Grafico di allocazione';

  @override
  String get customizationPortfolioRealizedPnl => 'Realizzato P/L';

  @override
  String get customizationPortfolioJournal => 'Giornale commerciale';

  @override
  String get customizationAssistantPreferCloud => 'IA cloud (Gemini)';

  @override
  String get customizationAssistantQuickChips => 'Patatine veloci';

  @override
  String get customizationAssistantVoice => 'Ingresso vocale';

  @override
  String get customizationDataDecimalPlaces => 'Posti decimali';

  @override
  String get customizationDataLargeNumbers => 'Grandi numeri';

  @override
  String get customizationDataShowCurrencyCode => 'Mostra il codice valuta';

  @override
  String get customizationData24HourTime => '24 ore su 24';

  @override
  String get customizationSyncTitle => 'Sincronizzazione del server';

  @override
  String get customizationSyncSubtitle =>
      'Personalizzazione push/pull tramite home server (LAN)';

  @override
  String get customizationSyncNotLoggedIn =>
      'Accedi al server principale per sincronizzare';

  @override
  String get customizationSyncNever => 'Non ancora sincronizzato con il server';

  @override
  String get customizationSyncSynced =>
      'La personalizzazione corrisponde al server';

  @override
  String get customizationSyncLocalNewer =>
      'Le impostazioni locali sono più recenti: push consigliato';

  @override
  String get customizationSyncRemoteNewer =>
      'Il server ha impostazioni più recenti: pull consigliato';

  @override
  String get customizationSyncRemoteMissing =>
      'Nessuna impostazione sul server: premi per caricare';

  @override
  String customizationSyncLastPush(String date) {
    return 'Inserito: $date';
  }

  @override
  String customizationSyncLastPull(String date) {
    return 'Estratto: $date';
  }

  @override
  String customizationSyncError(String message) {
    return 'Errore di sincronizzazione: $message';
  }

  @override
  String get customizationSyncOpenServer => 'Account del server domestico';

  @override
  String get customizationSyncSmart => 'Sincronizzazione intelligente';

  @override
  String get customizationSyncPush => 'Spingere';

  @override
  String get customizationSyncPull => 'Tiro';

  @override
  String get customizationSyncDone => 'Personalizzazione sincronizzata';

  @override
  String get customizationSyncPushDone => 'Impostazioni inviate al server';

  @override
  String get customizationSyncPullDone => 'Impostazioni caricate dal server';

  @override
  String get customizationSyncFailed =>
      'Sincronizzazione non riuscita: controlla la connessione';

  @override
  String get customizationChartShowMa7 => 'MA(7)';

  @override
  String get customizationChartShowMa25 => 'MA(25)';

  @override
  String get customizationChartShowMa99 => 'MA(99)';

  @override
  String get chartFullscreen => 'Grafico a schermo intero';

  @override
  String get customizationHubSectionsTitle => 'Sezioni';

  @override
  String get settingsHubSubtitle => 'Preferenze e dati dell\'app';

  @override
  String get settingsHubGroupsTitle => 'Gruppi di impostazioni';

  @override
  String get portfolioAccountsTitle => 'Conti';

  @override
  String get portfolioAccountsAdd => 'Aggiungi account';

  @override
  String get portfolioAccountKindMain => 'Principale';

  @override
  String get portfolioAccountKindIis => 'IIS';

  @override
  String get portfolioAccountKindUsd => 'USD';

  @override
  String get portfolioAccountKindCrypto => 'Criptovaluta';

  @override
  String get portfolioAccountKindCustom => 'Costume';

  @override
  String get portfolioAccountNameHint => 'Nome utente';

  @override
  String get portfolioAccountCreate => 'Creare un account';

  @override
  String get portfolioAccountDelete => 'Rimuovi conto';

  @override
  String portfolioAccountDeleteConfirm(String name) {
    return 'Rimuovere \"$name\" e tutte le sue posizioni?';
  }

  @override
  String get portfolioAccountMaxReached => 'Massimo 8 account';

  @override
  String get portfolioSavingsGoalsTitle => 'Obiettivi di risparmio';

  @override
  String get portfolioSavingsGoalsSubtitle =>
      'Tieni traccia dei progressi verso un importo target';

  @override
  String get portfolioSavingsGoalAdd => 'Aggiungi obiettivo';

  @override
  String get portfolioSavingsGoalTitleHint => 'Nome dell\'obiettivo';

  @override
  String get portfolioSavingsGoalTargetHint => 'Importo target, ₽';

  @override
  String get portfolioSavingsGoalDeadline => 'Scadenza';

  @override
  String portfolioSavingsGoalProgress(String current, String target) {
    return '$current di $target';
  }

  @override
  String portfolioSavingsGoalDaysLeft(int days) {
    return '$days giorni rimasti';
  }

  @override
  String get portfolioSavingsGoalOverdue => 'La scadenza è passata';

  @override
  String get portfolioSavingsGoalLinkedAccount => 'Collegato al conto corrente';

  @override
  String get portfolioSavingsGoalEmpty =>
      'Ancora nessun obiettivo: imposta il tuo primo obiettivo';

  @override
  String get overnightChangesTitle => 'Dall\'ultima visita';

  @override
  String overnightChangesSince(int hours) {
    return 'Snapshot $hours h fa';
  }

  @override
  String get supportCenterTitle => 'Aiuto e supporto';

  @override
  String get supportCenterSubtitle => 'FAQ e contatti';

  @override
  String get supportCenterIntro =>
      'Risposte alle domande frequenti e contatti del team.';

  @override
  String get supportCenterFaqTitle => 'FAQ';

  @override
  String get supportCenterContactTitle => 'Contatti';

  @override
  String get supportCenterFeedback => 'Invia feedback';

  @override
  String get supportCenterGithub => 'GitHub Issues';

  @override
  String get sectorHeatmapTapHint =>
      'Tocca un settore per filtrare le azioni MOEX';

  @override
  String marketsSectorFilterActive(String sector) {
    return 'Settore: $sector';
  }

  @override
  String get shareWatchlistToChat => 'Condividi watchlist in Messages';

  @override
  String get shareWatchlistToChatHint =>
      'Invia brief + watchlist alla chat personale';

  @override
  String get shareWatchlistToChatNeedServer => 'Accedi prima al home server';

  @override
  String get shareWatchlistToChatSuccess =>
      'Watchlist inviata alla chat personale';

  @override
  String get shareWatchlistToChatFailed =>
      'Invio non riuscito — controlla il server';
}
