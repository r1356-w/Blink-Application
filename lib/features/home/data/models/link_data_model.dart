import '../../../../core/network/image_url_resolver.dart';

/// The navigable target behind a section item is never `item.id` — it's
/// nested under `link_data: { id, name, logo_url }`. This model isolates
/// that shape so the controller can pull a store id from one obvious
/// place instead of guessing across the item's fields.
class LinkDataModel {
  final int id;
  final String name;
  final String? logoUrl;

  const LinkDataModel({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  factory LinkDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const LinkDataModel(id: -1, name: '');
    }
    return LinkDataModel(
      id: json['id'] as int? ?? -1,
      name: json['name'] as String? ?? '',
      logoUrl: ImageUrlResolver.resolve(json['logo_url'] as String?),
    );
  }
}
