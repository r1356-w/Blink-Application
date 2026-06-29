import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../data/datasources/notifications_remote_data_source.dart';
import '../data/repositories/notifications_repository_impl.dart';
import '../domain/repositories/notifications_repository.dart';
import '../presentation/controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
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

    Get.lazyPut<NotificationsController>(
      () => NotificationsController(Get.find<NotificationsRepository>()),
      fenix: true,
    );
  }
}
