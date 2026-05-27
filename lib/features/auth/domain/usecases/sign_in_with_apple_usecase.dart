import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Triggers Apple Sign-In flow.
class SignInWithAppleUseCase {
  final AuthRepository _repository;

  const SignInWithAppleUseCase(this._repository);

  Future<({UserEntity user, Failure? failure})> call() =>
      _repository.signInWithApple();
}
