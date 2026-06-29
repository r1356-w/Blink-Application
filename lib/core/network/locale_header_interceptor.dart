import 'package:dio/dio.dart';
import 'package:get/get.dart';

/// Ensures every request carries the standard headers required by the
/// spec, with `Accept-language` dynamically synced to whatever locale
/// GetX currently has active (`en` or `ar`).
class LocaleHeaderInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final languageCode = Get.locale?.languageCode ?? 'en';

    options.headers['Accept'] = 'application/json';
    options.headers['Accept-language'] = languageCode;

    handler.next(options);
  }
}
