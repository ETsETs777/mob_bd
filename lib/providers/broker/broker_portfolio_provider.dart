import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_keys_store.dart';
import '../../data/models/broker_account.dart';
import '../../data/services/api_client.dart';
import '../../data/services/cache_service.dart';
import '../../data/services/tinkoff_broker_client.dart';
import '../app/app_providers.dart';
import '../settings/api_keys_provider.dart';

class BrokerPortfolioState {
  const BrokerPortfolioState({
    this.loading = false,
    this.error = '',
    this.accounts = const [],
    this.selectedAccountId = '',
    this.snapshot,
  });

  final bool loading;
  final String error;
  final List<BrokerAccount> accounts;
  final String selectedAccountId;
  final BrokerPortfolioSnapshot? snapshot;

  bool get isConfigured => ApiKeysStore.instance.hasTinkoffBrokerToken;

  BrokerPortfolioState copyWith({
    bool? loading,
    String? error,
    List<BrokerAccount>? accounts,
    String? selectedAccountId,
    BrokerPortfolioSnapshot? snapshot,
    bool clearSnapshot = false,
  }) {
    return BrokerPortfolioState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      accounts: accounts ?? this.accounts,
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      snapshot: clearSnapshot ? null : (snapshot ?? this.snapshot),
    );
  }
}

final brokerPortfolioProvider =
    NotifierProvider<BrokerPortfolioNotifier, BrokerPortfolioState>(
  BrokerPortfolioNotifier.new,
);

final tinkoffBrokerClientProvider = Provider<TinkoffBrokerClient>((ref) {
  return TinkoffBrokerClient(dio: ref.watch(dioProvider));
});

class BrokerPortfolioNotifier extends Notifier<BrokerPortfolioState> {
  static const accountCacheKey = 'broker_tinkoff_account_id';

  @override
  BrokerPortfolioState build() {
    final cachedAccount = CacheService.instance.getString(accountCacheKey) ?? '';
    return BrokerPortfolioState(selectedAccountId: cachedAccount);
  }

  String get _token => ApiKeysStore.instance.tinkoffBrokerToken;

  Future<void> refresh() async {
    if (_token.isEmpty) {
      state = state.copyWith(error: 'no_token', clearSnapshot: true);
      return;
    }

    state = state.copyWith(loading: true, error: '');
    try {
      final client = ref.read(tinkoffBrokerClientProvider);
      var accounts = await client.fetchAccounts(_token);
      if (accounts.isEmpty) {
        state = state.copyWith(
          loading: false,
          error: 'no_accounts',
          accounts: [],
          clearSnapshot: true,
        );
        return;
      }

      var accountId = state.selectedAccountId;
      if (accountId.isEmpty ||
          !accounts.any((account) => account.id == accountId)) {
        accountId = accounts.first.id;
        await CacheService.instance.putString(accountCacheKey, accountId);
      }

      final account = accounts.firstWhere((a) => a.id == accountId);
      final raw = await client.fetchPortfolioRaw(_token, accountId);
      final positions = parseBrokerPositions(raw);
      final total = parsePortfolioTotalRub(raw);

      state = state.copyWith(
        loading: false,
        accounts: accounts,
        selectedAccountId: accountId,
        snapshot: BrokerPortfolioSnapshot(
          accountId: accountId,
          accountName: account.name,
          positions: positions,
          totalAmountRub: total,
          syncedAt: DateTime.now().toUtc(),
        ),
      );
    } on BrokerException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> selectAccount(String accountId) async {
    if (accountId == state.selectedAccountId) return;
    await CacheService.instance.putString(accountCacheKey, accountId);
    state = state.copyWith(selectedAccountId: accountId);
    await refresh();
  }

  Future<void> clearToken() async {
    await ApiKeysStore.instance.setTinkoffBroker(
      '',
      (k, v) => CacheService.instance.putString(k, v),
    );
    ref.read(apiKeysProvider.notifier).init();
    await CacheService.instance.deleteKey(accountCacheKey);
    state = const BrokerPortfolioState();
  }
}
