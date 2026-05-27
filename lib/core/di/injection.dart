import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/mappers/user_mapper.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_anonymously_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/watch_auth_state_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../storage/secure_storage_service.dart';
import '../storage/shared_prefs_service.dart';
import '../theme/theme_cubit.dart';

final GetIt sl = GetIt.instance;

/// Registers all dependencies.
/// Call once in main() before runApp().
Future<void> configureDependencies() async {
  // ── External / Platform ────────────────────────────────────────────────────

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPrefs);

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(scopes: ['email', 'profile']),
  );

  // ── Core Services ──────────────────────────────────────────────────────────

  sl.registerLazySingleton<SharedPrefsService>(
    () => SharedPrefsService(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(sl<FlutterSecureStorage>()),
  );

  // ── Theme ──────────────────────────────────────────────────────────────────

  sl.registerFactory<ThemeCubit>(
    () => ThemeCubit(sl<SharedPrefsService>()),
  );

  // ── Auth: Data Layer ───────────────────────────────────────────────────────

  sl.registerLazySingleton<UserMapper>(() => const UserMapper());

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      datasource: sl<AuthRemoteDatasource>(),
      mapper: sl<UserMapper>(),
    ),
  );

  // ── Auth: Domain Layer (UseCases) ──────────────────────────────────────────

  sl.registerLazySingleton(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => WatchAuthStateUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => SignInWithGoogleUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => SignInWithAppleUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => SignInAnonymouslyUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => SignOutUseCase(sl<AuthRepository>()),
  );

  // ── Auth: Presentation Layer (BLoC) ───────────────────────────────────────
  // registerFactory — new instance per usage

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      getCurrentUser: sl<GetCurrentUserUseCase>(),
      watchAuthState: sl<WatchAuthStateUseCase>(),
      signInWithGoogle: sl<SignInWithGoogleUseCase>(),
      signInWithApple: sl<SignInWithAppleUseCase>(),
      signInAnonymously: sl<SignInAnonymouslyUseCase>(),
      signOut: sl<SignOutUseCase>(),
    ),
  );
}
