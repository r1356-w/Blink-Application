import '../../../../core/network/image_url_resolver.dart';

/// A single entry in the store's paginated products list.
class ProductModel {
  final int id;
  final String name;
  final String? imageUrl;
  final double price;
  final double? discountedPrice;
  final int? categoryId;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.discountedPrice,
    this.categoryId,
  });

  /// True when the backend sent a discounted price strictly below the
  /// regular price — guards against a `0` or equal value being treated
  /// as a "deal" badge in the UI.
  bool get hasDiscount =>
      discountedPrice != null && discountedPrice! < price;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? -1,
      name: json['name'] as String? ?? '',
      imageUrl: ImageUrlResolver.resolve(json['image_url'] as String?),
      price: _toDouble(json['price']),
      discountedPrice: json['discounted_price'] != null
          ? _toDouble(json['discounted_price'])
          : null,
      categoryId: json['store_product_category_id'] as int? ??
          json['category_id'] as int?,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
