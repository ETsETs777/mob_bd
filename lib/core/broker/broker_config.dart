/// Конфигурация брокерских API.
abstract final class BrokerConfig {
  static const sandbox = bool.fromEnvironment(
    'BROKER_SANDBOX',
    defaultValue: false,
  );

  static String get tinkoffRestBase => sandbox
      ? 'https://sandbox-invest-public-api.tinkoff.ru/rest/'
      : 'https://invest-public-api.tinkoff.ru/rest/';
}
