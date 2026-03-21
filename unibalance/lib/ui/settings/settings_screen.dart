import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../state/state.dart';

/// Settings screen for app configuration
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final authService = ref.watch(authServiceProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Security Section
          _SectionHeader(title: l10n.security),
          FutureBuilder<bool>(
            future: authService.canAuthenticate(),
            builder: (context, snapshot) {
              final canAuth = snapshot.data ?? false;
              return SwitchListTile(
                title: Text(l10n.biometricAuth),
                subtitle: Text(canAuth ? l10n.biometricDesc : l10n.biometricUnavailable),
                value: settings.biometricEnabled,
                onChanged: canAuth
                    ? (value) =>
                        ref.read(settingsProvider.notifier).setBiometricEnabled(value)
                    : null,
              );
            },
          ),

          const Divider(),

          // Display Section
          _SectionHeader(title: l10n.display),
          ListTile(
            title: Text(l10n.theme),
            subtitle: Text(_getThemeLabel(settings.themeMode, l10n)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context, ref, settings.themeMode, l10n),
          ),
          ListTile(
            title: Text(l10n.currency),
            subtitle: Text(settings.currency),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCurrencyPicker(context, ref, l10n),
          ),

          const Divider(),

          // Alerts Section
          _SectionHeader(title: l10n.alerts),
          ListTile(
            title: Text(l10n.alertThreshold),
            subtitle: Text('${l10n.alertThreshold}: \$${settings.alertThreshold.toStringAsFixed(0)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThresholdPicker(context, ref, settings.alertThreshold, l10n),
          ),

          const Divider(),

          // About Section
          _SectionHeader(title: l10n.about),
          ListTile(
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(context),
          ),
          ListTile(
            title: Text(l10n.version),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  String _getThemeLabel(String themeMode, AppLocalizations l10n) {
    switch (themeMode) {
      case 'light':
        return l10n.themeLight;
      case 'dark':
        return l10n.themeDark;
      default:
        return l10n.themeSystem;
    }
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, String currentMode, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.theme),
        children: [
          RadioListTile<String>(
            title: Text(l10n.themeSystem),
            value: 'system',
            groupValue: currentMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setThemeMode(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: Text(l10n.themeLight),
            value: 'light',
            groupValue: currentMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setThemeMode(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: Text(l10n.themeDark),
            value: 'dark',
            groupValue: currentMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setThemeMode(value!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final currencies = ['USD', 'CNY', 'EUR', 'GBP', 'JPY'];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.currency),
        children: currencies.map((currency) {
          return SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).setCurrency(currency);
              Navigator.pop(context);
            },
            child: Text(currency),
          );
        }).toList(),
      ),
    );
  }

  void _showThresholdPicker(BuildContext context, WidgetRef ref, double current, AppLocalizations l10n) {
    final controller = TextEditingController(text: current.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.alertThreshold),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.alertThreshold,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                ref.read(settingsProvider.notifier).setAlertThreshold(value);
              }
              Navigator.pop(context);
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.privacyPolicy),
        content: const SingleChildScrollView(
          child: Text(
            '''UniBalance Privacy Policy

1. Data Collection
We do not collect any personal data. All your API keys and usage information are stored locally on your device.

2. API Keys
Your API keys are stored securely using your device's secure storage (iOS KeyChain / Android KeyStore). We never transmit your API keys to any server.

3. Usage Data
Balance and usage information is fetched directly from the API providers' servers and displayed in the app. No data is stored on external servers.

4. Third-Party Services
We use the following third-party services:
- OpenAI API (for OpenAI balance information)
- DeepSeek API (for DeepSeek balance information)

5. Contact
For privacy concerns, please contact us through GitHub Issues.''',
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
