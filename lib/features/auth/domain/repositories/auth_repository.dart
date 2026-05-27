import '../entities/user_entity.dart';
import '../../../../core/errors/failures.dart';

/// Contract for authentication operations.
/// Lives in domain — no implementation details.
abstract class AuthRepository {
  /// Returns the currently signed-in user, or null if not authenticated.
  Future<UserEntity?> getCurrentUser();

  /// Stream of auth state changes.
  Stream<UserEntity?> get authStateChanges;

  /// Sign in with Google OAuth.
  Future<({UserEntity user, Failure? failure})> signInWithGoogle();

  /// Sign in with Apple ID.
  Future<({UserEntity user, Failure? failure})> signInWithApple();

  /// Sign in anonymously (recommended for stranger apps).
  Future<({UserEntity user, Failure? failure})> signInAnonymously();

  /// Sign out from all providers.
  Future<void> signOut();
}
