/// Minimal, stable shape of "the logged-in user" that `core/` is allowed
/// to know about. Feature-level models (e.g. `UserModel` in
/// `features/auth/data/models`) extend this and add any
/// endpoint-specific parsing — `core` never imports from `features`.
class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool isCompleteProfile;
  final String? profileImageUrl;
  final String? email;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.isCompleteProfile,
    this.profileImageUrl,
    this.email,
  });

  String get fullName => '$firstName $lastName'.trim();
}
