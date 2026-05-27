import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Exposes a stream of auth state changes for reactive navigation.
class WatchAuthStateUseCase {
  final AuthRepository _repository;

  const WatchAuthStateUseCase(this._repository);

  Stream<UserEntity?> call() => _repository.authStateChanges;
}
