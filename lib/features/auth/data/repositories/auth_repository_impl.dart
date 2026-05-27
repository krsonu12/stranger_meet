import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/user_mapper.dart';

/// Implements [AuthRepository] contract from the domain layer.
/// Translates datasource exceptions into domain Failures.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final UserMapper _mapper;

  const AuthRepositoryImpl({
    required AuthRemoteDatasource datasource,
    required UserMapper mapper,
  })  : _datasource = datasource,
        _mapper = mapper;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final dto = await _datasource.getCurrentUser();
    return dto != null ? _mapper.toEntity(dto) : null;
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _datasource.authStateChanges.map(
      (dto) => dto != null ? _mapper.toEntity(dto) : null,
    );
  }

  @override
  Future<({UserEntity user, Failure? failure})> signInWithGoogle() async {
    try {
      final dto = await _datasource.signInWithGoogle();
      return (user: _mapper.toEntity(dto), failure: null);
    } on AuthException catch (e) {
      return (
        user: const UserEntity(
            uid: '', isAnonymous: false, isEmailVerified: false),
        failure: AuthFailure(e.message),
      );
    } catch (e) {
      return (
        user: const UserEntity(
            uid: '', isAnonymous: false, isEmailVerified: false),
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  @override
  Future<({UserEntity user, Failure? failure})> signInWithApple() async {
    try {
      final dto = await _datasource.signInWithApple();
      return (user: _mapper.toEntity(dto), failure: null);
    } on AuthException catch (e) {
      return (
        user: const UserEntity(
            uid: '', isAnonymous: false, isEmailVerified: false),
        failure: AuthFailure(e.message),
      );
    } catch (e) {
      return (
        user: const UserEntity(
            uid: '', isAnonymous: false, isEmailVerified: false),
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  @override
  Future<({UserEntity user, Failure? failure})> signInAnonymously() async {
    try {
      final dto = await _datasource.signInAnonymously();
      return (user: _mapper.toEntity(dto), failure: null);
    } on AuthException catch (e) {
      return (
        user: const UserEntity(
            uid: '', isAnonymous: false, isEmailVerified: false),
        failure: AuthFailure(e.message),
      );
    } catch (e) {
      return (
        user: const UserEntity(
            uid: '', isAnonymous: false, isEmailVerified: false),
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  @override
  Future<void> signOut() => _datasource.signOut();
}
