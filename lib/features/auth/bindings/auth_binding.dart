import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/fcm_service.dart';
import '../../notifications/data/datasources/notifications_remote_data_source.dart';
import '../../notifications/data/repositories/notifications_repository_impl.dart';
import '../../notifications/domain/repositories/notifications_repository.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/controllers/auth_controller.dart';

/// Shared by both `AppRoutes.login` and `AppRoutes.otp` so the two
/// screens resolve to the *same* `AuthController` instance — `fenix: true`
/// keeps it alive across that brief login -> otp navigation but lets GetX
/// dispose it once the user leaves the Auth flow entirely (e.g. after
/// landing on Home).
///
/// Also wires the Notifications feature's data layer (deliberately, see
/// `AuthController` — device-token registration happens right after
/// login, which is squarely Auth's concern even though the endpoint
/// itself is implemented in `features/notifications`).
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut<NotificationsRepository>(
      () => NotificationsRepositoryImpl(
        Get.find<NotificationsRemoteDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<AuthRepository>(),
        Get.find<AuthService>(),
        Get.find<FcmService>(),
        Get.find<NotificationsRepository>(),
      ),
      fenix: true,
    );
  }
}
