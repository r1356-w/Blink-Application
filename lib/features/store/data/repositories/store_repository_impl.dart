import '../../domain/repositories/store_repository.dart';
import '../datasources/store_remote_data_source.dart';
import '../models/products_page_model.dart';
import '../models/store_model.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource _remoteDataSource;

  StoreRepositoryImpl(this._remoteDataSource);

  @override
  Future<StoreModel> getStoreDetails({required int storeId}) async {
    final json = await _remoteDataSource.getStoreDetails(storeId);
    return StoreModel.fromJson(json);
  }

  @override
  Future<ProductsPageModel> getProducts({
    required int storeId,
    required int page,
    int? categoryId,
  }) async {
    final json = await _remoteDataSource.getProducts(
      storeId: storeId,
      page: page,
      categoryId: categoryId,
    );
    return ProductsPageModel.fromJson(json);
  }
}
