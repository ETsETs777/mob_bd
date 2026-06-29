import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/paper_portfolio_account.dart';
import '../../data/models/portfolio_position.dart';
import '../../data/services/cache_service.dart';

final paperPortfolioStoreProvider =
    NotifierProvider<PaperPortfolioStoreNotifier, PaperPortfolioStore>(
  PaperPortfolioStoreNotifier.new,
);

/// Активный счёт (метаданные).
final activePaperPortfolioAccountProvider = Provider<PaperPortfolioAccount>((ref) {
  return ref.watch(paperPortfolioStoreProvider).activeAccount;
});

class PaperPortfolioStoreNotifier extends Notifier<PaperPortfolioStore> {
  static const storeKey = 'paper_portfolio_accounts';
  static const legacyKey = 'paper_portfolio';

  @override
  PaperPortfolioStore build() => _load();

  PaperPortfolioStore _load() {
    final raw = CacheService.instance.getString(storeKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        return PaperPortfolioStore.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } catch (_) {
        // fall through to legacy migration
      }
    }
    return _loadLegacyOrInitial();
  }

  PaperPortfolioStore _loadLegacyOrInitial() {
    final legacy = CacheService.instance.getString(legacyKey);
    if (legacy != null && legacy.isNotEmpty) {
      try {
        final portfolio = PaperPortfolio.fromJson(
          jsonDecode(legacy) as Map<String, dynamic>,
        );
        return PaperPortfolioStore.fromLegacyPortfolio(portfolio);
      } catch (_) {
        return PaperPortfolioStore.initial();
      }
    }
    return PaperPortfolioStore.initial();
  }

  Future<void> switchAccount(String accountId) async {
    if (!state.accounts.any((a) => a.id == accountId)) return;
    state = state.copyWith(activeAccountId: accountId);
    await _persist();
  }

  Future<void> setActivePortfolio(PaperPortfolio portfolio) async {
    final account = state.activeAccount.copyWith(portfolio: portfolio);
    state = state.updateAccount(account);
    await _persist();
  }

  Future<PaperPortfolioAccount?> createAccount({
    required String name,
    required PaperPortfolioKind kind,
    double? initialCapitalRub,
  }) async {
    if (state.accounts.length >= 8) return null;
    final id = 'acc_${DateTime.now().millisecondsSinceEpoch}';
    final account = PaperPortfolioAccount.create(
      id: id,
      name: name.trim().isEmpty ? kind.name : name.trim(),
      kind: kind,
      initialCapitalRub: initialCapitalRub,
    );
    state = state.copyWith(
      activeAccountId: id,
      accounts: [...state.accounts, account],
    );
    await _persist();
    return account;
  }

  Future<bool> renameAccount(String accountId, String name) async {
    final idx = state.accounts.indexWhere((a) => a.id == accountId);
    if (idx < 0) return false;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;
    final updated = state.accounts[idx].copyWith(name: trimmed);
    state = state.updateAccount(updated);
    await _persist();
    return true;
  }

  Future<bool> deleteAccount(String accountId) async {
    if (state.accounts.length <= 1) return false;
    if (accountId == 'main') return false;
    final nextAccounts =
        state.accounts.where((a) => a.id != accountId).toList();
    final nextActive = state.activeAccountId == accountId
        ? nextAccounts.first.id
        : state.activeAccountId;
    state = PaperPortfolioStore(
      activeAccountId: nextActive,
      accounts: nextAccounts,
    );
    await _persist();
    return true;
  }

  Future<void> resetActiveAccount() async {
    final account = state.activeAccount;
    final resetPortfolio = PaperPortfolio(
      initialCapitalRub: account.portfolio.initialCapitalRub,
      cashRub: account.portfolio.initialCapitalRub,
    );
    await setActivePortfolio(resetPortfolio);
  }

  Future<void> _persist() async {
    await CacheService.instance.putString(
      storeKey,
      jsonEncode(state.toJson()),
    );
  }
}
