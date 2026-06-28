// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'EcoPulse';

  @override
  String get tabHome => 'Главная';

  @override
  String get tabCurrency => 'Валюты';

  @override
  String get tabInflation => 'Инфляция';

  @override
  String get tabMarkets => 'Рынки';

  @override
  String get tabMessages => 'Сообщения';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get pinEnterCode => 'Введите код доступа';

  @override
  String get pinWrongCode => 'Неверный код';

  @override
  String get pinUseBiometric => 'Войти по биометрии';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsDefaultTab => 'Стартовая вкладка';

  @override
  String get settingsBiometric => 'Биометрия';

  @override
  String get settingsBiometricSubtitle => 'Отпечаток или Face ID вместо PIN';

  @override
  String get shareQuote => 'Поделиться';

  @override
  String get copyQuote => 'Копировать';

  @override
  String get copied => 'Скопировано';

  @override
  String shareMessage(String title, String value) {
    return '$title: $value';
  }

  @override
  String get alertsTitle => 'Ценовые алерты';

  @override
  String get alertsAdd => 'Добавить алерт';

  @override
  String get alertsEmpty => 'Нет алертов. Например: USD/RUB выше 90 ₽';

  @override
  String get alertsSymbol => 'Инструмент';

  @override
  String get alertsThreshold => 'Порог';

  @override
  String get alertsSave => 'Сохранить';

  @override
  String get alertsCheckOnRefresh => 'Проверка при обновлении данных';

  @override
  String get alertsSettingsSubtitle =>
      'USD/RUB, BTC и другие — push в фоне и при обновлении';

  @override
  String alertsLastTriggered(String time) {
    return 'Срабатывание: $time';
  }

  @override
  String get alertAction => 'Создать алерт';

  @override
  String get homePulseTitle => 'Пульс экономики';

  @override
  String get homePulseSubtitle => 'Ключевые показатели в реальном времени';

  @override
  String homeUpdated(String time) {
    return 'Обновлено: $time';
  }

  @override
  String get sectionCurrencies => 'Валюты';

  @override
  String get sectionKeyRate => 'Ставка ЦБ РФ';

  @override
  String get sectionInflation => 'Инфляция';

  @override
  String get sectionCommodities => 'Сырьё';

  @override
  String get sectionMarkets => 'Рынки';

  @override
  String get sectionWatchlist => 'Избранное';

  @override
  String get actionAll => 'Все';

  @override
  String get actionMarkets => 'Рынки';

  @override
  String get actionCalculators => 'Калькуляторы';

  @override
  String get chartTitle => 'График';

  @override
  String get chartLine => 'Линия';

  @override
  String get chartCandles => 'Свечи';

  @override
  String get shareChart => 'Поделиться графиком';

  @override
  String get retry => 'Повторить';

  @override
  String errorGeneric(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get assetType => 'Тип';

  @override
  String get assetCurrency => 'Валюта';

  @override
  String get assetSource => 'Источник';

  @override
  String get assetTypeCrypto => 'Криптовалюта';

  @override
  String get assetTypeStockRu => 'Акция (MOEX)';

  @override
  String get assetTypeStockUs => 'Акция (US)';

  @override
  String get settingsCompactHome => 'Компактная главная';

  @override
  String get settingsCompactHomeSubtitle =>
      'Плотная сетка 2×2, меньше отступов';

  @override
  String get currencyLoadError => 'Ошибка загрузки';

  @override
  String currencyChart30d(String pair) {
    return 'График $pair (30 дней)';
  }

  @override
  String get currencyConverter => 'Конвертер';

  @override
  String get currencyAmount => 'Сумма';

  @override
  String get currencyFrom => 'Из';

  @override
  String get currencyTo => 'В';

  @override
  String get currencyFee => 'Комиссия обмена';

  @override
  String get currencyQuickConvert => 'Быстрая конвертация';

  @override
  String get currencyQuickHint => '100 USD в EUR';

  @override
  String get currencyQuickFormatError => 'Формат: 100 USD в EUR';

  @override
  String get currencyHistory => 'История конвертаций';

  @override
  String get currencyUnavailable => 'Ошибка загрузки · нажмите обновить';

  @override
  String get marketsSearchHint => 'Поиск BTC, SBER, AAPL…';

  @override
  String get marketsTabCrypto => 'Крипто';

  @override
  String get marketsTabStocks => 'Акции';

  @override
  String get marketsTabBonds => 'Облигации';

  @override
  String get assetTypeBondRu => 'Облигация (MOEX)';

  @override
  String get marketsFilterOfz => 'ОФЗ';

  @override
  String get marketsFilterCorporateBonds => 'Корп.';

  @override
  String get bondCategoryOfz => 'ОФЗ — федеральные';

  @override
  String get bondCategoryCorporate => 'Корпоративные';

  @override
  String get bondYieldLabel => 'Доходность';

  @override
  String get bondCouponLabel => 'Купон';

  @override
  String get bondMaturityLabel => 'Погашение';

  @override
  String get bondFaceValueLabel => 'Номинал';

  @override
  String marketsBondCatalogCounts(int count) {
    return 'Каталог: $count облигаций · MOEX ISS';
  }

  @override
  String get bondYieldCurveTitle => 'Кривая доходности ОФЗ';

  @override
  String get bondYieldCurveSubtitle => 'YTM × срок до погашения · MOEX ISS';

  @override
  String get bondYieldCurveTapHint => 'Нажмите для полноэкранного графика';

  @override
  String get bondYieldCurveEmpty => 'Недостаточно данных ОФЗ для кривой';

  @override
  String get bondYieldCurveTableTitle => 'Точки кривой';

  @override
  String get bondYieldCurveOpen => 'Кривая доходности';

  @override
  String get bondYieldSpreadLabel => 'Спред длинный–короткий';

  @override
  String bondYieldSpreadValue(String spread) {
    return '+$spread п.п.';
  }

  @override
  String get bondYearsShort => 'л';

  @override
  String get bondLadderTitle => 'Лестница ОФЗ';

  @override
  String get bondLadderSubtitle =>
      'По годам погашения · доходность к погашению';

  @override
  String get bondLadderTapHint => 'Нажмите для полного экрана';

  @override
  String bondLadderFullSubtitle(int ofzCount, int yearCount) {
    return '$ofzCount ОФЗ · $yearCount лет погашения';
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
      other: 'лет',
      few: 'года',
      one: 'год',
    );
    return 'Ещё $count $_temp0';
  }

  @override
  String get bondYieldCurveCrosshairHint => 'Нажмите на точку кривой';

  @override
  String get bondYieldCurveZoomHint =>
      'Колёсико или pinch для масштаба · двойной тап — сброс';

  @override
  String bondYieldCurveZoomActive(String zoom) {
    return 'Масштаб ×$zoom · двойной тап — сброс';
  }

  @override
  String get bondCalendarTitle => 'Календарь облигаций';

  @override
  String get bondCalendarSubtitle =>
      'Избранное и портфель · купоны MOEX или оценка';

  @override
  String get bondCalendarTapHint => 'Нажмите для полного календаря';

  @override
  String get bondCalendarFullSubtitle =>
      'Избранное и бумажный портфель · купоны и погашения';

  @override
  String get bondCalendarHorizon6m => '6 мес.';

  @override
  String get bondCalendarHorizon1y => '1 год';

  @override
  String get bondCalendarHorizon2y => '2 года';

  @override
  String get bondCalendarCouponIncome => 'Купоны портфеля (оценка)';

  @override
  String get bondCalendarCouponIncomeHint => 'MOEX COUPONVALUE × количество';

  @override
  String get bondCalendarEmptyTracked =>
      'Добавьте облигации в избранное или портфель';

  @override
  String get bondCalendarEmptyEvents => 'Нет событий в выбранном горизонте';

  @override
  String bondCalendarMoreEvents(int count) {
    return 'Ещё $count событий';
  }

  @override
  String get bondEventMaturity => 'Погашение';

  @override
  String bondEventCouponRub(String amount) {
    return 'Купон $amount ₽';
  }

  @override
  String bondEventCouponPercent(String rate) {
    return 'Купон $rate%';
  }

  @override
  String bondEventCouponEstimate(String rate) {
    return 'Купон ~$rate% (оценка)';
  }

  @override
  String get bondNextCouponLabel => 'Ближайший купон';

  @override
  String get bondCouponValueLabel => 'Размер купона';

  @override
  String get bondHomeCardTitle => 'Облигации ОФЗ';

  @override
  String get bondHomeCardSubtitle => 'Средняя доходность и спред · MOEX ISS';

  @override
  String bondHomeUpcomingEvents(int count) {
    return 'Ближайшие события: $count';
  }

  @override
  String get bondCalendarOpen => 'Календарь';

  @override
  String get bondHomeAvgYield => 'Средняя YTM';

  @override
  String get bondHomeTopYield => 'Макс. доходность';

  @override
  String get marketsFavorites => 'Избранное';

  @override
  String get marketsEmptyFavoritesTitle => 'Нет избранных активов';

  @override
  String get marketsEmptySearchTitle => 'Ничего не найдено';

  @override
  String get marketsEmptyFavoritesSubtitle =>
      'Нажмите ★ на активе, чтобы добавить в избранное';

  @override
  String get marketsEmptySearchSubtitle =>
      'Попробуйте другой запрос или сбросьте фильтр';

  @override
  String get marketsAllAssets => 'Все активы';

  @override
  String marketsRemovedFromWatchlist(String symbol) {
    return '$symbol удалён из избранного';
  }

  @override
  String get undo => 'Отмена';

  @override
  String get inflationTabCountries => 'Страны';

  @override
  String get inflationTabCalculator => 'Инфляция';

  @override
  String get inflationTabFinance => 'Финансы';

  @override
  String get inflationCpiTitle => 'Инфляция (CPI), год к году';

  @override
  String get inflationWorldBankNote =>
      'Данные World Bank · последний доступный год';

  @override
  String get inflationCalcTitle => 'Сколько стоят деньги сегодня?';

  @override
  String get inflationCalcSubtitle =>
      'Учитывает накопленную инфляцию по данным World Bank';

  @override
  String get inflationCountry => 'Страна';

  @override
  String get inflationAmount => 'Сумма';

  @override
  String get inflationYear => 'Год';

  @override
  String get inflationYoy => 'год к году';

  @override
  String get inflationUnavailable => 'Данные временно недоступны';

  @override
  String purchasingPower(String base, int year, String today) {
    return '$base в $year ≈ $today сегодня';
  }

  @override
  String get chartInsufficientData => 'Недостаточно данных для графика';

  @override
  String get chartInsufficientCandles => 'Недостаточно данных для свечей';

  @override
  String get dataUnavailable => 'Данные временно недоступны';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeAuto => 'Авто';

  @override
  String get settingsThemeOled => 'OLED';

  @override
  String get settingsThemeDim => 'Приглуш.';

  @override
  String get settingsThemeSepia => 'Сепия';

  @override
  String get settingsThemeContrast => 'Контраст';

  @override
  String get settingsAccentColor => 'Акцентный цвет';

  @override
  String settingsThemeCurrent(String mode) {
    return 'Текущая: $mode';
  }

  @override
  String get sectorHeatmapTitle => 'Секторы MOEX';

  @override
  String get sectorHeatmapSubtitle => 'Среднее изменение за 7 дней по секторам';

  @override
  String get sectorFinance => 'Финансы';

  @override
  String get sectorEnergy => 'Энергетика';

  @override
  String get sectorIt => 'IT';

  @override
  String get sectorIndex => 'Индекс';

  @override
  String dataStatusFresh(String time) {
    return 'Обновлено: $time';
  }

  @override
  String get dataStatusLive => 'Данные актуальны';

  @override
  String dataStatusCache(String age) {
    return 'Кэш · $age';
  }

  @override
  String get dataStatusCacheUnknown => 'Кэш · данные устарели';

  @override
  String dataStatusOffline(String age) {
    return 'Offline · кэш $age';
  }

  @override
  String get dataStatusOfflineUnknown => 'Offline · сохранённые данные';

  @override
  String get alertsCheckBackground =>
      'Проверка каждые 15 мин в фоне + при обновлении';

  @override
  String get currencyCompareTitle => 'Сравнение курсов';

  @override
  String get currencyCompareSubtitle =>
      'Индекс 100 в начале периода — до 3 пар';

  @override
  String get currencyCompareSelect => 'Выберите ещё одну пару для сравнения';

  @override
  String get assetPreviewOpen => 'Открыть график';

  @override
  String get assetPreviewAddWatchlist => 'В избранное';

  @override
  String get assetPreviewRemoveWatchlist => 'Убрать из избранного';

  @override
  String get inflationCompareTitle => 'Сравнение стран';

  @override
  String get inflationCompareSubtitle =>
      'CPI год к году — до 3 стран на одном графике';

  @override
  String get inflationCompareSelect => 'Выберите ещё одну страну для сравнения';

  @override
  String get settingsHomeWidget => 'Виджет Android';

  @override
  String get settingsHomeWidgetSubtitle =>
      'USD/RUB и BTC на домашнем экране — обновляется при refresh';

  @override
  String get keyRateDetailTitle => 'Ключевая ставка ЦБ';

  @override
  String keyRateUpdated(String date) {
    return 'Обновлено: $date';
  }

  @override
  String get keyRateEventsTitle => 'Изменения ставки';

  @override
  String get keyRateEventsEmpty => 'За период изменений не было';

  @override
  String keyRateEventChange(String date, String rate) {
    return '$date → $rate';
  }

  @override
  String keyRateSince(int day, int month, int year) {
    return 'с $day.$month.$year';
  }

  @override
  String get sourceCbr => 'ЦБ РФ';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get onboarding1Title => 'Валюты и курсы';

  @override
  String get onboarding1Subtitle =>
      'USD/RUB, EUR/RUB и мировые валюты в реальном времени с MOEX и Frankfurter';

  @override
  String get onboarding2Title => 'Инфляция и ставка ЦБ';

  @override
  String get onboarding2Subtitle =>
      'Данные World Bank, ключевая ставка ЦБ РФ и финансовые калькуляторы';

  @override
  String get onboarding3Title => 'Рынки и избранное';

  @override
  String get onboarding3Subtitle =>
      'Криптовалюты, акции MOEX, графики и watchlist — всё в одном месте';

  @override
  String get settingsSectionAppearance => 'Оформление';

  @override
  String get settingsAppTheme => 'Тема приложения';

  @override
  String get settingsAppBackground => 'Фон приложения';

  @override
  String get settingsBackgroundSubtitle =>
      'Градиент как в банковских приложениях';

  @override
  String get settingsSectionSecurity => 'Безопасность';

  @override
  String get settingsPinCode => 'Код доступа';

  @override
  String get settingsPinEnabled => 'Приложение защищено · 4 цифры';

  @override
  String get settingsPinDisabled => 'PIN не включён';

  @override
  String get settingsChangePin => 'Сменить код';

  @override
  String get settingsLockNow => 'Заблокировать сейчас';

  @override
  String get settingsLockedSnack => 'Приложение заблокировано';

  @override
  String get settingsSectionDisplay => 'Отображение';

  @override
  String get settingsBaseCurrency => 'Базовая валюта';

  @override
  String get settingsKeysLocalNote =>
      'Ключи сохраняются локально — пересборка не нужна';

  @override
  String get settingsSectionDataApi => 'Данные и API';

  @override
  String get settingsSectionAbout => 'О приложении';

  @override
  String get settingsAboutDescription =>
      'Экономический дашборд с валютами, инфляцией, криптовалютами и биржевыми котировками.';

  @override
  String get settingsAboutDesign =>
      'Дизайн: Material 3 · fl_chart · flutter_animate';

  @override
  String get settingsAboutDeveloper =>
      'Разработал Цымбал Евгений Владиславович';

  @override
  String get sourceFrankfurter => 'Frankfurter';

  @override
  String get sourceFrankfurterSub => 'Международные валюты';

  @override
  String get sourceMoex => 'MOEX ISS';

  @override
  String get sourceMoexSub => 'Валюты и акции РФ';

  @override
  String get sourceCbrSub => 'Ключевая ставка';

  @override
  String get sourceWorldBank => 'World Bank';

  @override
  String get sourceWorldBankSub => 'Инфляция CPI';

  @override
  String get sourceCoingecko => 'CoinGecko';

  @override
  String get sourceCoingeckoSub => 'Криптовалюты';

  @override
  String get sourceFinnhub => 'Finnhub';

  @override
  String get sourceFinnhubSub => 'Акции США';

  @override
  String get sourceCommodities => 'MOEX ISS';

  @override
  String get sourceCommoditiesSub => 'Сырьё';

  @override
  String get statusActive => 'Активен';

  @override
  String get statusKeyOk => 'Ключ OK';

  @override
  String get statusNoKey => 'Без ключа';

  @override
  String get statusNotConfigured => 'Не настроен';

  @override
  String get inflationRateVsTitle => 'Ставка ЦБ vs инфляция';

  @override
  String get inflationRateVsSubtitle =>
      'Средняя ключевая ставка и CPI РФ по годам';

  @override
  String get inflationRateVsKeyRate => 'Ставка ЦБ';

  @override
  String get inflationRateVsCpi => 'CPI inflation';

  @override
  String get correlationTitle => 'Корреляция активов';

  @override
  String correlationSubtitle(int days) {
    return 'Дневные доходности за $days дней (Пирсон)';
  }

  @override
  String get correlationChartTitle => 'Динамика (индекс 100)';

  @override
  String get correlationNote =>
      '1 — полная синхронность, −1 — обратная, 0 — нет связи';

  @override
  String get correlationBtc => 'BTC';

  @override
  String get correlationUsdRub => 'USD/RUB';

  @override
  String get correlationImoex => 'IMOEX';

  @override
  String get sectorMetals => 'Металлы';

  @override
  String get sectorTelecom => 'Телеком';

  @override
  String get sectorConsumer => 'Потребительский';

  @override
  String get sectorTransport => 'Транспорт';

  @override
  String get sectorRealestate => 'Недвижимость';

  @override
  String get sectorChemicals => 'Химия';

  @override
  String get sectorEtf => 'ETF';

  @override
  String get sectorTech => 'Технологии';

  @override
  String get sectorAuto => 'Авто';

  @override
  String get sectorHealth => 'Здоровье';

  @override
  String get sectorMedia => 'Медиа';

  @override
  String get sectorIndustrial => 'Промышленность';

  @override
  String get sectorUs => 'США';

  @override
  String get sectorOther => 'Прочее';

  @override
  String get marketsFilterAll => 'Все';

  @override
  String get marketsFilterMoex => 'MOEX';

  @override
  String get marketsFilterUs => 'NYSE/NASDAQ';

  @override
  String get marketsGroupBySector => 'По секторам';

  @override
  String get marketsCatalogHint =>
      '50 MOEX · 45 US · 100 crypto · поиск по тикеру';

  @override
  String marketsCatalogCounts(int moex, int us, int crypto) {
    return '$moex MOEX · $us US · $crypto crypto · поиск';
  }

  @override
  String get currencyGroupMoex => 'MOEX · рубли';

  @override
  String get currencyGroupMajor => 'Основные';

  @override
  String get currencyGroupEurope => 'Европа';

  @override
  String get currencyGroupAsia => 'Азия';

  @override
  String get currencyGroupEm => 'Развивающиеся';

  @override
  String get currencyGroupAmericas => 'Америка и Океания';

  @override
  String get adminPanelTitle => 'Admin Panel';

  @override
  String get adminPanelSubtitle =>
      'Dev-инструменты: API, кэш, каталоги, feature flags';

  @override
  String get adminApiStatus => 'Статус API';

  @override
  String get adminCache => 'Кэш';

  @override
  String get adminCatalog => 'Каталоги';

  @override
  String get adminFeatureFlags => 'Feature flags';

  @override
  String get adminHttpLog => 'HTTP лог';

  @override
  String get adminHttpLogEmpty => 'Запросов пока нет';

  @override
  String get adminRefreshAll => 'Обновить всё';

  @override
  String get adminReloadStatus => 'Перезагрузить статус';

  @override
  String get adminRefreshed => 'Данные обновлены';

  @override
  String get adminFlagSectorHeatmap => 'Теплокарта секторов MOEX';

  @override
  String get adminFlagStocksGrouped => 'Группировка акций по секторам';

  @override
  String get adminFlagVerboseHttp => 'Подробный HTTP лог';

  @override
  String get adminCacheEmpty => 'Пусто';

  @override
  String get adminCacheFresh => 'Свежий';

  @override
  String get adminCacheStale => 'Устарел';

  @override
  String adminCacheAge(String age) {
    return 'Возраст: $age';
  }

  @override
  String adminCacheItems(int count) {
    return '$count записей';
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
  String get profileSectionTitle => 'Профиль';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileGuest => 'Гость · настройте профиль';

  @override
  String profileGreeting(String name) {
    return 'Привет, $name!';
  }

  @override
  String get profileDisplayName => 'Имя';

  @override
  String get profileDisplayNameHint => 'Как к вам обращаться';

  @override
  String get profileAvatarHint => 'Выберите аватар';

  @override
  String get profileCountry => 'Страна для инфляции';

  @override
  String get profileCountryHint => 'Используется на вкладке «Страны»';

  @override
  String profileCountryLabel(String country) {
    return 'Страна: $country';
  }

  @override
  String get profileSaved => 'Профиль сохранён';

  @override
  String get profileSave => 'Сохранить';

  @override
  String get backupSectionTitle => 'Резервная копия';

  @override
  String get backupExportTitle => 'Экспорт данных';

  @override
  String get backupExportSubtitle =>
      'Watchlist, профиль, настройки, заметки — JSON';

  @override
  String get backupImportTitle => 'Импорт данных';

  @override
  String get backupImportSubtitle => 'Вставьте JSON из экспорта';

  @override
  String get backupImportHint => 'Вставьте JSON из экспорта EcoPulse';

  @override
  String get backupImportConfirm => 'Восстановить';

  @override
  String backupImportSuccess(int count) {
    return 'Восстановлено ключей: $count';
  }

  @override
  String backupImportError(String error) {
    return 'Ошибка импорта: $error';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get assetNoteTitle => 'Заметка';

  @override
  String get assetNoteHint => 'Купил @ 280, цель 320…';

  @override
  String get portfolioTitle => 'Бумажный портфель';

  @override
  String get portfolioEmptySubtitle =>
      '100 000 ₽ виртуально · нажмите, чтобы начать';

  @override
  String get portfolioTotal => 'Стоимость портфеля';

  @override
  String get portfolioPnl => 'P&L';

  @override
  String get portfolioCash => 'Кэш';

  @override
  String get portfolioPositions => 'Позиции';

  @override
  String get portfolioEmptyPositions =>
      'Купите актив из избранного или preview на «Рынках»';

  @override
  String get portfolioAdd => 'Купить';

  @override
  String get portfolioBuy => 'Покупка';

  @override
  String get portfolioBuyAction => 'В портфель';

  @override
  String portfolioBought(String symbol) {
    return '$symbol добавлен в портфель';
  }

  @override
  String get portfolioInsufficientCash => 'Недостаточно виртуальных средств';

  @override
  String get portfolioReset => 'Сбросить';

  @override
  String get portfolioResetConfirm =>
      'Вернуть 100 000 ₽ и удалить все позиции?';

  @override
  String portfolioRemoved(String symbol) {
    return '$symbol удалён (long press)';
  }

  @override
  String get portfolioPickAsset => 'Выберите актив';

  @override
  String get portfolioPickFromWatchlist =>
      'Добавьте активы в избранное на «Рынках»';

  @override
  String cryptoLoadMore(int loaded, int total) {
    return 'Ещё ($loaded / $total)';
  }

  @override
  String get homeShareDashboard => 'Поделиться дашбордом';

  @override
  String get newsSectionTitle => 'Новости';

  @override
  String get newsFinnhubHint =>
      'Добавьте Finnhub Key в настройках для новостей и календаря';

  @override
  String get newsEmpty => 'Новостей пока нет';

  @override
  String get newsLoadError => 'Не удалось загрузить новости';

  @override
  String get macroCalendarTitle => 'Macro-календарь';

  @override
  String get macroCalendarEmpty => 'Событий на ближайшую неделю нет';

  @override
  String get digestSectionTitle => 'Уведомления';

  @override
  String get digestMorningTitle => 'Утренняя сводка';

  @override
  String get digestMorningSubtitle =>
      'Push с brief USD/RUB, BTC, IMOEX в выбранный час';

  @override
  String get digestMorningHour => 'Время отправки';

  @override
  String get indicesSectionTitle => 'Индексы США';

  @override
  String get radarTitle => 'Экономический радар';

  @override
  String get radarSubtitle => 'Оценка по рынку, валюте, инфляции, ставке и F&G';

  @override
  String get timelineTitle => 'Лента событий';

  @override
  String get timelineEmpty => 'Событий пока нет · нужен Finnhub для macro';

  @override
  String get macroWeekTitle => 'Макро-неделя';

  @override
  String macroWeekRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get macroWeekBriefTitle => 'Сводка рынка';

  @override
  String get macroWeekToday => 'Сегодня';

  @override
  String get macroWeekKeyRateToday => 'Ключевая ставка ЦБ';

  @override
  String macroWeekStats(int events, int days) {
    return '$events macro-событий · $days дней с событиями';
  }

  @override
  String get macroWeekEmptyDay => 'Без событий';

  @override
  String get macroWeekMon => 'Пн';

  @override
  String get macroWeekTue => 'Вт';

  @override
  String get macroWeekWed => 'Ср';

  @override
  String get macroWeekThu => 'Чт';

  @override
  String get macroWeekFri => 'Пт';

  @override
  String get macroWeekSat => 'Сб';

  @override
  String get macroWeekSun => 'Вс';

  @override
  String get portfolioExportCsv => 'Экспорт CSV';

  @override
  String get portfolioExportDone => 'CSV отправлен';

  @override
  String get demoModeTitle => 'Демо-режим';

  @override
  String get demoModeSubtitle =>
      'Mock-данные без сети — для скриншотов и презентаций';

  @override
  String get demoModeBadge => 'Демо-данные';

  @override
  String get homeLayoutTitle => 'Секции главной';

  @override
  String get homeSectionPortfolio => 'Бумажный портфель';

  @override
  String get homeSectionNews => 'Новости';

  @override
  String get homeSectionRadar => 'Экономический радар';

  @override
  String get homeSectionIndices => 'Индексы США';

  @override
  String get homeSectionFearGreed => 'Fear & Greed';

  @override
  String get homeSectionCurrencies => 'Валюты';

  @override
  String get homeSectionKeyRate => 'Ключевая ставка';

  @override
  String get homeSectionInflation => 'Инфляция';

  @override
  String get homeSectionCommodities => 'Сырьё';

  @override
  String get homeSectionMarkets => 'Рынки';

  @override
  String get homeSectionBonds => 'Облигации';

  @override
  String get homeSectionWatchlist => 'Избранное';

  @override
  String get homeSectionCorrelation => 'Корреляции';

  @override
  String get compareTitle => 'Сравнение активов';

  @override
  String compareSubtitle(int max) {
    return 'Выберите до $max активов для overlay-графика';
  }

  @override
  String get compareEmpty => 'Выберите тикеры выше';

  @override
  String get compareClear => 'Очистить';

  @override
  String get compareChartTitle => 'Индекс 100 · 30 дней';

  @override
  String get compareLoadError => 'Не удалось загрузить историю';

  @override
  String get settingsApiKeysTitle => 'API-ключи';

  @override
  String settingsApiKeySaved(String label) {
    return '$label сохранён';
  }

  @override
  String get settingsBaseCurrencyHint => 'Используется в конвертере';

  @override
  String get settingsWidgetConfigTitle => 'Виджет Android';

  @override
  String get settingsWidgetConfigSubtitle =>
      'Полоска 4×1 или сетка 2×2 · до 4 метрик';

  @override
  String get settingsWidgetLayout => 'Макет';

  @override
  String get settingsWidgetLayoutAuto => 'Авто (по размеру)';

  @override
  String get settingsWidgetLayoutCompact => 'Компакт 4×1';

  @override
  String get settingsWidgetLayoutExpanded => 'Расширенный 2×2';

  @override
  String get settingsWidgetLayoutHint =>
      'В режиме «Авто» макет меняется при изменении размера виджета на рабочем столе';

  @override
  String get settingsWidgetSlot1 => 'Слот 1';

  @override
  String get settingsWidgetSlot2 => 'Слот 2';

  @override
  String get settingsWidgetSlot3 => 'Слот 3';

  @override
  String get settingsWidgetSlot4 => 'Слот 4';

  @override
  String get widgetMetricUsdRub => 'USD/RUB';

  @override
  String get widgetMetricEurRub => 'EUR/RUB';

  @override
  String get widgetMetricBtc => 'BTC';

  @override
  String get widgetMetricEth => 'ETH';

  @override
  String get widgetMetricKeyRate => 'Ставка ЦБ';

  @override
  String get widgetMetricBrent => 'Brent';

  @override
  String get widgetMetricWti => 'WTI';

  @override
  String get widgetMetricImoex => 'IMOEX';

  @override
  String get widgetMetricPortfolio => 'Бумажный портфель';

  @override
  String get widgetMetricInflationRu => 'Инфляция РФ';

  @override
  String get homeLayoutReorderHint =>
      'Перетащите для порядка · переключатель — показ';

  @override
  String get alertsKindThreshold => 'По цене';

  @override
  String get alertsKindPercentChange => 'По изменению %';

  @override
  String get alertsPercentHint => 'Порог изменения за день, %';

  @override
  String get alertsHistoryTitle => 'История срабатываний';

  @override
  String get alertsHistoryEmpty => 'Пока не было срабатываний';

  @override
  String get alertsQuietHoursTitle => 'Тихие часы';

  @override
  String get alertsQuietHoursSubtitle => 'Без push в выбранный интервал';

  @override
  String alertsQuietHoursRange(int start, int end) {
    return 'С $start:00 до $end:00';
  }

  @override
  String get alertsQuietHoursStart => 'С';

  @override
  String get alertsQuietHoursEnd => 'До';

  @override
  String get alertsConditionRise => 'Рост';

  @override
  String get alertsConditionDrop => 'Падение';

  @override
  String get alertsConditionAbove => 'Выше';

  @override
  String get alertsConditionBelow => 'Ниже';

  @override
  String get alertsPresetsTitle => 'Быстрые шаблоны';

  @override
  String get alertsPresetUsd100 => 'USD/RUB > 100';

  @override
  String get alertsPresetBtcDrop5 => 'BTC −5% за день';

  @override
  String get alertsPresetBtcRise5 => 'BTC +5% за день';

  @override
  String get alertsPresetImoexDrop3 => 'IMOEX −3% за день';

  @override
  String get exportReportTitle => 'Отчёт за неделю';

  @override
  String get exportReportSubtitle => 'Сводка + избранное + валюты';

  @override
  String get exportReportDone => 'Отчёт отправлен';

  @override
  String get portfolioBacktestTitle => 'Бэктест ~30 дней';

  @override
  String portfolioBacktestResult(String past, String current, String change) {
    return 'Было $past → сейчас $current ($change)';
  }

  @override
  String get portfolioBacktestUnavailable => 'Недостаточно истории по позициям';

  @override
  String get portfolioAllocationTitle => 'Аллокация';

  @override
  String get portfolioAllocationSubtitle =>
      'Доли классов активов · бумажный портфель';

  @override
  String get portfolioAllocationCash => 'Кэш';

  @override
  String get portfolioAllocationCrypto => 'Крипто';

  @override
  String get portfolioAllocationStocks => 'Акции';

  @override
  String get portfolioAllocationBonds => 'Облигации';

  @override
  String portfolioAllocationTotal(String total) {
    return 'Всего в активах: $total';
  }

  @override
  String get portfolioRebalanceTitle => 'Ребалансировка';

  @override
  String get portfolioRebalanceSubtitle =>
      'Целевые доли и подсказки по классам активов';

  @override
  String get portfolioRebalanceConservative => 'Консерв.';

  @override
  String get portfolioRebalancePresetBalanced => 'Баланс';

  @override
  String get portfolioRebalanceGrowth => 'Рост';

  @override
  String get portfolioRebalanceCustom => 'Свой';

  @override
  String portfolioRebalanceDrift(String drift) {
    return 'Макс. отклонение: $drift';
  }

  @override
  String get portfolioRebalanceOnTarget =>
      'Портфель близок к целевой аллокации';

  @override
  String portfolioRebalanceBuy(String amount) {
    return 'Купить $amount';
  }

  @override
  String portfolioRebalanceSell(String amount) {
    return 'Продать $amount';
  }

  @override
  String get portfolioRebalanceHold => 'Ок';

  @override
  String portfolioRebalanceInvestCash(String amount) {
    return 'Инвестировать $amount';
  }

  @override
  String portfolioRebalanceFreeCash(String amount) {
    return 'Освободить $amount';
  }

  @override
  String portfolioRebalanceCurrentTarget(int current, int target) {
    return 'Сейчас $current% → цель $target%';
  }

  @override
  String get portfolioIncomeTitle => 'Календарь дохода';

  @override
  String get portfolioIncomeSubtitle =>
      'Купоны, дивиденды и погашения по вашим позициям';

  @override
  String get portfolioIncomeNext30 => '30 дней';

  @override
  String get portfolioIncomeNext90 => '90 дней';

  @override
  String get portfolioIncomeByMonth => 'По месяцам';

  @override
  String portfolioIncomeMonthChip(String month, String amount) {
    return '$month · $amount ₽';
  }

  @override
  String get portfolioIncomeUpcoming => 'Ближайшие поступления';

  @override
  String get portfolioIncomeCoupon => 'Купон';

  @override
  String get portfolioIncomeCouponEstimate => 'Купон (оценка)';

  @override
  String get portfolioIncomeMaturity => 'Погашение номинала';

  @override
  String get portfolioIncomeDividendEstimate => 'Дивиденды (оценка)';

  @override
  String get portfolioScenarioTitle => 'Сценарии «что если»';

  @override
  String get portfolioScenarioSubtitle => 'Пересчёт стоимости при шоке рынка';

  @override
  String get portfolioScenarioUsdUp10 => 'USD/RUB +10%';

  @override
  String get portfolioScenarioBtcDown30 => 'BTC −30%';

  @override
  String get portfolioScenarioImoexDown15 => 'IMOEX −15%';

  @override
  String get portfolioScenarioKeyRateUp2 => 'Ставка +2 п.п.';

  @override
  String portfolioScenarioResult(String base, String scenario) {
    return '$base → $scenario';
  }

  @override
  String portfolioScenarioDelta(String amount, String percent) {
    return 'Δ $amount ($percent)';
  }

  @override
  String get portfolioRealReturnTitle => 'Реальная доходность';

  @override
  String get portfolioRealReturnSubtitle =>
      'Номинал минус инфляция · сравнение с IMOEX и депозитом';

  @override
  String get portfolioRealReturnHorizon30d => '30 дней';

  @override
  String get portfolioRealReturnHorizonAll => 'С начала';

  @override
  String get portfolioRealReturnNominal => 'Портфель (номинал)';

  @override
  String get portfolioRealReturnReal => 'Портфель (реальная)';

  @override
  String get portfolioRealReturnInflation => 'Инфляция (RU)';

  @override
  String get portfolioRealReturnImoex => 'IMOEX';

  @override
  String get portfolioRealReturnDeposit => 'Депозит (ставка ЦБ)';

  @override
  String portfolioRealReturnBeatInflation(String value) {
    return 'Реальная доходность $value — опережает инфляцию';
  }

  @override
  String portfolioRealReturnLoseInflation(String value) {
    return 'Реальная доходность $value — ниже инфляции';
  }

  @override
  String portfolioRealReturnBeatImoex(String delta) {
    return 'Опережает IMOEX на $delta';
  }

  @override
  String portfolioRealReturnLoseImoex(String delta) {
    return 'Отстаёт от IMOEX на $delta';
  }

  @override
  String get portfolioRealReturnBeatDeposit =>
      'Выше депозита по ключевой ставке';

  @override
  String get portfolioRealReturnLoseDeposit =>
      'Ниже депозита по ключевой ставке';

  @override
  String get watchlistVolatilityTitle => 'Волатильность избранного';

  @override
  String get watchlistVolatilitySubtitle =>
      'Годовая σ по дневным доходностям · sparkline ~30 дней';

  @override
  String watchlistVolatilityAnnual(String value) {
    return 'σ $value';
  }

  @override
  String get watchlistVolatilityLow => 'Низкая';

  @override
  String get watchlistVolatilityHigh => 'Высокая';

  @override
  String get portfolioTradeJournalTitle => 'Журнал сделок';

  @override
  String get portfolioTradeJournalSubtitle =>
      'История покупок и продаж бумажного портфеля';

  @override
  String get portfolioTradeJournalEmpty =>
      'Сделок пока нет · купите актив из избранного';

  @override
  String get portfolioTradeJournalBuy => 'Покупка';

  @override
  String get portfolioTradeJournalSell => 'Продажа';

  @override
  String get portfolioTradeJournalOpenAll => 'Все';

  @override
  String get portfolioTradeJournalExport => 'Экспорт CSV';

  @override
  String portfolioTradeJournalStats(int total, int buys, int sells) {
    return '$total сделок · $buys покупок · $sells продаж';
  }

  @override
  String portfolioTradeJournalRealizedPnl(String value) {
    return 'Реализованный P&L: $value';
  }

  @override
  String get cloudSyncTitle => 'Cloud sync';

  @override
  String get cloudSyncSubtitle =>
      'Синхронизация через JSON-файл · Google Drive, Telegram, почта';

  @override
  String get cloudSyncStatusSynced => 'Данные синхронизированы';

  @override
  String get cloudSyncStatusPending =>
      'Есть локальные изменения — отправьте sync';

  @override
  String get cloudSyncStatusNever => 'Синхронизация ещё не выполнялась';

  @override
  String cloudSyncLastOut(String date) {
    return 'Отправлено: $date';
  }

  @override
  String cloudSyncLastIn(String date) {
    return 'Загружено: $date';
  }

  @override
  String get cloudSyncExport => 'Отправить';

  @override
  String get cloudSyncImport => 'Загрузить';

  @override
  String get cloudSyncExportDone => 'Файл sync готов — сохраните в облако';

  @override
  String cloudSyncImportSuccess(int count) {
    return 'Загружено $count ключей данных';
  }

  @override
  String get cloudSyncImportNotNewer =>
      'Файл не новее текущих данных на устройстве';

  @override
  String get cloudSyncShareSubject => 'EcoPulse sync';

  @override
  String cloudSyncError(String message) {
    return 'Ошибка sync: $message';
  }

  @override
  String get adminCrashReports => 'Отчёты об ошибках';

  @override
  String get assistantTitle => 'EcoPulse Assistant';

  @override
  String get assistantHint => 'Спросите о курсе, сводке или портфеле…';

  @override
  String get assistantThinking => 'Думаю…';

  @override
  String get assistantDisclaimer => 'Не является инвестиционной рекомендацией';

  @override
  String get assistantClearHistory => 'Очистить чат';

  @override
  String get assistantVoiceListen => 'Слушать';

  @override
  String get assistantSourceLocal => 'локально';

  @override
  String get assistantSourceCloud => 'Gemini';

  @override
  String get assistantQuickPrice => 'USD/RUB';

  @override
  String get assistantQuickBrief => 'Сводка';

  @override
  String get assistantQuickPortfolio => 'Портфель';

  @override
  String get assistantQuickExplain => 'Инфляция';

  @override
  String get assistantQuickPriceQuery => 'курс доллара';

  @override
  String get assistantQuickBriefQuery => 'что сегодня';

  @override
  String get assistantQuickPortfolioQuery => 'мой портфель';

  @override
  String get assistantQuickExplainQuery => 'что такое инфляция';

  @override
  String get settingsGeminiKey => 'Gemini API Key';

  @override
  String get courseLibraryTitle => 'Курсы';

  @override
  String get courseLibrarySubtitle =>
      'Обучение инвестированию и личным финансам';

  @override
  String get courseDisclaimer =>
      'Образовательные материалы EcoPulse. Не является инвестиционной рекомендацией.';

  @override
  String get courseHomeCardTitle => 'Курс инвестора';

  @override
  String courseChaptersCount(int count) {
    return '$count глав';
  }

  @override
  String courseReadMinutes(int minutes) {
    return '~$minutes мин чтения';
  }

  @override
  String courseProgressPercent(int percent) {
    return 'Пройдено $percent%';
  }

  @override
  String get courseStartReading => 'Читать';

  @override
  String get courseReadFromStart => 'С начала';

  @override
  String get courseContinue => 'Продолжить';

  @override
  String get courseTableOfContents => 'Оглавление';

  @override
  String courseChapterProgress(int current, int total) {
    return 'Глава $current из $total';
  }

  @override
  String get courseChapterDone => 'Прочитано';

  @override
  String get courseMarkRead => 'Отметить';

  @override
  String get courseMarkedRead => 'Глава отмечена как прочитанная';

  @override
  String get coursePrevChapter => 'Назад';

  @override
  String get courseNextChapter => 'Далее';

  @override
  String get courseFinish => 'Готово';

  @override
  String get homeSectionLearn => 'Курсы';

  @override
  String get assistantQuickCourse => 'Курс';

  @override
  String get assistantQuickCourseQuery => 'открой курс инвестирования';

  @override
  String coursePagesCount(int pages) {
    return '~$pages стр.';
  }

  @override
  String courseChapterShort(int current, int total) {
    return 'Гл. $current/$total';
  }

  @override
  String get courseReaderSettings => 'Настройки чтения';

  @override
  String get courseFontSize => 'Размер шрифта';

  @override
  String get courseReadingTheme => 'Тема';

  @override
  String get courseThemeSystem => 'Система';

  @override
  String get courseThemeSepia => 'Сепия';

  @override
  String get courseThemeDark => 'Тёмная';

  @override
  String get courseSearch => 'Поиск по книге';

  @override
  String get courseSearchHint => 'Ключевое слово…';

  @override
  String get courseSearchEmpty => 'Ничего не найдено';

  @override
  String get courseSearchClose => 'Закрыть';

  @override
  String courseQuizProgress(int current, int total) {
    return 'Вопрос $current из $total';
  }

  @override
  String get courseQuizNext => 'Ответить';

  @override
  String get courseQuizPassed => 'Отлично! Часть пройдена';

  @override
  String get courseQuizRetry => 'Нужно повторить';

  @override
  String courseQuizScore(int correct, int total) {
    return 'Правильных: $correct из $total';
  }

  @override
  String get courseQuizContinue => 'Продолжить чтение';

  @override
  String get courseQuizTryAgain => 'Пройти снова';

  @override
  String get homeServerTitle => 'Домашний сервер';

  @override
  String get homeServerSubtitle => 'ПК-бэкенд в LAN: Profile ID и чаты';

  @override
  String get homeServerUrlLabel => 'URL сервера';

  @override
  String get homeServerUrlHint => 'http://192.168.1.105:8081';

  @override
  String get homeServerIpHint => 'На ПК: ipconfig → IPv4 Wi‑Fi адаптера';

  @override
  String get homeServerCheckConnection => 'Проверить связь';

  @override
  String get homeServerStatusOnline => 'Онлайн';

  @override
  String get homeServerStatusOffline => 'Офлайн';

  @override
  String get homeServerStatusUnknown => 'Не проверено';

  @override
  String get homeServerLogin => 'Вход';

  @override
  String get homeServerRegister => 'Регистрация';

  @override
  String get homeServerLoginLabel => 'Логин';

  @override
  String get homeServerPasswordLabel => 'Пароль';

  @override
  String get homeServerProfileId => 'Profile ID';

  @override
  String get homeServerCopyProfileId => 'Копировать Profile ID';

  @override
  String get homeServerProfileIdCopied => 'Profile ID скопирован';

  @override
  String homeServerLoggedInAs(String login) {
    return 'Вход: $login';
  }

  @override
  String get homeServerLogout => 'Выйти';

  @override
  String get homeServerSwitchAccount => 'Сменить аккаунт';

  @override
  String get homeServerEnsureSelfChat => 'Создать чат «Себе»';

  @override
  String get homeServerSelfChatReady => 'Чат «Себе» готов';

  @override
  String get homeServerRegisterSuccess => 'Регистрация успешна';

  @override
  String get homeServerLoginSuccess => 'Вход выполнен';

  @override
  String get homeServerLoggedOut => 'Вы вышли';

  @override
  String get homeServerCreateTestAccount => 'Создать test2';

  @override
  String get homeServerTestAccountCreated =>
      'Аккаунт test2 создан (или уже есть)';

  @override
  String get homeServerErrorLoginTaken => 'Логин занят';

  @override
  String get homeServerErrorInvalidCredentials => 'Неверный логин или пароль';

  @override
  String get homeServerErrorLoginShort => 'Логин — минимум 3 символа';

  @override
  String get homeServerErrorPasswordShort => 'Пароль — минимум 4 символа';

  @override
  String get homeServerErrorUpgrade =>
      'Нужно обновить приложение для этого сервера';

  @override
  String get homeServerErrorNoUrl => 'Сначала укажите URL сервера';

  @override
  String get homeServerErrorNetwork => 'Сервер недоступен — Wi‑Fi и firewall';

  @override
  String get messagesTitle => 'Сообщения';

  @override
  String get messagesNewChat => 'Новый чат';

  @override
  String get messagesEmpty => 'Чатов пока нет';

  @override
  String get messagesNotConnected => 'Подключите домашний сервер в настройках';

  @override
  String get messagesSelfChat => 'Написать себе';

  @override
  String get messagesSearchHint => 'Поиск по логину или Profile ID';

  @override
  String get messagesSearchEmpty => 'Пользователи не найдены';

  @override
  String get messagesInputHint => 'Сообщение…';

  @override
  String get messagesThreadEmpty => 'Сообщений пока нет — напишите первое';

  @override
  String get profileIdLabel => 'Profile ID';

  @override
  String get profileIdHint => 'UUID с домашнего сервера — для начала чата';

  @override
  String get customizationSectionTitle => 'Кастомизация';

  @override
  String get customizationTitle => 'Кастомизация';

  @override
  String get customizationSubtitle =>
      'Тема, графики, главная и навигация в одном месте';

  @override
  String get customizationSettingsEntry => 'Все настройки оформления';

  @override
  String get customizationSettingsEntrySubtitle =>
      'Графики, тема, главная, навигация и виджеты';

  @override
  String get customizationPreview => 'Предпросмотр';

  @override
  String get customizationPreviewSample =>
      'Пример графика с текущими параметрами';

  @override
  String customizationPreviewTheme(String mode) {
    return 'Тема: $mode';
  }

  @override
  String customizationPreviewAccent(String color) {
    return 'Акцент: $color';
  }

  @override
  String get customizationResetSection => 'Сбросить секцию';

  @override
  String get customizationResetAll => 'Сбросить всё';

  @override
  String get customizationResetAllConfirm =>
      'Вернуть все настройки к заводским?';

  @override
  String get customizationSectionCharts => 'Графики';

  @override
  String get customizationSectionAppearance => 'Внешний вид';

  @override
  String get customizationSectionHome => 'Главная';

  @override
  String get customizationSectionNavigation => 'Навигация';

  @override
  String get customizationSectionMarkets => 'Рынки';

  @override
  String get customizationSectionPortfolio => 'Портфель';

  @override
  String get customizationSectionWidgets => 'Виджет';

  @override
  String get customizationSectionDataDisplay => 'Данные';

  @override
  String get customizationSectionAssistant => 'Ассистент';

  @override
  String get customizationChartDefaultType => 'Тип по умолчанию';

  @override
  String get customizationChartPeriod => 'Период';

  @override
  String get customizationChartHeight => 'Высота';

  @override
  String get customizationChartShowLegend => 'Легенда';

  @override
  String get customizationChartPreferCandles => 'Свечи, если доступны';

  @override
  String get customizationChartNormalizedCompare => 'Нормализация сравнения';

  @override
  String get customizationFontScale => 'Масштаб текста';

  @override
  String get customizationUiDensity => 'Плотность интерфейса';

  @override
  String get customizationCardStyle => 'Стиль карточек';

  @override
  String get customizationMotionReduced => 'Меньше анимаций';

  @override
  String get customizationAmoledPureBlack => 'Чистый чёрный (OLED)';

  @override
  String get customizationNavDefaultTab => 'Стартовая вкладка';

  @override
  String get customizationNavShowFab => 'Кнопка ассистента';

  @override
  String get customizationNavHideLabels => 'Скрыть подписи вкладок';

  @override
  String get customizationNavVisibleTabs => 'Видимые вкладки';

  @override
  String get customizationHomeNewsCount => 'Новостей на главной';

  @override
  String get customizationHomeSparklines => 'Спарклайны';

  @override
  String get customizationMarketsGroupStocks =>
      'Группировать акции по секторам';

  @override
  String get customizationMarketsHeatmap => 'Тепловая карта секторов';

  @override
  String get customizationMarketsCompactRows => 'Компактные строки';

  @override
  String get customizationPortfolioAllocation => 'Диаграмма аллокации';

  @override
  String get customizationPortfolioRealizedPnl => 'Реализованный P/L';

  @override
  String get customizationPortfolioJournal => 'Журнал сделок';

  @override
  String get customizationAssistantPreferCloud => 'Облачный AI (Gemini)';

  @override
  String get customizationAssistantQuickChips => 'Быстрые подсказки';

  @override
  String get customizationAssistantVoice => 'Голосовой ввод';

  @override
  String get customizationDataDecimalPlaces => 'Знаков после запятой';

  @override
  String get customizationDataLargeNumbers => 'Крупные числа';

  @override
  String get customizationDataShowCurrencyCode => 'Показывать код валюты';

  @override
  String get customizationData24HourTime => '24-часовой формат';
}
