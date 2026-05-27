import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Signs in the user anonymously — ideal for stranger/ephemeral apps.
class SignInAnonymouslyUseCase {
  final AuthRepository _repository;

  const SignInAnonymouslyUseCase(this._repository);

  Future<({UserEntity user, Failure? failure})> call() =>
      _repository.signInAnonymously();
}
