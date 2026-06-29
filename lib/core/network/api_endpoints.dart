/// Single source of truth for every path the app talks to.
///
/// Keeping these as constants (rather than inlined strings scattered across
/// data sources) means a backend path change is a one-line edit.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api-blink.casper-ai.net/api/';
  static const String baseOrigin = 'https://api-blink.casper-ai.net';

  // ---- Auth ----
  static const String requestOtp = 'auth/request-otp';
  static const String verifyOtp = 'auth/verify-otp';

  // ---- Home ----
  static const String homeLayout = 'home';

  // ---- Store ----
  static String storeDetails(String storeId) => 'stores/$storeId';
  static const String products = 'products';

  // ---- Profile ----
  static const String profile = 'customer/profile';
  static const String updateProfile = 'auth/update-profile';
  static const String logout = 'auth/logout';
  static const String deviceTokens = 'customer/device-tokens';

  // ---- Notifications ----
  static const String notifications = 'customer/notifications';

  /// Endpoints that must NEVER receive the Authorization header.
  static const List<String> publicEndpoints = [
    requestOtp,
    verifyOtp,
  ];
}
