import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/tinkoff_quotation.dart';
import 'package:ecopulse/data/models/broker_account.dart';
import 'package:ecopulse/data/services/tinkoff_broker_client.dart';

void main() {
  test('parseTinkoffQuotation handles units and nano', () {
    expect(
      parseTinkoffQuotation({'units': '10', 'nano': 500000000}),
      closeTo(10.5, 0.001),
    );
  });

  test('parseBrokerPositions skips currency rows', () {
    final positions = parseBrokerPositions({
      'positions': [
        {
          'figi': 'BBG004730N88',
          'ticker': 'SBER',
          'instrumentType': 'share',
          'quantity': {'units': '10', 'nano': 0},
          'averagePositionPrice': {'units': '250', 'nano': 0, 'currency': 'rub'},
          'currentPrice': {'units': '260', 'nano': 0, 'currency': 'rub'},
          'expectedYield': {'units': '100', 'nano': 0, 'currency': 'rub'},
        },
        {
          'figi': 'RUB',
          'instrumentType': 'currency',
          'quantity': {'units': '1000', 'nano': 0},
        },
      ],
    });

    expect(positions, hasLength(1));
    expect(positions.first.ticker, 'SBER');
    expect(positions.first.quantity, 10);
    expect(positions.first.marketValue, 2600);
  });

  test('parsePortfolioTotalRub', () {
    expect(
      parsePortfolioTotalRub({
        'totalAmountPortfolio': {'units': '150000', 'nano': 0, 'currency': 'rub'},
      }),
      150000,
    );
  });

  test('BrokerAccount fromJson', () {
    final account = BrokerAccount.fromJson({
      'id': 'acc1',
      'name': 'Брокерский',
      'type': 'ACCOUNT_TYPE_TINKOFF',
    });
    expect(account.id, 'acc1');
    expect(account.name, 'Брокерский');
  });
}
