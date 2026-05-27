import 'package:equatable/equatable.dart';

/// Immutable domain entity representing an authenticated user.
/// No Firebase or Flutter imports — pure Dart.
class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isEmailVerified;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.isAnonymous,
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoUrl,
        isAnonymous,
        isEmailVerified,
      ];
}
