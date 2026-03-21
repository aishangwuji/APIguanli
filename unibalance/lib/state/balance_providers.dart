import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../providers/providers.dart';

/// Service providers
final securityServiceProvider = Provider<SecurityService>((ref) {
  return SecurityService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Available API providers
final availableProvidersProvider = Provider<List<ApiProvider>>((ref) {
  return ApiProvider.allProviders;
});

/// Provider map for API adapters
final providerAdaptersProvider = Provider<Map<String, BaseProvider>>((ref) {
  return {
    'openai': OpenAIProvider(),
    'deepseek': DeepSeekProvider(),
  };
});

/// State class for balance data
class BalanceState {
  final Map<String, BalanceInfo> balances;
  final Map<String, bool> loading;
  final Map<String, String?> errors;

  const BalanceState({
    this.balances = const {},
    this.loading = const {},
    this.errors = const {},
  });

  BalanceState copyWith({
    Map<String, BalanceInfo>? balances,
    Map<String, bool>? loading,
    Map<String, String?>? errors,
  }) {
    return BalanceState(
      balances: balances ?? this.balances,
      loading: loading ?? this.loading,
      errors: errors ?? this.errors,
    );
  }
}

/// Balance state notifier
class BalanceNotifier extends StateNotifier<BalanceState> {
  final SecurityService _securityService;
  final Map<String, BaseProvider> _adapters;

  BalanceNotifier(this._securityService, this._adapters)
      : super(const BalanceState());

  /// Fetch balance for a specific provider
  Future<void> fetchBalance(String providerId) async {
    state = state.copyWith(
      loading: {...state.loading, providerId: true},
      errors: {...state.errors, providerId: null},
    );

    try {
      final apiKey = await _securityService.getApiKey(providerId);
      if (apiKey == null || apiKey.isEmpty) {
        state = state.copyWith(
          loading: {...state.loading, providerId: false},
          errors: {...state.errors, providerId: 'API key not configured'},
        );
        return;
      }

      final adapter = _adapters[providerId];
      if (adapter == null) {
        state = state.copyWith(
          loading: {...state.loading, providerId: false},
          errors: {...state.errors, providerId: 'Provider not supported'},
        );
        return;
      }

      final balance = await adapter.fetchBalance(apiKey);
      state = state.copyWith(
        balances: {...state.balances, providerId: balance},
        loading: {...state.loading, providerId: false},
      );
    } catch (e) {
      state = state.copyWith(
        loading: {...state.loading, providerId: false},
        errors: {...state.errors, providerId: e.toString()},
      );
    }
  }

  /// Fetch all configured balances
  Future<void> fetchAllBalances(List<String> providerIds) async {
    await Future.wait(
      providerIds.map((id) => fetchBalance(id)),
    );
  }

  /// Refresh all balances
  Future<void> refreshAll() async {
    final providerIds = _adapters.keys.toList();
    await fetchAllBalances(providerIds);
  }
}

/// Balance state provider
final balanceProvider =
    StateNotifierProvider<BalanceNotifier, BalanceState>((ref) {
  final securityService = ref.watch(securityServiceProvider);
  final adapters = ref.watch(providerAdaptersProvider);
  return BalanceNotifier(securityService, adapters);
});

/// Usage history provider
final usageHistoryProvider = FutureProvider.family<List<UsageRecord>, String>(
  (ref, providerId) async {
    final securityService = ref.watch(securityServiceProvider);
    final adapters = ref.watch(providerAdaptersProvider);

    final apiKey = await securityService.getApiKey(providerId);
    if (apiKey == null || apiKey.isEmpty) return [];

    final adapter = adapters[providerId];
    if (adapter == null) return [];

    return await adapter.fetchUsage(apiKey);
  },
);
