/// Centralized route names. Navigation calls (`Get.toNamed`, etc.) always
/// reference these — never a raw string literal path.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String storeDetails = '/store-details';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
}
