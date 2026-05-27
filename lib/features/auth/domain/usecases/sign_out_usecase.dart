import '../repositories/auth_repository.dart';

/// Signs out the current user from all providers.
class SignOutUseCase {
  final AuthRepository _repository;

  const SignOutUseCase(this._repository);

  Future<void> call() => _repository.signOut();
}
