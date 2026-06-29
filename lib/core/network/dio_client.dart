import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import 'locale_header_interceptor.dart';
import 'certificate_manager.dart' if (dart.library.io) 'certificate_manager_io.dart';

/// Single, app-wide Dio instance.
///
/// Nothing outside this file should construct a `Dio()` directly — every
/// data source receives this client via DI and calls `.get/.post/...`
/// on it. All header injection, locale sync, and 401 handling lives in
/// the interceptors wired up here, not in callers.
class DioClient {
  late final Dio dio;

  DioClient(AuthService authService) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // --- DEV-ONLY: relax certificate validation -----------------------
    // The dev/staging server (api-blink.casper-ai.net) currently serves a
    // self-signed certificate. This MUST be removed (or gated behind a
    // build flavor / kReleaseMode check) before shipping to production —
    // flagged again in the README.
    if (!kReleaseMode) {
      setupCertificate(dio);
    }

    dio.interceptors.addAll([
      LocaleHeaderInterceptor(),
      AuthInterceptor(authService),
      if (!kReleaseMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
    ]);
  }
}
