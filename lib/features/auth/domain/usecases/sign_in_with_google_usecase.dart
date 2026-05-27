import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Triggers Google OAuth sign-in flow.
class SignInWithGoogleUseCase {
  final AuthRepository _repository;

  const SignInWithGoogleUseCase(this._repository);

  Future<({UserEntity user, Failure? failure})> call() =>
      _repository.signInWithGoogle();
}
