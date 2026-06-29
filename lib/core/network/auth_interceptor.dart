import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../routing/app_routes.dart';
import '../services/auth_service.dart';
import 'api_endpoints.dart';

/// Injects `Authorization: Bearer <token>` on every request EXCEPT the
/// explicitly public ones (`request-otp`, `verify-otp`), and reacts to a
/// 401 response by logging the user out and routing them back to Login.
///
/// This is the only interceptor allowed to touch [AuthService].
class AuthInterceptor extends Interceptor {
  final AuthService _authService;

  AuthInterceptor(this._authService);

  bool _isPublicEndpoint(String path) {
    return ApiEndpoints.publicEndpoints.any((e) => path.contains(e));
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = _authService.token.value;
    final isPublic = _isPublicEndpoint(options.path);

    if (!isPublic && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final statusCode = err.response?.statusCode;
    final requestedPublic = _isPublicEndpoint(err.requestOptions.path);

    if (statusCode == 401 && !requestedPublic) {
      // Fire-and-forget: clear session then bounce to Login.
      // We don't await here — interceptors must resolve synchronously
      // with respect to the original request chain.
      _authService.logout().then((_) {
        if (Get.currentRoute != AppRoutes.login) {
          Get.offAllNamed(AppRoutes.login);
        }
      });
    }

    handler.next(err);
  }
}
