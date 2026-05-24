import 'package:local_auth/local_auth.dart';

class GroveBiometrics {
  GroveBiometrics._();
  static final GroveBiometrics instance = GroveBiometrics._();

  final _auth = LocalAuthentication();

  Future<bool> get isAvailable async {
    try {
      final canCheck    = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock your Grove',
      );
    } catch (_) {
      return false;
    }
  }
}
