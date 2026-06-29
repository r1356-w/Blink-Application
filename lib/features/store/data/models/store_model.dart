import '../../../../core/network/image_url_resolver.dart';
import 'store_category_model.dart';

/// Result of `GET stores/{id}`. Image fields go through
/// [ImageUrlResolver] at parse time so the UI layer never has to think
/// about relative vs absolute URLs.
class StoreModel {
  final int id;
  final String name;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? description;
  final List<StoreCategoryModel> categories;

  const StoreModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.coverImageUrl,
    this.description,
    this.categories = const [],
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'];

    return StoreModel(
      id: json['id'] as int? ?? -1,
      name: json['name'] as String? ?? '',
      logoUrl: ImageUrlResolver.resolve(json['logo_url'] as String?),
      coverImageUrl: ImageUrlResolver.resolve(
        json['cover_image_url'] as String?,
      ),
      description: json['description'] as String?,
      categories: rawCategories is List
          ? rawCategories
              .whereType<Map<String, dynamic>>()
              .map(StoreCategoryModel.fromJson)
              .toList()
          : const [],
    );
  }
}
