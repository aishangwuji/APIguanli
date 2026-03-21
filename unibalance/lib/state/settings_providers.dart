import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Theme mode: "system" (跟随系统), "light" (浅色), "dark" (深色)
class AppSettings {
  final bool biometricEnabled;
  final String currency;
  final double alertThreshold;
  final String themeMode; // "system", "light", "dark"

  const AppSettings({
    this.biometricEnabled = false,
    this.currency = 'USD',
    this.alertThreshold = 5.0,
    this.themeMode = 'system',
  });

  AppSettings copyWith({
    bool? biometricEnabled,
    String? currency,
    double? alertThreshold,
    String? themeMode,
  }) {
    return AppSettings(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      currency: currency ?? this.currency,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() => {
        'biometricEnabled': biometricEnabled,
        'currency': currency,
        'alertThreshold': alertThreshold,
        'themeMode': themeMode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        biometricEnabled: json['biometricEnabled'] as bool? ?? false,
        currency: json['currency'] as String? ?? 'USD',
        alertThreshold: (json['alertThreshold'] as num?)?.toDouble() ?? 5.0,
        themeMode: json['themeMode'] as String? ?? 'system',
      );
}

/// Settings state notifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  static const _boxName = 'settings';
  static const _settingsKey = 'app_settings';

  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final box = await Hive.openBox(_boxName);
    final json = box.get(_settingsKey);
    if (json != null) {
      state = AppSettings.fromJson(Map<String, dynamic>.from(json));
    }
  }

  Future<void> _saveSettings() async {
    final box = await Hive.openBox(_boxName);
    await box.put(_settingsKey, state.toJson());
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    state = state.copyWith(biometricEnabled: enabled);
    await _saveSettings();
  }

  Future<void> setCurrency(String currency) async {
    state = state.copyWith(currency: currency);
    await _saveSettings();
  }

  Future<void> setAlertThreshold(double threshold) async {
    state = state.copyWith(alertThreshold: threshold);
    await _saveSettings();
  }

  Future<void> setThemeMode(String mode) async {
    state = state.copyWith(themeMode: mode);
    await _saveSettings();
  }
}

/// Settings provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

/// Auth state provider
final authStateProvider = StateProvider<bool>((ref) => false);

/// App lock state - true means app is locked and needs authentication
final appLockProvider = StateProvider<bool>((ref) => false);
