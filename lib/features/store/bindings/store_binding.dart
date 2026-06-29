import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../data/datasources/store_remote_data_source.dart';
import '../data/repositories/store_repository_impl.dart';
import '../domain/repositories/store_repository.dart';
import '../presentation/controllers/store_controller.dart';

/// `AppRoutes.storeDetails` is always pushed with `arguments: storeId`
/// (an `int`) — see `HomeController.onStoreItemTap`. Binding-time is the
/// one place that's read and validated, so `StoreController` itself can
/// take a non-nullable `storeId` and never has to defend against a
/// missing argument.
class StoreBinding extends Bindings {
  @override
  void dependencies() {
    final storeId = Get.arguments is int ? Get.arguments as int : -1;

    // A previous visit to a *different* store could have left a
    // fenix-kept StoreController registered for the old storeId.
    // Force a fresh instance scoped to the storeId we were just
    // navigated here with.
    if (Get.isRegistered<StoreController>()) {
      Get.delete<StoreController>(force: true);
    }

    Get.lazyPut<StoreRemoteDataSource>(
      () => StoreRemoteDataSourceImpl(Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut<StoreRepository>(
      () => StoreRepositoryImpl(Get.find<StoreRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut<StoreController>(
      () => StoreController(Get.find<StoreRepository>(), storeId: storeId),
      fenix: true,
    );
  }
}
