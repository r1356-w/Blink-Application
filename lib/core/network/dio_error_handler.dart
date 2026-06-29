import 'package:dio/dio.dart';

import 'api_exceptions.dart';

/// Converts any [DioException] (or unexpected error) thrown during a
/// request into a typed [AppException].
///
/// This is the ONLY place in the app that should inspect raw status codes
/// or Dio error types — repositories call this and rethrow the result,
/// controllers only ever catch [AppException].
class DioErrorHandler {
  static AppException handle(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutException();

        case DioExceptionType.connectionError:
          return const NetworkException();

        case DioExceptionType.badCertificate:
          return const NetworkException('insecure_connection');

        case DioExceptionType.cancel:
          return const UnknownException('request_cancelled');

        case DioExceptionType.badResponse:
          return _mapStatusCode(error);

        case DioExceptionType.unknown:
          return const NetworkException();
      }
    }
    return const UnknownException();
  }

  static AppException _mapStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final serverMessage =
        (data is Map && data['message'] is String) ? data['message'] as String : null;

    switch (statusCode) {
      case 401:
        return UnauthorizedException(serverMessage ?? 'session_expired');
      case 404:
        return NotFoundException(serverMessage ?? 'resource_not_found');
      case 422:
      case 400:
        final rawErrors = (data is Map) ? data['errors'] : null;
        final parsed = <String, List<String>>{};
        if (rawErrors is Map) {
          rawErrors.forEach((key, value) {
            if (value is List) {
              parsed[key.toString()] = value.map((e) => e.toString()).toList();
            }
          });
        }
        return ValidationException(parsed, serverMessage ?? 'validation_error');
      default:
        if (statusCode != null && statusCode >= 500) {
          return ServerException(serverMessage ?? 'server_error');
        }
        return UnknownException(serverMessage ?? 'unknown_error');
    }
  }
}
