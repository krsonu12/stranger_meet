/// Base app exception
class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => 'AppException: $message';
}

class AuthException extends AppException {
  const AuthException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}
