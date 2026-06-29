/// A product category scoped to a single store, as returned inside the
/// store details payload. Used purely to drive the optional
/// `store_product_category_id` filter on the products list.
class StoreCategoryModel {
  final int id;
  final String name;

  const StoreCategoryModel({required this.id, required this.name});

  factory StoreCategoryModel.fromJson(Map<String, dynamic> json) {
    return StoreCategoryModel(
      id: json['id'] as int? ?? -1,
      name: json['name'] as String? ?? '',
    );
  }
}
