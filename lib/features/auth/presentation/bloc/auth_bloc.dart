import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_anonymously_usecase.dart';
import '../../domain/usecases/sign_in_with_apple_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/watch_auth_state_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Orchestrates all authentication flows.
/// Receives events from UI → calls UseCases → emits states.
///
/// Uses [WatchAuthStateUseCase] to reactively listen to Firebase auth stream,
/// so sign-out / token revocation from any source is reflected immediately.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final WatchAuthStateUseCase _watchAuthState;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignInWithAppleUseCase _signInWithApple;
  final SignInAnonymouslyUseCase _signInAnonymously;
  final SignOutUseCase _signOut;

  StreamSubscription<UserEntity?>? _authStateSubscription;

  AuthBloc({
    required GetCurrentUserUseCase getCurrentUser,
    required WatchAuthStateUseCase watchAuthState,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignInWithAppleUseCase signInWithApple,
    required SignInAnonymouslyUseCase signInAnonymously,
    required SignOutUseCase signOut,
  })  : _getCurrentUser = getCurrentUser,
        _watchAuthState = watchAuthState,
        _signInWithGoogle = signInWithGoogle,
        _signInWithApple = signInWithApple,
        _signInAnonymously = signInAnonymously,
        _signOut = signOut,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignIn);
    on<AuthAppleSignInRequested>(_onAppleSignIn);
    on<AuthAnonymousSignInRequested>(_onAnonymousSignIn);
    on<AuthSignOutRequested>(_onSignOut);
    on<_AuthStateChanged>(_onAuthStateChanged);
  }

  /// Starts listening to Firebase auth stream.
  /// Called once from [AuthCheckRequested] — drives all subsequent navigation.
  void _subscribeToAuthState() {
    _authStateSubscription?.cancel();
    _authStateSubscription = _watchAuthState().listen(
      (user) => add(_AuthStateChanged(user)),
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    // Subscribe to the stream — future auth changes will auto-emit states.
    _subscribeToAuthState();
    // Also do an immediate check so the splash screen resolves quickly.
    final user = await _getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Handles reactive auth state changes from Firebase stream.
  Future<void> _onAuthStateChanged(
    _AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    // Only react if we're not in the middle of an explicit sign-in/out flow
    // (those handlers emit their own states). Skip if already loading.
    if (state is AuthLoading) return;

    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onGoogleSignIn(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInWithGoogle();
    if (result.failure != null) {
      emit(AuthError(result.failure!.message));
    } else {
      emit(AuthAuthenticated(result.user));
    }
  }

  Future<void> _onAppleSignIn(
    AuthAppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInWithApple();
    if (result.failure != null) {
      emit(AuthError(result.failure!.message));
    } else {
      emit(AuthAuthenticated(result.user));
    }
  }

  Future<void> _onAnonymousSignIn(
    AuthAnonymousSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInAnonymously();
    if (result.failure != null) {
      emit(AuthError(result.failure!.message));
    } else {
      emit(AuthAuthenticated(result.user));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await _signOut();
    emit(const AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
