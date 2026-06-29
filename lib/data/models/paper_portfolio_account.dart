import 'portfolio_position.dart';

/// Тип виртуального счёта.
enum PaperPortfolioKind {
  main,
  iis,
  usd,
  crypto,
  custom,
}

/// Один бумажный портфель (счёт).
class PaperPortfolioAccount {
  const PaperPortfolioAccount({
    required this.id,
    required this.name,
    required this.kind,
    required this.portfolio,
    required this.createdAt,
  });

  final String id;
  final String name;
  final PaperPortfolioKind kind;
  final PaperPortfolio portfolio;
  final DateTime createdAt;

  PaperPortfolioAccount copyWith({
    String? name,
    PaperPortfolioKind? kind,
    PaperPortfolio? portfolio,
  }) {
    return PaperPortfolioAccount(
      id: id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      portfolio: portfolio ?? this.portfolio,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kind': kind.name,
        'portfolio': portfolio.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory PaperPortfolioAccount.fromJson(Map<String, dynamic> json) {
    return PaperPortfolioAccount(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      kind: PaperPortfolioKind.values.byName(
        json['kind'] as String? ?? PaperPortfolioKind.main.name,
      ),
      portfolio: PaperPortfolio.fromJson(
        json['portfolio'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
    );
  }

  static PaperPortfolioAccount create({
    required String id,
    required String name,
    required PaperPortfolioKind kind,
    double? initialCapitalRub,
  }) {
    final capital = initialCapitalRub ?? defaultCapitalFor(kind);
    return PaperPortfolioAccount(
      id: id,
      name: name,
      kind: kind,
      portfolio: PaperPortfolio(
        initialCapitalRub: capital,
        cashRub: capital,
      ),
      createdAt: DateTime.now().toUtc(),
    );
  }

  static double defaultCapitalFor(PaperPortfolioKind kind) => switch (kind) {
        PaperPortfolioKind.main => PaperPortfolio.defaultCapital,
        PaperPortfolioKind.iis => 400000,
        PaperPortfolioKind.usd => 100000,
        PaperPortfolioKind.crypto => 50000,
        PaperPortfolioKind.custom => PaperPortfolio.defaultCapital,
      };
}

/// Хранилище нескольких бумажных портфелей.
class PaperPortfolioStore {
  const PaperPortfolioStore({
    required this.activeAccountId,
    required this.accounts,
  });

  final String activeAccountId;
  final List<PaperPortfolioAccount> accounts;

  PaperPortfolioAccount get activeAccount =>
      accounts.firstWhere((a) => a.id == activeAccountId);

  PaperPortfolio get activePortfolio => activeAccount.portfolio;

  PaperPortfolioStore copyWith({
    String? activeAccountId,
    List<PaperPortfolioAccount>? accounts,
  }) {
    return PaperPortfolioStore(
      activeAccountId: activeAccountId ?? this.activeAccountId,
      accounts: accounts ?? this.accounts,
    );
  }

  PaperPortfolioStore updateAccount(PaperPortfolioAccount account) {
    return copyWith(
      accounts: accounts
          .map((a) => a.id == account.id ? account : a)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
        'activeAccountId': activeAccountId,
        'accounts': accounts.map((a) => a.toJson()).toList(),
      };

  factory PaperPortfolioStore.fromJson(Map<String, dynamic> json) {
    final accounts = (json['accounts'] as List<dynamic>? ?? [])
        .map((e) => PaperPortfolioAccount.fromJson(e as Map<String, dynamic>))
        .toList();
    if (accounts.isEmpty) return PaperPortfolioStore.initial();
    final activeId = json['activeAccountId'] as String? ?? accounts.first.id;
    return PaperPortfolioStore(
      activeAccountId: accounts.any((a) => a.id == activeId)
          ? activeId
          : accounts.first.id,
      accounts: accounts,
    );
  }

  static PaperPortfolioStore initial() {
    return PaperPortfolioStore(
      activeAccountId: 'main',
      accounts: [
        PaperPortfolioAccount.create(
          id: 'main',
          name: 'Main',
          kind: PaperPortfolioKind.main,
        ),
      ],
    );
  }

  /// Миграция из одиночного `paper_portfolio` cache key.
  static PaperPortfolioStore fromLegacyPortfolio(PaperPortfolio portfolio) {
    return PaperPortfolioStore(
      activeAccountId: 'main',
      accounts: [
        PaperPortfolioAccount(
          id: 'main',
          name: 'Main',
          kind: PaperPortfolioKind.main,
          portfolio: portfolio,
          createdAt: DateTime.now().toUtc(),
        ),
      ],
    );
  }
}
