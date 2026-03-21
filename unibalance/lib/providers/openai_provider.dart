import 'package:dio/dio.dart';
import '../models/models.dart';
import '../services/balance_service.dart';

/// OpenAI API provider adapter
class OpenAIProvider extends BaseProvider {
  OpenAIProvider()
      : super(
          id: 'openai',
          name: 'OpenAI',
          baseUrl: 'https://api.openai.com',
        );

  @override
  Future<BalanceInfo> fetchBalance(String apiKey) async {
    return handleRateLimit(() async {
      // Fetch subscription info
      final subscriptionResponse = await dio.get(
        '${baseUrl}/v1/dashboard/billing/subscription',
        options: Options(headers: buildHeaders(apiKey)),
      );

      // Fetch usage for current billing period
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final usageResponse = await dio.get(
        '${baseUrl}/v1/dashboard/billing/usage',
        queryParameters: {
          'start_date': startOfMonth.toIso8601String().split('T')[0],
          'end_date': now.toIso8601String().split('T')[0],
        },
        options: Options(headers: buildHeaders(apiKey)),
      );

      return parseBalanceResponse('openai', {
        'subscription': subscriptionResponse.data,
        'usage': usageResponse.data,
      });
    });
  }

  @override
  Future<List<UsageRecord>> fetchUsage(String apiKey, {int days = 30}) async {
    return handleRateLimit(() async {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      final response = await dio.get(
        '${baseUrl}/v1/dashboard/billing/usage',
        queryParameters: {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': now.toIso8601String().split('T')[0],
        },
        options: Options(headers: buildHeaders(apiKey)),
      );

      final List<UsageRecord> records = [];
      final dailyCosts = response.data['daily_costs'] as List? ?? [];

      for (final day in dailyCosts) {
        final date = DateTime.parse(day['date'] as String);
        final cost = (day['cost'] as num).toDouble();
        final lineItems = day['line_items'] as List? ?? [];

        int totalInput = 0;
        int totalOutput = 0;
        int requests = 0;

        for (final item in lineItems) {
          totalInput += (item['num_items']?['Input'] as int?) ?? 0;
          totalOutput += (item['num_items']?['Output'] as int?) ?? 0;
          requests += (item['num_requests'] as int?) ?? 0;
        }

        records.add(UsageRecord(
          providerId: id,
          date: date,
          cost: cost,
          requests: requests,
          inputTokens: totalInput,
          outputTokens: totalOutput,
        ));
      }

      return records;
    });
  }

  @override
  BalanceInfo parseBalanceResponse(String providerId, dynamic response) {
    final subscription = response['subscription'] as Map<String, dynamic>;
    final usage = response['usage'] as Map<String, dynamic>;

    final hardLimit =
        (subscription['hard_limit_usd'] as num?)?.toDouble() ?? 0.0;

    // Get current month's cost
    final dailyCosts = usage['daily_costs'] as List? ?? [];
    double currentMonthUsage = 0.0;
    for (final day in dailyCosts) {
      currentMonthUsage += (day['cost'] as num?)?.toDouble() ?? 0.0;
    }

    final available = hardLimit - currentMonthUsage;

    return BalanceInfo(
      providerId: providerId,
      total: hardLimit,
      used: currentMonthUsage,
      available: available > 0 ? available : 0,
      currency: 'USD',
      lastUpdated: DateTime.now(),
    );
  }
}
