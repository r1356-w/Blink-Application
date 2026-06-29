import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../data/datasources/profile_remote_data_source.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/profile_repository.dart';
import '../presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(Get.find<ProfileRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<ProfileRepository>(),
        Get.find<AuthService>(),
        Get.find<LocalStorageService>(),
      ),
      fenix: true,
    );
  }
}
