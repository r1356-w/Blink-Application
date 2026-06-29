import '../../data/models/products_page_model.dart';
import '../../data/models/store_model.dart';

abstract class StoreRepository {
  Future<StoreModel> getStoreDetails({required int storeId});

  Future<ProductsPageModel> getProducts({
    required int storeId,
    required int page,
    int? categoryId,
  });
}
