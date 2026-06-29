import '../../../../core/models/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  });

  Future<void> logout();
}
