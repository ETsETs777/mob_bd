import 'package:dio/dio.dart';

import '../../core/broker/broker_config.dart';
import '../models/broker_account.dart';

class BrokerException implements Exception {
  BrokerException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

/// Read-only клиент T-Invest Open API (Tinkoff / T-Bank).
class TinkoffBrokerClient {
  TinkoffBrokerClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _usersService =
      'tinkoff.public.invest.api.contract.v1.UsersService/GetAccounts';
  static const _portfolioService =
      'tinkoff.public.invest.api.contract.v1.OperationsService/GetPortfolio';

  Map<String, String> _headers(String token) => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<List<BrokerAccount>> fetchAccounts(String token) async {
    final data = await _post(token, _usersService, {});
    final accounts = data['accounts'] as List<dynamic>? ?? [];
    return accounts
        .map((e) => BrokerAccount.fromJson(e as Map<String, dynamic>))
        .where((a) => a.id.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> fetchPortfolioRaw(
    String token,
    String accountId,
  ) async {
    return _post(token, _portfolioService, {'accountId': accountId});
  }

  Future<Map<String, dynamic>> _post(
    String token,
    String method,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '${BrokerConfig.tinkoffRestBase}$method',
        data: body,
        options: Options(headers: _headers(token)),
      );
      return response.data ?? {};
    } on DioException catch (e) {
      final msg = _extractError(e);
      throw BrokerException(msg, code: e.response?.statusCode?.toString());
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      if (message != null && message.isNotEmpty) return message;
    }
    return e.message ?? 'network_error';
  }
}

List<BrokerPosition> parseBrokerPositions(Map<String, dynamic> portfolioJson) {
  final positions = portfolioJson['positions'] as List<dynamic>? ?? [];
  return positions
      .map((e) => BrokerPosition.fromPortfolioJson(e as Map<String, dynamic>))
      .where((p) => p.quantity > 0 && p.instrumentType != 'currency')
      .toList();
}

double parsePortfolioTotalRub(Map<String, dynamic> portfolioJson) {
  final total = portfolioJson['totalAmountPortfolio'] as Map<String, dynamic>?;
  if (total == null) return 0;
  final units = int.tryParse(total['units']?.toString() ?? '0') ?? 0;
  final nano = int.tryParse(total['nano']?.toString() ?? '0') ?? 0;
  return units + nano / 1e9;
}
