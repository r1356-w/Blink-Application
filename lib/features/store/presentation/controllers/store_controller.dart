import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../data/models/product_model.dart';
import '../../data/models/store_model.dart';
import '../../domain/repositories/store_repository.dart';

/// View-state for the one-shot store header fetch. Kept separate from
/// the products list's own loading/pagination state since the two load
/// independently and a products error shouldn't blank out a
/// successfully-loaded store header.
enum StoreViewState { loading, error, success }

class StoreController extends GetxController {
  final StoreRepository _storeRepository;
  final int storeId;

  StoreController(this._storeRepository, {required this.storeId});

  final ScrollController scrollController = ScrollController();

  // ---- Store header ----
  final Rx<StoreViewState> viewState = StoreViewState.loading.obs;
  final Rxn<StoreModel> store = Rxn<StoreModel>();
  final RxnString errorMessage = RxnString();

  // ---- Products / pagination ----
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxnString productsErrorMessage = RxnString();
  final RxnInt selectedCategoryId = RxnInt();

  int _currentPage = 1;
  int _lastPage = 1;
  bool get _hasNextPage => _currentPage < _lastPage;

  @override
  void onReady() {
    super.onReady();
    scrollController.addListener(_onScroll);
    fetchStoreDetails();
    fetchProducts(reset: true);
  }

  Future<void> fetchStoreDetails() async {
    viewState.value = StoreViewState.loading;
    errorMessage.value = null;

    try {
      final result = await _storeRepository.getStoreDetails(
        storeId: storeId,
      );
      store.value = result;
      viewState.value = StoreViewState.success;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      viewState.value = StoreViewState.error;
    } catch (_) {
      errorMessage.value = 'unknown_error';
      viewState.value = StoreViewState.error;
    }
  }

  /// Fetches page 1 (when [reset] is true, e.g. initial load, category
  /// change, or pull-to-refresh) or the next page (infinite scroll).
  Future<void> fetchProducts({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _lastPage = 1;
      products.clear();
      isLoadingProducts.value = true;
    } else {
      if (!_hasNextPage || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    productsErrorMessage.value = null;

    try {
      final page = await _storeRepository.getProducts(
        storeId: storeId,
        page: reset ? 1 : _currentPage + 1,
        categoryId: selectedCategoryId.value,
      );

      _currentPage = page.currentPage;
      _lastPage = page.lastPage;

      if (reset) {
        products.assignAll(page.products);
      } else {
        products.addAll(page.products);
      }
    } on AppException catch (e) {
      productsErrorMessage.value = e.message;
    } catch (_) {
      productsErrorMessage.value = 'unknown_error';
    } finally {
      isLoadingProducts.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Triggered by the category filter chips. Resets to page 1 under the
  /// new filter rather than appending — a filter change is a new query,
  /// not a continuation of the old one.
  Future<void> onCategorySelected(int? categoryId) async {
    if (selectedCategoryId.value == categoryId) return;
    selectedCategoryId.value = categoryId;
    await fetchProducts(reset: true);
  }

  void _onScroll() {
    const loadMoreThreshold = 200.0;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - loadMoreThreshold) {
      fetchProducts();
    }
  }

  Future<void> onRetryStoreDetails() => fetchStoreDetails();

  Future<void> onRetryProducts() => fetchProducts(reset: true);

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
