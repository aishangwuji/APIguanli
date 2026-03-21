import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/settings_providers.dart';
import '../../state/balance_providers.dart';

/// Lock screen shown when app resumes from background
class AppLockScreen extends ConsumerWidget {
  final Widget child;

  const AppLockScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isLocked = ref.watch(appLockProvider);

    if (!settings.biometricEnabled || !isLocked) {
      return child;
    }

    return _LockScreen(
      onUnlock: () {
        ref.read(appLockProvider.notifier).state = false;
      },
    );
  }
}

class _LockScreen extends ConsumerWidget {
  final VoidCallback onUnlock;

  const _LockScreen({required this.onUnlock});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'UniBalance',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '验证后访问',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),
                FilledButton.icon(
                  onPressed: () => _authenticate(context, ref),
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('解锁'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate(BuildContext context, WidgetRef ref) async {
    final authService = ref.read(authServiceProvider);
    final canAuth = await authService.canAuthenticate();

    if (!canAuth) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法使用生物识别')),
        );
      }
      return;
    }

    final success = await authService.authenticate();
    if (success) {
      onUnlock();
    }
  }
}
