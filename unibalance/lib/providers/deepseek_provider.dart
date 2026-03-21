import 'package:dio/dio.dart';
import '../models/models.dart';
import '../services/balance_service.dart';

/// DeepSeek API provider adapter
class DeepSeekProvider extends BaseProvider {
  DeepSeekProvider()
      : super(
          id: 'deepseek',
          name: 'DeepSeek',
          baseUrl: 'https://api.deepseek.com',
        );

  @override
  Future<BalanceInfo> fetchBalance(String apiKey) async {
    return handleRateLimit(() async {
      final response = await dio.get(
        '${baseUrl}/user/balance',
        options: Options(headers: buildHeaders(apiKey)),
      );

      return parseBalanceResponse('deepseek', response.data);
    });
  }

  @override
  Future<List<UsageRecord>> fetchUsage(String apiKey, {int days = 30}) async {
    // DeepSeek doesn't provide detailed usage history API
    return [];
  }

  @override
  BalanceInfo parseBalanceResponse(String providerId, dynamic response) {
    final balanceInfos = response['balance_infos'] as List? ?? [];

    double totalBalance = 0.0;
    String currency = 'USD';

    for (final item in balanceInfos) {
      final balanceStr = item['total_balance']?.toString() ?? '0';
      totalBalance += double.tryParse(balanceStr) ?? 0.0;
      currency = item['currency']?.toString() ?? 'USD';
    }

    // DeepSeek: total = granted + topped_up, available = total (no used info)
    return BalanceInfo(
      providerId: providerId,
      total: totalBalance,
      used: 0,
      available: totalBalance,
      currency: currency,
      lastUpdated: DateTime.now(),
    );
  }
}
