part of 'auth_bloc.dart';

/// All possible auth states — covers every async scenario.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any auth check.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Auth check or sign-in in progress — show shimmer/loading.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated.
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// An auth operation failed.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
