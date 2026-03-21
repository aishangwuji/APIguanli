import 'package:local_auth/local_auth.dart';

/// Authentication service for biometric authentication
class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if device supports biometric authentication
  Future<bool> canAuthenticate() async {
    try {
      final canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } catch (_) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  /// Authenticate user with biometrics
  Future<bool> authenticate({
    String reason = 'Please authenticate to access UniBalance',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  /// Check if biometrics are enrolled
  Future<bool> hasBiometricsEnrolled() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }
}
