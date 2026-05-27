import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/errors/exceptions.dart';
import '../dto/user_dto.dart';

/// Remote datasource — all Firebase Auth calls live here.
/// Isolated from domain and presentation layers.
abstract class AuthRemoteDatasource {
  Future<UserDto?> getCurrentUser();
  Stream<UserDto?> get authStateChanges;
  Future<UserDto> signInWithGoogle();
  Future<UserDto> signInWithApple();
  Future<UserDto> signInAnonymously();
  Future<void> signOut();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  const AuthRemoteDatasourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  Future<UserDto?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserDto.fromFirebaseUser(user);
  }

  @override
  Stream<UserDto?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(
          (user) => user != null ? UserDto.fromFirebaseUser(user) : null,
        );
  }

  @override
  Future<UserDto> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled by the user.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return UserDto.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Google sign-in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserDto> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      return UserDto.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AuthException('Apple sign-in was cancelled.');
      }
      throw AuthException('Apple sign-in failed: ${e.message}');
    } catch (e) {
      throw AuthException('Apple sign-in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserDto> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      return UserDto.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      throw AuthException('Anonymous sign-in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Sign-out failed: ${e.toString()}');
    }
  }

  /// Maps Firebase error codes to user-friendly messages.
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
        return 'The credential is invalid or has expired.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for this credential.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
