import '../../domain/entities/user_entity.dart';
import '../dto/user_dto.dart';

/// Maps between [UserDto] (data layer) and [UserEntity] (domain layer).
/// DTOs never cross into the domain or presentation layers.
class UserMapper {
  const UserMapper();

  UserEntity toEntity(UserDto dto) => UserEntity(
        uid: dto.uid,
        email: dto.email,
        displayName: dto.displayName,
        photoUrl: dto.photoUrl,
        isAnonymous: dto.isAnonymous,
        isEmailVerified: dto.isEmailVerified,
      );
}
