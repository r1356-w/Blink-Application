import 'product_model.dart';

/// `GET products` returns Laravel-style pagination nested inside the
/// envelope's `data` field: `{ data: [...], current_page, last_page }`.
/// This model unwraps that *inner* pagination shape — one level below
/// the `{success, message, data}` envelope our `ApiResponse<T>` already
/// strips off.
class ProductsPageModel {
  final List<ProductModel> products;
  final int currentPage;
  final int lastPage;

  const ProductsPageModel({
    required this.products,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasNextPage => currentPage < lastPage;

  factory ProductsPageModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['data'];

    final products = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(ProductModel.fromJson)
            .toList()
        : <ProductModel>[];

    return ProductsPageModel(
      products: products,
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
    );
  }

  factory ProductsPageModel.empty() => const ProductsPageModel(
        products: [],
        currentPage: 1,
        lastPage: 1,
      );
}
