import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'EcoPulse'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get tabHome;

  /// No description provided for @tabCurrency.
  ///
  /// In ru, this message translates to:
  /// **'Валюты'**
  String get tabCurrency;

  /// No description provided for @tabInflation.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция'**
  String get tabInflation;

  /// No description provided for @tabMarkets.
  ///
  /// In ru, this message translates to:
  /// **'Рынки'**
  String get tabMarkets;

  /// No description provided for @tabMessages.
  ///
  /// In ru, this message translates to:
  /// **'Сообщения'**
  String get tabMessages;

  /// No description provided for @tabSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get tabSettings;

  /// No description provided for @pinEnterCode.
  ///
  /// In ru, this message translates to:
  /// **'Введите код доступа'**
  String get pinEnterCode;

  /// No description provided for @pinWrongCode.
  ///
  /// In ru, this message translates to:
  /// **'Неверный код'**
  String get pinWrongCode;

  /// No description provided for @pinUseBiometric.
  ///
  /// In ru, this message translates to:
  /// **'Войти по биометрии'**
  String get pinUseBiometric;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguage;

  /// No description provided for @settingsDefaultTab.
  ///
  /// In ru, this message translates to:
  /// **'Стартовая вкладка'**
  String get settingsDefaultTab;

  /// No description provided for @settingsBiometric.
  ///
  /// In ru, this message translates to:
  /// **'Биометрия'**
  String get settingsBiometric;

  /// No description provided for @settingsBiometricSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Отпечаток или Face ID вместо PIN'**
  String get settingsBiometricSubtitle;

  /// No description provided for @shareQuote.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться'**
  String get shareQuote;

  /// No description provided for @copyQuote.
  ///
  /// In ru, this message translates to:
  /// **'Копировать'**
  String get copyQuote;

  /// No description provided for @copied.
  ///
  /// In ru, this message translates to:
  /// **'Скопировано'**
  String get copied;

  /// No description provided for @shareMessage.
  ///
  /// In ru, this message translates to:
  /// **'{title}: {value}'**
  String shareMessage(String title, String value);

  /// No description provided for @alertsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ценовые алерты'**
  String get alertsTitle;

  /// No description provided for @alertsAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить алерт'**
  String get alertsAdd;

  /// No description provided for @alertsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет алертов. Например: USD/RUB выше 90 ₽'**
  String get alertsEmpty;

  /// No description provided for @alertsSymbol.
  ///
  /// In ru, this message translates to:
  /// **'Инструмент'**
  String get alertsSymbol;

  /// No description provided for @alertsThreshold.
  ///
  /// In ru, this message translates to:
  /// **'Порог'**
  String get alertsThreshold;

  /// No description provided for @alertsSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get alertsSave;

  /// No description provided for @alertsCheckOnRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Проверка при обновлении данных'**
  String get alertsCheckOnRefresh;

  /// No description provided for @alertsSettingsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'USD/RUB, BTC и другие — push в фоне и при обновлении'**
  String get alertsSettingsSubtitle;

  /// No description provided for @alertsLastTriggered.
  ///
  /// In ru, this message translates to:
  /// **'Срабатывание: {time}'**
  String alertsLastTriggered(String time);

  /// No description provided for @alertAction.
  ///
  /// In ru, this message translates to:
  /// **'Создать алерт'**
  String get alertAction;

  /// No description provided for @homePulseTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пульс экономики'**
  String get homePulseTitle;

  /// No description provided for @homePulseSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Ключевые показатели в реальном времени'**
  String get homePulseSubtitle;

  /// No description provided for @homeUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено: {time}'**
  String homeUpdated(String time);

  /// No description provided for @sectionCurrencies.
  ///
  /// In ru, this message translates to:
  /// **'Валюты'**
  String get sectionCurrencies;

  /// No description provided for @sectionKeyRate.
  ///
  /// In ru, this message translates to:
  /// **'Ставка ЦБ РФ'**
  String get sectionKeyRate;

  /// No description provided for @sectionInflation.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция'**
  String get sectionInflation;

  /// No description provided for @sectionCommodities.
  ///
  /// In ru, this message translates to:
  /// **'Сырьё'**
  String get sectionCommodities;

  /// No description provided for @sectionMarkets.
  ///
  /// In ru, this message translates to:
  /// **'Рынки'**
  String get sectionMarkets;

  /// No description provided for @sectionWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get sectionWatchlist;

  /// No description provided for @actionAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get actionAll;

  /// No description provided for @actionMarkets.
  ///
  /// In ru, this message translates to:
  /// **'Рынки'**
  String get actionMarkets;

  /// No description provided for @actionCalculators.
  ///
  /// In ru, this message translates to:
  /// **'Калькуляторы'**
  String get actionCalculators;

  /// No description provided for @chartTitle.
  ///
  /// In ru, this message translates to:
  /// **'График'**
  String get chartTitle;

  /// No description provided for @chartLine.
  ///
  /// In ru, this message translates to:
  /// **'Линия'**
  String get chartLine;

  /// No description provided for @chartCandles.
  ///
  /// In ru, this message translates to:
  /// **'Свечи'**
  String get chartCandles;

  /// No description provided for @shareChart.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться графиком'**
  String get shareChart;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @errorGeneric.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка: {message}'**
  String errorGeneric(String message);

  /// No description provided for @assetType.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get assetType;

  /// No description provided for @assetCurrency.
  ///
  /// In ru, this message translates to:
  /// **'Валюта'**
  String get assetCurrency;

  /// No description provided for @assetSource.
  ///
  /// In ru, this message translates to:
  /// **'Источник'**
  String get assetSource;

  /// No description provided for @assetTypeCrypto.
  ///
  /// In ru, this message translates to:
  /// **'Криптовалюта'**
  String get assetTypeCrypto;

  /// No description provided for @assetTypeStockRu.
  ///
  /// In ru, this message translates to:
  /// **'Акция (MOEX)'**
  String get assetTypeStockRu;

  /// No description provided for @assetTypeStockUs.
  ///
  /// In ru, this message translates to:
  /// **'Акция (US)'**
  String get assetTypeStockUs;

  /// No description provided for @settingsCompactHome.
  ///
  /// In ru, this message translates to:
  /// **'Компактная главная'**
  String get settingsCompactHome;

  /// No description provided for @settingsCompactHomeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Плотная сетка 2×2, меньше отступов'**
  String get settingsCompactHomeSubtitle;

  /// No description provided for @currencyLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка загрузки'**
  String get currencyLoadError;

  /// No description provided for @currencyChart30d.
  ///
  /// In ru, this message translates to:
  /// **'График {pair} (30 дней)'**
  String currencyChart30d(String pair);

  /// No description provided for @currencyConverter.
  ///
  /// In ru, this message translates to:
  /// **'Конвертер'**
  String get currencyConverter;

  /// No description provided for @currencyAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сумма'**
  String get currencyAmount;

  /// No description provided for @currencyFrom.
  ///
  /// In ru, this message translates to:
  /// **'Из'**
  String get currencyFrom;

  /// No description provided for @currencyTo.
  ///
  /// In ru, this message translates to:
  /// **'В'**
  String get currencyTo;

  /// No description provided for @currencyFee.
  ///
  /// In ru, this message translates to:
  /// **'Комиссия обмена'**
  String get currencyFee;

  /// No description provided for @currencyQuickConvert.
  ///
  /// In ru, this message translates to:
  /// **'Быстрая конвертация'**
  String get currencyQuickConvert;

  /// No description provided for @currencyQuickHint.
  ///
  /// In ru, this message translates to:
  /// **'100 USD в EUR'**
  String get currencyQuickHint;

  /// No description provided for @currencyQuickFormatError.
  ///
  /// In ru, this message translates to:
  /// **'Формат: 100 USD в EUR'**
  String get currencyQuickFormatError;

  /// No description provided for @currencyHistory.
  ///
  /// In ru, this message translates to:
  /// **'История конвертаций'**
  String get currencyHistory;

  /// No description provided for @currencyUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка загрузки · нажмите обновить'**
  String get currencyUnavailable;

  /// No description provided for @marketsSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск BTC, SBER, AAPL…'**
  String get marketsSearchHint;

  /// No description provided for @marketsTabCrypto.
  ///
  /// In ru, this message translates to:
  /// **'Крипто'**
  String get marketsTabCrypto;

  /// No description provided for @marketsTabStocks.
  ///
  /// In ru, this message translates to:
  /// **'Акции'**
  String get marketsTabStocks;

  /// No description provided for @marketsTabBonds.
  ///
  /// In ru, this message translates to:
  /// **'Облигации'**
  String get marketsTabBonds;

  /// No description provided for @assetTypeBondRu.
  ///
  /// In ru, this message translates to:
  /// **'Облигация (MOEX)'**
  String get assetTypeBondRu;

  /// No description provided for @marketsFilterOfz.
  ///
  /// In ru, this message translates to:
  /// **'ОФЗ'**
  String get marketsFilterOfz;

  /// No description provided for @marketsFilterCorporateBonds.
  ///
  /// In ru, this message translates to:
  /// **'Корп.'**
  String get marketsFilterCorporateBonds;

  /// No description provided for @bondCategoryOfz.
  ///
  /// In ru, this message translates to:
  /// **'ОФЗ — федеральные'**
  String get bondCategoryOfz;

  /// No description provided for @bondCategoryCorporate.
  ///
  /// In ru, this message translates to:
  /// **'Корпоративные'**
  String get bondCategoryCorporate;

  /// No description provided for @bondYieldLabel.
  ///
  /// In ru, this message translates to:
  /// **'Доходность'**
  String get bondYieldLabel;

  /// No description provided for @bondCouponLabel.
  ///
  /// In ru, this message translates to:
  /// **'Купон'**
  String get bondCouponLabel;

  /// No description provided for @bondMaturityLabel.
  ///
  /// In ru, this message translates to:
  /// **'Погашение'**
  String get bondMaturityLabel;

  /// No description provided for @bondFaceValueLabel.
  ///
  /// In ru, this message translates to:
  /// **'Номинал'**
  String get bondFaceValueLabel;

  /// No description provided for @marketsBondCatalogCounts.
  ///
  /// In ru, this message translates to:
  /// **'Каталог: {count} облигаций · MOEX ISS'**
  String marketsBondCatalogCounts(int count);

  /// No description provided for @bondYieldCurveTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кривая доходности ОФЗ'**
  String get bondYieldCurveTitle;

  /// No description provided for @bondYieldCurveSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'YTM × срок до погашения · MOEX ISS'**
  String get bondYieldCurveSubtitle;

  /// No description provided for @bondYieldCurveTapHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите для полноэкранного графика'**
  String get bondYieldCurveTapHint;

  /// No description provided for @bondYieldCurveEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно данных ОФЗ для кривой'**
  String get bondYieldCurveEmpty;

  /// No description provided for @bondYieldCurveTableTitle.
  ///
  /// In ru, this message translates to:
  /// **'Точки кривой'**
  String get bondYieldCurveTableTitle;

  /// No description provided for @bondYieldCurveOpen.
  ///
  /// In ru, this message translates to:
  /// **'Кривая доходности'**
  String get bondYieldCurveOpen;

  /// No description provided for @bondYieldSpreadLabel.
  ///
  /// In ru, this message translates to:
  /// **'Спред длинный–короткий'**
  String get bondYieldSpreadLabel;

  /// No description provided for @bondYieldSpreadValue.
  ///
  /// In ru, this message translates to:
  /// **'+{spread} п.п.'**
  String bondYieldSpreadValue(String spread);

  /// No description provided for @bondYearsShort.
  ///
  /// In ru, this message translates to:
  /// **'л'**
  String get bondYearsShort;

  /// No description provided for @bondLadderTitle.
  ///
  /// In ru, this message translates to:
  /// **'Лестница ОФЗ'**
  String get bondLadderTitle;

  /// No description provided for @bondLadderSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'По годам погашения · доходность к погашению'**
  String get bondLadderSubtitle;

  /// No description provided for @bondLadderTapHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите для полного экрана'**
  String get bondLadderTapHint;

  /// No description provided for @bondLadderFullSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'{ofzCount} ОФЗ · {yearCount} лет погашения'**
  String bondLadderFullSubtitle(int ofzCount, int yearCount);

  /// No description provided for @bondLadderYearHeader.
  ///
  /// In ru, this message translates to:
  /// **'{year} · {count}'**
  String bondLadderYearHeader(int year, int count);

  /// No description provided for @bondLadderMoreYears.
  ///
  /// In ru, this message translates to:
  /// **'Ещё {count} {count, plural, one{год} few{года} other{лет}}'**
  String bondLadderMoreYears(int count);

  /// No description provided for @bondYieldCurveCrosshairHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите на точку кривой'**
  String get bondYieldCurveCrosshairHint;

  /// No description provided for @bondYieldCurveZoomHint.
  ///
  /// In ru, this message translates to:
  /// **'Колёсико или pinch для масштаба · двойной тап — сброс'**
  String get bondYieldCurveZoomHint;

  /// No description provided for @bondYieldCurveZoomActive.
  ///
  /// In ru, this message translates to:
  /// **'Масштаб ×{zoom} · двойной тап — сброс'**
  String bondYieldCurveZoomActive(String zoom);

  /// No description provided for @bondCalendarTitle.
  ///
  /// In ru, this message translates to:
  /// **'Календарь облигаций'**
  String get bondCalendarTitle;

  /// No description provided for @bondCalendarSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Избранное и портфель · купоны MOEX или оценка'**
  String get bondCalendarSubtitle;

  /// No description provided for @bondCalendarTapHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите для полного календаря'**
  String get bondCalendarTapHint;

  /// No description provided for @bondCalendarFullSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Избранное и бумажный портфель · купоны и погашения'**
  String get bondCalendarFullSubtitle;

  /// No description provided for @bondCalendarHorizon6m.
  ///
  /// In ru, this message translates to:
  /// **'6 мес.'**
  String get bondCalendarHorizon6m;

  /// No description provided for @bondCalendarHorizon1y.
  ///
  /// In ru, this message translates to:
  /// **'1 год'**
  String get bondCalendarHorizon1y;

  /// No description provided for @bondCalendarHorizon2y.
  ///
  /// In ru, this message translates to:
  /// **'2 года'**
  String get bondCalendarHorizon2y;

  /// No description provided for @bondCalendarCouponIncome.
  ///
  /// In ru, this message translates to:
  /// **'Купоны портфеля (оценка)'**
  String get bondCalendarCouponIncome;

  /// No description provided for @bondCalendarCouponIncomeHint.
  ///
  /// In ru, this message translates to:
  /// **'MOEX COUPONVALUE × количество'**
  String get bondCalendarCouponIncomeHint;

  /// No description provided for @bondCalendarEmptyTracked.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте облигации в избранное или портфель'**
  String get bondCalendarEmptyTracked;

  /// No description provided for @bondCalendarEmptyEvents.
  ///
  /// In ru, this message translates to:
  /// **'Нет событий в выбранном горизонте'**
  String get bondCalendarEmptyEvents;

  /// No description provided for @bondCalendarMoreEvents.
  ///
  /// In ru, this message translates to:
  /// **'Ещё {count} событий'**
  String bondCalendarMoreEvents(int count);

  /// No description provided for @bondEventMaturity.
  ///
  /// In ru, this message translates to:
  /// **'Погашение'**
  String get bondEventMaturity;

  /// No description provided for @bondEventCouponRub.
  ///
  /// In ru, this message translates to:
  /// **'Купон {amount} ₽'**
  String bondEventCouponRub(String amount);

  /// No description provided for @bondEventCouponPercent.
  ///
  /// In ru, this message translates to:
  /// **'Купон {rate}%'**
  String bondEventCouponPercent(String rate);

  /// No description provided for @bondEventCouponEstimate.
  ///
  /// In ru, this message translates to:
  /// **'Купон ~{rate}% (оценка)'**
  String bondEventCouponEstimate(String rate);

  /// No description provided for @bondNextCouponLabel.
  ///
  /// In ru, this message translates to:
  /// **'Ближайший купон'**
  String get bondNextCouponLabel;

  /// No description provided for @bondCouponValueLabel.
  ///
  /// In ru, this message translates to:
  /// **'Размер купона'**
  String get bondCouponValueLabel;

  /// No description provided for @bondHomeCardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Облигации ОФЗ'**
  String get bondHomeCardTitle;

  /// No description provided for @bondHomeCardSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Средняя доходность и спред · MOEX ISS'**
  String get bondHomeCardSubtitle;

  /// No description provided for @bondHomeUpcomingEvents.
  ///
  /// In ru, this message translates to:
  /// **'Ближайшие события: {count}'**
  String bondHomeUpcomingEvents(int count);

  /// No description provided for @bondCalendarOpen.
  ///
  /// In ru, this message translates to:
  /// **'Календарь'**
  String get bondCalendarOpen;

  /// No description provided for @bondHomeAvgYield.
  ///
  /// In ru, this message translates to:
  /// **'Средняя YTM'**
  String get bondHomeAvgYield;

  /// No description provided for @bondHomeTopYield.
  ///
  /// In ru, this message translates to:
  /// **'Макс. доходность'**
  String get bondHomeTopYield;

  /// No description provided for @marketsFavorites.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get marketsFavorites;

  /// No description provided for @marketsEmptyFavoritesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Нет избранных активов'**
  String get marketsEmptyFavoritesTitle;

  /// No description provided for @marketsEmptySearchTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get marketsEmptySearchTitle;

  /// No description provided for @marketsEmptyFavoritesSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите ★ на активе, чтобы добавить в избранное'**
  String get marketsEmptyFavoritesSubtitle;

  /// No description provided for @marketsEmptySearchSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте другой запрос или сбросьте фильтр'**
  String get marketsEmptySearchSubtitle;

  /// No description provided for @marketsAllAssets.
  ///
  /// In ru, this message translates to:
  /// **'Все активы'**
  String get marketsAllAssets;

  /// No description provided for @marketsRemovedFromWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'{symbol} удалён из избранного'**
  String marketsRemovedFromWatchlist(String symbol);

  /// No description provided for @undo.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get undo;

  /// No description provided for @inflationTabCountries.
  ///
  /// In ru, this message translates to:
  /// **'Страны'**
  String get inflationTabCountries;

  /// No description provided for @inflationTabCalculator.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция'**
  String get inflationTabCalculator;

  /// No description provided for @inflationTabFinance.
  ///
  /// In ru, this message translates to:
  /// **'Финансы'**
  String get inflationTabFinance;

  /// No description provided for @inflationCpiTitle.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция (CPI), год к году'**
  String get inflationCpiTitle;

  /// No description provided for @inflationWorldBankNote.
  ///
  /// In ru, this message translates to:
  /// **'Данные World Bank · последний доступный год'**
  String get inflationWorldBankNote;

  /// No description provided for @inflationCalcTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сколько стоят деньги сегодня?'**
  String get inflationCalcTitle;

  /// No description provided for @inflationCalcSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Учитывает накопленную инфляцию по данным World Bank'**
  String get inflationCalcSubtitle;

  /// No description provided for @inflationCountry.
  ///
  /// In ru, this message translates to:
  /// **'Страна'**
  String get inflationCountry;

  /// No description provided for @inflationAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сумма'**
  String get inflationAmount;

  /// No description provided for @inflationYear.
  ///
  /// In ru, this message translates to:
  /// **'Год'**
  String get inflationYear;

  /// No description provided for @inflationYoy.
  ///
  /// In ru, this message translates to:
  /// **'год к году'**
  String get inflationYoy;

  /// No description provided for @inflationUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Данные временно недоступны'**
  String get inflationUnavailable;

  /// No description provided for @purchasingPower.
  ///
  /// In ru, this message translates to:
  /// **'{base} в {year} ≈ {today} сегодня'**
  String purchasingPower(String base, int year, String today);

  /// No description provided for @chartInsufficientData.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно данных для графика'**
  String get chartInsufficientData;

  /// No description provided for @chartInsufficientCandles.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно данных для свечей'**
  String get chartInsufficientCandles;

  /// No description provided for @dataUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Данные временно недоступны'**
  String get dataUnavailable;

  /// No description provided for @settingsThemeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeAuto.
  ///
  /// In ru, this message translates to:
  /// **'Авто'**
  String get settingsThemeAuto;

  /// No description provided for @settingsThemeOled.
  ///
  /// In ru, this message translates to:
  /// **'OLED'**
  String get settingsThemeOled;

  /// No description provided for @settingsThemeDim.
  ///
  /// In ru, this message translates to:
  /// **'Приглуш.'**
  String get settingsThemeDim;

  /// No description provided for @settingsThemeSepia.
  ///
  /// In ru, this message translates to:
  /// **'Сепия'**
  String get settingsThemeSepia;

  /// No description provided for @settingsThemeContrast.
  ///
  /// In ru, this message translates to:
  /// **'Контраст'**
  String get settingsThemeContrast;

  /// No description provided for @settingsAccentColor.
  ///
  /// In ru, this message translates to:
  /// **'Акцентный цвет'**
  String get settingsAccentColor;

  /// No description provided for @settingsThemeCurrent.
  ///
  /// In ru, this message translates to:
  /// **'Текущая: {mode}'**
  String settingsThemeCurrent(String mode);

  /// No description provided for @sectorHeatmapTitle.
  ///
  /// In ru, this message translates to:
  /// **'Секторы MOEX'**
  String get sectorHeatmapTitle;

  /// No description provided for @sectorHeatmapSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Среднее изменение за 7 дней по секторам'**
  String get sectorHeatmapSubtitle;

  /// No description provided for @sectorFinance.
  ///
  /// In ru, this message translates to:
  /// **'Финансы'**
  String get sectorFinance;

  /// No description provided for @sectorEnergy.
  ///
  /// In ru, this message translates to:
  /// **'Энергетика'**
  String get sectorEnergy;

  /// No description provided for @sectorIt.
  ///
  /// In ru, this message translates to:
  /// **'IT'**
  String get sectorIt;

  /// No description provided for @sectorIndex.
  ///
  /// In ru, this message translates to:
  /// **'Индекс'**
  String get sectorIndex;

  /// No description provided for @dataStatusFresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено: {time}'**
  String dataStatusFresh(String time);

  /// No description provided for @dataStatusLive.
  ///
  /// In ru, this message translates to:
  /// **'Данные актуальны'**
  String get dataStatusLive;

  /// No description provided for @dataStatusCache.
  ///
  /// In ru, this message translates to:
  /// **'Кэш · {age}'**
  String dataStatusCache(String age);

  /// No description provided for @dataStatusCacheUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Кэш · данные устарели'**
  String get dataStatusCacheUnknown;

  /// No description provided for @dataStatusOffline.
  ///
  /// In ru, this message translates to:
  /// **'Offline · кэш {age}'**
  String dataStatusOffline(String age);

  /// No description provided for @dataStatusOfflineUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Offline · сохранённые данные'**
  String get dataStatusOfflineUnknown;

  /// No description provided for @alertsCheckBackground.
  ///
  /// In ru, this message translates to:
  /// **'Проверка каждые 15 мин в фоне + при обновлении'**
  String get alertsCheckBackground;

  /// No description provided for @currencyCompareTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сравнение курсов'**
  String get currencyCompareTitle;

  /// No description provided for @currencyCompareSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Индекс 100 в начале периода — до 3 пар'**
  String get currencyCompareSubtitle;

  /// No description provided for @currencyCompareSelect.
  ///
  /// In ru, this message translates to:
  /// **'Выберите ещё одну пару для сравнения'**
  String get currencyCompareSelect;

  /// No description provided for @assetPreviewOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть график'**
  String get assetPreviewOpen;

  /// No description provided for @assetPreviewAddWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'В избранное'**
  String get assetPreviewAddWatchlist;

  /// No description provided for @assetPreviewRemoveWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'Убрать из избранного'**
  String get assetPreviewRemoveWatchlist;

  /// No description provided for @inflationCompareTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сравнение стран'**
  String get inflationCompareTitle;

  /// No description provided for @inflationCompareSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'CPI год к году — до 3 стран на одном графике'**
  String get inflationCompareSubtitle;

  /// No description provided for @inflationCompareSelect.
  ///
  /// In ru, this message translates to:
  /// **'Выберите ещё одну страну для сравнения'**
  String get inflationCompareSelect;

  /// No description provided for @settingsHomeWidget.
  ///
  /// In ru, this message translates to:
  /// **'Виджет Android'**
  String get settingsHomeWidget;

  /// No description provided for @settingsHomeWidgetSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'USD/RUB и BTC на домашнем экране — обновляется при refresh'**
  String get settingsHomeWidgetSubtitle;

  /// No description provided for @keyRateDetailTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ключевая ставка ЦБ'**
  String get keyRateDetailTitle;

  /// No description provided for @keyRateUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено: {date}'**
  String keyRateUpdated(String date);

  /// No description provided for @keyRateEventsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Изменения ставки'**
  String get keyRateEventsTitle;

  /// No description provided for @keyRateEventsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'За период изменений не было'**
  String get keyRateEventsEmpty;

  /// No description provided for @keyRateEventChange.
  ///
  /// In ru, this message translates to:
  /// **'{date} → {rate}'**
  String keyRateEventChange(String date, String rate);

  /// No description provided for @keyRateSince.
  ///
  /// In ru, this message translates to:
  /// **'с {day}.{month}.{year}'**
  String keyRateSince(int day, int month, int year);

  /// No description provided for @sourceCbr.
  ///
  /// In ru, this message translates to:
  /// **'ЦБ РФ'**
  String get sourceCbr;

  /// No description provided for @onboardingSkip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get onboardingStart;

  /// No description provided for @onboarding1Title.
  ///
  /// In ru, this message translates to:
  /// **'Валюты и курсы'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In ru, this message translates to:
  /// **'USD/RUB, EUR/RUB и мировые валюты в реальном времени с MOEX и Frankfurter'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция и ставка ЦБ'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In ru, this message translates to:
  /// **'Данные World Bank, ключевая ставка ЦБ РФ и финансовые калькуляторы'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In ru, this message translates to:
  /// **'Рынки и избранное'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In ru, this message translates to:
  /// **'Криптовалюты, акции MOEX, графики и watchlist — всё в одном месте'**
  String get onboarding3Subtitle;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsAppTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тема приложения'**
  String get settingsAppTheme;

  /// No description provided for @settingsAppBackground.
  ///
  /// In ru, this message translates to:
  /// **'Фон приложения'**
  String get settingsAppBackground;

  /// No description provided for @settingsBackgroundSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Градиент как в банковских приложениях'**
  String get settingsBackgroundSubtitle;

  /// No description provided for @settingsSectionSecurity.
  ///
  /// In ru, this message translates to:
  /// **'Безопасность'**
  String get settingsSectionSecurity;

  /// No description provided for @settingsPinCode.
  ///
  /// In ru, this message translates to:
  /// **'Код доступа'**
  String get settingsPinCode;

  /// No description provided for @settingsPinEnabled.
  ///
  /// In ru, this message translates to:
  /// **'Приложение защищено · 4 цифры'**
  String get settingsPinEnabled;

  /// No description provided for @settingsPinDisabled.
  ///
  /// In ru, this message translates to:
  /// **'PIN не включён'**
  String get settingsPinDisabled;

  /// No description provided for @settingsChangePin.
  ///
  /// In ru, this message translates to:
  /// **'Сменить код'**
  String get settingsChangePin;

  /// No description provided for @settingsLockNow.
  ///
  /// In ru, this message translates to:
  /// **'Заблокировать сейчас'**
  String get settingsLockNow;

  /// No description provided for @settingsLockedSnack.
  ///
  /// In ru, this message translates to:
  /// **'Приложение заблокировано'**
  String get settingsLockedSnack;

  /// No description provided for @settingsSectionDisplay.
  ///
  /// In ru, this message translates to:
  /// **'Отображение'**
  String get settingsSectionDisplay;

  /// No description provided for @settingsBaseCurrency.
  ///
  /// In ru, this message translates to:
  /// **'Базовая валюта'**
  String get settingsBaseCurrency;

  /// No description provided for @settingsKeysLocalNote.
  ///
  /// In ru, this message translates to:
  /// **'Ключи сохраняются локально — пересборка не нужна'**
  String get settingsKeysLocalNote;

  /// No description provided for @settingsSectionDataApi.
  ///
  /// In ru, this message translates to:
  /// **'Данные и API'**
  String get settingsSectionDataApi;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get settingsSectionAbout;

  /// No description provided for @settingsAboutDescription.
  ///
  /// In ru, this message translates to:
  /// **'Экономический дашборд с валютами, инфляцией, криптовалютами и биржевыми котировками.'**
  String get settingsAboutDescription;

  /// No description provided for @settingsAboutDesign.
  ///
  /// In ru, this message translates to:
  /// **'Дизайн: Material 3 · fl_chart · flutter_animate'**
  String get settingsAboutDesign;

  /// No description provided for @settingsAboutDeveloper.
  ///
  /// In ru, this message translates to:
  /// **'Разработал Цымбал Евгений Владиславович'**
  String get settingsAboutDeveloper;

  /// No description provided for @sourceFrankfurter.
  ///
  /// In ru, this message translates to:
  /// **'Frankfurter'**
  String get sourceFrankfurter;

  /// No description provided for @sourceFrankfurterSub.
  ///
  /// In ru, this message translates to:
  /// **'Международные валюты'**
  String get sourceFrankfurterSub;

  /// No description provided for @sourceMoex.
  ///
  /// In ru, this message translates to:
  /// **'MOEX ISS'**
  String get sourceMoex;

  /// No description provided for @sourceMoexSub.
  ///
  /// In ru, this message translates to:
  /// **'Валюты и акции РФ'**
  String get sourceMoexSub;

  /// No description provided for @sourceCbrSub.
  ///
  /// In ru, this message translates to:
  /// **'Ключевая ставка'**
  String get sourceCbrSub;

  /// No description provided for @sourceWorldBank.
  ///
  /// In ru, this message translates to:
  /// **'World Bank'**
  String get sourceWorldBank;

  /// No description provided for @sourceWorldBankSub.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция CPI'**
  String get sourceWorldBankSub;

  /// No description provided for @sourceCoingecko.
  ///
  /// In ru, this message translates to:
  /// **'CoinGecko'**
  String get sourceCoingecko;

  /// No description provided for @sourceCoingeckoSub.
  ///
  /// In ru, this message translates to:
  /// **'Криптовалюты'**
  String get sourceCoingeckoSub;

  /// No description provided for @sourceFinnhub.
  ///
  /// In ru, this message translates to:
  /// **'Finnhub'**
  String get sourceFinnhub;

  /// No description provided for @sourceFinnhubSub.
  ///
  /// In ru, this message translates to:
  /// **'Акции США'**
  String get sourceFinnhubSub;

  /// No description provided for @sourceCommodities.
  ///
  /// In ru, this message translates to:
  /// **'MOEX ISS'**
  String get sourceCommodities;

  /// No description provided for @sourceCommoditiesSub.
  ///
  /// In ru, this message translates to:
  /// **'Сырьё'**
  String get sourceCommoditiesSub;

  /// No description provided for @statusActive.
  ///
  /// In ru, this message translates to:
  /// **'Активен'**
  String get statusActive;

  /// No description provided for @statusKeyOk.
  ///
  /// In ru, this message translates to:
  /// **'Ключ OK'**
  String get statusKeyOk;

  /// No description provided for @statusNoKey.
  ///
  /// In ru, this message translates to:
  /// **'Без ключа'**
  String get statusNoKey;

  /// No description provided for @statusNotConfigured.
  ///
  /// In ru, this message translates to:
  /// **'Не настроен'**
  String get statusNotConfigured;

  /// No description provided for @inflationRateVsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ставка ЦБ vs инфляция'**
  String get inflationRateVsTitle;

  /// No description provided for @inflationRateVsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Средняя ключевая ставка и CPI РФ по годам'**
  String get inflationRateVsSubtitle;

  /// No description provided for @inflationRateVsKeyRate.
  ///
  /// In ru, this message translates to:
  /// **'Ставка ЦБ'**
  String get inflationRateVsKeyRate;

  /// No description provided for @inflationRateVsCpi.
  ///
  /// In ru, this message translates to:
  /// **'CPI inflation'**
  String get inflationRateVsCpi;

  /// No description provided for @correlationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Корреляция активов'**
  String get correlationTitle;

  /// No description provided for @correlationSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Дневные доходности за {days} дней (Пирсон)'**
  String correlationSubtitle(int days);

  /// No description provided for @correlationChartTitle.
  ///
  /// In ru, this message translates to:
  /// **'Динамика (индекс 100)'**
  String get correlationChartTitle;

  /// No description provided for @correlationNote.
  ///
  /// In ru, this message translates to:
  /// **'1 — полная синхронность, −1 — обратная, 0 — нет связи'**
  String get correlationNote;

  /// No description provided for @correlationBtc.
  ///
  /// In ru, this message translates to:
  /// **'BTC'**
  String get correlationBtc;

  /// No description provided for @correlationUsdRub.
  ///
  /// In ru, this message translates to:
  /// **'USD/RUB'**
  String get correlationUsdRub;

  /// No description provided for @correlationImoex.
  ///
  /// In ru, this message translates to:
  /// **'IMOEX'**
  String get correlationImoex;

  /// No description provided for @sectorMetals.
  ///
  /// In ru, this message translates to:
  /// **'Металлы'**
  String get sectorMetals;

  /// No description provided for @sectorTelecom.
  ///
  /// In ru, this message translates to:
  /// **'Телеком'**
  String get sectorTelecom;

  /// No description provided for @sectorConsumer.
  ///
  /// In ru, this message translates to:
  /// **'Потребительский'**
  String get sectorConsumer;

  /// No description provided for @sectorTransport.
  ///
  /// In ru, this message translates to:
  /// **'Транспорт'**
  String get sectorTransport;

  /// No description provided for @sectorRealestate.
  ///
  /// In ru, this message translates to:
  /// **'Недвижимость'**
  String get sectorRealestate;

  /// No description provided for @sectorChemicals.
  ///
  /// In ru, this message translates to:
  /// **'Химия'**
  String get sectorChemicals;

  /// No description provided for @sectorEtf.
  ///
  /// In ru, this message translates to:
  /// **'ETF'**
  String get sectorEtf;

  /// No description provided for @sectorTech.
  ///
  /// In ru, this message translates to:
  /// **'Технологии'**
  String get sectorTech;

  /// No description provided for @sectorAuto.
  ///
  /// In ru, this message translates to:
  /// **'Авто'**
  String get sectorAuto;

  /// No description provided for @sectorHealth.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье'**
  String get sectorHealth;

  /// No description provided for @sectorMedia.
  ///
  /// In ru, this message translates to:
  /// **'Медиа'**
  String get sectorMedia;

  /// No description provided for @sectorIndustrial.
  ///
  /// In ru, this message translates to:
  /// **'Промышленность'**
  String get sectorIndustrial;

  /// No description provided for @sectorUs.
  ///
  /// In ru, this message translates to:
  /// **'США'**
  String get sectorUs;

  /// No description provided for @sectorOther.
  ///
  /// In ru, this message translates to:
  /// **'Прочее'**
  String get sectorOther;

  /// No description provided for @marketsFilterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get marketsFilterAll;

  /// No description provided for @marketsFilterMoex.
  ///
  /// In ru, this message translates to:
  /// **'MOEX'**
  String get marketsFilterMoex;

  /// No description provided for @marketsFilterUs.
  ///
  /// In ru, this message translates to:
  /// **'NYSE/NASDAQ'**
  String get marketsFilterUs;

  /// No description provided for @marketsGroupBySector.
  ///
  /// In ru, this message translates to:
  /// **'По секторам'**
  String get marketsGroupBySector;

  /// No description provided for @marketsCatalogHint.
  ///
  /// In ru, this message translates to:
  /// **'50 MOEX · 45 US · 100 crypto · поиск по тикеру'**
  String get marketsCatalogHint;

  /// No description provided for @marketsCatalogCounts.
  ///
  /// In ru, this message translates to:
  /// **'{moex} MOEX · {us} US · {crypto} crypto · поиск'**
  String marketsCatalogCounts(int moex, int us, int crypto);

  /// No description provided for @currencyGroupMoex.
  ///
  /// In ru, this message translates to:
  /// **'MOEX · рубли'**
  String get currencyGroupMoex;

  /// No description provided for @currencyGroupMajor.
  ///
  /// In ru, this message translates to:
  /// **'Основные'**
  String get currencyGroupMajor;

  /// No description provided for @currencyGroupEurope.
  ///
  /// In ru, this message translates to:
  /// **'Европа'**
  String get currencyGroupEurope;

  /// No description provided for @currencyGroupAsia.
  ///
  /// In ru, this message translates to:
  /// **'Азия'**
  String get currencyGroupAsia;

  /// No description provided for @currencyGroupEm.
  ///
  /// In ru, this message translates to:
  /// **'Развивающиеся'**
  String get currencyGroupEm;

  /// No description provided for @currencyGroupAmericas.
  ///
  /// In ru, this message translates to:
  /// **'Америка и Океания'**
  String get currencyGroupAmericas;

  /// No description provided for @adminPanelTitle.
  ///
  /// In ru, this message translates to:
  /// **'Admin Panel'**
  String get adminPanelTitle;

  /// No description provided for @adminPanelSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Dev-инструменты: API, кэш, каталоги, feature flags'**
  String get adminPanelSubtitle;

  /// No description provided for @adminApiStatus.
  ///
  /// In ru, this message translates to:
  /// **'Статус API'**
  String get adminApiStatus;

  /// No description provided for @adminCache.
  ///
  /// In ru, this message translates to:
  /// **'Кэш'**
  String get adminCache;

  /// No description provided for @adminCatalog.
  ///
  /// In ru, this message translates to:
  /// **'Каталоги'**
  String get adminCatalog;

  /// No description provided for @adminFeatureFlags.
  ///
  /// In ru, this message translates to:
  /// **'Feature flags'**
  String get adminFeatureFlags;

  /// No description provided for @adminHttpLog.
  ///
  /// In ru, this message translates to:
  /// **'HTTP лог'**
  String get adminHttpLog;

  /// No description provided for @adminHttpLogEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Запросов пока нет'**
  String get adminHttpLogEmpty;

  /// No description provided for @adminRefreshAll.
  ///
  /// In ru, this message translates to:
  /// **'Обновить всё'**
  String get adminRefreshAll;

  /// No description provided for @adminReloadStatus.
  ///
  /// In ru, this message translates to:
  /// **'Перезагрузить статус'**
  String get adminReloadStatus;

  /// No description provided for @adminRefreshed.
  ///
  /// In ru, this message translates to:
  /// **'Данные обновлены'**
  String get adminRefreshed;

  /// No description provided for @adminFlagSectorHeatmap.
  ///
  /// In ru, this message translates to:
  /// **'Теплокарта секторов MOEX'**
  String get adminFlagSectorHeatmap;

  /// No description provided for @adminFlagStocksGrouped.
  ///
  /// In ru, this message translates to:
  /// **'Группировка акций по секторам'**
  String get adminFlagStocksGrouped;

  /// No description provided for @adminFlagVerboseHttp.
  ///
  /// In ru, this message translates to:
  /// **'Подробный HTTP лог'**
  String get adminFlagVerboseHttp;

  /// No description provided for @adminCacheEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пусто'**
  String get adminCacheEmpty;

  /// No description provided for @adminCacheFresh.
  ///
  /// In ru, this message translates to:
  /// **'Свежий'**
  String get adminCacheFresh;

  /// No description provided for @adminCacheStale.
  ///
  /// In ru, this message translates to:
  /// **'Устарел'**
  String get adminCacheStale;

  /// No description provided for @adminCacheAge.
  ///
  /// In ru, this message translates to:
  /// **'Возраст: {age}'**
  String adminCacheAge(String age);

  /// No description provided for @adminCacheItems.
  ///
  /// In ru, this message translates to:
  /// **'{count} записей'**
  String adminCacheItems(int count);

  /// No description provided for @adminCatalogMoex.
  ///
  /// In ru, this message translates to:
  /// **'MOEX'**
  String get adminCatalogMoex;

  /// No description provided for @adminCatalogUs.
  ///
  /// In ru, this message translates to:
  /// **'US'**
  String get adminCatalogUs;

  /// No description provided for @adminCatalogFx.
  ///
  /// In ru, this message translates to:
  /// **'FX'**
  String get adminCatalogFx;

  /// No description provided for @adminCatalogCrypto.
  ///
  /// In ru, this message translates to:
  /// **'Crypto'**
  String get adminCatalogCrypto;

  /// No description provided for @profileSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileSectionTitle;

  /// No description provided for @profileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// No description provided for @profileGuest.
  ///
  /// In ru, this message translates to:
  /// **'Гость · настройте профиль'**
  String get profileGuest;

  /// No description provided for @profileGreeting.
  ///
  /// In ru, this message translates to:
  /// **'Привет, {name}!'**
  String profileGreeting(String name);

  /// No description provided for @profileDisplayName.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get profileDisplayName;

  /// No description provided for @profileDisplayNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Как к вам обращаться'**
  String get profileDisplayNameHint;

  /// No description provided for @profileAvatarHint.
  ///
  /// In ru, this message translates to:
  /// **'Выберите аватар'**
  String get profileAvatarHint;

  /// No description provided for @profileCountry.
  ///
  /// In ru, this message translates to:
  /// **'Страна для инфляции'**
  String get profileCountry;

  /// No description provided for @profileCountryHint.
  ///
  /// In ru, this message translates to:
  /// **'Используется на вкладке «Страны»'**
  String get profileCountryHint;

  /// No description provided for @profileCountryLabel.
  ///
  /// In ru, this message translates to:
  /// **'Страна: {country}'**
  String profileCountryLabel(String country);

  /// No description provided for @profileSaved.
  ///
  /// In ru, this message translates to:
  /// **'Профиль сохранён'**
  String get profileSaved;

  /// No description provided for @profileSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get profileSave;

  /// No description provided for @backupSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Резервная копия'**
  String get backupSectionTitle;

  /// No description provided for @backupExportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт данных'**
  String get backupExportTitle;

  /// No description provided for @backupExportSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Watchlist, профиль, настройки, заметки — JSON'**
  String get backupExportSubtitle;

  /// No description provided for @backupImportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Импорт данных'**
  String get backupImportTitle;

  /// No description provided for @backupImportSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Вставьте JSON из экспорта'**
  String get backupImportSubtitle;

  /// No description provided for @backupImportHint.
  ///
  /// In ru, this message translates to:
  /// **'Вставьте JSON из экспорта EcoPulse'**
  String get backupImportHint;

  /// No description provided for @backupImportConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить'**
  String get backupImportConfirm;

  /// No description provided for @backupImportSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Восстановлено ключей: {count}'**
  String backupImportSuccess(int count);

  /// No description provided for @backupImportError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка импорта: {error}'**
  String backupImportError(String error);

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @assetNoteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get assetNoteTitle;

  /// No description provided for @assetNoteHint.
  ///
  /// In ru, this message translates to:
  /// **'Купил @ 280, цель 320…'**
  String get assetNoteHint;

  /// No description provided for @portfolioTitle.
  ///
  /// In ru, this message translates to:
  /// **'Бумажный портфель'**
  String get portfolioTitle;

  /// No description provided for @portfolioEmptySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'100 000 ₽ виртуально · нажмите, чтобы начать'**
  String get portfolioEmptySubtitle;

  /// No description provided for @portfolioTotal.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость портфеля'**
  String get portfolioTotal;

  /// No description provided for @portfolioPnl.
  ///
  /// In ru, this message translates to:
  /// **'P&L'**
  String get portfolioPnl;

  /// No description provided for @portfolioCash.
  ///
  /// In ru, this message translates to:
  /// **'Кэш'**
  String get portfolioCash;

  /// No description provided for @portfolioPositions.
  ///
  /// In ru, this message translates to:
  /// **'Позиции'**
  String get portfolioPositions;

  /// No description provided for @portfolioEmptyPositions.
  ///
  /// In ru, this message translates to:
  /// **'Купите актив из избранного или preview на «Рынках»'**
  String get portfolioEmptyPositions;

  /// No description provided for @portfolioAdd.
  ///
  /// In ru, this message translates to:
  /// **'Купить'**
  String get portfolioAdd;

  /// No description provided for @portfolioBuy.
  ///
  /// In ru, this message translates to:
  /// **'Покупка'**
  String get portfolioBuy;

  /// No description provided for @portfolioBuyAction.
  ///
  /// In ru, this message translates to:
  /// **'В портфель'**
  String get portfolioBuyAction;

  /// No description provided for @portfolioBought.
  ///
  /// In ru, this message translates to:
  /// **'{symbol} добавлен в портфель'**
  String portfolioBought(String symbol);

  /// No description provided for @portfolioInsufficientCash.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно виртуальных средств'**
  String get portfolioInsufficientCash;

  /// No description provided for @portfolioReset.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get portfolioReset;

  /// No description provided for @portfolioResetConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть 100 000 ₽ и удалить все позиции?'**
  String get portfolioResetConfirm;

  /// No description provided for @portfolioRemoved.
  ///
  /// In ru, this message translates to:
  /// **'{symbol} удалён (long press)'**
  String portfolioRemoved(String symbol);

  /// No description provided for @portfolioPickAsset.
  ///
  /// In ru, this message translates to:
  /// **'Выберите актив'**
  String get portfolioPickAsset;

  /// No description provided for @portfolioPickFromWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте активы в избранное на «Рынках»'**
  String get portfolioPickFromWatchlist;

  /// No description provided for @cryptoLoadMore.
  ///
  /// In ru, this message translates to:
  /// **'Ещё ({loaded} / {total})'**
  String cryptoLoadMore(int loaded, int total);

  /// No description provided for @homeShareDashboard.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться дашбордом'**
  String get homeShareDashboard;

  /// No description provided for @newsSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новости'**
  String get newsSectionTitle;

  /// No description provided for @newsFinnhubHint.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте Finnhub Key в настройках для новостей и календаря'**
  String get newsFinnhubHint;

  /// No description provided for @newsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Новостей пока нет'**
  String get newsEmpty;

  /// No description provided for @newsLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить новости'**
  String get newsLoadError;

  /// No description provided for @macroCalendarTitle.
  ///
  /// In ru, this message translates to:
  /// **'Macro-календарь'**
  String get macroCalendarTitle;

  /// No description provided for @macroCalendarEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Событий на ближайшую неделю нет'**
  String get macroCalendarEmpty;

  /// No description provided for @digestSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get digestSectionTitle;

  /// No description provided for @digestMorningTitle.
  ///
  /// In ru, this message translates to:
  /// **'Утренняя сводка'**
  String get digestMorningTitle;

  /// No description provided for @digestMorningSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Push с brief USD/RUB, BTC, IMOEX в выбранный час'**
  String get digestMorningSubtitle;

  /// No description provided for @digestMorningHour.
  ///
  /// In ru, this message translates to:
  /// **'Время отправки'**
  String get digestMorningHour;

  /// No description provided for @indicesSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Индексы США'**
  String get indicesSectionTitle;

  /// No description provided for @radarTitle.
  ///
  /// In ru, this message translates to:
  /// **'Экономический радар'**
  String get radarTitle;

  /// No description provided for @radarSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Оценка по рынку, валюте, инфляции, ставке и F&G'**
  String get radarSubtitle;

  /// No description provided for @timelineTitle.
  ///
  /// In ru, this message translates to:
  /// **'Лента событий'**
  String get timelineTitle;

  /// No description provided for @timelineEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Событий пока нет · нужен Finnhub для macro'**
  String get timelineEmpty;

  /// No description provided for @macroWeekTitle.
  ///
  /// In ru, this message translates to:
  /// **'Макро-неделя'**
  String get macroWeekTitle;

  /// No description provided for @macroWeekRange.
  ///
  /// In ru, this message translates to:
  /// **'{start} – {end}'**
  String macroWeekRange(String start, String end);

  /// No description provided for @macroWeekBriefTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сводка рынка'**
  String get macroWeekBriefTitle;

  /// No description provided for @macroWeekToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get macroWeekToday;

  /// No description provided for @macroWeekKeyRateToday.
  ///
  /// In ru, this message translates to:
  /// **'Ключевая ставка ЦБ'**
  String get macroWeekKeyRateToday;

  /// No description provided for @macroWeekStats.
  ///
  /// In ru, this message translates to:
  /// **'{events} macro-событий · {days} дней с событиями'**
  String macroWeekStats(int events, int days);

  /// No description provided for @macroWeekEmptyDay.
  ///
  /// In ru, this message translates to:
  /// **'Без событий'**
  String get macroWeekEmptyDay;

  /// No description provided for @macroWeekMon.
  ///
  /// In ru, this message translates to:
  /// **'Пн'**
  String get macroWeekMon;

  /// No description provided for @macroWeekTue.
  ///
  /// In ru, this message translates to:
  /// **'Вт'**
  String get macroWeekTue;

  /// No description provided for @macroWeekWed.
  ///
  /// In ru, this message translates to:
  /// **'Ср'**
  String get macroWeekWed;

  /// No description provided for @macroWeekThu.
  ///
  /// In ru, this message translates to:
  /// **'Чт'**
  String get macroWeekThu;

  /// No description provided for @macroWeekFri.
  ///
  /// In ru, this message translates to:
  /// **'Пт'**
  String get macroWeekFri;

  /// No description provided for @macroWeekSat.
  ///
  /// In ru, this message translates to:
  /// **'Сб'**
  String get macroWeekSat;

  /// No description provided for @macroWeekSun.
  ///
  /// In ru, this message translates to:
  /// **'Вс'**
  String get macroWeekSun;

  /// No description provided for @portfolioExportCsv.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт CSV'**
  String get portfolioExportCsv;

  /// No description provided for @portfolioExportDone.
  ///
  /// In ru, this message translates to:
  /// **'CSV отправлен'**
  String get portfolioExportDone;

  /// No description provided for @demoModeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Демо-режим'**
  String get demoModeTitle;

  /// No description provided for @demoModeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Mock-данные без сети — для скриншотов и презентаций'**
  String get demoModeSubtitle;

  /// No description provided for @demoModeBadge.
  ///
  /// In ru, this message translates to:
  /// **'Демо-данные'**
  String get demoModeBadge;

  /// No description provided for @homeLayoutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Секции главной'**
  String get homeLayoutTitle;

  /// No description provided for @homeSectionPortfolio.
  ///
  /// In ru, this message translates to:
  /// **'Бумажный портфель'**
  String get homeSectionPortfolio;

  /// No description provided for @homeSectionNews.
  ///
  /// In ru, this message translates to:
  /// **'Новости'**
  String get homeSectionNews;

  /// No description provided for @homeSectionRadar.
  ///
  /// In ru, this message translates to:
  /// **'Экономический радар'**
  String get homeSectionRadar;

  /// No description provided for @homeSectionIndices.
  ///
  /// In ru, this message translates to:
  /// **'Индексы США'**
  String get homeSectionIndices;

  /// No description provided for @homeSectionFearGreed.
  ///
  /// In ru, this message translates to:
  /// **'Fear & Greed'**
  String get homeSectionFearGreed;

  /// No description provided for @homeSectionCurrencies.
  ///
  /// In ru, this message translates to:
  /// **'Валюты'**
  String get homeSectionCurrencies;

  /// No description provided for @homeSectionKeyRate.
  ///
  /// In ru, this message translates to:
  /// **'Ключевая ставка'**
  String get homeSectionKeyRate;

  /// No description provided for @homeSectionInflation.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция'**
  String get homeSectionInflation;

  /// No description provided for @homeSectionCommodities.
  ///
  /// In ru, this message translates to:
  /// **'Сырьё'**
  String get homeSectionCommodities;

  /// No description provided for @homeSectionMarkets.
  ///
  /// In ru, this message translates to:
  /// **'Рынки'**
  String get homeSectionMarkets;

  /// No description provided for @homeSectionBonds.
  ///
  /// In ru, this message translates to:
  /// **'Облигации'**
  String get homeSectionBonds;

  /// No description provided for @homeSectionWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get homeSectionWatchlist;

  /// No description provided for @homeSectionCorrelation.
  ///
  /// In ru, this message translates to:
  /// **'Корреляции'**
  String get homeSectionCorrelation;

  /// No description provided for @compareTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сравнение активов'**
  String get compareTitle;

  /// No description provided for @compareSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Выберите до {max} активов для overlay-графика'**
  String compareSubtitle(int max);

  /// No description provided for @compareEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Выберите тикеры выше'**
  String get compareEmpty;

  /// No description provided for @compareClear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get compareClear;

  /// No description provided for @compareChartTitle.
  ///
  /// In ru, this message translates to:
  /// **'Индекс 100 · 30 дней'**
  String get compareChartTitle;

  /// No description provided for @compareLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить историю'**
  String get compareLoadError;

  /// No description provided for @settingsApiKeysTitle.
  ///
  /// In ru, this message translates to:
  /// **'API-ключи'**
  String get settingsApiKeysTitle;

  /// No description provided for @settingsApiKeySaved.
  ///
  /// In ru, this message translates to:
  /// **'{label} сохранён'**
  String settingsApiKeySaved(String label);

  /// No description provided for @settingsBaseCurrencyHint.
  ///
  /// In ru, this message translates to:
  /// **'Используется в конвертере'**
  String get settingsBaseCurrencyHint;

  /// No description provided for @settingsWidgetConfigTitle.
  ///
  /// In ru, this message translates to:
  /// **'Виджет Android'**
  String get settingsWidgetConfigTitle;

  /// No description provided for @settingsWidgetConfigSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Полоска 4×1 или сетка 2×2 · до 4 метрик'**
  String get settingsWidgetConfigSubtitle;

  /// No description provided for @settingsWidgetLayout.
  ///
  /// In ru, this message translates to:
  /// **'Макет'**
  String get settingsWidgetLayout;

  /// No description provided for @settingsWidgetLayoutAuto.
  ///
  /// In ru, this message translates to:
  /// **'Авто (по размеру)'**
  String get settingsWidgetLayoutAuto;

  /// No description provided for @settingsWidgetLayoutCompact.
  ///
  /// In ru, this message translates to:
  /// **'Компакт 4×1'**
  String get settingsWidgetLayoutCompact;

  /// No description provided for @settingsWidgetLayoutExpanded.
  ///
  /// In ru, this message translates to:
  /// **'Расширенный 2×2'**
  String get settingsWidgetLayoutExpanded;

  /// No description provided for @settingsWidgetLayoutHint.
  ///
  /// In ru, this message translates to:
  /// **'В режиме «Авто» макет меняется при изменении размера виджета на рабочем столе'**
  String get settingsWidgetLayoutHint;

  /// No description provided for @settingsWidgetSlot1.
  ///
  /// In ru, this message translates to:
  /// **'Слот 1'**
  String get settingsWidgetSlot1;

  /// No description provided for @settingsWidgetSlot2.
  ///
  /// In ru, this message translates to:
  /// **'Слот 2'**
  String get settingsWidgetSlot2;

  /// No description provided for @settingsWidgetSlot3.
  ///
  /// In ru, this message translates to:
  /// **'Слот 3'**
  String get settingsWidgetSlot3;

  /// No description provided for @settingsWidgetSlot4.
  ///
  /// In ru, this message translates to:
  /// **'Слот 4'**
  String get settingsWidgetSlot4;

  /// No description provided for @widgetMetricUsdRub.
  ///
  /// In ru, this message translates to:
  /// **'USD/RUB'**
  String get widgetMetricUsdRub;

  /// No description provided for @widgetMetricEurRub.
  ///
  /// In ru, this message translates to:
  /// **'EUR/RUB'**
  String get widgetMetricEurRub;

  /// No description provided for @widgetMetricBtc.
  ///
  /// In ru, this message translates to:
  /// **'BTC'**
  String get widgetMetricBtc;

  /// No description provided for @widgetMetricEth.
  ///
  /// In ru, this message translates to:
  /// **'ETH'**
  String get widgetMetricEth;

  /// No description provided for @widgetMetricKeyRate.
  ///
  /// In ru, this message translates to:
  /// **'Ставка ЦБ'**
  String get widgetMetricKeyRate;

  /// No description provided for @widgetMetricBrent.
  ///
  /// In ru, this message translates to:
  /// **'Brent'**
  String get widgetMetricBrent;

  /// No description provided for @widgetMetricWti.
  ///
  /// In ru, this message translates to:
  /// **'WTI'**
  String get widgetMetricWti;

  /// No description provided for @widgetMetricImoex.
  ///
  /// In ru, this message translates to:
  /// **'IMOEX'**
  String get widgetMetricImoex;

  /// No description provided for @widgetMetricPortfolio.
  ///
  /// In ru, this message translates to:
  /// **'Бумажный портфель'**
  String get widgetMetricPortfolio;

  /// No description provided for @widgetMetricInflationRu.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция РФ'**
  String get widgetMetricInflationRu;

  /// No description provided for @homeLayoutReorderHint.
  ///
  /// In ru, this message translates to:
  /// **'Перетащите для порядка · переключатель — показ'**
  String get homeLayoutReorderHint;

  /// No description provided for @alertsKindThreshold.
  ///
  /// In ru, this message translates to:
  /// **'По цене'**
  String get alertsKindThreshold;

  /// No description provided for @alertsKindPercentChange.
  ///
  /// In ru, this message translates to:
  /// **'По изменению %'**
  String get alertsKindPercentChange;

  /// No description provided for @alertsPercentHint.
  ///
  /// In ru, this message translates to:
  /// **'Порог изменения за день, %'**
  String get alertsPercentHint;

  /// No description provided for @alertsHistoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'История срабатываний'**
  String get alertsHistoryTitle;

  /// No description provided for @alertsHistoryEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пока не было срабатываний'**
  String get alertsHistoryEmpty;

  /// No description provided for @alertsQuietHoursTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тихие часы'**
  String get alertsQuietHoursTitle;

  /// No description provided for @alertsQuietHoursSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Без push в выбранный интервал'**
  String get alertsQuietHoursSubtitle;

  /// No description provided for @alertsQuietHoursRange.
  ///
  /// In ru, this message translates to:
  /// **'С {start}:00 до {end}:00'**
  String alertsQuietHoursRange(int start, int end);

  /// No description provided for @alertsQuietHoursStart.
  ///
  /// In ru, this message translates to:
  /// **'С'**
  String get alertsQuietHoursStart;

  /// No description provided for @alertsQuietHoursEnd.
  ///
  /// In ru, this message translates to:
  /// **'До'**
  String get alertsQuietHoursEnd;

  /// No description provided for @alertsConditionRise.
  ///
  /// In ru, this message translates to:
  /// **'Рост'**
  String get alertsConditionRise;

  /// No description provided for @alertsConditionDrop.
  ///
  /// In ru, this message translates to:
  /// **'Падение'**
  String get alertsConditionDrop;

  /// No description provided for @alertsConditionAbove.
  ///
  /// In ru, this message translates to:
  /// **'Выше'**
  String get alertsConditionAbove;

  /// No description provided for @alertsConditionBelow.
  ///
  /// In ru, this message translates to:
  /// **'Ниже'**
  String get alertsConditionBelow;

  /// No description provided for @alertsPresetsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Быстрые шаблоны'**
  String get alertsPresetsTitle;

  /// No description provided for @alertsPresetUsd100.
  ///
  /// In ru, this message translates to:
  /// **'USD/RUB > 100'**
  String get alertsPresetUsd100;

  /// No description provided for @alertsPresetBtcDrop5.
  ///
  /// In ru, this message translates to:
  /// **'BTC −5% за день'**
  String get alertsPresetBtcDrop5;

  /// No description provided for @alertsPresetBtcRise5.
  ///
  /// In ru, this message translates to:
  /// **'BTC +5% за день'**
  String get alertsPresetBtcRise5;

  /// No description provided for @alertsPresetImoexDrop3.
  ///
  /// In ru, this message translates to:
  /// **'IMOEX −3% за день'**
  String get alertsPresetImoexDrop3;

  /// No description provided for @exportReportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отчёт за неделю'**
  String get exportReportTitle;

  /// No description provided for @exportReportSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сводка + избранное + валюты'**
  String get exportReportSubtitle;

  /// No description provided for @exportReportDone.
  ///
  /// In ru, this message translates to:
  /// **'Отчёт отправлен'**
  String get exportReportDone;

  /// No description provided for @portfolioBacktestTitle.
  ///
  /// In ru, this message translates to:
  /// **'Бэктест ~30 дней'**
  String get portfolioBacktestTitle;

  /// No description provided for @portfolioBacktestResult.
  ///
  /// In ru, this message translates to:
  /// **'Было {past} → сейчас {current} ({change})'**
  String portfolioBacktestResult(String past, String current, String change);

  /// No description provided for @portfolioBacktestUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно истории по позициям'**
  String get portfolioBacktestUnavailable;

  /// No description provided for @portfolioAllocationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Аллокация'**
  String get portfolioAllocationTitle;

  /// No description provided for @portfolioAllocationSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Доли классов активов · бумажный портфель'**
  String get portfolioAllocationSubtitle;

  /// No description provided for @portfolioAllocationCash.
  ///
  /// In ru, this message translates to:
  /// **'Кэш'**
  String get portfolioAllocationCash;

  /// No description provided for @portfolioAllocationCrypto.
  ///
  /// In ru, this message translates to:
  /// **'Крипто'**
  String get portfolioAllocationCrypto;

  /// No description provided for @portfolioAllocationStocks.
  ///
  /// In ru, this message translates to:
  /// **'Акции'**
  String get portfolioAllocationStocks;

  /// No description provided for @portfolioAllocationBonds.
  ///
  /// In ru, this message translates to:
  /// **'Облигации'**
  String get portfolioAllocationBonds;

  /// No description provided for @portfolioAllocationTotal.
  ///
  /// In ru, this message translates to:
  /// **'Всего в активах: {total}'**
  String portfolioAllocationTotal(String total);

  /// No description provided for @portfolioRebalanceTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ребалансировка'**
  String get portfolioRebalanceTitle;

  /// No description provided for @portfolioRebalanceSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Целевые доли и подсказки по классам активов'**
  String get portfolioRebalanceSubtitle;

  /// No description provided for @portfolioRebalanceConservative.
  ///
  /// In ru, this message translates to:
  /// **'Консерв.'**
  String get portfolioRebalanceConservative;

  /// No description provided for @portfolioRebalancePresetBalanced.
  ///
  /// In ru, this message translates to:
  /// **'Баланс'**
  String get portfolioRebalancePresetBalanced;

  /// No description provided for @portfolioRebalanceGrowth.
  ///
  /// In ru, this message translates to:
  /// **'Рост'**
  String get portfolioRebalanceGrowth;

  /// No description provided for @portfolioRebalanceCustom.
  ///
  /// In ru, this message translates to:
  /// **'Свой'**
  String get portfolioRebalanceCustom;

  /// No description provided for @portfolioRebalanceDrift.
  ///
  /// In ru, this message translates to:
  /// **'Макс. отклонение: {drift}'**
  String portfolioRebalanceDrift(String drift);

  /// No description provided for @portfolioRebalanceOnTarget.
  ///
  /// In ru, this message translates to:
  /// **'Портфель близок к целевой аллокации'**
  String get portfolioRebalanceOnTarget;

  /// No description provided for @portfolioRebalanceBuy.
  ///
  /// In ru, this message translates to:
  /// **'Купить {amount}'**
  String portfolioRebalanceBuy(String amount);

  /// No description provided for @portfolioRebalanceSell.
  ///
  /// In ru, this message translates to:
  /// **'Продать {amount}'**
  String portfolioRebalanceSell(String amount);

  /// No description provided for @portfolioRebalanceHold.
  ///
  /// In ru, this message translates to:
  /// **'Ок'**
  String get portfolioRebalanceHold;

  /// No description provided for @portfolioRebalanceInvestCash.
  ///
  /// In ru, this message translates to:
  /// **'Инвестировать {amount}'**
  String portfolioRebalanceInvestCash(String amount);

  /// No description provided for @portfolioRebalanceFreeCash.
  ///
  /// In ru, this message translates to:
  /// **'Освободить {amount}'**
  String portfolioRebalanceFreeCash(String amount);

  /// No description provided for @portfolioRebalanceCurrentTarget.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас {current}% → цель {target}%'**
  String portfolioRebalanceCurrentTarget(int current, int target);

  /// No description provided for @portfolioIncomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Календарь дохода'**
  String get portfolioIncomeTitle;

  /// No description provided for @portfolioIncomeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Купоны, дивиденды и погашения по вашим позициям'**
  String get portfolioIncomeSubtitle;

  /// No description provided for @portfolioIncomeNext30.
  ///
  /// In ru, this message translates to:
  /// **'30 дней'**
  String get portfolioIncomeNext30;

  /// No description provided for @portfolioIncomeNext90.
  ///
  /// In ru, this message translates to:
  /// **'90 дней'**
  String get portfolioIncomeNext90;

  /// No description provided for @portfolioIncomeByMonth.
  ///
  /// In ru, this message translates to:
  /// **'По месяцам'**
  String get portfolioIncomeByMonth;

  /// No description provided for @portfolioIncomeMonthChip.
  ///
  /// In ru, this message translates to:
  /// **'{month} · {amount} ₽'**
  String portfolioIncomeMonthChip(String month, String amount);

  /// No description provided for @portfolioIncomeUpcoming.
  ///
  /// In ru, this message translates to:
  /// **'Ближайшие поступления'**
  String get portfolioIncomeUpcoming;

  /// No description provided for @portfolioIncomeCoupon.
  ///
  /// In ru, this message translates to:
  /// **'Купон'**
  String get portfolioIncomeCoupon;

  /// No description provided for @portfolioIncomeCouponEstimate.
  ///
  /// In ru, this message translates to:
  /// **'Купон (оценка)'**
  String get portfolioIncomeCouponEstimate;

  /// No description provided for @portfolioIncomeMaturity.
  ///
  /// In ru, this message translates to:
  /// **'Погашение номинала'**
  String get portfolioIncomeMaturity;

  /// No description provided for @portfolioIncomeDividendEstimate.
  ///
  /// In ru, this message translates to:
  /// **'Дивиденды (оценка)'**
  String get portfolioIncomeDividendEstimate;

  /// No description provided for @portfolioScenarioTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сценарии «что если»'**
  String get portfolioScenarioTitle;

  /// No description provided for @portfolioScenarioSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Пересчёт стоимости при шоке рынка'**
  String get portfolioScenarioSubtitle;

  /// No description provided for @portfolioScenarioUsdUp10.
  ///
  /// In ru, this message translates to:
  /// **'USD/RUB +10%'**
  String get portfolioScenarioUsdUp10;

  /// No description provided for @portfolioScenarioBtcDown30.
  ///
  /// In ru, this message translates to:
  /// **'BTC −30%'**
  String get portfolioScenarioBtcDown30;

  /// No description provided for @portfolioScenarioImoexDown15.
  ///
  /// In ru, this message translates to:
  /// **'IMOEX −15%'**
  String get portfolioScenarioImoexDown15;

  /// No description provided for @portfolioScenarioKeyRateUp2.
  ///
  /// In ru, this message translates to:
  /// **'Ставка +2 п.п.'**
  String get portfolioScenarioKeyRateUp2;

  /// No description provided for @portfolioScenarioResult.
  ///
  /// In ru, this message translates to:
  /// **'{base} → {scenario}'**
  String portfolioScenarioResult(String base, String scenario);

  /// No description provided for @portfolioScenarioDelta.
  ///
  /// In ru, this message translates to:
  /// **'Δ {amount} ({percent})'**
  String portfolioScenarioDelta(String amount, String percent);

  /// No description provided for @portfolioRealReturnTitle.
  ///
  /// In ru, this message translates to:
  /// **'Реальная доходность'**
  String get portfolioRealReturnTitle;

  /// No description provided for @portfolioRealReturnSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Номинал минус инфляция · сравнение с IMOEX и депозитом'**
  String get portfolioRealReturnSubtitle;

  /// No description provided for @portfolioRealReturnHorizon30d.
  ///
  /// In ru, this message translates to:
  /// **'30 дней'**
  String get portfolioRealReturnHorizon30d;

  /// No description provided for @portfolioRealReturnHorizonAll.
  ///
  /// In ru, this message translates to:
  /// **'С начала'**
  String get portfolioRealReturnHorizonAll;

  /// No description provided for @portfolioRealReturnNominal.
  ///
  /// In ru, this message translates to:
  /// **'Портфель (номинал)'**
  String get portfolioRealReturnNominal;

  /// No description provided for @portfolioRealReturnReal.
  ///
  /// In ru, this message translates to:
  /// **'Портфель (реальная)'**
  String get portfolioRealReturnReal;

  /// No description provided for @portfolioRealReturnInflation.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция (RU)'**
  String get portfolioRealReturnInflation;

  /// No description provided for @portfolioRealReturnImoex.
  ///
  /// In ru, this message translates to:
  /// **'IMOEX'**
  String get portfolioRealReturnImoex;

  /// No description provided for @portfolioRealReturnDeposit.
  ///
  /// In ru, this message translates to:
  /// **'Депозит (ставка ЦБ)'**
  String get portfolioRealReturnDeposit;

  /// No description provided for @portfolioRealReturnBeatInflation.
  ///
  /// In ru, this message translates to:
  /// **'Реальная доходность {value} — опережает инфляцию'**
  String portfolioRealReturnBeatInflation(String value);

  /// No description provided for @portfolioRealReturnLoseInflation.
  ///
  /// In ru, this message translates to:
  /// **'Реальная доходность {value} — ниже инфляции'**
  String portfolioRealReturnLoseInflation(String value);

  /// No description provided for @portfolioRealReturnBeatImoex.
  ///
  /// In ru, this message translates to:
  /// **'Опережает IMOEX на {delta}'**
  String portfolioRealReturnBeatImoex(String delta);

  /// No description provided for @portfolioRealReturnLoseImoex.
  ///
  /// In ru, this message translates to:
  /// **'Отстаёт от IMOEX на {delta}'**
  String portfolioRealReturnLoseImoex(String delta);

  /// No description provided for @portfolioRealReturnBeatDeposit.
  ///
  /// In ru, this message translates to:
  /// **'Выше депозита по ключевой ставке'**
  String get portfolioRealReturnBeatDeposit;

  /// No description provided for @portfolioRealReturnLoseDeposit.
  ///
  /// In ru, this message translates to:
  /// **'Ниже депозита по ключевой ставке'**
  String get portfolioRealReturnLoseDeposit;

  /// No description provided for @watchlistVolatilityTitle.
  ///
  /// In ru, this message translates to:
  /// **'Волатильность избранного'**
  String get watchlistVolatilityTitle;

  /// No description provided for @watchlistVolatilitySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Годовая σ по дневным доходностям · sparkline ~30 дней'**
  String get watchlistVolatilitySubtitle;

  /// No description provided for @watchlistVolatilityAnnual.
  ///
  /// In ru, this message translates to:
  /// **'σ {value}'**
  String watchlistVolatilityAnnual(String value);

  /// No description provided for @watchlistVolatilityLow.
  ///
  /// In ru, this message translates to:
  /// **'Низкая'**
  String get watchlistVolatilityLow;

  /// No description provided for @watchlistVolatilityHigh.
  ///
  /// In ru, this message translates to:
  /// **'Высокая'**
  String get watchlistVolatilityHigh;

  /// No description provided for @portfolioTradeJournalTitle.
  ///
  /// In ru, this message translates to:
  /// **'Журнал сделок'**
  String get portfolioTradeJournalTitle;

  /// No description provided for @portfolioTradeJournalSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'История покупок и продаж бумажного портфеля'**
  String get portfolioTradeJournalSubtitle;

  /// No description provided for @portfolioTradeJournalEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Сделок пока нет · купите актив из избранного'**
  String get portfolioTradeJournalEmpty;

  /// No description provided for @portfolioTradeJournalBuy.
  ///
  /// In ru, this message translates to:
  /// **'Покупка'**
  String get portfolioTradeJournalBuy;

  /// No description provided for @portfolioTradeJournalSell.
  ///
  /// In ru, this message translates to:
  /// **'Продажа'**
  String get portfolioTradeJournalSell;

  /// No description provided for @portfolioTradeJournalOpenAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get portfolioTradeJournalOpenAll;

  /// No description provided for @portfolioTradeJournalExport.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт CSV'**
  String get portfolioTradeJournalExport;

  /// No description provided for @portfolioTradeJournalStats.
  ///
  /// In ru, this message translates to:
  /// **'{total} сделок · {buys} покупок · {sells} продаж'**
  String portfolioTradeJournalStats(int total, int buys, int sells);

  /// No description provided for @portfolioTradeJournalRealizedPnl.
  ///
  /// In ru, this message translates to:
  /// **'Реализованный P&L: {value}'**
  String portfolioTradeJournalRealizedPnl(String value);

  /// No description provided for @cloudSyncTitle.
  ///
  /// In ru, this message translates to:
  /// **'Cloud sync'**
  String get cloudSyncTitle;

  /// No description provided for @cloudSyncSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Синхронизация через JSON-файл · Google Drive, Telegram, почта'**
  String get cloudSyncSubtitle;

  /// No description provided for @cloudSyncStatusSynced.
  ///
  /// In ru, this message translates to:
  /// **'Данные синхронизированы'**
  String get cloudSyncStatusSynced;

  /// No description provided for @cloudSyncStatusPending.
  ///
  /// In ru, this message translates to:
  /// **'Есть локальные изменения — отправьте sync'**
  String get cloudSyncStatusPending;

  /// No description provided for @cloudSyncStatusNever.
  ///
  /// In ru, this message translates to:
  /// **'Синхронизация ещё не выполнялась'**
  String get cloudSyncStatusNever;

  /// No description provided for @cloudSyncLastOut.
  ///
  /// In ru, this message translates to:
  /// **'Отправлено: {date}'**
  String cloudSyncLastOut(String date);

  /// No description provided for @cloudSyncLastIn.
  ///
  /// In ru, this message translates to:
  /// **'Загружено: {date}'**
  String cloudSyncLastIn(String date);

  /// No description provided for @cloudSyncExport.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get cloudSyncExport;

  /// No description provided for @cloudSyncImport.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить'**
  String get cloudSyncImport;

  /// No description provided for @cloudSyncExportDone.
  ///
  /// In ru, this message translates to:
  /// **'Файл sync готов — сохраните в облако'**
  String get cloudSyncExportDone;

  /// No description provided for @cloudSyncImportSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Загружено {count} ключей данных'**
  String cloudSyncImportSuccess(int count);

  /// No description provided for @cloudSyncImportNotNewer.
  ///
  /// In ru, this message translates to:
  /// **'Файл не новее текущих данных на устройстве'**
  String get cloudSyncImportNotNewer;

  /// No description provided for @cloudSyncShareSubject.
  ///
  /// In ru, this message translates to:
  /// **'EcoPulse sync'**
  String get cloudSyncShareSubject;

  /// No description provided for @cloudSyncError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка sync: {message}'**
  String cloudSyncError(String message);

  /// No description provided for @adminCrashReports.
  ///
  /// In ru, this message translates to:
  /// **'Отчёты об ошибках'**
  String get adminCrashReports;

  /// No description provided for @assistantTitle.
  ///
  /// In ru, this message translates to:
  /// **'EcoPulse Assistant'**
  String get assistantTitle;

  /// No description provided for @assistantHint.
  ///
  /// In ru, this message translates to:
  /// **'Спросите о курсе, сводке или портфеле…'**
  String get assistantHint;

  /// No description provided for @assistantThinking.
  ///
  /// In ru, this message translates to:
  /// **'Думаю…'**
  String get assistantThinking;

  /// No description provided for @assistantDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'Не является инвестиционной рекомендацией'**
  String get assistantDisclaimer;

  /// No description provided for @assistantClearHistory.
  ///
  /// In ru, this message translates to:
  /// **'Очистить чат'**
  String get assistantClearHistory;

  /// No description provided for @assistantVoiceListen.
  ///
  /// In ru, this message translates to:
  /// **'Слушать'**
  String get assistantVoiceListen;

  /// No description provided for @assistantSourceLocal.
  ///
  /// In ru, this message translates to:
  /// **'локально'**
  String get assistantSourceLocal;

  /// No description provided for @assistantSourceCloud.
  ///
  /// In ru, this message translates to:
  /// **'Gemini'**
  String get assistantSourceCloud;

  /// No description provided for @assistantQuickPrice.
  ///
  /// In ru, this message translates to:
  /// **'USD/RUB'**
  String get assistantQuickPrice;

  /// No description provided for @assistantQuickBrief.
  ///
  /// In ru, this message translates to:
  /// **'Сводка'**
  String get assistantQuickBrief;

  /// No description provided for @assistantQuickPortfolio.
  ///
  /// In ru, this message translates to:
  /// **'Портфель'**
  String get assistantQuickPortfolio;

  /// No description provided for @assistantQuickExplain.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция'**
  String get assistantQuickExplain;

  /// No description provided for @assistantQuickPriceQuery.
  ///
  /// In ru, this message translates to:
  /// **'курс доллара'**
  String get assistantQuickPriceQuery;

  /// No description provided for @assistantQuickBriefQuery.
  ///
  /// In ru, this message translates to:
  /// **'что сегодня'**
  String get assistantQuickBriefQuery;

  /// No description provided for @assistantQuickPortfolioQuery.
  ///
  /// In ru, this message translates to:
  /// **'мой портфель'**
  String get assistantQuickPortfolioQuery;

  /// No description provided for @assistantQuickExplainQuery.
  ///
  /// In ru, this message translates to:
  /// **'что такое инфляция'**
  String get assistantQuickExplainQuery;

  /// No description provided for @settingsGeminiKey.
  ///
  /// In ru, this message translates to:
  /// **'Gemini API Key'**
  String get settingsGeminiKey;

  /// No description provided for @courseLibraryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Курсы'**
  String get courseLibraryTitle;

  /// No description provided for @courseLibrarySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Обучение инвестированию и личным финансам'**
  String get courseLibrarySubtitle;

  /// No description provided for @courseDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'Образовательные материалы EcoPulse. Не является инвестиционной рекомендацией.'**
  String get courseDisclaimer;

  /// No description provided for @courseHomeCardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Курс инвестора'**
  String get courseHomeCardTitle;

  /// No description provided for @courseChaptersCount.
  ///
  /// In ru, this message translates to:
  /// **'{count} глав'**
  String courseChaptersCount(int count);

  /// No description provided for @courseReadMinutes.
  ///
  /// In ru, this message translates to:
  /// **'~{minutes} мин чтения'**
  String courseReadMinutes(int minutes);

  /// No description provided for @courseProgressPercent.
  ///
  /// In ru, this message translates to:
  /// **'Пройдено {percent}%'**
  String courseProgressPercent(int percent);

  /// No description provided for @courseStartReading.
  ///
  /// In ru, this message translates to:
  /// **'Читать'**
  String get courseStartReading;

  /// No description provided for @courseReadFromStart.
  ///
  /// In ru, this message translates to:
  /// **'С начала'**
  String get courseReadFromStart;

  /// No description provided for @courseContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get courseContinue;

  /// No description provided for @courseTableOfContents.
  ///
  /// In ru, this message translates to:
  /// **'Оглавление'**
  String get courseTableOfContents;

  /// No description provided for @courseChapterProgress.
  ///
  /// In ru, this message translates to:
  /// **'Глава {current} из {total}'**
  String courseChapterProgress(int current, int total);

  /// No description provided for @courseChapterDone.
  ///
  /// In ru, this message translates to:
  /// **'Прочитано'**
  String get courseChapterDone;

  /// No description provided for @courseMarkRead.
  ///
  /// In ru, this message translates to:
  /// **'Отметить'**
  String get courseMarkRead;

  /// No description provided for @courseMarkedRead.
  ///
  /// In ru, this message translates to:
  /// **'Глава отмечена как прочитанная'**
  String get courseMarkedRead;

  /// No description provided for @coursePrevChapter.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get coursePrevChapter;

  /// No description provided for @courseNextChapter.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get courseNextChapter;

  /// No description provided for @courseFinish.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get courseFinish;

  /// No description provided for @homeSectionLearn.
  ///
  /// In ru, this message translates to:
  /// **'Курсы'**
  String get homeSectionLearn;

  /// No description provided for @assistantQuickCourse.
  ///
  /// In ru, this message translates to:
  /// **'Курс'**
  String get assistantQuickCourse;

  /// No description provided for @assistantQuickCourseQuery.
  ///
  /// In ru, this message translates to:
  /// **'открой курс инвестирования'**
  String get assistantQuickCourseQuery;

  /// No description provided for @coursePagesCount.
  ///
  /// In ru, this message translates to:
  /// **'~{pages} стр.'**
  String coursePagesCount(int pages);

  /// No description provided for @courseChapterShort.
  ///
  /// In ru, this message translates to:
  /// **'Гл. {current}/{total}'**
  String courseChapterShort(int current, int total);

  /// No description provided for @courseReaderSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки чтения'**
  String get courseReaderSettings;

  /// No description provided for @courseFontSize.
  ///
  /// In ru, this message translates to:
  /// **'Размер шрифта'**
  String get courseFontSize;

  /// No description provided for @courseReadingTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get courseReadingTheme;

  /// No description provided for @courseThemeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Система'**
  String get courseThemeSystem;

  /// No description provided for @courseThemeSepia.
  ///
  /// In ru, this message translates to:
  /// **'Сепия'**
  String get courseThemeSepia;

  /// No description provided for @courseThemeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get courseThemeDark;

  /// No description provided for @courseSearch.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по книге'**
  String get courseSearch;

  /// No description provided for @courseSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Ключевое слово…'**
  String get courseSearchHint;

  /// No description provided for @courseSearchEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get courseSearchEmpty;

  /// No description provided for @courseSearchClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get courseSearchClose;

  /// No description provided for @courseQuizProgress.
  ///
  /// In ru, this message translates to:
  /// **'Вопрос {current} из {total}'**
  String courseQuizProgress(int current, int total);

  /// No description provided for @courseQuizNext.
  ///
  /// In ru, this message translates to:
  /// **'Ответить'**
  String get courseQuizNext;

  /// No description provided for @courseQuizPassed.
  ///
  /// In ru, this message translates to:
  /// **'Отлично! Часть пройдена'**
  String get courseQuizPassed;

  /// No description provided for @courseQuizRetry.
  ///
  /// In ru, this message translates to:
  /// **'Нужно повторить'**
  String get courseQuizRetry;

  /// No description provided for @courseQuizScore.
  ///
  /// In ru, this message translates to:
  /// **'Правильных: {correct} из {total}'**
  String courseQuizScore(int correct, int total);

  /// No description provided for @courseQuizContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить чтение'**
  String get courseQuizContinue;

  /// No description provided for @courseQuizTryAgain.
  ///
  /// In ru, this message translates to:
  /// **'Пройти снова'**
  String get courseQuizTryAgain;

  /// No description provided for @homeServerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Домашний сервер'**
  String get homeServerTitle;

  /// No description provided for @homeServerSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'ПК-бэкенд в LAN: Profile ID и чаты'**
  String get homeServerSubtitle;

  /// No description provided for @homeServerUrlLabel.
  ///
  /// In ru, this message translates to:
  /// **'URL сервера'**
  String get homeServerUrlLabel;

  /// No description provided for @homeServerUrlHint.
  ///
  /// In ru, this message translates to:
  /// **'http://192.168.1.105:8081'**
  String get homeServerUrlHint;

  /// No description provided for @homeServerIpHint.
  ///
  /// In ru, this message translates to:
  /// **'На ПК: ipconfig → IPv4 Wi‑Fi адаптера'**
  String get homeServerIpHint;

  /// No description provided for @homeServerCheckConnection.
  ///
  /// In ru, this message translates to:
  /// **'Проверить связь'**
  String get homeServerCheckConnection;

  /// No description provided for @homeServerStatusOnline.
  ///
  /// In ru, this message translates to:
  /// **'Онлайн'**
  String get homeServerStatusOnline;

  /// No description provided for @homeServerStatusOffline.
  ///
  /// In ru, this message translates to:
  /// **'Офлайн'**
  String get homeServerStatusOffline;

  /// No description provided for @homeServerStatusUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Не проверено'**
  String get homeServerStatusUnknown;

  /// No description provided for @homeServerLogin.
  ///
  /// In ru, this message translates to:
  /// **'Вход'**
  String get homeServerLogin;

  /// No description provided for @homeServerRegister.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get homeServerRegister;

  /// No description provided for @homeServerLoginLabel.
  ///
  /// In ru, this message translates to:
  /// **'Логин'**
  String get homeServerLoginLabel;

  /// No description provided for @homeServerPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get homeServerPasswordLabel;

  /// No description provided for @homeServerProfileId.
  ///
  /// In ru, this message translates to:
  /// **'Profile ID'**
  String get homeServerProfileId;

  /// No description provided for @homeServerCopyProfileId.
  ///
  /// In ru, this message translates to:
  /// **'Копировать Profile ID'**
  String get homeServerCopyProfileId;

  /// No description provided for @homeServerProfileIdCopied.
  ///
  /// In ru, this message translates to:
  /// **'Profile ID скопирован'**
  String get homeServerProfileIdCopied;

  /// No description provided for @homeServerLoggedInAs.
  ///
  /// In ru, this message translates to:
  /// **'Вход: {login}'**
  String homeServerLoggedInAs(String login);

  /// No description provided for @homeServerLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get homeServerLogout;

  /// No description provided for @homeServerSwitchAccount.
  ///
  /// In ru, this message translates to:
  /// **'Сменить аккаунт'**
  String get homeServerSwitchAccount;

  /// No description provided for @homeServerEnsureSelfChat.
  ///
  /// In ru, this message translates to:
  /// **'Создать чат «Себе»'**
  String get homeServerEnsureSelfChat;

  /// No description provided for @homeServerSelfChatReady.
  ///
  /// In ru, this message translates to:
  /// **'Чат «Себе» готов'**
  String get homeServerSelfChatReady;

  /// No description provided for @homeServerRegisterSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация успешна'**
  String get homeServerRegisterSuccess;

  /// No description provided for @homeServerLoginSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Вход выполнен'**
  String get homeServerLoginSuccess;

  /// No description provided for @homeServerLoggedOut.
  ///
  /// In ru, this message translates to:
  /// **'Вы вышли'**
  String get homeServerLoggedOut;

  /// No description provided for @homeServerCreateTestAccount.
  ///
  /// In ru, this message translates to:
  /// **'Создать test2'**
  String get homeServerCreateTestAccount;

  /// No description provided for @homeServerTestAccountCreated.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт test2 создан (или уже есть)'**
  String get homeServerTestAccountCreated;

  /// No description provided for @homeServerErrorLoginTaken.
  ///
  /// In ru, this message translates to:
  /// **'Логин занят'**
  String get homeServerErrorLoginTaken;

  /// No description provided for @homeServerErrorInvalidCredentials.
  ///
  /// In ru, this message translates to:
  /// **'Неверный логин или пароль'**
  String get homeServerErrorInvalidCredentials;

  /// No description provided for @homeServerErrorLoginShort.
  ///
  /// In ru, this message translates to:
  /// **'Логин — минимум 3 символа'**
  String get homeServerErrorLoginShort;

  /// No description provided for @homeServerErrorPasswordShort.
  ///
  /// In ru, this message translates to:
  /// **'Пароль — минимум 4 символа'**
  String get homeServerErrorPasswordShort;

  /// No description provided for @homeServerErrorUpgrade.
  ///
  /// In ru, this message translates to:
  /// **'Нужно обновить приложение для этого сервера'**
  String get homeServerErrorUpgrade;

  /// No description provided for @homeServerErrorNoUrl.
  ///
  /// In ru, this message translates to:
  /// **'Сначала укажите URL сервера'**
  String get homeServerErrorNoUrl;

  /// No description provided for @homeServerErrorNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Сервер недоступен — Wi‑Fi и firewall'**
  String get homeServerErrorNetwork;

  /// No description provided for @messagesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сообщения'**
  String get messagesTitle;

  /// No description provided for @messagesNewChat.
  ///
  /// In ru, this message translates to:
  /// **'Новый чат'**
  String get messagesNewChat;

  /// No description provided for @messagesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Чатов пока нет'**
  String get messagesEmpty;

  /// No description provided for @messagesNotConnected.
  ///
  /// In ru, this message translates to:
  /// **'Подключите домашний сервер в настройках'**
  String get messagesNotConnected;

  /// No description provided for @messagesSelfChat.
  ///
  /// In ru, this message translates to:
  /// **'Написать себе'**
  String get messagesSelfChat;

  /// No description provided for @messagesSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по логину или Profile ID'**
  String get messagesSearchHint;

  /// No description provided for @messagesSearchEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пользователи не найдены'**
  String get messagesSearchEmpty;

  /// No description provided for @messagesInputHint.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение…'**
  String get messagesInputHint;

  /// No description provided for @messagesThreadEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Сообщений пока нет — напишите первое'**
  String get messagesThreadEmpty;

  /// No description provided for @profileIdLabel.
  ///
  /// In ru, this message translates to:
  /// **'Profile ID'**
  String get profileIdLabel;

  /// No description provided for @profileIdHint.
  ///
  /// In ru, this message translates to:
  /// **'UUID с домашнего сервера — для начала чата'**
  String get profileIdHint;

  /// No description provided for @customizationSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кастомизация'**
  String get customizationSectionTitle;

  /// No description provided for @customizationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кастомизация'**
  String get customizationTitle;

  /// No description provided for @customizationSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Тема, графики, главная и навигация в одном месте'**
  String get customizationSubtitle;

  /// No description provided for @customizationSettingsEntry.
  ///
  /// In ru, this message translates to:
  /// **'Все настройки оформления'**
  String get customizationSettingsEntry;

  /// No description provided for @customizationSettingsEntrySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Графики, тема, главная, навигация и виджеты'**
  String get customizationSettingsEntrySubtitle;

  /// No description provided for @customizationPreview.
  ///
  /// In ru, this message translates to:
  /// **'Предпросмотр'**
  String get customizationPreview;

  /// No description provided for @customizationPreviewSample.
  ///
  /// In ru, this message translates to:
  /// **'Пример графика с текущими параметрами'**
  String get customizationPreviewSample;

  /// No description provided for @customizationPreviewTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тема: {mode}'**
  String customizationPreviewTheme(String mode);

  /// No description provided for @customizationPreviewAccent.
  ///
  /// In ru, this message translates to:
  /// **'Акцент: {color}'**
  String customizationPreviewAccent(String color);

  /// No description provided for @customizationResetSection.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить секцию'**
  String get customizationResetSection;

  /// No description provided for @customizationResetAll.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить всё'**
  String get customizationResetAll;

  /// No description provided for @customizationResetAllConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть все настройки к заводским?'**
  String get customizationResetAllConfirm;

  /// No description provided for @customizationSectionCharts.
  ///
  /// In ru, this message translates to:
  /// **'Графики'**
  String get customizationSectionCharts;

  /// No description provided for @customizationSectionAppearance.
  ///
  /// In ru, this message translates to:
  /// **'Внешний вид'**
  String get customizationSectionAppearance;

  /// No description provided for @customizationSectionHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get customizationSectionHome;

  /// No description provided for @customizationSectionNavigation.
  ///
  /// In ru, this message translates to:
  /// **'Навигация'**
  String get customizationSectionNavigation;

  /// No description provided for @customizationSectionMarkets.
  ///
  /// In ru, this message translates to:
  /// **'Рынки'**
  String get customizationSectionMarkets;

  /// No description provided for @customizationSectionPortfolio.
  ///
  /// In ru, this message translates to:
  /// **'Портфель'**
  String get customizationSectionPortfolio;

  /// No description provided for @customizationSectionWidgets.
  ///
  /// In ru, this message translates to:
  /// **'Виджет'**
  String get customizationSectionWidgets;

  /// No description provided for @customizationSectionDataDisplay.
  ///
  /// In ru, this message translates to:
  /// **'Данные'**
  String get customizationSectionDataDisplay;

  /// No description provided for @customizationSectionAssistant.
  ///
  /// In ru, this message translates to:
  /// **'Ассистент'**
  String get customizationSectionAssistant;

  /// No description provided for @customizationChartDefaultType.
  ///
  /// In ru, this message translates to:
  /// **'Тип по умолчанию'**
  String get customizationChartDefaultType;

  /// No description provided for @customizationChartPeriod.
  ///
  /// In ru, this message translates to:
  /// **'Период'**
  String get customizationChartPeriod;

  /// No description provided for @customizationChartHeight.
  ///
  /// In ru, this message translates to:
  /// **'Высота'**
  String get customizationChartHeight;

  /// No description provided for @customizationChartShowLegend.
  ///
  /// In ru, this message translates to:
  /// **'Легенда'**
  String get customizationChartShowLegend;

  /// No description provided for @customizationChartPreferCandles.
  ///
  /// In ru, this message translates to:
  /// **'Свечи, если доступны'**
  String get customizationChartPreferCandles;

  /// No description provided for @customizationChartNormalizedCompare.
  ///
  /// In ru, this message translates to:
  /// **'Нормализация сравнения'**
  String get customizationChartNormalizedCompare;

  /// No description provided for @customizationFontScale.
  ///
  /// In ru, this message translates to:
  /// **'Масштаб текста'**
  String get customizationFontScale;

  /// No description provided for @customizationUiDensity.
  ///
  /// In ru, this message translates to:
  /// **'Плотность интерфейса'**
  String get customizationUiDensity;

  /// No description provided for @customizationCardStyle.
  ///
  /// In ru, this message translates to:
  /// **'Стиль карточек'**
  String get customizationCardStyle;

  /// No description provided for @customizationMotionReduced.
  ///
  /// In ru, this message translates to:
  /// **'Меньше анимаций'**
  String get customizationMotionReduced;

  /// No description provided for @customizationAmoledPureBlack.
  ///
  /// In ru, this message translates to:
  /// **'Чистый чёрный (OLED)'**
  String get customizationAmoledPureBlack;

  /// No description provided for @customizationNavDefaultTab.
  ///
  /// In ru, this message translates to:
  /// **'Стартовая вкладка'**
  String get customizationNavDefaultTab;

  /// No description provided for @customizationNavShowFab.
  ///
  /// In ru, this message translates to:
  /// **'Кнопка ассистента'**
  String get customizationNavShowFab;

  /// No description provided for @customizationNavHideLabels.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть подписи вкладок'**
  String get customizationNavHideLabels;

  /// No description provided for @customizationNavVisibleTabs.
  ///
  /// In ru, this message translates to:
  /// **'Видимые вкладки'**
  String get customizationNavVisibleTabs;

  /// No description provided for @customizationHomeNewsCount.
  ///
  /// In ru, this message translates to:
  /// **'Новостей на главной'**
  String get customizationHomeNewsCount;

  /// No description provided for @customizationHomeSparklines.
  ///
  /// In ru, this message translates to:
  /// **'Спарклайны'**
  String get customizationHomeSparklines;

  /// No description provided for @customizationMarketsGroupStocks.
  ///
  /// In ru, this message translates to:
  /// **'Группировать акции по секторам'**
  String get customizationMarketsGroupStocks;

  /// No description provided for @customizationMarketsHeatmap.
  ///
  /// In ru, this message translates to:
  /// **'Тепловая карта секторов'**
  String get customizationMarketsHeatmap;

  /// No description provided for @customizationMarketsCompactRows.
  ///
  /// In ru, this message translates to:
  /// **'Компактные строки'**
  String get customizationMarketsCompactRows;

  /// No description provided for @customizationPortfolioAllocation.
  ///
  /// In ru, this message translates to:
  /// **'Диаграмма аллокации'**
  String get customizationPortfolioAllocation;

  /// No description provided for @customizationPortfolioRealizedPnl.
  ///
  /// In ru, this message translates to:
  /// **'Реализованный P/L'**
  String get customizationPortfolioRealizedPnl;

  /// No description provided for @customizationPortfolioJournal.
  ///
  /// In ru, this message translates to:
  /// **'Журнал сделок'**
  String get customizationPortfolioJournal;

  /// No description provided for @customizationAssistantPreferCloud.
  ///
  /// In ru, this message translates to:
  /// **'Облачный AI (Gemini)'**
  String get customizationAssistantPreferCloud;

  /// No description provided for @customizationAssistantQuickChips.
  ///
  /// In ru, this message translates to:
  /// **'Быстрые подсказки'**
  String get customizationAssistantQuickChips;

  /// No description provided for @customizationAssistantVoice.
  ///
  /// In ru, this message translates to:
  /// **'Голосовой ввод'**
  String get customizationAssistantVoice;

  /// No description provided for @customizationDataDecimalPlaces.
  ///
  /// In ru, this message translates to:
  /// **'Знаков после запятой'**
  String get customizationDataDecimalPlaces;

  /// No description provided for @customizationDataLargeNumbers.
  ///
  /// In ru, this message translates to:
  /// **'Крупные числа'**
  String get customizationDataLargeNumbers;

  /// No description provided for @customizationDataShowCurrencyCode.
  ///
  /// In ru, this message translates to:
  /// **'Показывать код валюты'**
  String get customizationDataShowCurrencyCode;

  /// No description provided for @customizationData24HourTime.
  ///
  /// In ru, this message translates to:
  /// **'24-часовой формат'**
  String get customizationData24HourTime;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
