import 'package:dio/dio.dart';
import '../models/models.dart';

/// Base class for API providers using adapter pattern
abstract class BaseProvider {
  final String id;
  final String name;
  final String baseUrl;
  final Dio _dio;

  BaseProvider({
    required this.id,
    required this.name,
    required this.baseUrl,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  Dio get dio => _dio;

  /// Fetch current balance
  Future<BalanceInfo> fetchBalance(String apiKey);

  /// Fetch usage history
  Future<List<UsageRecord>> fetchUsage(String apiKey, {int days = 30});

  /// Parse provider-specific response
  BalanceInfo parseBalanceResponse(String providerId, dynamic response);

  /// Build headers for API request
  Map<String, String> buildHeaders(String apiKey) => {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

  /// Handle rate limiting with exponential backoff
  Future<T> handleRateLimit<T>(
    Future<T> Function() request, {
    int maxRetries = 3,
  }) async {
    int retries = 0;
    while (true) {
      try {
        return await request();
      } on DioException catch (e) {
        if (e.response?.statusCode == 429 && retries < maxRetries) {
          final delay = Duration(seconds: (1 << retries) * 2);
          await Future.delayed(delay);
          retries++;
          continue;
        }
        rethrow;
      }
    }
  }
}
