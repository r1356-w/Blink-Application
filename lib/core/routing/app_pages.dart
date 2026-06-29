import 'package:get/get.dart';

import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/bindings/notifications_binding.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/store/bindings/store_binding.dart';
import '../../features/store/presentation/screens/store_details_screen.dart';
import 'app_routes.dart';

/// Every route + its dedicated Bindings class lives here. All six
/// features are now wired.
class AppPages {
  AppPages._();

  static const String initial = AppRoutes.splash;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.storeDetails,
      page: () => const StoreDetailsScreen(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationsBinding(),
    ),
  ];
}
