import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/fcm_service.dart';
import '../../notifications/data/datasources/notifications_remote_data_source.dart';
import '../../notifications/data/repositories/notifications_repository_impl.dart';
import '../../notifications/domain/repositories/notifications_repository.dart';
import '../presentation/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
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

    Get.put<SplashController>(
      SplashController(
        Get.find<AuthService>(),
        Get.find<FcmService>(),
        Get.find<NotificationsRepository>(),
      ),
    );
  }
}
