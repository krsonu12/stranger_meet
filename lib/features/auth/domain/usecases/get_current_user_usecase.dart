import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Returns the currently authenticated user, or null.
/// Single responsibility — one use case, one job.
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  Future<UserEntity?> call() => _repository.getCurrentUser();
}
