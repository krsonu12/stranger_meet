import 'package:firebase_auth/firebase_auth.dart';

/// Data Transfer Object for Firebase User.
/// Maps raw Firebase data — never reaches the UI directly.
class UserDto {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isEmailVerified;

  const UserDto({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.isAnonymous,
    required this.isEmailVerified,
  });

  /// Factory from Firebase [User] object.
  factory UserDto.fromFirebaseUser(User user) => UserDto(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        isAnonymous: user.isAnonymous,
        isEmailVerified: user.emailVerified,
      );
}
