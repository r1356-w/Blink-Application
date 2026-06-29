import '../../../../core/models/user_entity.dart';

/// Data-layer representation of the `user` object nested inside
/// `verify-otp`'s response `data`. Extends [UserEntity] so the rest of
/// the app (e.g. `AuthService.currentUser`) can keep depending on the
/// entity type without knowing about JSON parsing details.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    required super.isCompleteProfile,
    super.profileImageUrl,
    super.email,
  });

  /// Defensive parsing: every field falls back to a safe default rather
  /// than throwing if the backend omits or null-fills something, since a
  /// malformed user object should never crash the login flow.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      isCompleteProfile: json['is_complete_profile'] as bool? ?? false,
      profileImageUrl: json['profile_image_url'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'is_complete_profile': isCompleteProfile,
      'profile_image_url': profileImageUrl,
      'email': email,
    };
  }
}
