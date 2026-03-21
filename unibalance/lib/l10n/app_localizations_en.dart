// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'UniBalance';

  @override
  String get noProviders => 'No monitored providers';

  @override
  String get addFirstProvider => 'Tap + to add your first API provider';

  @override
  String get addProvider => 'Add Provider';

  @override
  String enterApiKey(String name) {
    return 'Enter your $name API Key';
  }

  @override
  String get apiKeyStored => 'Your API key is stored locally only';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get used => 'Used';

  @override
  String get available => 'Available';

  @override
  String get total => 'Total';

  @override
  String get tapToRefresh => 'Tap to refresh balance';

  @override
  String get settings => 'Settings';

  @override
  String get security => 'Security';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get biometricDesc => 'Use Face ID or Touch ID to unlock';

  @override
  String get biometricUnavailable => 'Biometrics not available';

  @override
  String get display => 'Display';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'Follow System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get currency => 'Currency';

  @override
  String get alerts => 'Alerts';

  @override
  String get alertThreshold => 'Alert Threshold';

  @override
  String get about => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get version => 'Version';

  @override
  String alreadyAdded(String name) {
    return '$name already added';
  }
}
