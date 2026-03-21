import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../state/state.dart';
import '../widgets/widgets.dart';
import '../settings/settings_screen.dart';

/// Main dashboard screen showing monitored API provider balances
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndAuthenticate();
    });
  }

  Future<void> _checkAndAuthenticate() async {
    final settings = ref.read(settingsProvider);
    final authState = ref.read(authStateProvider);

    if (settings.biometricEnabled && !authState) {
      final authService = ref.read(authServiceProvider);
      final canAuth = await authService.canAuthenticate();

      if (canAuth) {
        final authenticated = await authService.authenticate();
        if (authenticated) {
          ref.read(authStateProvider.notifier).state = true;
          _loadBalances();
        }
      } else {
        ref.read(authStateProvider.notifier).state = true;
        _loadBalances();
      }
    } else {
      ref.read(authStateProvider.notifier).state = true;
      _loadBalances();
    }
  }

  Future<void> _loadBalances() async {
    final addedProviders = ref.read(addedProvidersProvider);
    if (addedProviders.isNotEmpty) {
      ref.read(balanceProvider.notifier).fetchAllBalances(addedProviders);
    }
  }

  Future<void> _refreshAll() async {
    final addedProviders = ref.read(addedProvidersProvider);
    if (addedProviders.isNotEmpty) {
      await ref.read(balanceProvider.notifier).fetchAllBalances(addedProviders);
    }
  }

  void _showAddProviderSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _AddProviderSheet(
        onProviderSelected: _onProviderSelected,
      ),
    );
  }

  Future<void> _onProviderSelected(ApiProvider provider) async {
    Navigator.pop(context); // Close bottom sheet

    // Check if already added
    final addedProviders = ref.read(addedProvidersProvider);
    if (addedProviders.contains(provider.id)) {
      _showError('${provider.name} 已经添加过了');
      return;
    }

    // Show API key dialog
    final apiKey = await _showApiKeyDialog(provider);
    if (apiKey != null && apiKey.isNotEmpty) {
      // Save API key
      final securityService = ref.read(securityServiceProvider);
      await securityService.saveApiKey(provider.id, apiKey);

      // Add to providers list
      await ref.read(addedProvidersProvider.notifier).addProvider(provider.id);

      // Fetch balance
      ref.read(balanceProvider.notifier).fetchBalance(provider.id);
    }
  }

  Future<String?> _showApiKeyDialog(ApiProvider provider) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('添加 ${provider.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '输入你的 ${provider.name} API Key',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'sk-...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '你的 API Key 仅存储在本地设备',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addedProviders = ref.watch(addedProvidersProvider);
    final allProviders = ref.watch(availableProvidersProvider);
    final balanceState = ref.watch(balanceProvider);
    final settings = ref.watch(settingsProvider);

    // Get added provider objects
    final addedProviderList = allProviders
        .where((p) => addedProviders.contains(p.id))
        .toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.3),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          '',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          if (addedProviders.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshAll,
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                  ]
                : [
                    const Color(0xFFE8E8FF),
                    const Color(0xFFF0F0FF),
                    const Color(0xFFE0E8FF),
                  ],
          ),
        ),
        child: addedProviders.isEmpty
            ? EmptyState(onAddPressed: _showAddProviderSheet)
            : RefreshIndicator(
                onRefresh: _refreshAll,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 100, bottom: 100, left: 8, right: 8),
                  itemCount: addedProviderList.length,
                  itemBuilder: (context, index) {
                    final provider = addedProviderList[index];
                    return ProviderCard(
                      provider: provider,
                      balance: balanceState.balances[provider.id],
                      isLoading: balanceState.loading[provider.id] ?? false,
                      error: balanceState.errors[provider.id],
                      currency: settings.currency,
                      onRefresh: () => ref
                          .read(balanceProvider.notifier)
                          .fetchBalance(provider.id),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProviderSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Bottom sheet for selecting a provider to add
class _AddProviderSheet extends StatelessWidget {
  final Function(ApiProvider) onProviderSelected;

  const _AddProviderSheet({required this.onProviderSelected});

  @override
  Widget build(BuildContext context) {
    final providers = ApiProvider.allProviders;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '添加服务商',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          ...providers.map((provider) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      provider.name[0],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(provider.name),
                onTap: () => onProviderSelected(provider),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
