import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for sensitive data (tokens, credentials).
/// Uses platform Keychain (iOS) / Keystore (Android).
class SecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  static const _authTokenKey = 'auth_token';
  static const _userIdKey = 'user_id';

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return _storage.read(key: _authTokenKey);
  }

  Future<void> saveUserId(String uid) async {
    await _storage.write(key: _userIdKey, value: uid);
  }

  Future<String?> getUserId() async {
    return _storage.read(key: _userIdKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
