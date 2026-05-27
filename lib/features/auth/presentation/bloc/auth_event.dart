part of 'auth_bloc.dart';

/// All auth-related events dispatched from the UI.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check current auth state on app start — also subscribes to auth stream.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// User tapped "Sign in with Google".
class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

/// User tapped "Sign in with Apple".
class AuthAppleSignInRequested extends AuthEvent {
  const AuthAppleSignInRequested();
}

/// User tapped "Continue as Guest".
class AuthAnonymousSignInRequested extends AuthEvent {
  const AuthAnonymousSignInRequested();
}

/// User tapped "Sign Out".
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Internal — emitted by the Firebase auth stream subscription.
/// Not dispatched from UI directly.
class _AuthStateChanged extends AuthEvent {
  final UserEntity? user;

  const _AuthStateChanged(this.user);

  @override
  List<Object?> get props => [user];
}
