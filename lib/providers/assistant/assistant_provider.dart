// =============================================================================
// EcoPulse · lib/providers/assistant_provider.dart
// Автор: Цымбал Е. В.
// Дата: 18.05.2026
// Riverpod state: провайдеры и notifiers. Файл: assistant_provider.
// =============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../core/constants/api_keys_store.dart';
import '../../core/services/assistant/assistant_context.dart';
import '../../core/services/assistant/assistant_service.dart';
import '../../core/services/assistant/intent_router.dart';
import '../../core/services/assistant/local_responder.dart';
import '../../data/models/chat_message.dart';
import '../../data/services/cache_service.dart';
import '../../features/home/economic_brief.dart';
import '../../core/services/home_widget_service.dart';
import '../../core/services/morning_digest_service.dart';
import '../../features/shared/app_actions.dart' show RefreshScope, refreshTimeProvider;
import 'package:ecopulse/providers/app/app_providers.dart';
import 'package:ecopulse/providers/markets/commodities_provider.dart';
import 'package:ecopulse/providers/markets/correlation_provider.dart';
import 'package:ecopulse/providers/markets/indices_provider.dart';
import 'package:ecopulse/providers/settings/morning_digest_provider.dart';
import 'package:ecopulse/providers/markets/news_provider.dart';
import 'package:ecopulse/providers/customization/assistant_customization_provider.dart';
import 'package:ecopulse/providers/customization/widget_customization_provider.dart';
import 'package:ecopulse/providers/app/demo_mode_provider.dart';
import 'package:ecopulse/providers/portfolio/paper_portfolio_provider.dart';
import 'package:ecopulse/providers/alerts/price_alerts_provider.dart';
import 'package:ecopulse/providers/markets/watchlist_provider.dart';

/// Riverpod-провайдер [assistantProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
final assistantProvider =
    NotifierProvider<AssistantNotifier, AssistantState>(AssistantNotifier.new);

/// Класс [AssistantState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
class AssistantState {
/// Создаёт [AssistantState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  const AssistantState({
    this.messages = const [],
    this.isLoading = false,
    this.isListening = false,
    this.pendingAction,
  });

/// Поле [messages] класса [AssistantState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  final List<ChatMessage> messages;
/// Поле [isLoading] класса [AssistantState].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final bool isLoading;
/// Поле [isListening] класса [AssistantState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  final bool isListening;
/// Поле [pendingAction] класса [AssistantState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  final AssistantAction? pendingAction;

/// Метод [copyWith] класса [AssistantState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  AssistantState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isListening,
    AssistantAction? pendingAction,
    bool clearPendingAction = false,
  }) =>
      AssistantState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        isListening: isListening ?? this.isListening,
        pendingAction:
            clearPendingAction ? null : (pendingAction ?? this.pendingAction),
      );
}

/// Riverpod AsyncNotifier [AssistantNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
class AssistantNotifier extends Notifier<AssistantState> {
/// Поле [_cacheKey] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static const _cacheKey = 'assistant_chat_v1';
/// Поле [_maxMessages] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  static const _maxMessages = 50;

/// Поле [_service] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  final _service = AssistantService();
/// Поле [_speech] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  final _speech = SpeechToText();
/// Поле [_tts] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  final _tts = FlutterTts();
/// Поле [_speechReady] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  bool _speechReady = false;

/// Отрисовывает UI [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  @override
  AssistantState build() {
    return AssistantState(messages: _loadHistory());
  }

/// Приватный метод [_loadHistory] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  List<ChatMessage> _loadHistory() {
    final raw = CacheService.instance.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

/// Приватный метод [_persist] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Future<void> _persist(List<ChatMessage> messages) async {
    final trimmed = messages.length > _maxMessages
        ? messages.sublist(messages.length - _maxMessages)
        : messages;
    await CacheService.instance.putString(
      _cacheKey,
      jsonEncode(trimmed.map((m) => m.toJson()).toList()),
    );
  }

/// Приватный метод [_buildContext] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  AssistantContext _buildContext(String locale) {
    final rates = ref.read(currencyRatesProvider).valueOrNull;
    final crypto = ref.read(cryptoProvider).valueOrNull?.assets;
    final stocks = ref.read(stocksProvider).valueOrNull;
    final keyRate = ref.read(keyRateProvider).valueOrNull;
    final commodities = ref.read(commoditiesProvider).valueOrNull;
    final fearGreed = ref.read(fearGreedProvider).valueOrNull;
    final watchlist = ref.read(watchlistProvider);
    final portfolio = ref.read(paperPortfolioProvider);

    var usdRub = 90.0;
    for (final r in rates ?? []) {
      if (r.isRub && r.code == 'USD') {
        usdRub = r.rate;
        break;
      }
    }

    final brief = buildEconomicBrief(
      rates: rates,
      keyRate: keyRate,
      crypto: crypto,
      stocks: stocks,
      commodities: commodities,
      fearGreed: fearGreed,
    );

    return AssistantContext.build(
      locale: locale,
      rates: rates,
      crypto: crypto,
      keyRate: keyRate,
      briefLines: brief,
      watchlist: watchlist,
      demoMode: ref.read(demoModeProvider),
      portfolio: portfolio,
      allAssets: [...?crypto, ...?stocks],
      usdRubRate: usdRub,
      hasGeminiKey: ApiKeysStore.instance.hasGeminiKey,
    );
  }

/// Метод [sendMessage] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<void> sendMessage(String text, {required String locale}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final userMsg = ChatMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_u',
      role: ChatRole.user,
      text: trimmed,
      timestamp: DateTime.now(),
    );

    final updated = [...state.messages, userMsg];
    state = state.copyWith(messages: updated, isLoading: true);
    await _persist(updated);

    final ctx = _buildContext(locale);
    final assistant = ref.read(resolvedAssistantProvider);
    final reply = await _service.reply(
      userText: trimmed,
      context: ctx,
      geminiKey: ApiKeysStore.instance.geminiKey,
      preferCloud: assistant.preferCloud,
    );

    if (reply.alertToSave != null) {
      await ref.read(priceAlertsProvider.notifier).add(reply.alertToSave!);
    }

    if (reply.action?.refreshData == true) {
      await _refreshAllData();
    }

    if (reply.action?.navigateTo != null) {
      ref.read(navigationIndexProvider.notifier).state =
          _navIndex(reply.action!.navigateTo!);
    }

    final withReply = [...state.messages, reply.message];
    state = state.copyWith(
      messages: withReply,
      isLoading: false,
      pendingAction: reply.action,
    );
    await _persist(withReply);
  }

/// Метод [clearPendingAction] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  void clearPendingAction() {
    state = state.copyWith(clearPendingAction: true);
  }

/// Приватный метод [_navIndex] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  int _navIndex(NavigationTarget target) => switch (target) {
        NavigationTarget.home => 0,
        NavigationTarget.currency => 1,
        NavigationTarget.inflation => 2,
        NavigationTarget.markets => 3,
        NavigationTarget.settings => 4,
      };

/// Приватный метод [_refreshAllData] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Future<void> _refreshAllData() async {
    await Future.wait([
      ref.read(currencyRatesProvider.notifier).refresh(),
      ref.read(inflationProvider.notifier).refresh(),
      ref.read(cryptoProvider.notifier).refresh(),
      ref.read(stocksProvider.notifier).refresh(),
      ref.read(bondsProvider.notifier).refresh(),
      ref.read(keyRateProvider.notifier).refresh(),
      ref.read(commoditiesProvider.notifier).refresh(),
      ref.read(fearGreedProvider.notifier).refresh(),
      ref.read(correlationProvider.notifier).refresh(),
      ref.read(marketNewsProvider.notifier).refresh(),
      ref.read(macroCalendarProvider.notifier).refresh(),
      ref.read(usIndicesProvider.notifier).refresh(),
    ]);
    final cache = ref.read(cacheServiceProvider);
    await MorningDigestService.instance.cacheSnapshotFromBrief(
      cache: cache,
      rates: ref.read(currencyRatesProvider).valueOrNull,
      keyRate: ref.read(keyRateProvider).valueOrNull,
      crypto: ref.read(cryptoProvider).valueOrNull?.assets,
      stocks: ref.read(stocksProvider).valueOrNull,
      commodities: ref.read(commoditiesProvider).valueOrNull,
      fearGreed: ref.read(fearGreedProvider).valueOrNull,
    );
    await MorningDigestService.instance.maybeSend(
      cache: cache,
      settings: ref.read(morningDigestProvider),
      rates: ref.read(currencyRatesProvider).valueOrNull,
      keyRate: ref.read(keyRateProvider).valueOrNull,
      crypto: ref.read(cryptoProvider).valueOrNull?.assets,
      stocks: ref.read(stocksProvider).valueOrNull,
      commodities: ref.read(commoditiesProvider).valueOrNull,
      fearGreed: ref.read(fearGreedProvider).valueOrNull,
    );
    await HomeWidgetService.update(
      rates: ref.read(currencyRatesProvider).valueOrNull,
      crypto: ref.read(cryptoProvider).valueOrNull?.assets,
      stocks: ref.read(stocksProvider).valueOrNull,
      commodities: ref.read(commoditiesProvider).valueOrNull,
      keyRate: ref.read(keyRateProvider).valueOrNull,
      portfolio: ref.read(portfolioSnapshotProvider),
      inflation: ref.read(inflationProvider).valueOrNull,
      config: ref.read(resolvedWidgetConfigProvider),
    );
    final now = DateTime.now();
    for (final scope in RefreshScope.values) {
      ref.read(refreshTimeProvider(scope).notifier).state = now;
    }
  }

/// Метод [clearHistory] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> clearHistory() async {
    state = const AssistantState();
    await CacheService.instance.putString(_cacheKey, '[]');
  }

/// Метод [initSpeech] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<void> initSpeech() async {
    if (_speechReady || kIsWeb) return;
    _speechReady = await _speech.initialize();
  }

/// Метод [toggleListening] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> toggleListening({required String locale, required void Function(String) onResult}) async {
    if (kIsWeb || !ref.read(resolvedAssistantProvider).voiceInputEnabled) return;
    await initSpeech();
    if (!_speechReady) return;

    if (state.isListening) {
      await _speech.stop();
      state = state.copyWith(isListening: false);
      return;
    }

    state = state.copyWith(isListening: true);
    await _speech.listen(
      localeId: locale.startsWith('ru') ? 'ru_RU' : 'en_US',
      onResult: (result) {
        if (result.finalResult) {
          state = state.copyWith(isListening: false);
          onResult(result.recognizedWords);
        }
      },
    );
  }

/// Метод [speak] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<void> speak(String text, {required String locale}) async {
    if (text.isEmpty || !ref.read(resolvedAssistantProvider).voiceInputEnabled) {
      return;
    }
    await _tts.setLanguage(locale.startsWith('ru') ? 'ru-RU' : 'en-US');
    await _tts.speak(text);
  }

/// Метод [stopSpeaking] класса [AssistantNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Future<void> stopSpeaking() async {
    await _tts.stop();
  }
}
