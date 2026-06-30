import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_it.dart';
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
    Locale('de'),
    Locale('en'),
    Locale('it'),
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
  /// **'Чаты'**
  String get tabMessages;

  /// No description provided for @tabArticles.
  ///
  /// In ru, this message translates to:
  /// **'Статьи'**
  String get tabArticles;

  /// No description provided for @tabCommunity.
  ///
  /// In ru, this message translates to:
  /// **'Сообщество'**
  String get tabCommunity;

  /// No description provided for @tabSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get tabSettings;

  /// No description provided for @tabProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get tabProfile;

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

  /// No description provided for @errorDataTitle.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить'**
  String get errorDataTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось подключиться к серверу данных. Проверьте интернет и попробуйте снова.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In ru, this message translates to:
  /// **'Сервер не ответил вовремя. Попробуйте позже.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In ru, this message translates to:
  /// **'Сервис временно недоступен. Попробуйте позже.'**
  String get errorServer;

  /// No description provided for @errorNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Данные не найдены.'**
  String get errorNotFound;

  /// No description provided for @errorRateLimit.
  ///
  /// In ru, this message translates to:
  /// **'Слишком много запросов. Подождите минуту.'**
  String get errorRateLimit;

  /// No description provided for @errorDataUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Данные временно недоступны.'**
  String get errorDataUnavailable;

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
  /// **'Выберите аватар или загрузите своё фото'**
  String get profileAvatarHint;

  /// No description provided for @profileAvatarPickPhoto.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить фото'**
  String get profileAvatarPickPhoto;

  /// No description provided for @profileAvatarRemovePhoto.
  ///
  /// In ru, this message translates to:
  /// **'Убрать фото'**
  String get profileAvatarRemovePhoto;

  /// No description provided for @profileAvatarPickFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обработать изображение'**
  String get profileAvatarPickFailed;

  /// No description provided for @profileAvatarPickSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Фото аватара обновлено'**
  String get profileAvatarPickSuccess;

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

  /// No description provided for @profileEmail.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileEmailHint.
  ///
  /// In ru, this message translates to:
  /// **'example@mail.ru'**
  String get profileEmailHint;

  /// No description provided for @profilePhone.
  ///
  /// In ru, this message translates to:
  /// **'Телефон'**
  String get profilePhone;

  /// No description provided for @profilePhoneHint.
  ///
  /// In ru, this message translates to:
  /// **'+7 (999) 000-00-00'**
  String get profilePhoneHint;

  /// No description provided for @profileHubAccountsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мои счета'**
  String get profileHubAccountsTitle;

  /// No description provided for @profileHubAccountPortfolio.
  ///
  /// In ru, this message translates to:
  /// **'Бумажный портфель'**
  String get profileHubAccountPortfolio;

  /// No description provided for @profileHubAccountWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get profileHubAccountWatchlist;

  /// No description provided for @profileHubAccountAlerts.
  ///
  /// In ru, this message translates to:
  /// **'Ценовые алерты'**
  String get profileHubAccountAlerts;

  /// No description provided for @profileHubAccountCash.
  ///
  /// In ru, this message translates to:
  /// **'Свободные средства'**
  String get profileHubAccountCash;

  /// No description provided for @profileHubAccountCashSub.
  ///
  /// In ru, this message translates to:
  /// **'Доступно для сделок'**
  String get profileHubAccountCashSub;

  /// No description provided for @profileHubPortfolioEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет открытых позиций'**
  String get profileHubPortfolioEmpty;

  /// No description provided for @profileHubQuickBackup.
  ///
  /// In ru, this message translates to:
  /// **'Бэкап'**
  String get profileHubQuickBackup;

  /// No description provided for @profileHubQuickSecurity.
  ///
  /// In ru, this message translates to:
  /// **'Защита'**
  String get profileHubQuickSecurity;

  /// No description provided for @profileHubQuickSync.
  ///
  /// In ru, this message translates to:
  /// **'Синхр.'**
  String get profileHubQuickSync;

  /// No description provided for @profileHubQuickCustomize.
  ///
  /// In ru, this message translates to:
  /// **'Стиль'**
  String get profileHubQuickCustomize;

  /// No description provided for @profileHubSectionProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileHubSectionProfile;

  /// No description provided for @profileHubSectionFinance.
  ///
  /// In ru, this message translates to:
  /// **'Финансы'**
  String get profileHubSectionFinance;

  /// No description provided for @profileHubSectionSecurity.
  ///
  /// In ru, this message translates to:
  /// **'Безопасность и данные'**
  String get profileHubSectionSecurity;

  /// No description provided for @profileHubSectionApp.
  ///
  /// In ru, this message translates to:
  /// **'Приложение'**
  String get profileHubSectionApp;

  /// No description provided for @profileHubPersonalData.
  ///
  /// In ru, this message translates to:
  /// **'Личные данные'**
  String get profileHubPersonalData;

  /// No description provided for @profileHubPersonalDataSub.
  ///
  /// In ru, this message translates to:
  /// **'Имя, аватар, email, телефон'**
  String get profileHubPersonalDataSub;

  /// No description provided for @profileHubServerAccount.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт сервера'**
  String get profileHubServerAccount;

  /// No description provided for @profileHubServerIntro.
  ///
  /// In ru, this message translates to:
  /// **'Вход на домашний сервер EcoPulse для чатов и синхронизации профиля.'**
  String get profileHubServerIntro;

  /// No description provided for @profileHubMessages.
  ///
  /// In ru, this message translates to:
  /// **'Сообщения'**
  String get profileHubMessages;

  /// No description provided for @profileHubArticles.
  ///
  /// In ru, this message translates to:
  /// **'Статьи'**
  String get profileHubArticles;

  /// No description provided for @profileHubPortfolio.
  ///
  /// In ru, this message translates to:
  /// **'Портфель'**
  String get profileHubPortfolio;

  /// No description provided for @profileHubWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'Избранные активы'**
  String get profileHubWatchlist;

  /// No description provided for @profileHubSecurity.
  ///
  /// In ru, this message translates to:
  /// **'Безопасность'**
  String get profileHubSecurity;

  /// No description provided for @profileHubSecuritySub.
  ///
  /// In ru, this message translates to:
  /// **'PIN-код и биометрия'**
  String get profileHubSecuritySub;

  /// No description provided for @profileHubSecurityPinBio.
  ///
  /// In ru, this message translates to:
  /// **'PIN и биометрия'**
  String get profileHubSecurityPinBio;

  /// No description provided for @profileHubSecurityActive.
  ///
  /// In ru, this message translates to:
  /// **'Приложение защищено'**
  String get profileHubSecurityActive;

  /// No description provided for @profileHubSecurityActiveSub.
  ///
  /// In ru, this message translates to:
  /// **'PIN-код включён. Данные под защитой при блокировке экрана.'**
  String get profileHubSecurityActiveSub;

  /// No description provided for @profileHubSecurityInactive.
  ///
  /// In ru, this message translates to:
  /// **'Защита отключена'**
  String get profileHubSecurityInactive;

  /// No description provided for @profileHubSecurityInactiveSub.
  ///
  /// In ru, this message translates to:
  /// **'Включите PIN-код, чтобы скрыть данные при блокировке.'**
  String get profileHubSecurityInactiveSub;

  /// No description provided for @profileHubDocuments.
  ///
  /// In ru, this message translates to:
  /// **'Документы и отчёты'**
  String get profileHubDocuments;

  /// No description provided for @profileHubDocumentsSub.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт, бэкап, недельный отчёт'**
  String get profileHubDocumentsSub;

  /// No description provided for @profileHubDocumentsIntro.
  ///
  /// In ru, this message translates to:
  /// **'Сохраните данные приложения или поделитесь отчётом по избранным активам.'**
  String get profileHubDocumentsIntro;

  /// No description provided for @profileHubCloudSync.
  ///
  /// In ru, this message translates to:
  /// **'Облачная синхронизация'**
  String get profileHubCloudSync;

  /// No description provided for @profileHubNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get profileHubNotifications;

  /// No description provided for @profileHubNotificationsSub.
  ///
  /// In ru, this message translates to:
  /// **'Утренний дайджест и алерты'**
  String get profileHubNotificationsSub;

  /// No description provided for @profileHubAppSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки приложения'**
  String get profileHubAppSettings;

  /// No description provided for @profileHubAppSettingsSub.
  ///
  /// In ru, this message translates to:
  /// **'Тема, язык, API, виджет'**
  String get profileHubAppSettingsSub;

  /// No description provided for @profileHubCustomization.
  ///
  /// In ru, this message translates to:
  /// **'Кастомизация'**
  String get profileHubCustomization;

  /// No description provided for @profileHubCourses.
  ///
  /// In ru, this message translates to:
  /// **'Курсы и обучение'**
  String get profileHubCourses;

  /// No description provided for @profileHubAbout.
  ///
  /// In ru, this message translates to:
  /// **'О EcoPulse'**
  String get profileHubAbout;

  /// No description provided for @profileHubVerified.
  ///
  /// In ru, this message translates to:
  /// **'Профиль настроен'**
  String get profileHubVerified;

  /// No description provided for @profileHubServerOnline.
  ///
  /// In ru, this message translates to:
  /// **'Сервер подключён'**
  String get profileHubServerOnline;

  /// No description provided for @profileHubServerOffline.
  ///
  /// In ru, this message translates to:
  /// **'Локальный режим'**
  String get profileHubServerOffline;

  /// No description provided for @profileHubEditProfile.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get profileHubEditProfile;

  /// No description provided for @profileHubPositions.
  ///
  /// In ru, this message translates to:
  /// **'{count} позиций'**
  String profileHubPositions(int count);

  /// No description provided for @profileHubAssets.
  ///
  /// In ru, this message translates to:
  /// **'{count} активов'**
  String profileHubAssets(int count);

  /// No description provided for @profileHubActiveAlerts.
  ///
  /// In ru, this message translates to:
  /// **'{count} алертов'**
  String profileHubActiveAlerts(int count);

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
  /// **'Watchlist, профиль, фото-аватар, календарь с вложениями — JSON'**
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

  /// No description provided for @portfolioLiveBadge.
  ///
  /// In ru, this message translates to:
  /// **'LIVE'**
  String get portfolioLiveBadge;

  /// No description provided for @portfolioLiveUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено {time}'**
  String portfolioLiveUpdated(String time);

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

  /// No description provided for @userCalendarTitle.
  ///
  /// In ru, this message translates to:
  /// **'Календарь событий'**
  String get userCalendarTitle;

  /// No description provided for @userCalendarShare.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться календарём'**
  String get userCalendarShare;

  /// No description provided for @userCalendarShareEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет событий для отправки'**
  String get userCalendarShareEmpty;

  /// No description provided for @userCalendarShareMore.
  ///
  /// In ru, this message translates to:
  /// **'…и ещё {count} событий'**
  String userCalendarShareMore(int count);

  /// No description provided for @userCalendarExportIcs.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт .ics'**
  String get userCalendarExportIcs;

  /// No description provided for @userCalendarExportIcsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет ручных событий для экспорта'**
  String get userCalendarExportIcsEmpty;

  /// No description provided for @userCalendarImportIcs.
  ///
  /// In ru, this message translates to:
  /// **'Импорт .ics'**
  String get userCalendarImportIcs;

  /// No description provided for @userCalendarImportIcsHint.
  ///
  /// In ru, this message translates to:
  /// **'Вставьте текст календаря (.ics)'**
  String get userCalendarImportIcsHint;

  /// No description provided for @userCalendarImportIcsFile.
  ///
  /// In ru, this message translates to:
  /// **'Из файла'**
  String get userCalendarImportIcsFile;

  /// No description provided for @userCalendarImportIcsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'События не найдены в тексте'**
  String get userCalendarImportIcsEmpty;

  /// No description provided for @userCalendarImportIcsDone.
  ///
  /// In ru, this message translates to:
  /// **'Импортировано событий: {count}'**
  String userCalendarImportIcsDone(int count);

  /// No description provided for @userCalendarDuplicateEvent.
  ///
  /// In ru, this message translates to:
  /// **'Дублировать'**
  String get userCalendarDuplicateEvent;

  /// No description provided for @userCalendarViewDetails.
  ///
  /// In ru, this message translates to:
  /// **'Подробнее'**
  String get userCalendarViewDetails;

  /// No description provided for @userCalendarDuplicateDone.
  ///
  /// In ru, this message translates to:
  /// **'Событие скопировано'**
  String get userCalendarDuplicateDone;

  /// No description provided for @userCalendarDuplicateSuffix.
  ///
  /// In ru, this message translates to:
  /// **' (копия)'**
  String get userCalendarDuplicateSuffix;

  /// No description provided for @userCalendarDayEvents.
  ///
  /// In ru, this message translates to:
  /// **'События на {date}'**
  String userCalendarDayEvents(String date);

  /// No description provided for @userCalendarSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Ваши события и поступления по портфелю'**
  String get userCalendarSubtitle;

  /// No description provided for @userCalendarAddEvent.
  ///
  /// In ru, this message translates to:
  /// **'Добавить событие'**
  String get userCalendarAddEvent;

  /// No description provided for @userCalendarEditEvent.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать событие'**
  String get userCalendarEditEvent;

  /// No description provided for @userCalendarShowPortfolio.
  ///
  /// In ru, this message translates to:
  /// **'События портфеля'**
  String get userCalendarShowPortfolio;

  /// No description provided for @userCalendarShowPortfolioHint.
  ///
  /// In ru, this message translates to:
  /// **'Купоны, дивиденды и погашения из бумажного портфеля'**
  String get userCalendarShowPortfolioHint;

  /// No description provided for @userCalendarHorizon30.
  ///
  /// In ru, this message translates to:
  /// **'30 дн.'**
  String get userCalendarHorizon30;

  /// No description provided for @userCalendarHorizon90.
  ///
  /// In ru, this message translates to:
  /// **'90 дн.'**
  String get userCalendarHorizon90;

  /// No description provided for @userCalendarHorizon365.
  ///
  /// In ru, this message translates to:
  /// **'1 год'**
  String get userCalendarHorizon365;

  /// No description provided for @userCalendarTotalsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Суммы за период'**
  String get userCalendarTotalsTitle;

  /// No description provided for @userCalendarTotalsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет сумм в выбранном периоде'**
  String get userCalendarTotalsEmpty;

  /// No description provided for @userCalendarByMonth.
  ///
  /// In ru, this message translates to:
  /// **'По месяцам'**
  String get userCalendarByMonth;

  /// No description provided for @userCalendarUpcoming.
  ///
  /// In ru, this message translates to:
  /// **'События'**
  String get userCalendarUpcoming;

  /// No description provided for @userCalendarEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет событий. Нажмите +, чтобы добавить.'**
  String get userCalendarEmpty;

  /// No description provided for @userCalendarManualBadge.
  ///
  /// In ru, this message translates to:
  /// **'Моё'**
  String get userCalendarManualBadge;

  /// No description provided for @userCalendarPortfolioBadge.
  ///
  /// In ru, this message translates to:
  /// **'Портфель'**
  String get userCalendarPortfolioBadge;

  /// No description provided for @userCalendarEstimateBadge.
  ///
  /// In ru, this message translates to:
  /// **'оценка'**
  String get userCalendarEstimateBadge;

  /// No description provided for @userCalendarFieldTitle.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get userCalendarFieldTitle;

  /// No description provided for @userCalendarFieldTitleHint.
  ///
  /// In ru, this message translates to:
  /// **'Например: выплата купона SU26238'**
  String get userCalendarFieldTitleHint;

  /// No description provided for @userCalendarFieldDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get userCalendarFieldDate;

  /// No description provided for @userCalendarFieldAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сумма'**
  String get userCalendarFieldAmount;

  /// No description provided for @userCalendarFieldAmountHint.
  ///
  /// In ru, this message translates to:
  /// **'Необязательно'**
  String get userCalendarFieldAmountHint;

  /// No description provided for @userCalendarFieldCurrency.
  ///
  /// In ru, this message translates to:
  /// **'Валюта'**
  String get userCalendarFieldCurrency;

  /// No description provided for @userCalendarFieldNote.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get userCalendarFieldNote;

  /// No description provided for @userCalendarFieldNoteHint.
  ///
  /// In ru, this message translates to:
  /// **'Комментарий к событию'**
  String get userCalendarFieldNoteHint;

  /// No description provided for @userCalendarAttachFile.
  ///
  /// In ru, this message translates to:
  /// **'Прикрепить файл'**
  String get userCalendarAttachFile;

  /// No description provided for @userCalendarRemoveAttachment.
  ///
  /// In ru, this message translates to:
  /// **'Убрать вложение'**
  String get userCalendarRemoveAttachment;

  /// No description provided for @userCalendarAttachmentFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось прикрепить файл (до 5 МБ, PDF или изображение)'**
  String get userCalendarAttachmentFailed;

  /// No description provided for @userCalendarSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get userCalendarSave;

  /// No description provided for @userCalendarDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get userCalendarDelete;

  /// No description provided for @userCalendarDeleteConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить это событие?'**
  String get userCalendarDeleteConfirm;

  /// No description provided for @userCalendarSaved.
  ///
  /// In ru, this message translates to:
  /// **'Событие сохранено'**
  String get userCalendarSaved;

  /// No description provided for @userCalendarDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Событие удалено'**
  String get userCalendarDeleted;

  /// No description provided for @userCalendarOpenAll.
  ///
  /// In ru, this message translates to:
  /// **'Все события'**
  String get userCalendarOpenAll;

  /// No description provided for @userCalendarViewAttachment.
  ///
  /// In ru, this message translates to:
  /// **'Открыть вложение'**
  String get userCalendarViewAttachment;

  /// No description provided for @userCalendarAttachmentShare.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться'**
  String get userCalendarAttachmentShare;

  /// No description provided for @userCalendarAttachmentPdfSize.
  ///
  /// In ru, this message translates to:
  /// **'{kb} КБ'**
  String userCalendarAttachmentPdfSize(int kb);

  /// No description provided for @userCalendarAttachmentPdfHint.
  ///
  /// In ru, this message translates to:
  /// **'На телефоне откройте PDF через «Поделиться». В веб-версии файл показывается ниже.'**
  String get userCalendarAttachmentPdfHint;

  /// No description provided for @userCalendarFieldRecurrence.
  ///
  /// In ru, this message translates to:
  /// **'Повторение'**
  String get userCalendarFieldRecurrence;

  /// No description provided for @userCalendarRecurrenceNone.
  ///
  /// In ru, this message translates to:
  /// **'Разово'**
  String get userCalendarRecurrenceNone;

  /// No description provided for @userCalendarRecurrenceMonthly.
  ///
  /// In ru, this message translates to:
  /// **'Ежемесячно'**
  String get userCalendarRecurrenceMonthly;

  /// No description provided for @userCalendarRecurrenceYearly.
  ///
  /// In ru, this message translates to:
  /// **'Ежегодно'**
  String get userCalendarRecurrenceYearly;

  /// No description provided for @userCalendarFieldReminders.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания'**
  String get userCalendarFieldReminders;

  /// No description provided for @userCalendarReminderDays.
  ///
  /// In ru, this message translates to:
  /// **'за {days} дн.'**
  String userCalendarReminderDays(int days);

  /// No description provided for @userCalendarHubTitle.
  ///
  /// In ru, this message translates to:
  /// **'Календарь событий'**
  String get userCalendarHubTitle;

  /// No description provided for @userCalendarHubSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Купоны, платежи и ваши напоминания'**
  String get userCalendarHubSubtitle;

  /// No description provided for @userArticlesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Статьи'**
  String get userArticlesTitle;

  /// No description provided for @userArticlesFeedTab.
  ///
  /// In ru, this message translates to:
  /// **'Лента'**
  String get userArticlesFeedTab;

  /// No description provided for @userArticlesMineTab.
  ///
  /// In ru, this message translates to:
  /// **'Мои'**
  String get userArticlesMineTab;

  /// No description provided for @userArticlesWrite.
  ///
  /// In ru, this message translates to:
  /// **'Написать статью'**
  String get userArticlesWrite;

  /// No description provided for @userArticlesWriteHint.
  ///
  /// In ru, this message translates to:
  /// **'Статья отправится на модерацию и появится в ленте после одобрения.'**
  String get userArticlesWriteHint;

  /// No description provided for @userArticlesFieldTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заголовок'**
  String get userArticlesFieldTitle;

  /// No description provided for @userArticlesFieldTitleHint.
  ///
  /// In ru, this message translates to:
  /// **'О чём статья'**
  String get userArticlesFieldTitleHint;

  /// No description provided for @userArticlesFieldBody.
  ///
  /// In ru, this message translates to:
  /// **'Текст'**
  String get userArticlesFieldBody;

  /// No description provided for @userArticlesFieldBodyHint.
  ///
  /// In ru, this message translates to:
  /// **'Markdown: ## заголовок, - список, [ссылка](url)'**
  String get userArticlesFieldBodyHint;

  /// No description provided for @userArticlesDraftRestored.
  ///
  /// In ru, this message translates to:
  /// **'Восстановлен черновик'**
  String get userArticlesDraftRestored;

  /// No description provided for @userArticlesContinueDraft.
  ///
  /// In ru, this message translates to:
  /// **'Есть незавершённый черновик статьи'**
  String get userArticlesContinueDraft;

  /// No description provided for @userArticlesContinueDraftAction.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get userArticlesContinueDraftAction;

  /// No description provided for @userArticlesShareToChat.
  ///
  /// In ru, this message translates to:
  /// **'В чат «Себе»'**
  String get userArticlesShareToChat;

  /// No description provided for @userArticlesShareToChatDone.
  ///
  /// In ru, this message translates to:
  /// **'Статья отправлена в чат «Себе»'**
  String get userArticlesShareToChatDone;

  /// No description provided for @userArticlesShareToChatFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отправить в чат'**
  String get userArticlesShareToChatFailed;

  /// No description provided for @userArticlesDetailMenu.
  ///
  /// In ru, this message translates to:
  /// **'Действия со статьёй'**
  String get userArticlesDetailMenu;

  /// No description provided for @userArticlesDraftClear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get userArticlesDraftClear;

  /// No description provided for @userArticlesDraftCleared.
  ///
  /// In ru, this message translates to:
  /// **'Черновик удалён'**
  String get userArticlesDraftCleared;

  /// No description provided for @userArticlesMarkdownHeading.
  ///
  /// In ru, this message translates to:
  /// **'Заголовок'**
  String get userArticlesMarkdownHeading;

  /// No description provided for @userArticlesMarkdownList.
  ///
  /// In ru, this message translates to:
  /// **'Список'**
  String get userArticlesMarkdownList;

  /// No description provided for @userArticlesMarkdownLink.
  ///
  /// In ru, this message translates to:
  /// **'Ссылка'**
  String get userArticlesMarkdownLink;

  /// No description provided for @userArticlesSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Отправить на модерацию'**
  String get userArticlesSubmit;

  /// No description provided for @userArticlesSubmitted.
  ///
  /// In ru, this message translates to:
  /// **'Статья отправлена на модерацию'**
  String get userArticlesSubmitted;

  /// No description provided for @userArticlesNeedLogin.
  ///
  /// In ru, this message translates to:
  /// **'Войдите в аккаунт сервера, чтобы читать и писать статьи'**
  String get userArticlesNeedLogin;

  /// No description provided for @userArticlesFeedEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет опубликованных статей'**
  String get userArticlesFeedEmpty;

  /// No description provided for @userArticlesMineEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Вы ещё не отправляли статей'**
  String get userArticlesMineEmpty;

  /// No description provided for @userArticlesDetailTitle.
  ///
  /// In ru, this message translates to:
  /// **'Статья'**
  String get userArticlesDetailTitle;

  /// No description provided for @userArticlesNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Статья не найдена'**
  String get userArticlesNotFound;

  /// No description provided for @userArticlesStatusPending.
  ///
  /// In ru, this message translates to:
  /// **'На модерации'**
  String get userArticlesStatusPending;

  /// No description provided for @userArticlesStatusApproved.
  ///
  /// In ru, this message translates to:
  /// **'Опубликовано'**
  String get userArticlesStatusApproved;

  /// No description provided for @userArticlesStatusRejected.
  ///
  /// In ru, this message translates to:
  /// **'Отклонено'**
  String get userArticlesStatusRejected;

  /// No description provided for @userArticlesRejectReason.
  ///
  /// In ru, this message translates to:
  /// **'Причина отклонения'**
  String get userArticlesRejectReason;

  /// No description provided for @userArticlesModerationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Модерация статей'**
  String get userArticlesModerationTitle;

  /// No description provided for @userArticlesModerationHubSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Одобрение и отклонение статей пользователей'**
  String get userArticlesModerationHubSubtitle;

  /// No description provided for @userArticlesModerationNeedLogin.
  ///
  /// In ru, this message translates to:
  /// **'Войдите на сервер для модерации'**
  String get userArticlesModerationNeedLogin;

  /// No description provided for @userArticlesModerationNotAdmin.
  ///
  /// In ru, this message translates to:
  /// **'Нужны права администратора на сервере'**
  String get userArticlesModerationNotAdmin;

  /// No description provided for @userArticlesModerationEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет статей на модерации'**
  String get userArticlesModerationEmpty;

  /// No description provided for @userArticlesModerationOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть'**
  String get userArticlesModerationOpen;

  /// No description provided for @userArticlesModerationApprove.
  ///
  /// In ru, this message translates to:
  /// **'Одобрить'**
  String get userArticlesModerationApprove;

  /// No description provided for @userArticlesModerationReject.
  ///
  /// In ru, this message translates to:
  /// **'Отклонить'**
  String get userArticlesModerationReject;

  /// No description provided for @userArticlesModerationApproved.
  ///
  /// In ru, this message translates to:
  /// **'Статья опубликована'**
  String get userArticlesModerationApproved;

  /// No description provided for @userArticlesModerationRejected.
  ///
  /// In ru, this message translates to:
  /// **'Статья отклонена'**
  String get userArticlesModerationRejected;

  /// No description provided for @userArticlesErrorNeedLogin.
  ///
  /// In ru, this message translates to:
  /// **'Войдите на сервер, чтобы работать со статьями'**
  String get userArticlesErrorNeedLogin;

  /// No description provided for @userArticlesErrorUnauthorized.
  ///
  /// In ru, this message translates to:
  /// **'Сессия истекла — войдите снова'**
  String get userArticlesErrorUnauthorized;

  /// No description provided for @userArticlesErrorForbidden.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно прав для этого действия'**
  String get userArticlesErrorForbidden;

  /// No description provided for @userArticlesErrorNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Статья не найдена на сервере'**
  String get userArticlesErrorNotFound;

  /// No description provided for @userArticlesErrorTitleRequired.
  ///
  /// In ru, this message translates to:
  /// **'Укажите заголовок статьи'**
  String get userArticlesErrorTitleRequired;

  /// No description provided for @userArticlesErrorBodyRequired.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте текст статьи'**
  String get userArticlesErrorBodyRequired;

  /// No description provided for @userArticlesErrorInvalidPayload.
  ///
  /// In ru, this message translates to:
  /// **'Некорректные данные статьи'**
  String get userArticlesErrorInvalidPayload;

  /// No description provided for @userArticlesErrorTitleTooShort.
  ///
  /// In ru, this message translates to:
  /// **'Заголовок слишком короткий'**
  String get userArticlesErrorTitleTooShort;

  /// No description provided for @userArticlesErrorTitleTooLong.
  ///
  /// In ru, this message translates to:
  /// **'Заголовок слишком длинный'**
  String get userArticlesErrorTitleTooLong;

  /// No description provided for @userArticlesErrorBodyTooShort.
  ///
  /// In ru, this message translates to:
  /// **'Текст статьи слишком короткий'**
  String get userArticlesErrorBodyTooShort;

  /// No description provided for @userArticlesErrorBodyTooLong.
  ///
  /// In ru, this message translates to:
  /// **'Текст статьи слишком длинный'**
  String get userArticlesErrorBodyTooLong;

  /// No description provided for @userArticlesErrorInvalidStatus.
  ///
  /// In ru, this message translates to:
  /// **'Нельзя изменить статью в этом статусе'**
  String get userArticlesErrorInvalidStatus;

  /// No description provided for @userArticlesErrorServer.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось связаться с сервером статей'**
  String get userArticlesErrorServer;

  /// No description provided for @userArticlesNotifyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Статус статей'**
  String get userArticlesNotifyTitle;

  /// No description provided for @userArticlesNotifySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Уведомление при одобрении или отклонении вашей статьи'**
  String get userArticlesNotifySubtitle;

  /// No description provided for @userArticlesShare.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться статьёй'**
  String get userArticlesShare;

  /// No description provided for @userArticlesSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по заголовку или автору'**
  String get userArticlesSearchHint;

  /// No description provided for @userArticlesSearchEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get userArticlesSearchEmpty;

  /// No description provided for @userArticlesReadingTime.
  ///
  /// In ru, this message translates to:
  /// **'{minutes} мин чтения'**
  String userArticlesReadingTime(int minutes);

  /// No description provided for @userArticlesCopy.
  ///
  /// In ru, this message translates to:
  /// **'Копировать'**
  String get userArticlesCopy;

  /// No description provided for @userArticlesCopied.
  ///
  /// In ru, this message translates to:
  /// **'Текст статьи скопирован'**
  String get userArticlesCopied;

  /// No description provided for @userArticlesStaleCache.
  ///
  /// In ru, this message translates to:
  /// **'Показаны сохранённые статьи — сервер недоступен'**
  String get userArticlesStaleCache;

  /// No description provided for @userArticlesSortLabel.
  ///
  /// In ru, this message translates to:
  /// **'Сортировка:'**
  String get userArticlesSortLabel;

  /// No description provided for @userArticlesSortNewest.
  ///
  /// In ru, this message translates to:
  /// **'Новые'**
  String get userArticlesSortNewest;

  /// No description provided for @userArticlesSortOldest.
  ///
  /// In ru, this message translates to:
  /// **'Старые'**
  String get userArticlesSortOldest;

  /// No description provided for @userArticlesFilterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get userArticlesFilterAll;

  /// No description provided for @userArticlesResubmit.
  ///
  /// In ru, this message translates to:
  /// **'Отправить снова'**
  String get userArticlesResubmit;

  /// No description provided for @userArticlesEdit.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get userArticlesEdit;

  /// No description provided for @userArticlesSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get userArticlesSave;

  /// No description provided for @userArticlesUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Статья обновлена'**
  String get userArticlesUpdated;

  /// No description provided for @userArticlesDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get userArticlesDelete;

  /// No description provided for @userArticlesDeleteConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить эту статью? Действие нельзя отменить.'**
  String get userArticlesDeleteConfirm;

  /// No description provided for @userArticlesDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Статья удалена'**
  String get userArticlesDeleted;

  /// No description provided for @userArticlesBookmark.
  ///
  /// In ru, this message translates to:
  /// **'В закладки'**
  String get userArticlesBookmark;

  /// No description provided for @userArticlesLoadMore.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить ещё'**
  String get userArticlesLoadMore;

  /// No description provided for @userArticlesShareBookmarks.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться закладками'**
  String get userArticlesShareBookmarks;

  /// No description provided for @userArticlesShareBookmarksEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет закладок для отправки'**
  String get userArticlesShareBookmarksEmpty;

  /// No description provided for @userArticlesUnreadOnly.
  ///
  /// In ru, this message translates to:
  /// **'Непрочитанные'**
  String get userArticlesUnreadOnly;

  /// No description provided for @userArticlesMarkAllRead.
  ///
  /// In ru, this message translates to:
  /// **'Прочитать все'**
  String get userArticlesMarkAllRead;

  /// No description provided for @userArticlesMarkRead.
  ///
  /// In ru, this message translates to:
  /// **'Отметить прочитанным'**
  String get userArticlesMarkRead;

  /// No description provided for @userArticlesMarkUnread.
  ///
  /// In ru, this message translates to:
  /// **'Отметить непрочитанным'**
  String get userArticlesMarkUnread;

  /// No description provided for @userArticlesSavedOnly.
  ///
  /// In ru, this message translates to:
  /// **'Закладки'**
  String get userArticlesSavedOnly;

  /// No description provided for @userArticlesAuthorFilter.
  ///
  /// In ru, this message translates to:
  /// **'Автор: {name}'**
  String userArticlesAuthorFilter(String name);

  /// No description provided for @userArticlesDetailStaleCache.
  ///
  /// In ru, this message translates to:
  /// **'Показана сохранённая версия — сервер недоступен'**
  String get userArticlesDetailStaleCache;

  /// No description provided for @userCalendarImportFromPortfolio.
  ///
  /// In ru, this message translates to:
  /// **'Добавить в календарь'**
  String get userCalendarImportFromPortfolio;

  /// No description provided for @userCalendarImportFromPortfolioDone.
  ///
  /// In ru, this message translates to:
  /// **'Событие добавлено в календарь'**
  String get userCalendarImportFromPortfolioDone;

  /// No description provided for @userCalendarImportPortfolioBatch.
  ///
  /// In ru, this message translates to:
  /// **'Импорт событий портфеля'**
  String get userCalendarImportPortfolioBatch;

  /// No description provided for @userCalendarImportPortfolioBatchConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Импортировать {count} событий портфеля в календарь?'**
  String userCalendarImportPortfolioBatchConfirm(int count);

  /// No description provided for @userCalendarImportPortfolioBatchDone.
  ///
  /// In ru, this message translates to:
  /// **'Импортировано событий: {count}'**
  String userCalendarImportPortfolioBatchDone(int count);

  /// No description provided for @userCalendarImportPortfolioBatchEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Все события портфеля уже в календаре'**
  String get userCalendarImportPortfolioBatchEmpty;

  /// No description provided for @userCalendarImportPortfolioEstimateNote.
  ///
  /// In ru, this message translates to:
  /// **'Оценка по портфелю'**
  String get userCalendarImportPortfolioEstimateNote;

  /// No description provided for @userLocalDataSyncTitle.
  ///
  /// In ru, this message translates to:
  /// **'Синхронизация данных устройства'**
  String get userLocalDataSyncTitle;

  /// No description provided for @userLocalDataSyncSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Аватар, календарь, закладки, прочитанное, настройки чатов и черновик статьи'**
  String get userLocalDataSyncSubtitle;

  /// No description provided for @userLocalDataSyncPush.
  ///
  /// In ru, this message translates to:
  /// **'На сервер'**
  String get userLocalDataSyncPush;

  /// No description provided for @userLocalDataSyncPull.
  ///
  /// In ru, this message translates to:
  /// **'С устройства'**
  String get userLocalDataSyncPull;

  /// No description provided for @userLocalDataSyncSmart.
  ///
  /// In ru, this message translates to:
  /// **'Умная синхронизация'**
  String get userLocalDataSyncSmart;

  /// No description provided for @userLocalDataSyncPushed.
  ///
  /// In ru, this message translates to:
  /// **'Данные отправлены на сервер'**
  String get userLocalDataSyncPushed;

  /// No description provided for @userLocalDataSyncPulled.
  ///
  /// In ru, this message translates to:
  /// **'Данные загружены с сервера'**
  String get userLocalDataSyncPulled;

  /// No description provided for @userLocalDataSyncDone.
  ///
  /// In ru, this message translates to:
  /// **'Синхронизация завершена'**
  String get userLocalDataSyncDone;

  /// No description provided for @userLocalDataSyncLast.
  ///
  /// In ru, this message translates to:
  /// **'Последняя синхронизация: {date}'**
  String userLocalDataSyncLast(DateTime date);

  /// No description provided for @userLocalDataSyncWifiOnly.
  ///
  /// In ru, this message translates to:
  /// **'Только по Wi‑Fi'**
  String get userLocalDataSyncWifiOnly;

  /// No description provided for @userLocalDataSyncWifiOnlySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Автосинхронизация при входе и возврате в приложение'**
  String get userLocalDataSyncWifiOnlySubtitle;

  /// No description provided for @userLocalDataSyncConflictTitle.
  ///
  /// In ru, this message translates to:
  /// **'Конфликт данных'**
  String get userLocalDataSyncConflictTitle;

  /// No description provided for @userLocalDataSyncConflictMessage.
  ///
  /// In ru, this message translates to:
  /// **'На сервере и на устройстве разные версии календаря, аватара и настроек сообщества. Что оставить?'**
  String get userLocalDataSyncConflictMessage;

  /// No description provided for @userLocalDataSyncKeepLocal.
  ///
  /// In ru, this message translates to:
  /// **'На устройстве'**
  String get userLocalDataSyncKeepLocal;

  /// No description provided for @userLocalDataSyncUseRemote.
  ///
  /// In ru, this message translates to:
  /// **'С сервера'**
  String get userLocalDataSyncUseRemote;

  /// No description provided for @userLocalDataSyncAutoPush.
  ///
  /// In ru, this message translates to:
  /// **'Автоотправка на сервер'**
  String get userLocalDataSyncAutoPush;

  /// No description provided for @userLocalDataSyncAutoPushSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'После изменения календаря, аватара или настроек сообщества (с задержкой 2 с)'**
  String get userLocalDataSyncAutoPushSubtitle;

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

  /// No description provided for @portfolioTradeJournalImport.
  ///
  /// In ru, this message translates to:
  /// **'Импорт CSV'**
  String get portfolioTradeJournalImport;

  /// No description provided for @portfolioTradeJournalImportHint.
  ///
  /// In ru, this message translates to:
  /// **'Вставьте CSV из EcoPulse или экспорт брокера'**
  String get portfolioTradeJournalImportHint;

  /// No description provided for @portfolioTradeJournalImportEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В файле не найдено сделок'**
  String get portfolioTradeJournalImportEmpty;

  /// No description provided for @portfolioTradeJournalImportDone.
  ///
  /// In ru, this message translates to:
  /// **'Импортировано {added} · пропущено {skipped}'**
  String portfolioTradeJournalImportDone(int added, int skipped);

  /// No description provided for @portfolioTradeJournalImportError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка импорта: {error}'**
  String portfolioTradeJournalImportError(String error);

  /// No description provided for @portfolioTaxTitle.
  ///
  /// In ru, this message translates to:
  /// **'Оценка налога'**
  String get portfolioTaxTitle;

  /// No description provided for @portfolioTaxSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Локальный расчёт НДФЛ по журналу · не налоговая консультация'**
  String get portfolioTaxSubtitle;

  /// No description provided for @portfolioTaxOpenDetails.
  ///
  /// In ru, this message translates to:
  /// **'Подробнее'**
  String get portfolioTaxOpenDetails;

  /// No description provided for @portfolioTaxExport.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт CSV'**
  String get portfolioTaxExport;

  /// No description provided for @portfolioTaxEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет налогооблагаемых событий за этот год'**
  String get portfolioTaxEmpty;

  /// No description provided for @portfolioTaxNetRealized.
  ///
  /// In ru, this message translates to:
  /// **'Чистая реализованная P&L'**
  String get portfolioTaxNetRealized;

  /// No description provided for @portfolioTaxEstimatedNdfl.
  ///
  /// In ru, this message translates to:
  /// **'Оценка НДФЛ'**
  String get portfolioTaxEstimatedNdfl;

  /// No description provided for @portfolioTaxPassiveIncome.
  ///
  /// In ru, this message translates to:
  /// **'Оценка купонов и дивидендов'**
  String get portfolioTaxPassiveIncome;

  /// No description provided for @portfolioTaxPassiveTax.
  ///
  /// In ru, this message translates to:
  /// **'НДФЛ на пассивный доход'**
  String get portfolioTaxPassiveTax;

  /// No description provided for @portfolioTaxRealizedGain.
  ///
  /// In ru, this message translates to:
  /// **'Реализованная прибыль'**
  String get portfolioTaxRealizedGain;

  /// No description provided for @portfolioTaxRealizedLoss.
  ///
  /// In ru, this message translates to:
  /// **'Реализованный убыток'**
  String get portfolioTaxRealizedLoss;

  /// No description provided for @portfolioTaxTaxableBase.
  ///
  /// In ru, this message translates to:
  /// **'Налоговая база'**
  String get portfolioTaxTaxableBase;

  /// No description provided for @portfolioTaxSellCount.
  ///
  /// In ru, this message translates to:
  /// **'Продаж'**
  String get portfolioTaxSellCount;

  /// No description provided for @portfolioTaxUnrealizedGain.
  ///
  /// In ru, this message translates to:
  /// **'Нереализованная прибыль (справ.)'**
  String get portfolioTaxUnrealizedGain;

  /// No description provided for @portfolioTaxUnrealizedLoss.
  ///
  /// In ru, this message translates to:
  /// **'Нереализованный убыток (справ.)'**
  String get portfolioTaxUnrealizedLoss;

  /// No description provided for @portfolioTaxSectionTrading.
  ///
  /// In ru, this message translates to:
  /// **'Доход от сделок'**
  String get portfolioTaxSectionTrading;

  /// No description provided for @portfolioTaxSectionPassive.
  ///
  /// In ru, this message translates to:
  /// **'Купоны и дивиденды (оценка)'**
  String get portfolioTaxSectionPassive;

  /// No description provided for @portfolioTaxSectionUnrealized.
  ///
  /// In ru, this message translates to:
  /// **'Открытые позиции'**
  String get portfolioTaxSectionUnrealized;

  /// No description provided for @portfolioTaxTotalLabel.
  ///
  /// In ru, this message translates to:
  /// **'Итого оценка налога'**
  String get portfolioTaxTotalLabel;

  /// No description provided for @portfolioTaxRateLabel.
  ///
  /// In ru, this message translates to:
  /// **'Ставка {rate}% · упрощённо'**
  String portfolioTaxRateLabel(String rate);

  /// No description provided for @portfolioTaxIisNote.
  ///
  /// In ru, this message translates to:
  /// **'Счёт ИИС: налог может быть снижен по типу А/Б — уточните у брокера.'**
  String get portfolioTaxIisNote;

  /// No description provided for @portfolioTaxDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'Только для обучения. Ставки, льготы и правила ИИС меняются. EcoPulse не подаёт декларацию.'**
  String get portfolioTaxDisclaimer;

  /// No description provided for @portfolioTaxSellsHeader.
  ///
  /// In ru, this message translates to:
  /// **'Продажи за год'**
  String get portfolioTaxSellsHeader;

  /// No description provided for @portfolioTaxSellPnl.
  ///
  /// In ru, this message translates to:
  /// **'P&L: {value}'**
  String portfolioTaxSellPnl(String value);

  /// No description provided for @portfolioRoboTitle.
  ///
  /// In ru, this message translates to:
  /// **'Robo-advisor lite'**
  String get portfolioRoboTitle;

  /// No description provided for @portfolioRoboSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Рекомендация аллокации по типу счёта, целям и настроению рынка'**
  String get portfolioRoboSubtitle;

  /// No description provided for @portfolioRoboRecommended.
  ///
  /// In ru, this message translates to:
  /// **'Рекомендуем: {preset}'**
  String portfolioRoboRecommended(String preset);

  /// No description provided for @portfolioRoboRiskScore.
  ///
  /// In ru, this message translates to:
  /// **'Профиль риска: {score}/100'**
  String portfolioRoboRiskScore(int score);

  /// No description provided for @portfolioRoboActionsHeader.
  ///
  /// In ru, this message translates to:
  /// **'Приоритетные действия'**
  String get portfolioRoboActionsHeader;

  /// No description provided for @portfolioRoboApplyPreset.
  ///
  /// In ru, this message translates to:
  /// **'Применить «{preset}»'**
  String portfolioRoboApplyPreset(String preset);

  /// No description provided for @portfolioRoboDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'Только для обучения. Не инвестиционная рекомендация.'**
  String get portfolioRoboDisclaimer;

  /// No description provided for @portfolioRoboReasonIis.
  ///
  /// In ru, this message translates to:
  /// **'Счёт ИИС — длинный горизонт, больше облигаций и стабильности'**
  String get portfolioRoboReasonIis;

  /// No description provided for @portfolioRoboReasonCrypto.
  ///
  /// In ru, this message translates to:
  /// **'Crypto-счёт — выше доля крипты и роста'**
  String get portfolioRoboReasonCrypto;

  /// No description provided for @portfolioRoboReasonUsd.
  ///
  /// In ru, this message translates to:
  /// **'USD-счёт — сбалансированный микс с global stocks'**
  String get portfolioRoboReasonUsd;

  /// No description provided for @portfolioRoboReasonShortGoal.
  ///
  /// In ru, this message translates to:
  /// **'Цель менее 2 лет — снижаем риск'**
  String get portfolioRoboReasonShortGoal;

  /// No description provided for @portfolioRoboReasonLongGoal.
  ///
  /// In ru, this message translates to:
  /// **'Долгая цель — можно добавить рост'**
  String get portfolioRoboReasonLongGoal;

  /// No description provided for @portfolioRoboReasonFngHigh.
  ///
  /// In ru, this message translates to:
  /// **'Fear & Greed высокий — осторожнее, без FOMO'**
  String get portfolioRoboReasonFngHigh;

  /// No description provided for @portfolioRoboReasonFngLow.
  ///
  /// In ru, this message translates to:
  /// **'Страх на рынке — дисциплина, без паники'**
  String get portfolioRoboReasonFngLow;

  /// No description provided for @portfolioRoboReasonEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пустой портфель — начните со сбалансированного микса'**
  String get portfolioRoboReasonEmpty;

  /// No description provided for @portfolioRoboReasonHighCash.
  ///
  /// In ru, this message translates to:
  /// **'Много кэша — можно инвестировать излишки'**
  String get portfolioRoboReasonHighCash;

  /// No description provided for @portfolioRoboReasonHighCrypto.
  ///
  /// In ru, this message translates to:
  /// **'Перевес крипты — ребаланс в акции и облигации'**
  String get portfolioRoboReasonHighCrypto;

  /// No description provided for @portfolioRoboReasonDefault.
  ///
  /// In ru, this message translates to:
  /// **'Сбалансированный микс под ваш профиль'**
  String get portfolioRoboReasonDefault;

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

  /// No description provided for @cloudAccountTitle.
  ///
  /// In ru, this message translates to:
  /// **'EcoPulse Cloud'**
  String get cloudAccountTitle;

  /// No description provided for @cloudAccountSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Синхронизация профиля и watchlist через Supabase'**
  String get cloudAccountSubtitle;

  /// No description provided for @cloudAccountNotConfigured.
  ///
  /// In ru, this message translates to:
  /// **'Соберите с --dart-define=SUPABASE_URL и SUPABASE_ANON_KEY для облачной синхронизации.'**
  String get cloudAccountNotConfigured;

  /// No description provided for @cloudEmailLabel.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get cloudEmailLabel;

  /// No description provided for @cloudPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get cloudPasswordLabel;

  /// No description provided for @cloudLogin.
  ///
  /// In ru, this message translates to:
  /// **'Вход'**
  String get cloudLogin;

  /// No description provided for @cloudRegister.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get cloudRegister;

  /// No description provided for @cloudSignInGoogle.
  ///
  /// In ru, this message translates to:
  /// **'Войти через Google'**
  String get cloudSignInGoogle;

  /// No description provided for @cloudSwitchToLogin.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт? Войти'**
  String get cloudSwitchToLogin;

  /// No description provided for @cloudSwitchToRegister.
  ///
  /// In ru, this message translates to:
  /// **'Новый пользователь? Зарегистрироваться'**
  String get cloudSwitchToRegister;

  /// No description provided for @cloudLoginSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Вход в EcoPulse Cloud выполнен'**
  String get cloudLoginSuccess;

  /// No description provided for @cloudRegisterSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт создан — проверьте email, если нужно подтверждение'**
  String get cloudRegisterSuccess;

  /// No description provided for @cloudLoggedOut.
  ///
  /// In ru, this message translates to:
  /// **'Выход из облака'**
  String get cloudLoggedOut;

  /// No description provided for @cloudLoggedInAs.
  ///
  /// In ru, this message translates to:
  /// **'Вход: {email}'**
  String cloudLoggedInAs(String email);

  /// No description provided for @cloudLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get cloudLogout;

  /// No description provided for @cloudSyncPush.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить'**
  String get cloudSyncPush;

  /// No description provided for @cloudSyncPull.
  ///
  /// In ru, this message translates to:
  /// **'Скачать'**
  String get cloudSyncPull;

  /// No description provided for @cloudSyncPushSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Профиль и watchlist загружены в облако'**
  String get cloudSyncPushSuccess;

  /// No description provided for @cloudSyncPullSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Профиль и watchlist скачаны'**
  String get cloudSyncPullSuccess;

  /// No description provided for @cloudSyncFailed.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка облачной синхронизации'**
  String get cloudSyncFailed;

  /// No description provided for @cloudSyncNever.
  ///
  /// In ru, this message translates to:
  /// **'Ещё не синхронизировалось'**
  String get cloudSyncNever;

  /// No description provided for @cloudSyncLastAt.
  ///
  /// In ru, this message translates to:
  /// **'Последняя синхронизация: {time}'**
  String cloudSyncLastAt(String time);

  /// No description provided for @marketsTabletSelectAsset.
  ///
  /// In ru, this message translates to:
  /// **'Выберите актив для просмотра графика'**
  String get marketsTabletSelectAsset;

  /// No description provided for @messagePushTitle.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления о сообщениях'**
  String get messagePushTitle;

  /// No description provided for @messagePushSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Push при новом сообщении на домашнем сервере'**
  String get messagePushSubtitle;

  /// No description provided for @messagePushRequiresServer.
  ///
  /// In ru, this message translates to:
  /// **'Войдите на домашний сервер для push-уведомлений'**
  String get messagePushRequiresServer;

  /// No description provided for @messagePushFcmReady.
  ///
  /// In ru, this message translates to:
  /// **'FCM включён — мгновенная доставка, если сервер шлёт push'**
  String get messagePushFcmReady;

  /// No description provided for @marketsLiveBadge.
  ///
  /// In ru, this message translates to:
  /// **'LIVE'**
  String get marketsLiveBadge;

  /// No description provided for @proTierTitle.
  ///
  /// In ru, this message translates to:
  /// **'EcoPulse Pro'**
  String get proTierTitle;

  /// No description provided for @proTierFreeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Бесплатный план'**
  String get proTierFreeTitle;

  /// No description provided for @proTierActiveTitle.
  ///
  /// In ru, this message translates to:
  /// **'Pro активен'**
  String get proTierActiveTitle;

  /// No description provided for @proTierSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Безлимитные алерты, расширенные графики и экспорт без ограничений.'**
  String get proTierSubtitle;

  /// No description provided for @proTierFreeBadge.
  ///
  /// In ru, this message translates to:
  /// **'Pro — безлимитные алерты'**
  String get proTierFreeBadge;

  /// No description provided for @proTierActiveBadge.
  ///
  /// In ru, this message translates to:
  /// **'Pro-функции включены'**
  String get proTierActiveBadge;

  /// No description provided for @proTierComingSoon.
  ///
  /// In ru, this message translates to:
  /// **'Покупка в приложении скоро. Dev-сборки: включить в Admin panel.'**
  String get proTierComingSoon;

  /// No description provided for @proBenefitAlertsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ценовые алерты'**
  String get proBenefitAlertsTitle;

  /// No description provided for @proBenefitAlertsFree.
  ///
  /// In ru, this message translates to:
  /// **'До {count} активных алертов'**
  String proBenefitAlertsFree(int count);

  /// No description provided for @proBenefitAlertsPro.
  ///
  /// In ru, this message translates to:
  /// **'Безлимитные алерты'**
  String get proBenefitAlertsPro;

  /// No description provided for @proBenefitChartsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Расширенные графики'**
  String get proBenefitChartsTitle;

  /// No description provided for @proBenefitChartsSub.
  ///
  /// In ru, this message translates to:
  /// **'Все периоды MA, индикаторы, полноэкранный режим'**
  String get proBenefitChartsSub;

  /// No description provided for @proBenefitExportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт'**
  String get proBenefitExportTitle;

  /// No description provided for @proBenefitExportSub.
  ///
  /// In ru, this message translates to:
  /// **'CSV/PDF без watermark (скоро)'**
  String get proBenefitExportSub;

  /// No description provided for @proAlertLimitReached.
  ///
  /// In ru, this message translates to:
  /// **'Лимит Free: {count} алертов. Перейдите на Pro.'**
  String proAlertLimitReached(int count);

  /// No description provided for @adminDashboardMetrics.
  ///
  /// In ru, this message translates to:
  /// **'Метрики пользователя'**
  String get adminDashboardMetrics;

  /// No description provided for @adminMetricWatchlist.
  ///
  /// In ru, this message translates to:
  /// **'Watchlist'**
  String get adminMetricWatchlist;

  /// No description provided for @adminMetricAlerts.
  ///
  /// In ru, this message translates to:
  /// **'Алерты'**
  String get adminMetricAlerts;

  /// No description provided for @adminMetricThreads.
  ///
  /// In ru, this message translates to:
  /// **'Чаты'**
  String get adminMetricThreads;

  /// No description provided for @adminMetricPositions.
  ///
  /// In ru, this message translates to:
  /// **'Позиции'**
  String get adminMetricPositions;

  /// No description provided for @adminMetricServer.
  ///
  /// In ru, this message translates to:
  /// **'Сервер'**
  String get adminMetricServer;

  /// No description provided for @adminFlagLiveCrypto.
  ///
  /// In ru, this message translates to:
  /// **'Live crypto WebSocket (Binance)'**
  String get adminFlagLiveCrypto;

  /// No description provided for @adminFlagProTier.
  ///
  /// In ru, this message translates to:
  /// **'EcoPulse Pro (dev unlock)'**
  String get adminFlagProTier;

  /// No description provided for @brokerConnectTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подключить брокера (read-only)'**
  String get brokerConnectTitle;

  /// No description provided for @brokerConnectSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Реальный портфель T-Bank рядом с бумажным'**
  String get brokerConnectSubtitle;

  /// No description provided for @brokerReadOnlyTitle.
  ///
  /// In ru, this message translates to:
  /// **'T-Bank · только просмотр'**
  String get brokerReadOnlyTitle;

  /// No description provided for @brokerReadOnlyDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'Только просмотр — EcoPulse не выставляет заявки и не переводит деньги.'**
  String get brokerReadOnlyDisclaimer;

  /// No description provided for @brokerTokenLabel.
  ///
  /// In ru, this message translates to:
  /// **'T-Invest API токен'**
  String get brokerTokenLabel;

  /// No description provided for @brokerTokenHint.
  ///
  /// In ru, this message translates to:
  /// **'Read-only токен в tbank.ru/invest/settings'**
  String get brokerTokenHint;

  /// No description provided for @brokerRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get brokerRefresh;

  /// No description provided for @brokerAccountLabel.
  ///
  /// In ru, this message translates to:
  /// **'Брокерский счёт'**
  String get brokerAccountLabel;

  /// No description provided for @brokerTotalValue.
  ///
  /// In ru, this message translates to:
  /// **'Итого: {value}'**
  String brokerTotalValue(String value);

  /// No description provided for @brokerSyncedAt.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено: {time}'**
  String brokerSyncedAt(String time);

  /// No description provided for @brokerEmptyPositions.
  ///
  /// In ru, this message translates to:
  /// **'Нет ценных бумаг на счёте'**
  String get brokerEmptyPositions;

  /// No description provided for @brokerMorePositions.
  ///
  /// In ru, this message translates to:
  /// **'ещё {count} позиций'**
  String brokerMorePositions(int count);

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

  /// No description provided for @messagesMarkAllRead.
  ///
  /// In ru, this message translates to:
  /// **'Прочитать все'**
  String get messagesMarkAllRead;

  /// No description provided for @messagesFilterHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по чатам'**
  String get messagesFilterHint;

  /// No description provided for @messagesFilterEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Чаты не найдены'**
  String get messagesFilterEmpty;

  /// No description provided for @messagesUnreadFirst.
  ///
  /// In ru, this message translates to:
  /// **'Непрочитанные сверху'**
  String get messagesUnreadFirst;

  /// No description provided for @messagesUnreadOnly.
  ///
  /// In ru, this message translates to:
  /// **'Только непрочитанные'**
  String get messagesUnreadOnly;

  /// No description provided for @messagesShowHidden.
  ///
  /// In ru, this message translates to:
  /// **'Скрытые ({count})'**
  String messagesShowHidden(int count);

  /// No description provided for @messagesUnhide.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть'**
  String get messagesUnhide;

  /// No description provided for @messagesThreadPin.
  ///
  /// In ru, this message translates to:
  /// **'Закрепить'**
  String get messagesThreadPin;

  /// No description provided for @messagesThreadMenu.
  ///
  /// In ru, this message translates to:
  /// **'Действия с чатом'**
  String get messagesThreadMenu;

  /// No description provided for @messagesThreadSearch.
  ///
  /// In ru, this message translates to:
  /// **'Поиск в чате'**
  String get messagesThreadSearch;

  /// No description provided for @messagesThreadSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по сообщениям…'**
  String get messagesThreadSearchHint;

  /// No description provided for @messagesThreadSearchEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Сообщения не найдены'**
  String get messagesThreadSearchEmpty;

  /// No description provided for @messagesThreadSearchPrev.
  ///
  /// In ru, this message translates to:
  /// **'Предыдущее совпадение'**
  String get messagesThreadSearchPrev;

  /// No description provided for @messagesThreadSearchNext.
  ///
  /// In ru, this message translates to:
  /// **'Следующее совпадение'**
  String get messagesThreadSearchNext;

  /// No description provided for @messagesThreadSearchCounter.
  ///
  /// In ru, this message translates to:
  /// **'{current} / {total}'**
  String messagesThreadSearchCounter(int current, int total);

  /// No description provided for @messagesOpenArticle.
  ///
  /// In ru, this message translates to:
  /// **'Открыть статью'**
  String get messagesOpenArticle;

  /// No description provided for @messagesThreadUnpin.
  ///
  /// In ru, this message translates to:
  /// **'Открепить'**
  String get messagesThreadUnpin;

  /// No description provided for @messagesThreadMute.
  ///
  /// In ru, this message translates to:
  /// **'Без уведомлений'**
  String get messagesThreadMute;

  /// No description provided for @messagesThreadUnmute.
  ///
  /// In ru, this message translates to:
  /// **'Включить уведомления'**
  String get messagesThreadUnmute;

  /// No description provided for @messagesThreadMarkRead.
  ///
  /// In ru, this message translates to:
  /// **'Отметить прочитанным'**
  String get messagesThreadMarkRead;

  /// No description provided for @messagesThreadMarkUnread.
  ///
  /// In ru, this message translates to:
  /// **'Отметить непрочитанным'**
  String get messagesThreadMarkUnread;

  /// No description provided for @messagesThreadHide.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть чат'**
  String get messagesThreadHide;

  /// No description provided for @messagesLoadOlder.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить раньше'**
  String get messagesLoadOlder;

  /// No description provided for @messagesCopyText.
  ///
  /// In ru, this message translates to:
  /// **'Копировать текст'**
  String get messagesCopyText;

  /// No description provided for @messagesShareText.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться текстом'**
  String get messagesShareText;

  /// No description provided for @messagesCopied.
  ///
  /// In ru, this message translates to:
  /// **'Скопировано'**
  String get messagesCopied;

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

  /// No description provided for @customizationPreviewCarouselHint.
  ///
  /// In ru, this message translates to:
  /// **'Свайп: график, главная, рынки, портфель, навигация'**
  String get customizationPreviewCarouselHint;

  /// No description provided for @customizationPreviewSlideChart.
  ///
  /// In ru, this message translates to:
  /// **'График'**
  String get customizationPreviewSlideChart;

  /// No description provided for @customizationPreviewSlideHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get customizationPreviewSlideHome;

  /// No description provided for @customizationPreviewSlideMarkets.
  ///
  /// In ru, this message translates to:
  /// **'Рынки'**
  String get customizationPreviewSlideMarkets;

  /// No description provided for @customizationPreviewSlidePortfolio.
  ///
  /// In ru, this message translates to:
  /// **'Портфель'**
  String get customizationPreviewSlidePortfolio;

  /// No description provided for @customizationPreviewSlideNavigation.
  ///
  /// In ru, this message translates to:
  /// **'Навигация'**
  String get customizationPreviewSlideNavigation;

  /// No description provided for @customizationPreviewCompact.
  ///
  /// In ru, this message translates to:
  /// **'Компакт'**
  String get customizationPreviewCompact;

  /// No description provided for @customizationWidgetPreviewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Превью виджета Android'**
  String get customizationWidgetPreviewTitle;

  /// No description provided for @customizationWidgetPreviewSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Живой макет домашнего виджета с текущими метриками'**
  String get customizationWidgetPreviewSubtitle;

  /// No description provided for @customizationWidgetPreviewAutoHint.
  ///
  /// In ru, this message translates to:
  /// **'Auto: компакт на 4×1, развёрнутый — если виджет выше'**
  String get customizationWidgetPreviewAutoHint;

  /// No description provided for @customizationThemeAbTitle.
  ///
  /// In ru, this message translates to:
  /// **'A/B превью темы'**
  String get customizationThemeAbTitle;

  /// No description provided for @customizationThemeAbSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сравните текущую тему с встроенным пресетом рядом'**
  String get customizationThemeAbSubtitle;

  /// No description provided for @customizationThemeAbCompareWith.
  ///
  /// In ru, this message translates to:
  /// **'Сравнить с'**
  String get customizationThemeAbCompareWith;

  /// No description provided for @customizationThemeAbCurrent.
  ///
  /// In ru, this message translates to:
  /// **'Текущая (A)'**
  String get customizationThemeAbCurrent;

  /// No description provided for @customizationThemeAbApply.
  ///
  /// In ru, this message translates to:
  /// **'Применить тему сравнения'**
  String get customizationThemeAbApply;

  /// No description provided for @customizationThemeAbApplied.
  ///
  /// In ru, this message translates to:
  /// **'Тема «{name}» применена'**
  String customizationThemeAbApplied(String name);

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

  /// No description provided for @customizationPresetsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пресеты'**
  String get customizationPresetsTitle;

  /// No description provided for @customizationPresetsHint.
  ///
  /// In ru, this message translates to:
  /// **'Готовые профили или свои сохранённые настройки'**
  String get customizationPresetsHint;

  /// No description provided for @customizationPresetSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить текущий'**
  String get customizationPresetSave;

  /// No description provided for @customizationPresetSaveDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый пресет'**
  String get customizationPresetSaveDialogTitle;

  /// No description provided for @customizationPresetNameRu.
  ///
  /// In ru, this message translates to:
  /// **'Название (RU)'**
  String get customizationPresetNameRu;

  /// No description provided for @customizationPresetNameEn.
  ///
  /// In ru, this message translates to:
  /// **'Название (EN)'**
  String get customizationPresetNameEn;

  /// No description provided for @customizationPresetExport.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт'**
  String get customizationPresetExport;

  /// No description provided for @customizationPresetImport.
  ///
  /// In ru, this message translates to:
  /// **'Импорт'**
  String get customizationPresetImport;

  /// No description provided for @customizationPresetImportHint.
  ///
  /// In ru, this message translates to:
  /// **'JSON пресета EcoPulse или share-ссылка'**
  String get customizationPresetImportHint;

  /// No description provided for @customizationPresetShareLink.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться ссылкой'**
  String get customizationPresetShareLink;

  /// No description provided for @customizationPresetMarketplaceTitle.
  ///
  /// In ru, this message translates to:
  /// **'Marketplace пресетов'**
  String get customizationPresetMarketplaceTitle;

  /// No description provided for @customizationPresetMarketplaceSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Featured-профили — применить или отправить ссылку'**
  String get customizationPresetMarketplaceSubtitle;

  /// No description provided for @customizationPresetMarketplaceApply.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get customizationPresetMarketplaceApply;

  /// No description provided for @customizationPresetLinkImportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Импорт пресета'**
  String get customizationPresetLinkImportTitle;

  /// No description provided for @customizationPresetLinkImportBody.
  ///
  /// In ru, this message translates to:
  /// **'Установить пресет «{name}» по ссылке?'**
  String customizationPresetLinkImportBody(String name);

  /// No description provided for @customizationPresetLinkImportApply.
  ///
  /// In ru, this message translates to:
  /// **'Установить'**
  String get customizationPresetLinkImportApply;

  /// No description provided for @customizationPresetImportSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Пресет «{name}» добавлен'**
  String customizationPresetImportSuccess(String name);

  /// No description provided for @customizationPresetImportError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось импортировать пресет'**
  String get customizationPresetImportError;

  /// No description provided for @customizationPresetApplied.
  ///
  /// In ru, this message translates to:
  /// **'Пресет «{name}» применён'**
  String customizationPresetApplied(String name);

  /// No description provided for @customizationPresetSaved.
  ///
  /// In ru, this message translates to:
  /// **'Пресет «{name}» сохранён'**
  String customizationPresetSaved(String name);

  /// No description provided for @customizationPresetShareSubject.
  ///
  /// In ru, this message translates to:
  /// **'EcoPulse preset'**
  String get customizationPresetShareSubject;

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

  /// No description provided for @customizationChartVisualTitle.
  ///
  /// In ru, this message translates to:
  /// **'Визуальные опции'**
  String get customizationChartVisualTitle;

  /// No description provided for @customizationChartSeriesPalette.
  ///
  /// In ru, this message translates to:
  /// **'Палитра серий'**
  String get customizationChartSeriesPalette;

  /// No description provided for @customizationChartGridStyle.
  ///
  /// In ru, this message translates to:
  /// **'Стиль сетки'**
  String get customizationChartGridStyle;

  /// No description provided for @customizationChartLineWidth.
  ///
  /// In ru, this message translates to:
  /// **'Толщина линии'**
  String get customizationChartLineWidth;

  /// No description provided for @customizationChartShowGrid.
  ///
  /// In ru, this message translates to:
  /// **'Сетка'**
  String get customizationChartShowGrid;

  /// No description provided for @customizationChartShowGradientFill.
  ///
  /// In ru, this message translates to:
  /// **'Градиент под линией'**
  String get customizationChartShowGradientFill;

  /// No description provided for @customizationChartShowCrosshair.
  ///
  /// In ru, this message translates to:
  /// **'Crosshair при касании'**
  String get customizationChartShowCrosshair;

  /// No description provided for @customizationChartShowEventMarkers.
  ///
  /// In ru, this message translates to:
  /// **'Маркеры событий'**
  String get customizationChartShowEventMarkers;

  /// No description provided for @customizationChartShowPointMarkers.
  ///
  /// In ru, this message translates to:
  /// **'Точки на линии'**
  String get customizationChartShowPointMarkers;

  /// No description provided for @customizationChartAnimateOnLoad.
  ///
  /// In ru, this message translates to:
  /// **'Анимация появления'**
  String get customizationChartAnimateOnLoad;

  /// No description provided for @customizationChartShowVolume.
  ///
  /// In ru, this message translates to:
  /// **'Объём (свечи)'**
  String get customizationChartShowVolume;

  /// No description provided for @customizationChartEnablePanZoom.
  ///
  /// In ru, this message translates to:
  /// **'Масштаб и прокрутка'**
  String get customizationChartEnablePanZoom;

  /// No description provided for @customizationChartPriceAxisRight.
  ///
  /// In ru, this message translates to:
  /// **'Ось цены справа'**
  String get customizationChartPriceAxisRight;

  /// No description provided for @customizationChartContextProfilesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профили по экранам'**
  String get customizationChartContextProfilesTitle;

  /// No description provided for @customizationChartContextProfilesHint.
  ///
  /// In ru, this message translates to:
  /// **'Переопределение типа и периода графика для отдельных экранов.'**
  String get customizationChartContextProfilesHint;

  /// No description provided for @customizationChartUseGlobalDefaults.
  ///
  /// In ru, this message translates to:
  /// **'Глобальные настройки'**
  String get customizationChartUseGlobalDefaults;

  /// No description provided for @customizationChartContextTypeOverride.
  ///
  /// In ru, this message translates to:
  /// **'Тип графика'**
  String get customizationChartContextTypeOverride;

  /// No description provided for @customizationChartContextPeriodOverride.
  ///
  /// In ru, this message translates to:
  /// **'Период'**
  String get customizationChartContextPeriodOverride;

  /// No description provided for @customizationChartContextAssetDetail.
  ///
  /// In ru, this message translates to:
  /// **'Карточка актива'**
  String get customizationChartContextAssetDetail;

  /// No description provided for @customizationChartContextInflation.
  ///
  /// In ru, this message translates to:
  /// **'Инфляция (ИПЦ)'**
  String get customizationChartContextInflation;

  /// No description provided for @customizationChartContextCurrency.
  ///
  /// In ru, this message translates to:
  /// **'Курсы валют'**
  String get customizationChartContextCurrency;

  /// No description provided for @customizationChartContextCompare.
  ///
  /// In ru, this message translates to:
  /// **'Сравнение активов'**
  String get customizationChartContextCompare;

  /// No description provided for @customizationChartContextPortfolio.
  ///
  /// In ru, this message translates to:
  /// **'Аллокация портфеля'**
  String get customizationChartContextPortfolio;

  /// No description provided for @customizationChartContextBonds.
  ///
  /// In ru, this message translates to:
  /// **'Кривая доходности ОФЗ'**
  String get customizationChartContextBonds;

  /// No description provided for @customizationChartContextKeyRate.
  ///
  /// In ru, this message translates to:
  /// **'Ключевая ставка'**
  String get customizationChartContextKeyRate;

  /// No description provided for @customizationChartContextHomeSparkline.
  ///
  /// In ru, this message translates to:
  /// **'Спарклайны на главной'**
  String get customizationChartContextHomeSparkline;

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

  /// No description provided for @customizationUiDensityCompact.
  ///
  /// In ru, this message translates to:
  /// **'Компактно'**
  String get customizationUiDensityCompact;

  /// No description provided for @customizationUiDensityComfortable.
  ///
  /// In ru, this message translates to:
  /// **'Стандарт'**
  String get customizationUiDensityComfortable;

  /// No description provided for @customizationUiDensitySpacious.
  ///
  /// In ru, this message translates to:
  /// **'Просторно'**
  String get customizationUiDensitySpacious;

  /// No description provided for @customizationCardStyleFlat.
  ///
  /// In ru, this message translates to:
  /// **'Плоские'**
  String get customizationCardStyleFlat;

  /// No description provided for @customizationCardStyleGlass.
  ///
  /// In ru, this message translates to:
  /// **'Стекло'**
  String get customizationCardStyleGlass;

  /// No description provided for @customizationCardStyleBordered.
  ///
  /// In ru, this message translates to:
  /// **'С рамкой'**
  String get customizationCardStyleBordered;

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

  /// No description provided for @customizationNavTabOrder.
  ///
  /// In ru, this message translates to:
  /// **'Перетащите, чтобы изменить порядок вкладок'**
  String get customizationNavTabOrder;

  /// No description provided for @customizationNavTabHidden.
  ///
  /// In ru, this message translates to:
  /// **'Скрыта'**
  String get customizationNavTabHidden;

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

  /// No description provided for @customizationMarketsDefaultRegion.
  ///
  /// In ru, this message translates to:
  /// **'Фильтр акций по умолчанию'**
  String get customizationMarketsDefaultRegion;

  /// No description provided for @customizationMarketsRegionAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get customizationMarketsRegionAll;

  /// No description provided for @customizationMarketsRegionRu.
  ///
  /// In ru, this message translates to:
  /// **'MOEX'**
  String get customizationMarketsRegionRu;

  /// No description provided for @customizationMarketsRegionUs.
  ///
  /// In ru, this message translates to:
  /// **'US'**
  String get customizationMarketsRegionUs;

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

  /// No description provided for @customizationSyncTitle.
  ///
  /// In ru, this message translates to:
  /// **'Синхронизация с сервером'**
  String get customizationSyncTitle;

  /// No description provided for @customizationSyncSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Отправка/загрузка кастомизации через home server (LAN)'**
  String get customizationSyncSubtitle;

  /// No description provided for @customizationSyncNotLoggedIn.
  ///
  /// In ru, this message translates to:
  /// **'Войдите в home server для синхронизации'**
  String get customizationSyncNotLoggedIn;

  /// No description provided for @customizationSyncNever.
  ///
  /// In ru, this message translates to:
  /// **'С сервером ещё не синхронизировались'**
  String get customizationSyncNever;

  /// No description provided for @customizationSyncSynced.
  ///
  /// In ru, this message translates to:
  /// **'Кастомизация совпадает с сервером'**
  String get customizationSyncSynced;

  /// No description provided for @customizationSyncLocalNewer.
  ///
  /// In ru, this message translates to:
  /// **'Локальные настройки новее — отправьте на сервер'**
  String get customizationSyncLocalNewer;

  /// No description provided for @customizationSyncRemoteNewer.
  ///
  /// In ru, this message translates to:
  /// **'На сервере новее — загрузите настройки'**
  String get customizationSyncRemoteNewer;

  /// No description provided for @customizationSyncRemoteMissing.
  ///
  /// In ru, this message translates to:
  /// **'На сервере нет настроек — отправьте первую копию'**
  String get customizationSyncRemoteMissing;

  /// No description provided for @customizationSyncLastPush.
  ///
  /// In ru, this message translates to:
  /// **'Отправлено: {date}'**
  String customizationSyncLastPush(String date);

  /// No description provided for @customizationSyncLastPull.
  ///
  /// In ru, this message translates to:
  /// **'Загружено: {date}'**
  String customizationSyncLastPull(String date);

  /// No description provided for @customizationSyncError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка sync: {message}'**
  String customizationSyncError(String message);

  /// No description provided for @customizationSyncOpenServer.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт home server'**
  String get customizationSyncOpenServer;

  /// No description provided for @customizationSyncSmart.
  ///
  /// In ru, this message translates to:
  /// **'Умная синхронизация'**
  String get customizationSyncSmart;

  /// No description provided for @customizationSyncPush.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get customizationSyncPush;

  /// No description provided for @customizationSyncPull.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить'**
  String get customizationSyncPull;

  /// No description provided for @customizationSyncDone.
  ///
  /// In ru, this message translates to:
  /// **'Кастомизация синхронизирована'**
  String get customizationSyncDone;

  /// No description provided for @customizationSyncPushDone.
  ///
  /// In ru, this message translates to:
  /// **'Настройки отправлены на сервер'**
  String get customizationSyncPushDone;

  /// No description provided for @customizationSyncPullDone.
  ///
  /// In ru, this message translates to:
  /// **'Настройки загружены с сервера'**
  String get customizationSyncPullDone;

  /// No description provided for @customizationSyncFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось синхронизировать — проверьте связь'**
  String get customizationSyncFailed;

  /// No description provided for @customizationChartShowMa7.
  ///
  /// In ru, this message translates to:
  /// **'MA(7)'**
  String get customizationChartShowMa7;

  /// No description provided for @customizationChartShowMa25.
  ///
  /// In ru, this message translates to:
  /// **'MA(25)'**
  String get customizationChartShowMa25;

  /// No description provided for @customizationChartShowMa99.
  ///
  /// In ru, this message translates to:
  /// **'MA(99)'**
  String get customizationChartShowMa99;

  /// No description provided for @chartFullscreen.
  ///
  /// In ru, this message translates to:
  /// **'График на весь экран'**
  String get chartFullscreen;

  /// No description provided for @customizationHubSectionsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Разделы'**
  String get customizationHubSectionsTitle;

  /// No description provided for @settingsHubSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Предпочтения приложения и данные'**
  String get settingsHubSubtitle;

  /// No description provided for @settingsHubGroupsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Группы настроек'**
  String get settingsHubGroupsTitle;

  /// No description provided for @portfolioAccountsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Счета'**
  String get portfolioAccountsTitle;

  /// No description provided for @portfolioAccountsAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить счёт'**
  String get portfolioAccountsAdd;

  /// No description provided for @portfolioAccountKindMain.
  ///
  /// In ru, this message translates to:
  /// **'Основной'**
  String get portfolioAccountKindMain;

  /// No description provided for @portfolioAccountKindIis.
  ///
  /// In ru, this message translates to:
  /// **'ИИС'**
  String get portfolioAccountKindIis;

  /// No description provided for @portfolioAccountKindUsd.
  ///
  /// In ru, this message translates to:
  /// **'USD'**
  String get portfolioAccountKindUsd;

  /// No description provided for @portfolioAccountKindCrypto.
  ///
  /// In ru, this message translates to:
  /// **'Крипто'**
  String get portfolioAccountKindCrypto;

  /// No description provided for @portfolioAccountKindCustom.
  ///
  /// In ru, this message translates to:
  /// **'Свой'**
  String get portfolioAccountKindCustom;

  /// No description provided for @portfolioAccountNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Название счёта'**
  String get portfolioAccountNameHint;

  /// No description provided for @portfolioAccountCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать счёт'**
  String get portfolioAccountCreate;

  /// No description provided for @portfolioAccountDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить счёт'**
  String get portfolioAccountDelete;

  /// No description provided for @portfolioAccountDeleteConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить «{name}» и все позиции?'**
  String portfolioAccountDeleteConfirm(String name);

  /// No description provided for @portfolioAccountMaxReached.
  ///
  /// In ru, this message translates to:
  /// **'Максимум 8 счетов'**
  String get portfolioAccountMaxReached;

  /// No description provided for @portfolioSavingsGoalsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Цели накопления'**
  String get portfolioSavingsGoalsTitle;

  /// No description provided for @portfolioSavingsGoalsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс к целевой сумме'**
  String get portfolioSavingsGoalsSubtitle;

  /// No description provided for @portfolioSavingsGoalAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить цель'**
  String get portfolioSavingsGoalAdd;

  /// No description provided for @portfolioSavingsGoalTitleHint.
  ///
  /// In ru, this message translates to:
  /// **'Название цели'**
  String get portfolioSavingsGoalTitleHint;

  /// No description provided for @portfolioSavingsGoalTargetHint.
  ///
  /// In ru, this message translates to:
  /// **'Целевая сумма, ₽'**
  String get portfolioSavingsGoalTargetHint;

  /// No description provided for @portfolioSavingsGoalDeadline.
  ///
  /// In ru, this message translates to:
  /// **'Срок'**
  String get portfolioSavingsGoalDeadline;

  /// No description provided for @portfolioSavingsGoalProgress.
  ///
  /// In ru, this message translates to:
  /// **'{current} из {target}'**
  String portfolioSavingsGoalProgress(String current, String target);

  /// No description provided for @portfolioSavingsGoalDaysLeft.
  ///
  /// In ru, this message translates to:
  /// **'Осталось {days} дн.'**
  String portfolioSavingsGoalDaysLeft(int days);

  /// No description provided for @portfolioSavingsGoalOverdue.
  ///
  /// In ru, this message translates to:
  /// **'Срок истёк'**
  String get portfolioSavingsGoalOverdue;

  /// No description provided for @portfolioSavingsGoalLinkedAccount.
  ///
  /// In ru, this message translates to:
  /// **'Привязано к текущему счёту'**
  String get portfolioSavingsGoalLinkedAccount;

  /// No description provided for @portfolioSavingsGoalEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Целей пока нет — задайте первую'**
  String get portfolioSavingsGoalEmpty;

  /// No description provided for @overnightChangesTitle.
  ///
  /// In ru, this message translates to:
  /// **'С прошлого визита'**
  String get overnightChangesTitle;

  /// No description provided for @overnightChangesSince.
  ///
  /// In ru, this message translates to:
  /// **'Снимок {hours} ч назад'**
  String overnightChangesSince(int hours);

  /// No description provided for @supportCenterTitle.
  ///
  /// In ru, this message translates to:
  /// **'Помощь и поддержка'**
  String get supportCenterTitle;

  /// No description provided for @supportCenterSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'FAQ и контакты'**
  String get supportCenterSubtitle;

  /// No description provided for @supportCenterIntro.
  ///
  /// In ru, this message translates to:
  /// **'Ответы на частые вопросы и способы связаться с командой.'**
  String get supportCenterIntro;

  /// No description provided for @supportCenterFaqTitle.
  ///
  /// In ru, this message translates to:
  /// **'FAQ'**
  String get supportCenterFaqTitle;

  /// No description provided for @supportCenterContactTitle.
  ///
  /// In ru, this message translates to:
  /// **'Контакты'**
  String get supportCenterContactTitle;

  /// No description provided for @supportCenterFeedback.
  ///
  /// In ru, this message translates to:
  /// **'Написать отзыв'**
  String get supportCenterFeedback;

  /// No description provided for @supportCenterGithub.
  ///
  /// In ru, this message translates to:
  /// **'GitHub Issues'**
  String get supportCenterGithub;

  /// No description provided for @sectorHeatmapTapHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите сектор — фильтр акций MOEX'**
  String get sectorHeatmapTapHint;

  /// No description provided for @marketsSectorFilterActive.
  ///
  /// In ru, this message translates to:
  /// **'Сектор: {sector}'**
  String marketsSectorFilterActive(String sector);

  /// No description provided for @shareWatchlistToChat.
  ///
  /// In ru, this message translates to:
  /// **'Отправить избранное в Messages'**
  String get shareWatchlistToChat;

  /// No description provided for @shareWatchlistToChatHint.
  ///
  /// In ru, this message translates to:
  /// **'Сводка и watchlist в чат «с себе»'**
  String get shareWatchlistToChatHint;

  /// No description provided for @shareWatchlistToChatNeedServer.
  ///
  /// In ru, this message translates to:
  /// **'Сначала войдите на home server'**
  String get shareWatchlistToChatNeedServer;

  /// No description provided for @shareWatchlistToChatSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Избранное отправлено в self chat'**
  String get shareWatchlistToChatSuccess;

  /// No description provided for @shareWatchlistToChatFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отправить — проверьте сервер'**
  String get shareWatchlistToChatFailed;
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
      <String>['de', 'en', 'it', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
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
