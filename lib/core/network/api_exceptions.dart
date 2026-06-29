/// Base type for every error surfaced to the presentation layer.
///
/// Repositories must never let a raw [DioException] or [Exception] leak
/// upward — `DioErrorHandler` converts everything into one of these first.
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// No internet / connection timeout / socket failure.
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'no_internet_connection',
  ]);
}

/// Request timed out (connect/send/receive).
class TimeoutException extends AppException {
  const TimeoutException([
    super.message = 'request_timeout',
  ]);
}

/// 401 — invalid or expired token. Triggers auto-logout in the interceptor.
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'session_expired',
  ]);
}

/// 422 / 400 with field-level validation errors from the API.
class ValidationException extends AppException {
  final Map<String, List<String>> errors;
  const ValidationException(this.errors, [
    super.message = 'validation_error',
  ]);
}

/// 404.
class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'resource_not_found',
  ]);
}

/// 5xx.
class ServerException extends AppException {
  const ServerException([
    super.message = 'server_error',
  ]);
}

/// Anything that doesn't fit a more specific bucket above.
class UnknownException extends AppException {
  const UnknownException([
    super.message = 'unknown_error',
  ]);
}
