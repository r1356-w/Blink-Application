import '../../../../core/models/user_entity.dart';

/// What a successful `verify-otp` call hands back to the controller:
/// the session token and the parsed user, kept together since they
/// arrive together from the API and are consumed together by
/// `AuthService.login`.
class AuthResult {
  final String token;
  final UserEntity user;

  const AuthResult({required this.token, required this.user});
}

/// Contract the presentation layer depends on. `AuthController` only
/// ever talks to this interface — never to Dio, never to
/// `AuthRemoteDataSource` directly.
abstract class AuthRepository {
  Future<void> requestOtp({required String phoneNumber});

  Future<AuthResult> verifyOtp({
    required String phoneNumber,
    required String otp,
    String? notificationToken,
  });
}
