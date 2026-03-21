import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Security service for storing API keys securely
/// Uses iOS KeyChain / Android KeyStore
class SecurityService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Store API key for a provider
  Future<void> saveApiKey(String providerId, String apiKey) async {
    await _storage.write(key: 'api_key_$providerId', value: apiKey);
  }

  /// Get API key for a provider
  Future<String?> getApiKey(String providerId) async {
    return await _storage.read(key: 'api_key_$providerId');
  }

  /// Delete API key for a provider
  Future<void> deleteApiKey(String providerId) async {
    await _storage.delete(key: 'api_key_$providerId');
  }

  /// Check if API key exists for a provider
  Future<bool> hasApiKey(String providerId) async {
    final key = await getApiKey(providerId);
    return key != null && key.isNotEmpty;
  }

  /// Get all stored provider IDs
  Future<List<String>> getStoredProviderIds() async {
    final all = await _storage.readAll();
    return all.keys
        .where((key) => key.startsWith('api_key_'))
        .map((key) => key.replaceFirst('api_key_', ''))
        .toList();
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
