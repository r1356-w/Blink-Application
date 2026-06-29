import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

/// Concrete implementation the DI layer binds [AuthRepository] to.
///
/// This is the only place that knows the `verify-otp` response's `data`
/// block contains a `token` string and a nested `user` object — that
/// shape knowledge stops here and never leaks into the controller.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> requestOtp({required String phoneNumber}) {
    return _remoteDataSource.requestOtp(phoneNumber: phoneNumber);
  }

  @override
  Future<AuthResult> verifyOtp({
    required String phoneNumber,
    required String otp,
    String? notificationToken,
  }) async {
    final data = await _remoteDataSource.verifyOtp(
      phoneNumber: phoneNumber,
      otp: otp,
      notificationToken: notificationToken,
    );

    final token = data['token'] as String? ?? '';
    final userJson = data['user'];

    final user = UserModel.fromJson(
      userJson is Map<String, dynamic> ? userJson : <String, dynamic>{},
    );

    return AuthResult(token: token, user: user);
  }
}
